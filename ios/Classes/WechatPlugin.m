#import "WechatPlugin.h"
#import <wechat_plugin/wechat_plugin-Swift.h>

@implementation WechatPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftWechatPlugin registerWithRegistrar:registrar];
}
@end
