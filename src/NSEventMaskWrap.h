//
// NSEventMonitor extension
// NSEventMaskWrap wrapper around NSEventMask
//
// Author: Andrei Mihailov <and@codeispoetry.ru>
//

#include <node.h>

namespace addon {

  class NSEventMaskWrap {
    public:
      static void Init(v8::Local<v8::Object> exports, v8::Local<v8::Object> module);

    private:
      static v8::Persistent<v8::Object> sharedInstance;
  };

}