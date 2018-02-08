//
// NSEventMonitor extension
//
// Author: Andrei Mihailov <and@codeispoetry.ru>
//

#include <node.h>
#include <node_object_wrap.h>

@class NSEvent;

namespace addon {

  class NSEventWrap: public node::ObjectWrap {
  public:
    static void Init(v8::Local<v8::Object> exports);
    static v8::Local<v8::Object> CreateObject(v8::Isolate *isolate, NSEvent *event);

    NSEvent *GetNSEvent();

  private:
    explicit NSEventWrap(NSEvent *event) : m_event(event) {};
    ~NSEventWrap() {};

    static void PrivateNew(const v8::FunctionCallbackInfo<v8::Value>& args);
    static void New(const v8::FunctionCallbackInfo<v8::Value>& args);
    static void Type(const v8::FunctionCallbackInfo<v8::Value>& args);
    static void Timestamp(const v8::FunctionCallbackInfo<v8::Value>& args);

    static v8::Persistent<v8::Function> m_publicConstructor;
    static v8::Persistent<v8::Function> m_privateConstructor;

    NSEvent *m_event;
  };

}