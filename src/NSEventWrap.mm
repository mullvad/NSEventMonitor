//
// NSEventMonitor extension
//
// Author: Andrei Mihailov <and@codeispoetry.ru>
//

#import <AppKit/AppKit.h>
#import "NSEventWrap.h"

v8::Persistent<v8::Function> addon::NSEventWrap::m_publicConstructor;
v8::Persistent<v8::Function> addon::NSEventWrap::m_privateConstructor;

void addon::NSEventWrap::Init(v8::Local<v8::Object> exports) {
  v8::Isolate* isolate = exports->GetIsolate();
  v8::HandleScope scope(isolate);

  // Prepare constructor template

  v8::Local<v8::FunctionTemplate> privateTemplate = v8::FunctionTemplate::New(isolate, PrivateNew);
  v8::Local<v8::FunctionTemplate> publicTemplate = v8::FunctionTemplate::New(isolate, New);

  publicTemplate->SetClassName(v8::String::NewFromUtf8(isolate, "NSEvent"));
  publicTemplate->InstanceTemplate()->SetInternalFieldCount(1);

  privateTemplate->SetClassName(v8::String::NewFromUtf8(isolate, "NSEvent"));
  privateTemplate->InstanceTemplate()->SetInternalFieldCount(1);

  // Prototype
  v8::Local<v8::ObjectTemplate> prototype = privateTemplate->PrototypeTemplate();
  v8::PropertyAttribute readOnlyAttributes = (v8::PropertyAttribute)
    (v8::PropertyAttribute::ReadOnly | v8::PropertyAttribute::DontDelete);
  prototype->SetAccessorProperty(
    v8::String::NewFromUtf8(isolate, "type"),
    v8::FunctionTemplate::New(isolate, Type),
    v8::Local<v8::FunctionTemplate>(),
    readOnlyAttributes
  );

  prototype->SetAccessorProperty(
    v8::String::NewFromUtf8(isolate, "timestamp"),
    v8::FunctionTemplate::New(isolate, Timestamp),
    v8::Local<v8::FunctionTemplate>(),
    readOnlyAttributes
  );

  publicTemplate->Inherit(privateTemplate);

  m_publicConstructor.Reset(isolate, publicTemplate->GetFunction());
  m_privateConstructor.Reset(isolate, privateTemplate->GetFunction());

  exports->Set(v8::String::NewFromUtf8(isolate, "NSEvent"), publicTemplate->GetFunction());
}

v8::Local<v8::Object> addon::NSEventWrap::CreateObject(v8::Isolate *isolate, NSEvent *event) {
  v8::Local<v8::Context> context = isolate->GetCurrentContext();
  v8::EscapableHandleScope scope(isolate);

  NSEventWrap* object = new NSEventWrap(event);
  v8::Local<v8::Function> cons = v8::Local<v8::Function>::New(isolate, m_privateConstructor);
  v8::Local<v8::Object> instance = cons->NewInstance(context).ToLocalChecked();
  object->Wrap(instance);

  return scope.Escape(instance);
}

NSEvent *addon::NSEventWrap::GetNSEvent() {
  return m_event;
}

void addon::NSEventWrap::PrivateNew(const v8::FunctionCallbackInfo<v8::Value>& args) {}

void addon::NSEventWrap::New(const v8::FunctionCallbackInfo<v8::Value>& args) {
  v8::Isolate *isolate = v8::Isolate::GetCurrent();
  v8::HandleScope scope(isolate);

  isolate->ThrowException(
    v8::Exception::Error(v8::String::NewFromUtf8(isolate, "NSEvent is not a constructor."))
  );
}

void addon::NSEventWrap::Type(const v8::FunctionCallbackInfo<v8::Value>& args) {
  v8::Isolate *isolate = v8::Isolate::GetCurrent();
  v8::HandleScope scope(isolate);

  NSEventWrap *object = node::ObjectWrap::Unwrap<NSEventWrap>(args.Holder());
  args.GetReturnValue().Set(v8::Number::New(isolate, object->GetNSEvent().type));
}

void addon::NSEventWrap::Timestamp(const v8::FunctionCallbackInfo<v8::Value>& args) {
  v8::Isolate *isolate = v8::Isolate::GetCurrent();
  v8::HandleScope scope(isolate);

  NSEventWrap *object = node::ObjectWrap::Unwrap<NSEventWrap>(args.Holder());
  args.GetReturnValue().Set(v8::Number::New(isolate, object->GetNSEvent().timestamp));
}
