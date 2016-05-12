{EventEmitter} = require 'events'
TypedError = require 'error/typed'
millisecond = require 'millisecond'

MissingOptionError = TypedError
  type : 'missingOption'
  message : "The option {name} is missing."
  name : undefined

InvalidArgumentError = TypedError
  type : 'invalidArgument'
  message : "The argument {name} is invalid."
  name : undefined

module.exports = class Timer extends EventEmitter

  constructor : ( {@name, @timeout, @auto, @repeat} = {} ) ->
    for o in [ 'name', 'timeout' ]
      throw MissingOptionError name : o unless @[ o ]

    @timeout = millisecond(@timeout) if typeof @timeout is 'string'
    throw InvalidArgumentError name : 'timeout' if @timeout <= 0
    @repeat ?= 1 # single shot
    @running = false

    # trigger auto start only when we have a listener for
    # the 'timer' event.
    @once 'newListener', ( event ) =>
      return unless event is 'timer'
      @start() if @auto

  start : =>
    @_start() unless @timer
    @

  cancel : =>
    @_stop 'cancel' if @timer?
    @

  _onTimer : =>
    @count += 1
    @emit 'timer', @name, @count
    @_stop 'done' if @repeat >= 0 && @count >= @repeat

  _stop : ( event ) =>
    clearInterval @timer
    @running = false
    @timer = undefined
    @emit event, @name

  _start : =>
    @count = 0
    @timer = setInterval @_onTimer, @timeout
    @running = true
    @emit "start", @name
