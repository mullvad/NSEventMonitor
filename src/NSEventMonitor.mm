//
// NSEventMonitor extension
//
// Author: Andrei Mihailov <and@codeispoetry.ru>
//

#include "NSEventMonitor.h"
#import <AppKit/AppKit.h>
#import "NSEventMaskWrap.h"

v8::Persistent<v8::Function> addon::NSEventMonitor::constructor;

addon::NSEventMonitor::NSEventMonitor() : m_eventMonitor(NULL) {}

addon::NSEventMonitor::~NSEventMonitor() {
  StopMonitoring();
}

void addon::NSEventMonitor::EmitEvent() {
  v8::Isolate *isolate = v8::Isolate::GetCurrent();
  v8::HandleScope scope(isolate);

  if(!m_monitorCallback.IsEmpty()) {
    v8::Local<v8::Function> func = v8::Local<v8::Function>::New(isolate, m_monitorCallback);
    func->Call(Null(isolate), 0, NULL);
  }
}

void addon::NSEventMonitor::StartMonitoring(v8::Persistent<v8::Number> &eventMask, v8::Persistent<v8::Function> &callback) {
  v8::Isolate *isolate = v8::Isolate::GetCurrent();
  v8::HandleScope scope(isolate);
  
  v8::Local<v8::Number> mask = v8::Local<v8::Number>::New(isolate, eventMask);
  NSEventMask nsEventMask = static_cast<NSEventMask>(mask->IntegerValue());
  NSLog(@"StartMonitoring with mask: %@", @(nsEventMask));

  StopMonitoring();
  
  m_monitorCallback.Reset(v8::Isolate::GetCurrent(), callback);
  m_eventMonitor = [NSEvent addGlobalMonitorForEventsMatchingMask:nsEventMask handler:^(NSEvent *event) {
    EmitEvent();
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

void addon::NSEventMonitor::Init(v8::Local<v8::Object> exports, v8::Local<v8::Object> module) {
  v8::Isolate *isolate = exports->GetIsolate();
  v8::HandleScope scope(isolate);

  // Prepare constructor template
  v8::Local<v8::FunctionTemplate> tpl = v8::FunctionTemplate::New(isolate, New);
  
  tpl->SetClassName(v8::String::NewFromUtf8(isolate, "NSEventMonitor"));
  tpl->InstanceTemplate()->SetInternalFieldCount(1);

  // Prototype
  NODE_SET_PROTOTYPE_METHOD(tpl, "start", Start);
  NODE_SET_PROTOTYPE_METHOD(tpl, "stop", Stop);

  constructor.Reset(isolate, tpl->GetFunction());
  exports->Set(v8::String::NewFromUtf8(isolate, "NSEventMonitor"), tpl->GetFunction());
}

void addon::NSEventMonitor::Start(const v8::FunctionCallbackInfo<v8::Value>& args) {
  v8::Isolate *isolate = v8::Isolate::GetCurrent();
  v8::HandleScope scope(isolate);

  if (args.Length() >= 2 && args[0]->IsNumber() && args[1]->IsFunction()) {
    NSEventMonitor *eventMonitor = ObjectWrap::Unwrap<NSEventMonitor>(args.Holder());
    v8::Persistent<v8::Number> eventMask(isolate, v8::Local<v8::Number>::Cast(args[0]));
    v8::Persistent<v8::Function> func(isolate, v8::Local<v8::Function>::Cast(args[1]));
    
    eventMonitor->StartMonitoring(eventMask, func);
  } else {
    v8::Local<v8::String> error = v8::String::NewFromUtf8(isolate, "Expected two arguments: number, function");
    isolate->ThrowException(v8::Exception::TypeError(error));
  }
}

void addon::NSEventMonitor::Stop(const v8::FunctionCallbackInfo<v8::Value>& args) {
  v8::Isolate *isolate = args.GetIsolate();
  v8::HandleScope scope(isolate);

  NSEventMonitor* obj = ObjectWrap::Unwrap<NSEventMonitor>(args.Holder());

  obj->StopMonitoring();
}

void addon::NSEventMonitor::New(const v8::FunctionCallbackInfo<v8::Value>& args) {
  v8::Isolate *isolate = args.GetIsolate();
  v8::HandleScope scope(isolate);

  NSEventMonitor* object = new NSEventMonitor();
  object->Wrap(args.This());
  args.GetReturnValue().Set(args.This());
}
