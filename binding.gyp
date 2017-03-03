{
  "targets": [{
    "target_name": "nseventmonitor",
    "sources": [ "NSEventMonitor.mm" ],
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
