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
    (-> ntimer('10ms')).should.not.throw
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

  it "auto starts", ( done ) ->
    ntimer.auto 'foo', 1000
    .on "done", ( name ) ->
      name.should.equal 'foo'
      done()

  it "manual starts", ( done ) ->
    ntimer 'foo', 200
    .on "done", -> done()
    .start()

  it "emits event: started", ( done ) ->
    ntimer 'foo', 200
    .on "started", (name) ->
      name.should.equal 'foo'
      done()
    .start()

  it "emits event: done", ( done ) ->
    ntimer 'foo', 200
    .on "done", -> done()
    .start()

  it "emits event: cancelled", ( done ) ->
    t = ntimer 'foo', 5000
    .on "cancelled", (name) ->
      name.should.equal 'foo'
      done()
    .start()

    setTimeout ( -> t.cancel() ), 500

  it "can be restarted", ( done ) ->
    t = ntimer.auto 'foo', 1000
    .on "cancelled", -> done()
    .on "done", ->
      # restart the timer and cancel it before it can fire again
      t.start()
      setTimeout ( -> t.cancel() ), 500
    .start()

  it "can repeat", ( done ) ->
    t = ntimer.repeat 'foo', 500
    .on "timer", ->
      t.cancel()
      done()
    .start()

  it "can repeat", ( done ) ->
    t = ntimer.repeat 'foo', 500
    .on "timer", ->
      t.cancel()
      done()
    .start()

  it "repeat with a count", ( done ) ->
    count = 0
    ntimer.repeat 'foo', 500, 3
    .on "timer", ( name, c ) ->
      count++
      c.should.equal count
    .on "done", ->
      count.should.equal 3
      done()
    .start()

  it "can cancel repeating timer", ( done ) ->
    t = ntimer.repeat 'foo', 500
    .on "timer", ->
      t.cancel()
      done()
    .start()




