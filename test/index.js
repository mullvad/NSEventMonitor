const { NSEventMonitor, NSEventMask } = require('../');
const assert = require('assert');
const app = require('./support/App');
const mouse = require('./support/Mouse');

describe('NSEventMonitor', () => {
  let monitor;

  beforeEach(() => {
    monitor = new NSEventMonitor();
  });

  afterEach(() => {
    monitor.stop();
  })

  it('should receive click', (done) => {
    monitor.start((NSEventMask.leftMouseDown | NSEventMask.rightMouseDown), () => done());
    mouse.clickAt(0, 20000);
  });

  it('should throw exception when wrong arguments passed', () => {
    assert.throws(() => monitor.start());
    assert.throws(() => monitor.start("hello", "world"));
  });
  
});
