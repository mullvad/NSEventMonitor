# NSEventMonitor
[![Build Status](https://api.travis-ci.org/mullvad/NSEventMonitor.svg)](https://travis-ci.org/mullvad/NSEventMonitor)
[![dependencies Status](https://david-dm.org/mullvad/NSEventMonitor/status.svg)](https://david-dm.org/mullvad/NSEventMonitor)
[![devDependencies Status](https://david-dm.org/mullvad/NSEventMonitor/dev-status.svg)](https://david-dm.org/mullvad/NSEventMonitor?type=dev)

Currently when building menubar apps with Electron, `window.on('blur', ...)` does not fire if user clicks on other menubar items leaving displayed window on screen.

Native macOS popovers usually hide if user clicks anywhere on screen. This extension attempts to fix that for Electron apps, so the following will never be the case anymore:

<img src="readme/screenshot.png" width="200" />

## Example

```js
import { NSEventMonitor, NSEventMask } from 'nseventmonitor';

let macEventMonitor = new NSEventMonitor();

window.on('blur', () => {
  window.hide();
});

window.on('show', () => {
  tray.setHighlightMode('always');

  // start capturing global mouse events
  macEventMonitor.start((NSEventMask.leftMouseDown | NSEventMask.rightMouseDown), () => {
    window.hide();
  });
});

window.on('hide', () => {
  tray.setHighlightMode('never');

  // stop capturing global mouse events
  macEventMonitor.stop();
});
```

To run example app:

```
$ cd example
$ npm i
$ npm start
```

## Electron support

Electron comes with its own Node.js runtime, which may differ from the one installed on your 
desktop. Therefore all native modules have to be built specifically for Electron.

We strongly advise to use `electron-builder` and add a `postinstall` script to your 
`package.json` in order to automatically compile native modules for Electron:

```
electron-builder install-app-deps
```

## Building from source

To compile the extension run the following command:

```
$ npm i --build-from-source
```

You can confirm everything built correctly by [running the test suite](#to-run-tests).

### To run tests:

```
$ npm test
```

Note: tests are currently disabled due to issues with automation on macOS.
