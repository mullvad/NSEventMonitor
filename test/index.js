var addon = require('../');
var NSEventMonitor = addon.NSEventMonitor;
var NSEventMask = addon.NSEventMask;
var assert = require('assert');
var app = require('./support/App');
var mouse = require('./support/Mouse');

describe('NSEventMonitor', function() {
  var monitor;

  beforeEach(function() {
    monitor = new NSEventMonitor();
  });

  afterEach(function() {
    monitor.stop();
  })

  it('should receive click', function(done) {
    monitor.start((NSEventMask.leftMouseDown | NSEventMask.rightMouseDown), function (nsEvent) {
      console.log('nsEvent: ', nsEvent);
      done();
    });
    mouse.clickAt(0, 20000);
  });

  it('should throw exception when wrong arguments passed', () => {
    assert.throws(function() { monitor.start() });
    assert.throws(function() { monitor.start("hello", "world"); });
  });

});
