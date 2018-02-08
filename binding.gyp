{
  "targets": [{
    "target_name": "nseventmonitor",
    "sources": [
      "src/addon.mm",
      "src/NSEventMonitor.mm",
      "src/NSEventMaskWrap.mm",
      "src/NSEventWrap.mm"
    ],
    "conditions": [
      ['OS=="mac"', {
        'link_settings': {
          'libraries': [
            '$(SDKROOT)/System/Library/Frameworks/AppKit.framework'
          ]
        },
        'xcode_settings': {
          'MACOSX_DEPLOYMENT_TARGET': '10.7',
          'OTHER_CFLAGS': [
            '-std=c++11',
            '-stdlib=libc++'
          ]
        }
      }]
    ]
  }]
}
