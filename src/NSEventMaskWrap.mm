//
// NSEventMonitor extension
// NSEventMaskWrap wrapper around NSEventMask
//
// Author: Andrej Mihajlov <and@mullvad.net>
//

#include "NSEventMaskWrap.h"
#import <AppKit/AppKit.h>
#import <Availability.h>
#import <map>

static std::map<const char *, NSUInteger> eventMaskConstants = {
  { "leftMouseDown", NSEventMaskLeftMouseDown },
  { "leftMouseUp", NSEventMaskLeftMouseUp },

  { "rightMouseDown", NSEventMaskRightMouseDown },
  { "rightMouseUp", NSEventMaskRightMouseUp },

  { "mouseMoved", NSEventMaskMouseMoved },

  { "leftMouseDragged", NSEventMaskLeftMouseDragged },
  { "rightMouseDragged", NSEventMaskRightMouseDragged },

  { "mouseEntered", NSEventMaskMouseEntered },
  { "mouseExited", NSEventMaskMouseExited },

  { "keyDown", NSEventMaskKeyDown },
  { "keyUp", NSEventMaskKeyUp },

  { "flagsChanged", NSEventMaskFlagsChanged },
  { "appKitDefined", NSEventMaskAppKitDefined },
  { "applicationDefined", NSEventMaskApplicationDefined },
  { "periodic", NSEventMaskPeriodic },
  { "cursorUpdate", NSEventMaskCursorUpdate },
  { "scrollWheel", NSEventMaskScrollWheel },
  { "tabletPoint", NSEventMaskTabletPoint },
  { "tabletProximity", NSEventMaskTabletProximity },

  { "otherMouseDown", NSEventMaskOtherMouseDown },
  { "otherMouseUp", NSEventMaskOtherMouseUp },
  { "otherMouseDragged", NSEventMaskOtherMouseDragged },

#ifdef __MAC_10_5
  { "gesture", NSEventMaskGesture },
  { "magnify", NSEventMaskMagnify },
  { "swipe", NSEventMaskSwipe },
  { "rotate", NSEventMaskRotate },
  { "beginGesture", NSEventMaskBeginGesture },
  { "endGesture", NSEventMaskEndGesture },
#endif

#if __LP64__

#ifdef __MAC_10_8
  { "smartMagnify", NSEventMaskSmartMagnify },
#endif

#ifdef __MAC_10_10_3
  { "maskPressure", NSEventMaskPressure },
#endif

#ifdef __MAC_10_12_2
  { "directTouch", NSEventMaskDirectTouch },
#endif

#endif

  { "any", NSEventMaskAny }
};

NAN_MODULE_INIT(addon::NSEventMaskWrap::Init) {
  Nan::HandleScope scope;
  v8::Local<v8::Object> object = Nan::New<v8::Object>();

  for(auto const& entry: eventMaskConstants) {
      Nan::DefineOwnProperty(object,
        Nan::New<v8::String>(entry.first).ToLocalChecked(),
        Nan::New<v8::Number>(entry.second),
        static_cast<v8::PropertyAttribute>(v8::ReadOnly | v8::DontDelete)
      ).FromJust();
  }

  Nan::Set(target, Nan::New<v8::String>("NSEventMask").ToLocalChecked(), object);
}
