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
    @init()
    @start() if @auto

  init : ->

  start : =>
    return @ if @timer
    @timer = @doStart()
    @emit "started", @name
    @

  cancel : =>
    return @ unless @timer?
    @doCancel()
    @timer = undefined
    @emit "cancelled", @name
    @

  _onTimer : =>
    @timer = undefined
    @emit "timer", @name, 1
    @emit "done", @name

  doStart : ( fn ) => setTimeout @_onTimer, @timeout

  doCancel : ( fn ) => clearTimeout @timer
    
