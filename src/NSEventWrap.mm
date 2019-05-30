//
// NSEventMonitor extension
//
// Author: Andrei Mihailov <and@codeispoetry.ru>
//

#include <nan.h>
#import <AppKit/AppKit.h>
#import "NSEventWrap.h"

v8::Persistent<v8::Function> addon::NSEventWrap::m_publicConstructor;
v8::Persistent<v8::Function> addon::NSEventWrap::m_privateConstructor;

void addon::NSEventWrap::Init(v8::Local<v8::Object> exports) {
  v8::Isolate* isolate = exports->GetIsolate();
  v8::Local<v8::Context> context = isolate->GetCurrentContext();
  v8::HandleScope scope(isolate);

  // Prepare constructor template

  v8::Local<v8::FunctionTemplate> privateTemplate = v8::FunctionTemplate::New(isolate, PrivateNew);
  v8::Local<v8::FunctionTemplate> publicTemplate = v8::FunctionTemplate::New(isolate, New);

  publicTemplate->SetClassName(Nan::New<v8::String>("NSEvent").ToLocalChecked());
  publicTemplate->InstanceTemplate()->SetInternalFieldCount(1);

  privateTemplate->SetClassName(Nan::New<v8::String>("NSEvent").ToLocalChecked());
  privateTemplate->InstanceTemplate()->SetInternalFieldCount(1);

  // Prototype
  v8::Local<v8::ObjectTemplate> prototype = privateTemplate->PrototypeTemplate();
  v8::PropertyAttribute readOnlyAttributes = (v8::PropertyAttribute)
    (v8::PropertyAttribute::ReadOnly | v8::PropertyAttribute::DontDelete);
  prototype->SetAccessorProperty(
    Nan::New<v8::String>("type").ToLocalChecked(),
    v8::FunctionTemplate::New(isolate, Type),
    v8::Local<v8::FunctionTemplate>(),
    readOnlyAttributes
  );

  prototype->SetAccessorProperty(
    Nan::New<v8::String>("timestamp").ToLocalChecked(),
    v8::FunctionTemplate::New(isolate, Timestamp),
    v8::Local<v8::FunctionTemplate>(),
    readOnlyAttributes
  );

  publicTemplate->Inherit(privateTemplate);

  m_publicConstructor.Reset(isolate, publicTemplate->GetFunction(context).ToLocalChecked());
  m_privateConstructor.Reset(isolate, privateTemplate->GetFunction(context).ToLocalChecked());

  Nan::Set(exports,
    Nan::New<v8::String>("NSEvent").ToLocalChecked(),
    publicTemplate->GetFunction(context).ToLocalChecked());
}

v8::Local<v8::Object> addon::NSEventWrap::CreateObject(v8::Isolate *isolate, NSEvent *event) {
  v8::Local<v8::Context> context = isolate->GetCurrentContext();
  Nan::EscapableHandleScope scope;

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
  Nan::HandleScope scope;

  Nan::ThrowError("NSEvent is not a constructor.");
}

void addon::NSEventWrap::Type(const v8::FunctionCallbackInfo<v8::Value>& args) {
  Nan::HandleScope scope;

  NSEventWrap *object = node::ObjectWrap::Unwrap<NSEventWrap>(args.Holder());
  args.GetReturnValue().Set(Nan::New<v8::Number>(object->GetNSEvent().type));
}

void addon::NSEventWrap::Timestamp(const v8::FunctionCallbackInfo<v8::Value>& args) {
  Nan::HandleScope scope;

  NSEventWrap *object = node::ObjectWrap::Unwrap<NSEventWrap>(args.Holder());
  args.GetReturnValue().Set(Nan::New<v8::Number>(object->GetNSEvent().timestamp));
}
