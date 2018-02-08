//
// NSEventMonitor extension
// NSEventMaskWrap wrapper around NSEventMask
//
// Author: Andrei Mihailov <and@codeispoetry.ru>
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

void addon::NSEventMaskWrap::Init(v8::Local<v8::Object> exports) {
  v8::Isolate *isolate = exports->GetIsolate();
  v8::Local<v8::Context> context = isolate->GetCurrentContext();
  v8::HandleScope scope(isolate);
  v8::Local<v8::Object> object = v8::Object::New(isolate);

  for(auto const& entry: eventMaskConstants) {
    object->DefineOwnProperty(context,
      v8::String::NewFromUtf8(isolate, entry.first),
      v8::Number::New(isolate, entry.second),
      static_cast<v8::PropertyAttribute>(v8::ReadOnly | v8::DontDelete)
    ).FromJust();
  }

  exports->Set(v8::String::NewFromUtf8(isolate, "NSEventMask"), object);
}
