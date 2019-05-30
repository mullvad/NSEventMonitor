//
// NSEventMonitor extension
//
// Author: Andrej Mihajlov <and@mullvad.net>
//

#include <nan.h>

@class NSEvent;

namespace addon {

  class NSEventWrap: public Nan::ObjectWrap {
  public:
    static NAN_MODULE_INIT(Init);
    static v8::Local<v8::Object> CreateObject(NSEvent *event);

    NSEvent *GetNSEvent();

  private:
    explicit NSEventWrap(NSEvent *event) : m_event(event) {};
    ~NSEventWrap() {};

    static NAN_METHOD(PrivateNew);
    static NAN_METHOD(New);
    static NAN_METHOD(Type);
    static NAN_METHOD(Timestamp);

    static Nan::Persistent<v8::Function> publicConstructor;
    static Nan::Persistent<v8::Function> privateConstructor;

    NSEvent *m_event;
  };

}
