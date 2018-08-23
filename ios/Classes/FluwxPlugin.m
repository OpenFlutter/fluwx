#import <fluwx/FluwxPlugin.h>

#import "WXApi.h"
#import "StringUtil.h"
#import "../../../../../../ios/Classes/handler/FluwxShareHandler.h"
#import "ImageSchema.h"
#import "FluwxResponseHandler.h"
#import "FluwxAuthHandler.h"


@implementation FluwxPlugin

BOOL isWeChatRegistered = NO;


+ (void)registerWithRegistrar:(NSObject <FlutterPluginRegistrar> *)registrar {
    FlutterMethodChannel *channel = [FlutterMethodChannel
            methodChannelWithName:@"fluwx"
                  binaryMessenger:[registrar messenger]];

    FluwxPlugin *instance = [[FluwxPlugin alloc] initWithRegistrar:registrar];
    [[FluwxResponseHandler responseHandler] setMethodChannel:channel];
    [registrar addMethodCallDelegate:instance channel:channel];


}

- (instancetype)initWithRegistrar:(NSObject <FlutterPluginRegistrar> *)registrar {
    self = [super init];
    if (self) {
        _fluwxShareHandler = [[FluwxShareHandler alloc] initWithRegistrar:registrar];
        _fluwxAuthHandler = [[FluwxAuthHandler alloc] initWithRegistrar:registrar];
    }

    return self;
}

- (void)handleMethodCall:(FlutterMethodCall *)call result:(FlutterResult)result {


    if ([registerApp isEqualToString:call.method]) {
        [self initWeChatIfNeeded:call result:result];
        return;
    }

    if ([unregisterApp isEqualToString:call.method]) {
        [self initWeChatIfNeeded:call result:result];
        return;
    }


    if([@"sendAuth" isEqualToString :call.method]){
        [_fluwxAuthHandler handleAuth:call result:result];
        return;
    }

    if ([call.method hasPrefix:@"share"]) {
        [_fluwxShareHandler handleShare:call result:result];
        return;
    } else {
        result(FlutterMethodNotImplemented);
    }


}


- (void)initWeChatIfNeeded:(FlutterMethodCall *)call result:(FlutterResult)result {

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

- (void)unregisterApp:(FlutterMethodCall *)call result:(FlutterResult)result {

    isWeChatRegistered = false;
    result(@YES);
}


@end
