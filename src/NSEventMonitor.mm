//
// NSEventMonitor extension
//
// Author: Andrej Mihajlov <and@mullvad.net>
//

#include "NSEventMonitor.h"
#import <AppKit/AppKit.h>
#import "NSEventMaskWrap.h"
#import "NSEventWrap.h"

Nan::Persistent<v8::Function> addon::NSEventMonitor::constructor;

addon::NSEventMonitor::NSEventMonitor() : m_eventMonitor(NULL) {}

addon::NSEventMonitor::~NSEventMonitor() {
  StopMonitoring();
}

void addon::NSEventMonitor::EmitEvent(NSEvent *event) {
  Nan::HandleScope scope;

  if(!m_monitorCallback.IsEmpty()) {
    v8::Local<v8::Object> eventObject = NSEventWrap::CreateObject(event);
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

NAN_MODULE_INIT(addon::NSEventMonitor::Init) {
  Nan::HandleScope scope;

  // Prepare constructor template
  v8::Local<v8::FunctionTemplate> tpl = Nan::New<v8::FunctionTemplate>(New);

  tpl->SetClassName(Nan::New<v8::String>("NSEventMonitor").ToLocalChecked());
  tpl->InstanceTemplate()->SetInternalFieldCount(1);

  // Prototype
  Nan::SetPrototypeMethod(tpl, "start", Start);
  Nan::SetPrototypeMethod(tpl, "stop", Stop);

  constructor.Reset(Nan::GetFunction(tpl).ToLocalChecked());

  Nan::Set(target,
    Nan::New<v8::String>("NSEventMonitor").ToLocalChecked(),
    Nan::GetFunction(tpl).ToLocalChecked());
}

NAN_METHOD(addon::NSEventMonitor::Start) {
  Nan::HandleScope scope;

  if (info.Length() >= 2 && info[0]->IsNumber() && info[1]->IsFunction()) {
    NSEventMonitor *eventMonitor = Nan::ObjectWrap::Unwrap<NSEventMonitor>(info.Holder());
    v8::Local<v8::Number> eventMask(v8::Local<v8::Number>::Cast(info[0]));
    v8::Local<v8::Function> func = v8::Local<v8::Function>::Cast(info[1]);

    eventMonitor->StartMonitoring(eventMask, func);
  } else {
    Nan::ThrowTypeError("Expected two arguments: number, function");
  }
}

NAN_METHOD(addon::NSEventMonitor::Stop) {
  Nan::HandleScope scope;

  NSEventMonitor* obj = Nan::ObjectWrap::Unwrap<NSEventMonitor>(info.Holder());

  obj->StopMonitoring();
}

NAN_METHOD(addon::NSEventMonitor::New) {
  Nan::HandleScope scope;

  NSEventMonitor* object = new NSEventMonitor();
  object->Wrap(info.This());
  info.GetReturnValue().Set(info.This());
}
