//
// NSEventMonitor extension
//
// Author: Andrei Mihailov <and@codeispoetry.ru>
//

#import "NSEventMonitor.h"
#import "NSEventMaskWrap.h"

using namespace addon;

void InitAll(v8::Local<v8::Object> exports, v8::Local<v8::Object> module) {
  NSEventMonitor::Init(exports, module);
  NSEventMaskWrap::Init(exports, module);
}

NODE_MODULE(NSEventMonitor, InitAll)