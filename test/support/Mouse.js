const $ = require('NodObjC');
$.framework('Cocoa');

module.exports = {
  clickAt: (x, y) => {
    // get current mouse location
    const evtMouse = $.CGEventCreate(null);
    const mouseLocation = $.CGEventGetLocation(evtMouse);

    // simulate click, this will warp cursor position
    const evtDown = $.CGEventCreateMouseEvent(null, $.kCGEventLeftMouseDown, $.CGPointMake(x, y), $.kCGMouseButtonLeft);
    $.CGEventPost($.kCGHIDEventTap, evtDown);

    // restore cursor position after click
    $.CGWarpMouseCursorPosition(mouseLocation);

    // Release CGEvents
    $.CFRelease(evtMouse);
    $.CFRelease(evtDown);
  }
};
