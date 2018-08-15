#import <fluwx/FluwxPlugin.h>
#import "FluwxMethods.h"
#import "WXApi.h"
#import "StringUtil.h"
#import "CallResults.h"
#import "WXApiRequestHandler.h"
#import "FluwxKeys.h"
#import "StringToWeChatScene.h"


@implementation FluwxPlugin

BOOL isWeChatRegistered = NO;


+ (void)registerWithRegistrar:(NSObject <FlutterPluginRegistrar> *)registrar {
    FlutterMethodChannel *channel = [FlutterMethodChannel
            methodChannelWithName:@"fluwx"
                  binaryMessenger:[registrar messenger]];
    FluwxPlugin *instance = [[FluwxPlugin alloc] init];
    [registrar addMethodCallDelegate:instance channel:channel];

}

- (void)handleMethodCall:(FlutterMethodCall *)call result:(FlutterResult)result {

    if ([initWeChat isEqualToString:call.method]) {
        [self initWeChatIfNeeded:call result:result];
    } else if ([call.method hasPrefix:@"share"]) {
        [self handleShare:call result:result];
    } else {
        result(FlutterMethodNotImplemented);
    }

}


- (void)initWeChatIfNeeded:(FlutterMethodCall *)call result:(FlutterResult)result {
    if (isWeChatRegistered) {
        result(resultDone);
        return;
    }

    NSString *appId = call.arguments;
    if ([StringUtil isBlank:appId]) {
        result([FlutterError errorWithCode:@"invalid app id" message:@"are you sure your app id is correct ? " details:appId]);
        return;
    }


    [WXApi registerApp:appId];
    result(resultDone);
}

- (void)handleShare:(FlutterMethodCall *)call result:(FlutterResult)result {
    if (!isWeChatRegistered) {
        result([FlutterError errorWithCode:resultErrorNeedWeChat message:resultMessageNeedWeChat details:nil]);
        return;
    }

    if ([shareText isEqualToString:call.method]) {
        [self shareText:call result:result];
    } else if([shareImage isEqualToString:call.method]){
        [self shareImage:call result:result];
        result(FlutterMethodNotImplemented);
    }


}

- (void)shareText:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *text = call.arguments[fluwxKeyText];
    NSString *scene = call.arguments[fluwxKeyScene];
    BOOL done = [WXApiRequestHandler sendText:text InScene:[StringToWeChatScene toScene:scene]];
    result(@(done));
}


- (void)shareImage:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *text = call.arguments[fluwxKeyText];
    NSString *scene = call.arguments[fluwxKeyScene];
    BOOL done = [WXApiRequestHandler sendText:text InScene:[StringToWeChatScene toScene:scene]];
    result(@(done));
}


@end
