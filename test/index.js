var { NSEventMonitor, NSEventMask, NSEvent } = require('../');

var chai = require('chai');
var assert = chai.assert;
var robot = require('robotjs');

describe('NSEventMonitor', function() {
  var monitor;

  beforeEach(function() {
    monitor = new NSEventMonitor();
  });

  afterEach(function() {
    monitor.stop();
  });

  it('should not allow NSEvent creation from JS', () => {
    assert.throws(function () { new NSEvent(); });
  });

  it('should receive click', function(done) {
    monitor.start((NSEventMask.leftMouseDown | NSEventMask.rightMouseDown), function (nsEvent) {
      done();
    });

    var mouse = robot.getMousePos();
    robot.moveMouse(0, 20000);
    robot.mouseClick();
    robot.moveMouse(mouse.x, mouse.y);
  });

  it('should throw exception when wrong arguments passed', () => {
    assert.throws(function() { monitor.start() });
    assert.throws(function() { monitor.start("hello", "world"); });
  });

});
