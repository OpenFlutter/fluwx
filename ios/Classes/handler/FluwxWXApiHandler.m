//
// Created by mo on 2018/8/23.
//

#import <WechatOpenSDK/WXApi.h>
#import "FluwxWXApiHandler.h"
#import "StringUtil.h"
#import "FluwxPlugin.h"
#import "CallResults.h"


@implementation FluwxWXApiHandler
- (void)registerApp:(FlutterMethodCall *)call result:(FlutterResult)result {
    if (!call.arguments[fluwxKeyIOS]) {
        result(@{fluwxKeyPlatform: fluwxKeyIOS, fluwxKeyResult: @NO});
        return;
    }

    if (isWeChatRegistered) {
        result(@{fluwxKeyPlatform: fluwxKeyIOS, fluwxKeyResult: @YES});
        return;
    }

    NSString *appId = call.arguments[@"appId"];
    if ([StringUtil isBlank:appId]) {
        result([FlutterError errorWithCode:@"invalid app id" message:@"are you sure your app id is correct ? " details:appId]);
        return;
    }


    isWeChatRegistered = [WXApi registerApp:appId];
    result(@{fluwxKeyPlatform: fluwxKeyIOS, fluwxKeyResult: @(isWeChatRegistered)});
}

- (void)checkWeChatInstallation:(FlutterMethodCall *)call result:(FlutterResult)result {
    if (!isWeChatRegistered) {
        result([FlutterError errorWithCode:resultErrorNeedWeChat message:@"please config  wxapi first" details:nil]);
        return;
    }else{
        result(@([WXApi isWXAppInstalled]));
    }
}
@end