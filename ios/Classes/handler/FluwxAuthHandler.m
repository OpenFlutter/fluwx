//
// Created by mo on 2018/8/23.
//

#import "FluwxAuthHandler.h"


@implementation FluwxAuthHandler

- (instancetype)initWithRegistrar:(NSObject <FlutterPluginRegistrar> *)registrar {
    self = [super init];
//    if (self) {
//
//    }

    return self;
}

- (void)handleAuth:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *openId = call.arguments[@"openId"];

    [WXApiRequestHandler sendAuthRequestScope:call.arguments[@"scope"]
                                        State:call.arguments[@"state"]
                                       OpenID:(openId == (id) [NSNull null]) ? nil : openId];
}
@end