const NSEventMonitor = require('../');
const assert = require('assert');
const app = require('./support/App');
const mouse = require('./support/Mouse');

describe('NSEventMonitor', () => {

  it('should receive click', (done) => {
    const monitor = new NSEventMonitor();
    monitor.start(() => done());
    mouse.clickAt(0, 20000);
  });

  it('should throw exception if no function passed', () => {
    const monitor = new NSEventMonitor();
    assert.throws(() => monitor.start());
    assert.throws(() => monitor.start(1337));
  });
  
});
