//
// NSEventMonitor extension
// NSEventMaskWrap wrapper around NSEventMask
//
// Author: Andrej Mihajlov <and@mullvad.net>
//

#include <nan.h>

namespace addon {

  class NSEventMaskWrap {
    public:
      static NAN_MODULE_INIT(Init);
  };

}
