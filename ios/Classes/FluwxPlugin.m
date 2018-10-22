#import <fluwx/FluwxPlugin.h>


#import "FluwxAuthHandler.h"

#import "FluwxPaymentHandler.h"
#import "FluwxMethods.h"
#import "FluwxKeys.h"
#import "FluwxWXApiHandler.h"
#import "FluwxShareHandler.h"
#import "FluwxLaunchMiniProgramHandler.h"


@implementation FluwxPlugin

BOOL isWeChatRegistered = NO;
BOOL handleOpenURLByFluwx = YES;

FluwxShareHandler *_fluwxShareHandler;

FluwxAuthHandler *_fluwxAuthHandler;
FluwxWXApiHandler *_fluwxWXApiHandler;
FluwxPaymentHandler *_fluwxPaymentHandler;
FluwxLaunchMiniProgramHandler *_fluwxLaunchMiniProgramHandler;

- (void)dealloc
{
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

+ (void)registerWithRegistrar:(NSObject <FlutterPluginRegistrar> *)registrar {
    FlutterMethodChannel *channel = [FlutterMethodChannel
            methodChannelWithName:@"com.jarvanmo/fluwx"
                  binaryMessenger:[registrar messenger]];

    FluwxPlugin *instance = [[FluwxPlugin alloc] initWithRegistrar:registrar];
    [[FluwxResponseHandler defaultManager] setMethodChannel:channel];
    [registrar addMethodCallDelegate:instance channel:channel];


}

- (instancetype)initWithRegistrar:(NSObject <FlutterPluginRegistrar> *)registrar {
    self = [super init];
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(handleOpenURL:)
//                                                 name:@"WeChat"
//                                               object:nil];
    if (self) {
        _fluwxShareHandler = [[FluwxShareHandler alloc] initWithRegistrar:registrar];
        _fluwxAuthHandler = [[FluwxAuthHandler alloc] initWithRegistrar:registrar];
        _fluwxWXApiHandler = [[FluwxWXApiHandler alloc] init];
        _fluwxPaymentHandler = [[FluwxPaymentHandler alloc] initWithRegistrar:registrar];
        _fluwxLaunchMiniProgramHandler = [[FluwxLaunchMiniProgramHandler alloc] initWithRegistrar:registrar];

    }

    return self;
}




- (void)handleMethodCall:(FlutterMethodCall *)call result:(FlutterResult)result {


    if ([registerApp isEqualToString:call.method]) {
        [_fluwxWXApiHandler registerApp:call result:result];
        return;
    }

    if([@"isWeChatInstalled" isEqualToString :call.method]){
        [_fluwxWXApiHandler checkWeChatInstallation:call result:result];
        return;
    }


    if([@"sendAuth" isEqualToString :call.method]){
        [_fluwxAuthHandler handleAuth:call result:result];
        return;
    }

    if([@"payWithFluwx" isEqualToString :call.method]){
        [_fluwxPaymentHandler handlePayment:call result:result];
        return;
    }

    if ([call.method hasPrefix:@"share"]) {
        [_fluwxShareHandler handleShare:call result:result];
        return;
    } else {
        result(FlutterMethodNotImplemented);
    }
    if([@"launchMiniProgram" isEqualToString :call.method]){
//        [_fluwxLaunchMiniProgramHandler handlerLaunchMiniProgram:call result:result];
        return;
    }

}


-(BOOL)handleOpenURL:(NSNotification *)aNotification {

    if(handleOpenURLByFluwx){
        NSString * aURLString =  [aNotification userInfo][@"url"];
        NSURL * aURL = [NSURL URLWithString:aURLString];
        return [WXApi handleOpenURL:aURL delegate:[FluwxResponseHandler defaultManager]];
    } else{
        return NO;
    }

}

- (void)unregisterApp:(FlutterMethodCall *)call result:(FlutterResult)result {

    isWeChatRegistered = false;
    result(@YES);
}


@end
