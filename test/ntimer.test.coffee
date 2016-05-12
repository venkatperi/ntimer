util = require 'util'
should = require("should")
assert = require("assert")
ntimer = require '../index'

describe "ntimer", ->

  it "create a timer", ( done ) ->
    (-> ntimer('foo', 100)).should.not.throw
    done()

  it "needs a name", ( done ) ->
    (-> ntimer()).should.throw
    done()

  it "needs a timeout", ( done ) ->
    (-> ntimer('abc')).should.throw
    done()

  it "accepts string times", ( done ) ->
    t = ntimer('abc', '10ms')
    t.timeout.should.equal 10
    done()

  it "needs valid timeout", ( done ) ->
    (-> ntimer('abc', '10sdfiasfms')).should.throw
    done()

  it "needs timeout > 0", ( done ) ->
    (-> ntimer('abc', -1)).should.throw
    done()

  it "needs timeout > 0", ( done ) ->
    (-> ntimer('abc', 0)).should.throw
    done()

  it "auto start won't start until we have a 'timer' listener", ( done ) ->
    t = ntimer.auto 'foo', 100

    ntimer.auto 'wait', 400
    .on "timer", (n) ->
      n.should.equal 'wait'
      t.on 'timer', ( name ) ->
        name.should.equal 'foo'
        done()

  it "canceling stopped timer is a no-op", ( done ) ->
    ntimer 'foo', 200
    .on "cancel", -> throw new Error "eh?"
    .cancel()
    done()

  it "manual starts", ( done ) ->
    ntimer 'foo', 200
    .on "done", -> done()
    .start()

  it "emits event: start", ( done ) ->
    ntimer 'foo', 200
    .on "start", ( name ) ->
      name.should.equal 'foo'
      done()
    .start()

  it "emits event: done", ( done ) ->
    ntimer 'foo', 200
    .on "done", -> done()
    .start()

  it "emits event: cancel", ( done ) ->
    t = ntimer 'foo', 5000
    .on "cancel", ( name ) ->
      name.should.equal 'foo'
      done()
    .start()

    setTimeout ( -> t.cancel() ), 200

  it "can be restarted", ( done ) ->
    t = ntimer.auto 'foo', 500
    .on "cancel", -> done()
    .on "done", ->
      # restart the timer and cancel it before it can fire again
      t.start()
      setTimeout ( -> t.cancel() ), 50
    .start()

  it "can repeat", ( done ) ->
    t = ntimer.repeat 'foo', 100
    .on "timer", ->
      t.cancel()
      done()
    .start()

  it "repeating timer can be cancel", ( done ) ->
    ntimer.autoRepeat 'foo', 100
    .on "timer", ->
      @cancel()
      done()

  it "repeat with a count", ( done ) ->
    count = 0
    ntimer.repeat 'foo', 100, 3
    .on "timer", ( name, c ) ->
      count++
      c.should.equal count
    .on "done", ->
      count.should.equal 3
      done()
    .start()

  it "can cancel repeating timer", ( done ) ->
    t = ntimer.repeat 'foo', 100
    .on "timer", ->
      t.cancel()
      done()
    .start()

  it "exports Timer class", ( done ) ->
    ntimer.Timer.should.exist
    done()




