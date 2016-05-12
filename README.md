# ntimer
An event firing, repeatable, cancellable timer for `nodejs`.

[![Build Status](https://travis-ci.org/venkatperi/ntimer.svg?branch=master)](https://travis-ci.org/venkatperi/ntimer)
[![npm version](https://badge.fury.io/js/ntimer.svg)](https://badge.fury.io/js/ntimer)

# Installation

Install with npm

```shell
npm install ntimer --save
```

# Examples
### Just a Timer

```coffeescript
ntimer = require 'ntimer'

# Creates an manual-start timer which fires after 2000ms
ntimer('foo', '2s')
.on "done", -> # do something
.start()
```

### Auto Start

```coffeescript
# Creates an auto-start timer which fires after 200ms
ntimer.auto('foo', 200)
.on "done", -> # do something
```

### Cancel Timer

```coffeescript
# starts a second timer when the first starts which cancels 
# the first timer before the first timer ends.
ntimer.auto('foo', '5s')
.on "start", -> setTimeout ( => @cancel()), 500
.on "done", -> # do something
.on "cancel", -> # why, oh why?
```
### Repeat

```coffeescript
# Create an infinitely repeating timer whch fires every 500ms.
ntimer.repeat('foo', '500ms')
.on "timer", (name, count) -> # do something
.on "done", -> # never called
.on "cancel", -> # called if timer is cancelled
.start()
```
### Limited Repeat

```coffeescript
# Create a timer which fires every 500ms for five times.
ntimer.autoRepeat('foo', '500ms', 5)
.on "timer", (name, count) -> # do something
.on "done", -> # fired after the fifth 'timer' event
```

# API

## Create Timer

### ntimer(name, timeout)

### ntimer.auto(name, timeout)

Creates a single shot, restartable timer. `ntimer.auto` creates an auto starting timer.

* **name** `{String}` is returned as the first argument of events.
* **timeout** can be a `{Number}` in `milliseconds` or a `{String}` e.g. `'5s'` or `'2ms'` . See [format](https://github.com/unshiftio/millisecond). 

```coffeescript
ntimer('foo', 500)  # Single shot, manual start, 500ms timer.
```

> **Note:** An auto-starting timer will start **only** when it has a event listener for the `trigger` event.

```coffeescript
t = ntimer.auto('foo', 500)  # Create an auto start timer, 500ms

# The auto-start timer will start only after this listener is attached
t.on 'trigger', -> # do something
```

### ntimer.repeat(name, timeout[, maxRepeat])

### ntimer.autoRepeat(name, timeout[, maxRepeat])

Creates a repeating timer. `ntimer.auto` creates an auto starting version.

* **name** `{String}` is returned as the first argument of events.
* **timeout** can be a `{Number}` in `milliseconds` or a `{String}`. See [format](https://github.com/unshiftio/millisecond). 
* **maxRepeat** an optional `{Number}` specifies the maximum repeat count. 
```coffeescript
ntimer.repeat('foo', 500)  # Single shot, 500ms timer.
ntimer('foo', '2s')  # Single shot, 2 second timer.
```

## Properties

### timer.count

The `{Number}` of times the repeating timer has already fired.

### timer.running

`{Boolean}` indicating whether the timer is currently running.

## Methods

### timer.start()

Start a timer. No-op if already started. Returns the timer object for chaining.

### timer.cancel()
Cancels a running timer. No-op if not started or already stopped/cancelled. Returns the timer object for chaining.

## Events

### on("start", cb(name))

Fired when the timer is started (or restarted) with the **name** of the timer.

### on("cancel", cb(name))

Fired when the timer is cancelled with the **name** of the timer.

### on("done", cb(name))

Fired when the timer is done (not cancelled) with the **name** of the timer.

### on("timer", cb(name, count))

Fired for each `timeout` interval,  once for single shot timers, or repeatedly for repeating timers, with the **name** of the timer and the the **count** of the times the timer has triggered so far.

## ntimer.Timer Class
`ntimer` exports the Timer class.

## String Formats for Time

Uses the [millisecond](https://github.com/unshiftio/millisecond) module. The following formats are acceptable:

- x milliseconds
- x millisecond
- x msecs
- x msec
- x ms
- x seconds
- x second
- x secs
- x sec
- x s
- x minutes
- x minute
- x mins
- x min
- x m
- x hours
- x hour
- x hrs
- x hr
- x h
- x days
- x day
- x d
- x weeks
- x week
- x wks
- x wk
- x w
- x years
- x year
- x yrs
- x yr
- x y


The space after the number is optional so you can also write `1ms` instead of `1 ms`.
