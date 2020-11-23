{
  'conditions': [
    [
      'OS=="mac"', {
        "targets": [{
          "target_name": "nseventmonitor",
          "include_dirs" : [
            "<!(node -e \"require('nan')\")"
          ],
          "sources": [
            "src/addon.mm",
            "src/NSEventMonitor.mm",
            "src/NSEventMaskWrap.mm",
            "src/NSEventWrap.mm"
          ],
          "link_settings": {
            "libraries": [
              "$(SDKROOT)/System/Library/Frameworks/AppKit.framework"
            ]
          },
          "xcode_settings": {
            "MACOSX_DEPLOYMENT_TARGET": "10.7",
            "OTHER_CFLAGS": [
              "-std=c++14",
              "-stdlib=libc++"
            ]
          }
        }, {
          "target_name": "action_after_build",
          "type": "none",
          "dependencies": [ "<(module_name)" ],
          "copies": [
            {
              "files": [ "<(PRODUCT_DIR)/<(module_name).node" ],
              "destination": "<(module_path)"
            }
          ]
        }]
      }
    ]
  ]
}
