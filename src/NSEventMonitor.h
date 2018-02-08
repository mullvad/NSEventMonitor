//
// NSEventMonitor extension
//
// Author: Andrei Mihailov <and@codeispoetry.ru>
//

#include <node.h>
#include <node_object_wrap.h>

@class NSEvent;

namespace addon {

  class NSEventMonitor : public node::ObjectWrap {
  public:
    static void Init(v8::Local<v8::Object> exports);

  private:
    explicit NSEventMonitor();
    virtual ~NSEventMonitor();

    void StartMonitoring(v8::Persistent<v8::Number> &eventMask, v8::Persistent<v8::Function> &callback);
    void StopMonitoring();

    void EmitEvent(NSEvent *event);

    static void New(const v8::FunctionCallbackInfo<v8::Value>& args);
    static void Start(const v8::FunctionCallbackInfo<v8::Value>& args);
    static void Stop(const v8::FunctionCallbackInfo<v8::Value>& args);
    static v8::Persistent<v8::Function> constructor;

    v8::Persistent<v8::Function> m_monitorCallback;
    id m_eventMonitor;
  };
}