//
// NSEventMonitor extension
//
// Author: Andrej Mihajlov <and@mullvad.net>
//

#import "NSEventMonitor.h"
#import "NSEventMaskWrap.h"
#import "NSEventWrap.h"

using namespace addon;

NAN_MODULE_INIT(InitAll) {
  NSEventMonitor::Init(target);
  NSEventMaskWrap::Init(target);
  NSEventWrap::Init(target);
}

NODE_MODULE(NSEventMonitor, InitAll)
