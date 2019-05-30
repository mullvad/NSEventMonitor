//
// NSEventMonitor extension
//
// Author: Andrei Mihailov <and@codeispoetry.ru>
//

#include "NSEventMonitor.h"
#import <AppKit/AppKit.h>
#import <nan.h>
#import "NSEventMaskWrap.h"
#import "NSEventWrap.h"

v8::Persistent<v8::Function> addon::NSEventMonitor::constructor;

addon::NSEventMonitor::NSEventMonitor() : m_eventMonitor(NULL) {}

addon::NSEventMonitor::~NSEventMonitor() {
  StopMonitoring();
}

void addon::NSEventMonitor::EmitEvent(NSEvent *event) {
  v8::Isolate *isolate = v8::Isolate::GetCurrent();
  v8::HandleScope scope(isolate);

  if(!m_monitorCallback.IsEmpty()) {
    v8::Local<v8::Object> eventObject = NSEventWrap::CreateObject(isolate, event);
    v8::Local<v8::Value> args[1] = { eventObject };

    Nan::AsyncResource resource("NSEventMonitor.EmitEvent");

    m_monitorCallback.Call(1, args, &resource);
  }
}

void addon::NSEventMonitor::StartMonitoring(v8::Local<v8::Number> &eventMask, v8::Local<v8::Function> &callback) {
  Nan::HandleScope scope;
  NSEventMask nsEventMask = static_cast<NSEventMask>(Nan::To<int32_t>(eventMask).ToChecked());

  StopMonitoring();

  m_monitorCallback.Reset(callback);
  m_eventMonitor = [NSEvent addGlobalMonitorForEventsMatchingMask:nsEventMask handler:^(NSEvent *event) {
    EmitEvent(event);
  }];
}

void addon::NSEventMonitor::StopMonitoring() {
  if(m_eventMonitor) {
    [NSEvent removeMonitor:m_eventMonitor];
    m_eventMonitor = NULL;
    m_monitorCallback.Reset();
  }
}

//
// Exported methods
//

void addon::NSEventMonitor::Init(v8::Local<v8::Object> exports) {
  v8::Isolate *isolate = exports->GetIsolate();
  v8::Local<v8::Context> context = isolate->GetCurrentContext();
  v8::HandleScope scope(isolate);

  // Prepare constructor template
  v8::Local<v8::FunctionTemplate> tpl = v8::FunctionTemplate::New(isolate, New);

  tpl->SetClassName(Nan::New<v8::String>("NSEventMonitor").ToLocalChecked());
  tpl->InstanceTemplate()->SetInternalFieldCount(1);

  // Prototype
  NODE_SET_PROTOTYPE_METHOD(tpl, "start", Start);
  NODE_SET_PROTOTYPE_METHOD(tpl, "stop", Stop);

  constructor.Reset(isolate, tpl->GetFunction(context).ToLocalChecked());

  Nan::Set(exports,
    Nan::New<v8::String>("NSEventMonitor").ToLocalChecked(),
    tpl->GetFunction(context).ToLocalChecked());
}

void addon::NSEventMonitor::Start(const v8::FunctionCallbackInfo<v8::Value>& args) {
  v8::Isolate *isolate = v8::Isolate::GetCurrent();
  v8::HandleScope scope(isolate);

  if (args.Length() >= 2 && args[0]->IsNumber() && args[1]->IsFunction()) {
    NSEventMonitor *eventMonitor = ObjectWrap::Unwrap<NSEventMonitor>(args.Holder());
    v8::Local<v8::Number> eventMask(v8::Local<v8::Number>::Cast(args[0]));
    v8::Local<v8::Function> func = v8::Local<v8::Function>::Cast(args[1]);

    eventMonitor->StartMonitoring(eventMask, func);
  } else {
    Nan::ThrowTypeError("Expected two arguments: number, function");
  }
}

void addon::NSEventMonitor::Stop(const v8::FunctionCallbackInfo<v8::Value>& args) {
  Nan::HandleScope scope;

  NSEventMonitor* obj = ObjectWrap::Unwrap<NSEventMonitor>(args.Holder());

  obj->StopMonitoring();
}

void addon::NSEventMonitor::New(const v8::FunctionCallbackInfo<v8::Value>& args) {
  Nan::HandleScope scope;

  NSEventMonitor* object = new NSEventMonitor();
  object->Wrap(args.This());
  args.GetReturnValue().Set(args.This());
}
