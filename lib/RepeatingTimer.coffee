Timer = require './Timer'
millisecond = require 'millisecond'

module.exports = class RepeatingTimer extends Timer

  init : =>
    @count = 0

  _onTimer : =>
    @count += 1
    @emit 'timer', @name, @count
    return @ unless @repeat >= 0 && @count >= @repeat

    clearInterval @timer
    @timer = undefined
    @emit "done", @name

  createTimer : ( fn ) =>
    setInterval @_onTimer, @timeout

  destroyTimer : ( fn ) =>
    clearInterval @timer
    @timer = undefined
    
