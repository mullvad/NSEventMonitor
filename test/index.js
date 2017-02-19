const NSEventMonitor = require('../');
const assert = require('assert');

describe('native extension', function() {
  it('should export a wrapped object', (done) => {
    const monitor = new NSEventMonitor();
    monitor.start(() => done());
  });

  it('should throw exception if no function passed', () => {
    const monitor = new NSEventMonitor();
    assert.throws(() => monitor.start());
    assert.throws(() => monitor.start(1337));
  });
  
});
