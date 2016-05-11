# ntimer
An event firing, repeatable, cancellable timer for `nodejs`.

[![Build Status](https://travis-ci.org/venkatperi/ntimer.svg?branch=master)](https://travis-ci.org/venkatperi/ntimer)

## Installation

Install with npm

```shell
npm install ntimer
```

## Examples
### Just a Timer

```coffeescript
ntimer = require 'ntimer'

ntimer('foo', '2s')
.on "done", -> # do something
.start()
```

### Auto Start

```coffeescript
ntimer.auto('foo', '2s')
.on "done", -> # do something
```

### Cancel Timer

```coffeescript
t = ntimer.auto('foo', '5s')
.on "done", -> # do something
.on "cancelled", -> # why, oh why?

# start another timer to cancel the above before it fires
setTimeout ( -> t.cancel()), 500
```
### Repeat

```coffeescript
ntimer.repeat('foo', '500ms')
.on "timer", (name, count) -> # fired every 500ms
.start()
```
### Limited Repeat

```coffeescript
ntimer.repeat('foo', '500ms', 5)
.on "timer", (name, count) -> # fired every 500ms, five times
.on "done", -> # fired after the fifth 'timer' event
.start()
```

## API

### Properties

### timer.count

The `{Number}` of times the repeating timer has already fired.

#### timer.running

A `{Boolean}` indicating whether the timer is currently running.

### Methods

#### ntimer(name, timeout)
### ntimer.auto(name, timeout)

Creates a single shot, restartable timer. `ntimer.auto` creates an auto starting timer.

* **name** `{String}` is returned as the first argument of events.
* **timeout** can be a `{Number}` in `milliseconds` or a `{String}`. See [format](https://github.com/unshiftio/millisecond). 

#### ntimer.repeat(name, timeout[, maxRepeaet])
#### ntimer.autoRepeat(name, timeout[, maxRepeat])

Creates a repeating timer. `ntimer.auto` creates an auto starting version.

* **name** `{String}` is returned as the first argument of events.
* **timeout** can be a `{Number}` in `milliseconds` or a `{String}`. See [format](https://github.com/unshiftio/millisecond). 
* **maxRepeat** an optional `{Number}` specifies the maximum repeat count. 

#### timer.start()
Start a timer. No-op if already started. Returns the timer object for chaining.

#### timer.cancel()
Cancels a running timer. No-op if not started or already stopped/cancelled. Returns the timer object for chaining.

### Events

#### on("started", cb(name))

Fired when the timer is started (or restarted).

#### on("cancelled", cb(name))

Fired when the timer is cancelled.

#### on("done", cb(name))

Fired when the timer is done (not cancelled).

#### on("timer", cb(name, count))

Fired for each `timeout` interval,  once for single shot timers, or repeatdly for repeating timers.



