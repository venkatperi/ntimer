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
    @start() if @auto

  start : =>
    return @ if @timer
    @count = 0
    @timer = setInterval @_onTimer, @timeout
    @running = true
    @emit "start", @name
    @

  cancel : =>
    return @ unless @timer?
    clearInterval @timer
    @timer = undefined
    @running = false
    @emit "cancel", @name
    @

  _onTimer : =>
    @count += 1
    @emit 'timer', @name, @count
    return unless @repeat >= 0 && @count >= @repeat

    clearInterval @timer
    @timer = undefined
    @emit "done", @name
