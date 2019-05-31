const path = require('path');
const electron = require('electron');
const { NSEventMonitor, NSEventMask } = require('nseventmonitor');
const { app, BrowserWindow, Tray } = electron;

let window = null;
let tray = null;
let macEventMonitor = null;

// hide dock icon
app.dock.hide();

const getWindowPosition = () => {
  const windowBounds = window.getBounds();
  const trayBounds = tray.getBounds();

  // center window horizontally below the tray icon
  const x = Math.round(trayBounds.x + (trayBounds.width / 2) - (windowBounds.width / 2));

  // position window vertically below the tray icon
  const y = Math.round(trayBounds.y + trayBounds.height);

  return { x, y };
};

const createWindow = () => {
  window = new BrowserWindow({
    width: 320,
    height: 400,
    frame: false,
    resizable: false,
    maximizable: false,
    fullscreenable: false,
    transparent: true,
    show: false,
    webPreferences: {
      // prevents renderer process code from not running when window is hidden
      backgroundThrottling: false
    }
  });

  macEventMonitor = new NSEventMonitor();

  window.loadURL('file://' + path.join(__dirname, 'index.html'));

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

};

const toggleWindow = () => {
  if(window.isVisible()) {
    window.hide();
  } else {
    showWindow();
  }
};

const showWindow = () => {
  const position = getWindowPosition();
  window.setPosition(position.x, position.y, false);
  window.show();
  window.focus();
};

const createTray = () => {
  tray = new Tray(path.join(__dirname, 'trayIconTemplate.png'));
  tray.on('right-click', toggleWindow);
  tray.on('double-click', toggleWindow);
  tray.on('click', toggleWindow);
};

app.on('window-all-closed', () => {
  app.quit();
});

app.on('ready', () => {
  createTray();
  createWindow();
});
