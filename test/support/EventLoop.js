/* Cocoa application event loop implementation for NodObjC.
 * Code created for https://github.com/TooTallNate/NodObjC/pull/56
 * Working as of 2015-Jan-11 on Mac OS 10.10, Node 0.10.35, NodObjC 1.0.0
 *
 * Copyright (c) 2015, Shane Holloway
 *
 * Permission to use, copy, modify, and/or distribute this software for any purpose with or without fee is hereby granted, provided that the above copyright notice and this permission notice appear in all copies.
 *
 * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 */

var $, EventEmitter = require('events').EventEmitter;

// export EventLoop at module and as 'EventLoop'
module.exports = EventLoop.EventLoop = EventLoop
EventLoop.initObjC = function(NodObjC) {
  $ = NodObjC || $ || require('NodObjC')
  $.import('Cocoa')

  EventLoop.prototype._runLoopMode = $.NSDefaultRunLoopMode
  if (EventLoop.prototype._runLoopMode === null) {
    EventLoop.prototype._runLoopMode = $('kCFRunLoopDefaultMode')
    console.warn('WARNING: Falling back to hard-coded string for NSDefaultRunLoopMode constant. See https://github.com/TooTallNate/NodObjC/pull/56 for details.')
  }
}

function EventLoop(start, options) {
  EventEmitter.call(this)
  if (options) {
    if (options.runLoopMode) this._runLoopMode = options.runLoopMode
  }
  this.runInfo = {recurring:null, schedule_id:null, loop:{}}

  if (start) this.start()
  return this
}
require('util').inherits(EventLoop, EventEmitter)

EventLoop.prototype.start = function() {
  this.emit('start')
  return this.schedule(true)
}
EventLoop.prototype.stop = function() {
  this.runInfo.recurring = false
  this.emit('stop')
  return this
}
EventLoop.prototype._schedule = setTimeout
EventLoop.prototype._clearSchedule = clearTimeout
EventLoop.prototype.schedule = function(runRecurring) {
  var runInfo = this.runInfo
  if (runRecurring !== undefined)
    runInfo.recurring = !!runRecurring

  if (runInfo.schedule_id != null)
    return this; // exit if already scheduled

  var id = this._schedule(this.eventLoop.bind(this))
  runInfo.schedule_id = (id !== undefined) ? id : true
  this.emit('scheduled', runInfo)
  return this
}
EventLoop.prototype.clearSchedule = function() {
  var runInfo = this.runInfo
  var id = runInfo.schedule_id
  runInfo.recurring = false

  if (id != null) {
    runInfo.schedule_id = null
    this._clearSchedule(id)
    this.emit('unscheduled', runInfo)
  }
  return this
}

EventLoop.prototype.isScheduled = function(runInfo) {
  if (!runInfo) runInfo = this.runInfo
  return runInfo.schedule_id!=null }
EventLoop.prototype.isActive = function(runInfo) {
  if (!runInfo) runInfo = this.runInfo
  return this.isScheduled(runInfo) || runInfo.recurring }

EventLoop.prototype.eventLoop = function(runRecurring) {
  var runInfo = this.runInfo
  runInfo.schedule_id = null
  this.eventLoopCore()
  if (runInfo.recurring || runRecurring)
    this.schedule(runRecurring)
  else if (runInfo.schedule_id==null)
    this.emit('deactivate', this.runInfo)
  return this
}
EventLoop.prototype.eventLoopCore = function(block) {
  if ($==null) EventLoop.initObjC();

  var runInfo = this.runInfo,
      loopInfo = {running:true, count:0, t0:Date.now()},
      event, app = $.NSApplication('sharedApplication'),
      untilDate = block ? $.NSDate('distantFuture') : null, // or $.NSDate('distantPast') to not block
      inMode = this._runLoopMode

  var runLoopPool = $.NSAutoreleasePool('alloc')('init')
  try {
    runInfo.loop = loopInfo
    this.emit('eventLoop-enter', runInfo)
    do {
      this.emit('event-next', event, app, runInfo)
      event = app('nextEventMatchingMask',
              $.NSAnyEventMask.toString(), // …grumble… uint64 as string …grumble…
              'untilDate', untilDate,
              'inMode', inMode,
              'dequeue', 1)
      this.emit('event-match', event, app, runInfo)
      if (event) {
        app('sendEvent', event)
        this.emit('event-sent', event, app, runInfo)
      }
      ++loopInfo.count
    } while (event)
    loopInfo.t1 = Date.now()
    loopInfo.running = false
    this.emit('eventLoop-exit', runInfo)
  } catch (err) {
    loopInfo.t1 = Date.now()
    loopInfo.running = false
    loopInfo.error = err
    this.emit('error', err, runInfo)
    throw err
  } finally {
    runLoopPool('drain')
  }
  delete loopInfo.running
  this.emit('eventLoop', runInfo)
  return this
}