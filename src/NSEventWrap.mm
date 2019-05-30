//
// NSEventMonitor extension
//
// Author: Andrej Mihajlov <and@mullvad.net>
//

#import <AppKit/AppKit.h>
#import "NSEventWrap.h"

Nan::Persistent<v8::Function> addon::NSEventWrap::publicConstructor;
Nan::Persistent<v8::Function> addon::NSEventWrap::privateConstructor;

NAN_MODULE_INIT(addon::NSEventWrap::Init) {
  Nan::HandleScope scope;

  // Prepare constructor template

  v8::Local<v8::FunctionTemplate> privateTemplate = Nan::New<v8::FunctionTemplate>(PrivateNew);
  v8::Local<v8::FunctionTemplate> publicTemplate = Nan::New<v8::FunctionTemplate>(New);

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
    Nan::New<v8::FunctionTemplate>(Type),
    v8::Local<v8::FunctionTemplate>(),
    readOnlyAttributes
  );

  prototype->SetAccessorProperty(
    Nan::New<v8::String>("timestamp").ToLocalChecked(),
    Nan::New<v8::FunctionTemplate>(Timestamp),
    v8::Local<v8::FunctionTemplate>(),
    readOnlyAttributes
  );

  publicTemplate->Inherit(privateTemplate);

  publicConstructor.Reset(Nan::GetFunction(publicTemplate).ToLocalChecked());
  privateConstructor.Reset(Nan::GetFunction(privateTemplate).ToLocalChecked());

  Nan::Set(target,
    Nan::New<v8::String>("NSEvent").ToLocalChecked(),
    Nan::GetFunction(publicTemplate).ToLocalChecked());
}

v8::Local<v8::Object> addon::NSEventWrap::CreateObject(NSEvent *event) {
  Nan::EscapableHandleScope scope;

  NSEventWrap* object = new NSEventWrap(event);
  v8::Local<v8::Function> cons = Nan::New<v8::Function>(privateConstructor);
  v8::Local<v8::Object> instance = Nan::NewInstance(cons).ToLocalChecked();
  object->Wrap(instance);

  return scope.Escape(instance);
}

NSEvent *addon::NSEventWrap::GetNSEvent() {
  return m_event;
}

NAN_METHOD(addon::NSEventWrap::PrivateNew) {}

NAN_METHOD(addon::NSEventWrap::New) {
  Nan::HandleScope scope;

  Nan::ThrowError("NSEvent is not a constructor.");
}

NAN_METHOD(addon::NSEventWrap::Type) {
  Nan::HandleScope scope;

  NSEventWrap *object = Nan::ObjectWrap::Unwrap<NSEventWrap>(info.Holder());
  info.GetReturnValue().Set(Nan::New<v8::Number>(object->GetNSEvent().type));
}

NAN_METHOD(addon::NSEventWrap::Timestamp) {
  Nan::HandleScope scope;

  NSEventWrap *object = Nan::ObjectWrap::Unwrap<NSEventWrap>(info.Holder());
  info.GetReturnValue().Set(Nan::New<v8::Number>(object->GetNSEvent().timestamp));
}
