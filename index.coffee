Timer = require './lib/Timer'
RepeatingTimer = require './lib/RepeatingTimer'

timer = ( name, timeout ) ->
  new Timer name : name, timeout : timeout

timer.auto = ( name, timeout ) ->
  new Timer name : name, timeout : timeout, auto : true

timer.repeat = ( name, timeout, repeat ) ->
  repeat = -1 if Number.isNaN Number(repeat)
  new RepeatingTimer name : name, timeout : timeout, repeat : repeat

timer.autoRepeat = ( name, timeout, repeat ) ->
  repeat = -1 if Number.isNaN Number(repeat)
  new RepeatingTimer
    name : name, timeout : timeout, repeat : repeat, auto : true

module.exports = timer
