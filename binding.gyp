{
  "targets": [{
    "target_name": "nseventmonitor",
    "sources": [ "src/addon.mm", "src/NSEventMonitor.mm", "src/NSEventMaskWrap.mm" ],
    "conditions": [
      ['OS=="mac"', {
        'link_settings': {
          'libraries': [
            '$(SDKROOT)/System/Library/Frameworks/AppKit.framework'
          ]
        },
        'xcode_settings': {
          'MACOSX_DEPLOYMENT_TARGET': '10.9'
        }
      }]
    ]
  }]
}
