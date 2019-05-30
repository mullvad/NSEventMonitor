//
// NSEventMonitor extension
// NSEventMaskWrap wrapper around NSEventMask
//
// Author: Andrei Mihailov <and@codeispoetry.ru>
//

#include "NSEventMaskWrap.h"
#import <AppKit/AppKit.h>
#import <Availability.h>
#import <nan.h>
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

void addon::NSEventMaskWrap::Init(v8::Local<v8::Object> exports) {
  Nan::HandleScope scope;
  v8::Local<v8::Object> object = Nan::New<v8::Object>();

  for(auto const& entry: eventMaskConstants) {
      Nan::DefineOwnProperty(object,
        Nan::New<v8::String>(entry.first).ToLocalChecked(),
        Nan::New<v8::Number>(entry.second),
        static_cast<v8::PropertyAttribute>(v8::ReadOnly | v8::DontDelete)
      ).FromJust();
  }

  Nan::Set(exports, Nan::New<v8::String>("NSEventMask").ToLocalChecked(), object);
}
