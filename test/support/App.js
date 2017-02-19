var $ = require('NodObjC');

$.import('Cocoa')

var pool = $.NSAutoreleasePool('alloc')('init')
  , app  = $.NSApplication('sharedApplication')

// set up the app delegate
var AppDelegate = $.NSObject.extend('AppDelegate')
AppDelegate.addMethod('applicationDidFinishLaunching:', 'v@:@', function (self, _cmd, notif) {
  // console.log('got applicationDidFinishLauching')
  // console.log(notif)
})
AppDelegate.register()

var delegate = AppDelegate('alloc')('init')
app('setDelegate', delegate)

app('activateIgnoringOtherApps', true)
app('finishLaunching')

var EventLoop = require('./EventLoop')
var evtLoop = new EventLoop(true)

setInterval(function() {
  console.log("NodeJS event loop is ALIVE!", new Date().toISOString())
}, 1000)

module.exports = app