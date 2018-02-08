//
// NSEventMonitor extension
//
// Author: Andrei Mihailov <and@codeispoetry.ru>
//

#import "NSEventMonitor.h"
#import "NSEventMaskWrap.h"
#import "NSEventWrap.h"

using namespace addon;

void InitAll(v8::Local<v8::Object> exports, v8::Local<v8::Object> module) {
  NSEventMonitor::Init(exports);
  NSEventMaskWrap::Init(exports);
  NSEventWrap::Init(exports);
}

NODE_MODULE(NSEventMonitor, InitAll)