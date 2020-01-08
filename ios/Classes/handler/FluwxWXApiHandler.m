//
// Created by mo on 2018/8/23.
//


#import "FluwxWXApiHandler.h"
#import "FluwxStringUtil.h"
#import "FluwxPlugin.h"
#import "CallResults.h"
#import "FluwxKeys.h"
#import "WXApi.h"

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
    if ([FluwxStringUtil isBlank:appId]) {
        result([FlutterError errorWithCode:@"invalid app id" message:@"are you sure your app id is correct ? " details:appId]);
        return;
    }

    NSString *universalLink = call.arguments[@"universalLink"];

    if ([FluwxStringUtil isBlank:universalLink]) {
        result([FlutterError errorWithCode:@"invalid universal link" message:@"are you sure your universal link is correct ? " details:universalLink]);
        return;
    }
//    isWeChatRegistered = [WXApi registerApp:appId enableMTA:[call.arguments[@"enableMTA"] boolValue]];

    isWeChatRegistered = [WXApi registerApp:appId universalLink:universalLink];

//    UInt64 typeFlag = MMAPP_SUPPORT_TEXT | MMAPP_SUPPORT_PICTURE | MMAPP_SUPPORT_LOCATION | MMAPP_SUPPORT_VIDEO | MMAPP_SUPPORT_AUDIO | MMAPP_SUPPORT_WEBPAGE | MMAPP_SUPPORT_DOC | MMAPP_SUPPORT_DOCX | MMAPP_SUPPORT_PPT | MMAPP_SUPPORT_PPTX | MMAPP_SUPPORT_XLS | MMAPP_SUPPORT_XLSX | MMAPP_SUPPORT_PDF;
//    [WXApi registerAppSupportContentFlag:typeFlag];
//
//    wx
    result(@{fluwxKeyPlatform: fluwxKeyIOS, fluwxKeyResult: @(isWeChatRegistered)});
}

- (void)checkWeChatInstallation:(FlutterMethodCall *)call result:(FlutterResult)result {
//     if (!isWeChatRegistered) {
//         result([FlutterError errorWithCode:resultErrorNeedWeChat message:@"Did you register your WxApi correctly? Or is your universal link correct?" details:nil]);
//         return;
//     } else {
        result(@([WXApi isWXAppInstalled]));
//     }
}
@end
