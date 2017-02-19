//
// NSEventMonitor extension
//
// Author: Andrei Mihailov <and@codeispoetry.ru>
//

#include "NSEventMonitor.h"

#import <Cocoa/Cocoa.h>
#import <ApplicationServices/ApplicationServices.h>

Persistent<Function> NSEventMonitor::constructor;

NSEventMonitor::NSEventMonitor() : m_eventMonitor(NULL) {
  NSLog(@"NSEventMonitor<%p> created", this);
}

NSEventMonitor::~NSEventMonitor() {
  StopMonitoring();

  NSLog(@"NSEventMonitor<%p> destroyed", this);
}

void NSEventMonitor::CheckAccessibility() {
  // 10.9+ only, see this url for compatibility:
  // http://stackoverflow.com/questions/17693408/enable-access-for-assistive-devices-programmatically-on-10-9
  NSDictionary* opts = @{ (id)kAXTrustedCheckOptionPrompt: @YES };
  if(AXIsProcessTrustedWithOptions((__bridge CFDictionaryRef)opts)) {
    NSLog(@"NSEventMonitor<%p> accessibility enabled", this);
  } else {
    NSLog(@"NSEventMonitor<%p> accessibility disabled", this);
  }
}

void NSEventMonitor::EmitEvent() {
  Isolate *isolate = Isolate::GetCurrent();
  HandleScope scope(isolate);

  if(!m_monitorCallback.IsEmpty()) {
    Local<Function> func = Local<Function>::New(isolate, m_monitorCallback);
    func->Call(Null(isolate), 0, NULL);
  }
}

void NSEventMonitor::StartMonitoring(Persistent<Function> &callback) {
  CheckAccessibility();
  StopMonitoring();
  
  m_monitorCallback.Reset(Isolate::GetCurrent(), callback);
  m_eventMonitor = [NSEvent addGlobalMonitorForEventsMatchingMask:(NSEventMaskLeftMouseDown | NSEventMaskRightMouseDown) handler:^(NSEvent *event) {
    EmitEvent();
  }];

  NSLog(@"NSEventMonitor<%p> started", this);
}

void NSEventMonitor::StopMonitoring() {
  if(m_eventMonitor) {
    [NSEvent removeMonitor:m_eventMonitor];
    m_eventMonitor = NULL;
    m_monitorCallback.Reset();
  
    NSLog(@"NSEventMonitor<%p> stopped", this);
  }
}

// 
// Exported methods
//

void NSEventMonitor::Init(Local<Object> exports, Local<Object> module) {
  Isolate *isolate = exports->GetIsolate();
  HandleScope scope(isolate);

  // Prepare constructor template
  Local<FunctionTemplate> tpl = FunctionTemplate::New(isolate, New);

  tpl->SetClassName(String::NewFromUtf8(isolate, "NSEventMonitor"));
  tpl->InstanceTemplate()->SetInternalFieldCount(1);

  // Prototype
  NODE_SET_PROTOTYPE_METHOD(tpl, "start", Start);
  NODE_SET_PROTOTYPE_METHOD(tpl, "stop", Stop);

  constructor.Reset(isolate, tpl->GetFunction());

  // replace module.exports with constructor
  module->Set(String::NewFromUtf8(isolate, "exports"), tpl->GetFunction());
}

void NSEventMonitor::Start(const FunctionCallbackInfo<Value>& args) {
  Isolate *isolate = Isolate::GetCurrent();
  HandleScope scope(isolate);

  if (args.Length() >= 1 && args[0]->IsFunction()) {
    NSEventMonitor* eventMonitor = ObjectWrap::Unwrap<NSEventMonitor>(args.Holder());
    Persistent<Function> func(isolate, Local<Function>::Cast(args[0]));

    eventMonitor->StartMonitoring(func);
  } else {
    Local<String> error = String::NewFromUtf8(isolate, "First argument must be a function");
    isolate->ThrowException(v8::Exception::TypeError(error));
  }
}

void NSEventMonitor::Stop(const FunctionCallbackInfo<Value>& args) {
  Isolate *isolate = args.GetIsolate();
  HandleScope scope(isolate);

  NSEventMonitor* obj = ObjectWrap::Unwrap<NSEventMonitor>(args.Holder());

  obj->StopMonitoring();
}

void NSEventMonitor::New(const FunctionCallbackInfo<Value>& args) {
  Isolate *isolate = args.GetIsolate();
  HandleScope scope(isolate);

  NSEventMonitor* obj = new NSEventMonitor();
  obj->Wrap(args.This());
  args.GetReturnValue().Set(args.This());
}

void InitAll(Local<Object> exports, Local<Object> module) {
  NSEventMonitor::Init(exports, module);
}

NODE_MODULE(NSEventMonitor, InitAll)
