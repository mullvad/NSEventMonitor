//
// NSEventMonitor extension
//
// Author: Andrej Mihajlov <and@mullvad.net>
//

#include <nan.h>

@class NSEvent;

namespace addon {

  class NSEventMonitor : public Nan::ObjectWrap {
  public:
    static NAN_MODULE_INIT(Init);

  private:
    explicit NSEventMonitor();
    virtual ~NSEventMonitor();

    void StartMonitoring(v8::Local<v8::Number> &eventMask, v8::Local<v8::Function> &callback);
    void StopMonitoring();

    void EmitEvent(NSEvent *event);

    static NAN_METHOD(New);
    static NAN_METHOD(Start);
    static NAN_METHOD(Stop);
    static Nan::Persistent<v8::Function> constructor;

    Nan::Callback m_monitorCallback;

    id m_eventMonitor;
  };
}
