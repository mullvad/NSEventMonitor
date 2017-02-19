//
// NSEventMonitor extension
//
// Author: Andrei Mihailov <and@codeispoetry.ru>
//

#include <node.h>
#include <node_object_wrap.h>

namespace {

  using v8::Function;
  using v8::FunctionTemplate;
  using v8::FunctionCallbackInfo;
  using v8::Isolate;
  using v8::Persistent;
  using v8::Local;
  using v8::Null;
  using v8::Object;
  using v8::String;
  using v8::Value;
  using v8::HandleScope;

  class NSEventMonitor : public node::ObjectWrap {
  public:
    static void Init(Local<Object> exports, Local<Object> module);

  private:
    explicit NSEventMonitor();
    virtual ~NSEventMonitor();

    void StartMonitoring(Persistent<Function> &callback);
    void StopMonitoring();

    void EmitEvent();

    static void New(const FunctionCallbackInfo<Value>& args);
    static void Start(const FunctionCallbackInfo<Value>& args);
    static void Stop(const FunctionCallbackInfo<Value>& args);
    static Persistent<Function> constructor;

    Persistent<Function> m_monitorCallback;
    id m_eventMonitor;
  };
}