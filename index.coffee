Timer = require './lib/Timer'

timer = ( name, timeout ) ->
  new Timer name : name, timeout : timeout

timer.auto = ( name, timeout ) ->
  new Timer name : name, timeout : timeout, auto : true

timer.repeat = ( name, timeout, repeat ) ->
  repeat = -1 if Number.isNaN Number(repeat)
  new Timer name : name, timeout : timeout, repeat : repeat

timer.autoRepeat = ( name, timeout, repeat, auto ) ->
  repeat = -1 if Number.isNaN Number(repeat)
  new Timer
    name : name, timeout : timeout, repeat : repeat, auto : true

timer.Timer = Timer

module.exports = timer
