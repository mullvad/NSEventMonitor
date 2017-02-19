{
  "targets": [{
    "target_name": "NSEventMonitor",
    "sources": [ "NSEventMonitor.mm" ],
    "conditions": [
      ['OS=="mac"', {
        'link_settings': {
          'libraries': [
            '$(SDKROOT)/System/Library/Frameworks/Cocoa.framework',
            '$(SDKROOT)/System/Library/Frameworks/ApplicationServices.framework'
          ]
        },
        'xcode_settings': {
          'MACOSX_DEPLOYMENT_TARGET': '10.9'
        }
      }]
    ]
  }]
}