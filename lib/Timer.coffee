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
    @running = false
    @start() if @auto

  start : =>
    return @ if @timer
    @timer = @createTimer()
    @running = true
    @emit "start", @name
    @

  cancel : =>
    return @ unless @timer?
    @destroyTimer()
    @running = false
    @timer = undefined
    @emit "cancel", @name
    @

  _onTimer : =>
    @emit "timer", @name, 1
    @emit "done", @name

  createTimer : ( fn ) =>
    setTimeout @_onTimer, @timeout

  destroyTimer : ( fn ) =>
    clearTimeout @timer
    @timer = undefined


