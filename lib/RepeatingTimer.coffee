Timer = require './Timer'
millisecond = require 'millisecond'

module.exports = class RepeatingTimer extends Timer

  _onTimer : =>
    @count += 1
    @emit 'timer', @name, @count
    return @ unless @repeat >= 0 && @count >= @repeat

    clearInterval @timer
    @timer = undefined
    @emit "done", @name

  createTimer : ( fn ) =>
    @count = 0
    setInterval @_onTimer, @timeout

  destroyTimer : ( fn ) =>
    clearInterval @timer
    @timer = undefined
    
