#import <fluwx/FluwxPlugin.h>


#import "FluwxAuthHandler.h"

#import "FluwxPaymentHandler.h"
#import "FluwxMethods.h"
#import "FluwxKeys.h"
#import "FluwxWXApiHandler.h"
#import "FluwxShareHandler.h"
#import "FluwxLaunchMiniProgramHandler.h"
#import "FluwxSubscribeMsgHandler.h"
#import "FluwxAutoDeductHandler.h"

@implementation FluwxPlugin

BOOL isWeChatRegistered = NO;
BOOL handleOpenURLByFluwx = YES;

FluwxShareHandler *_fluwxShareHandler;

FluwxAuthHandler *_fluwxAuthHandler;
FluwxWXApiHandler *_fluwxWXApiHandler;
FluwxPaymentHandler *_fluwxPaymentHandler;
FluwxLaunchMiniProgramHandler *_fluwxLaunchMiniProgramHandler;
FluwxSubscribeMsgHandler *_fluwxSubscribeMsgHandler;
FluwxAutoDeductHandler *_fluwxAutoDeductHandler;

- (void)dealloc
{
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

+ (void)registerWithRegistrar:(NSObject <FlutterPluginRegistrar> *)registrar {
    FlutterMethodChannel *channel = [FlutterMethodChannel
            methodChannelWithName:@"com.jarvanmo/fluwx"
                  binaryMessenger:[registrar messenger]];

    FluwxPlugin *instance = [[FluwxPlugin alloc] initWithRegistrar:registrar methodChannel:channel];
    [[FluwxResponseHandler defaultManager] setMethodChannel:channel];
    [registrar addMethodCallDelegate:instance channel:channel];
    [registrar addApplicationDelegate:instance];

}

- (instancetype)initWithRegistrar:(NSObject <FlutterPluginRegistrar> *)registrar  methodChannel:(FlutterMethodChannel *)flutterMethodChannel {
    self = [super init];
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(handleOpenURL:)
//                                                 name:@"WeChat"
//                                               object:nil];
    if (self) {
        _fluwxShareHandler = [[FluwxShareHandler alloc] initWithRegistrar:registrar];
        _fluwxAuthHandler = [[FluwxAuthHandler alloc] initWithRegistrar:registrar methodChannel:flutterMethodChannel] ;
        _fluwxWXApiHandler = [[FluwxWXApiHandler alloc] init];
        _fluwxPaymentHandler = [[FluwxPaymentHandler alloc] initWithRegistrar:registrar];
        _fluwxLaunchMiniProgramHandler = [[FluwxLaunchMiniProgramHandler alloc] initWithRegistrar:registrar];
        _fluwxSubscribeMsgHandler = [[FluwxSubscribeMsgHandler alloc] initWithRegistrar:registrar];
        _fluwxAutoDeductHandler =[[FluwxAutoDeductHandler alloc] initWithRegistrar:registrar];
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

    if([@"launchMiniProgram" isEqualToString :call.method]){
        [_fluwxLaunchMiniProgramHandler handleLaunchMiniProgram:call result:result];
        return;
    }
    
    if([@"subscribeMsg" isEqualToString: call.method]){
        [_fluwxSubscribeMsgHandler handleSubscribeWithCall:call result:result];
        return;
    }

    if([@"authByQRCode" isEqualToString:call.method]){
        [_fluwxAuthHandler authByQRCode:call result:result];
        return;
    }

    if([@"stopAuthByQRCode" isEqualToString:call.method]){
        [_fluwxAuthHandler stopAuthByQRCode:call result:result];
        return;
    }
    if([@"autoDeduct" isEqualToString:call.method]){
        [_fluwxAutoDeductHandler handleAutoDeductWithCall:call result:result];
        return;
    }


    if([@"openWXApp" isEqualToString:call.method]){
        result(@([WXApi openWXApp]));
        return;
    }
    if ([call.method hasPrefix:@"share"]) {
        [_fluwxShareHandler handleShare:call result:result];
        return;
    } else {
        result(FlutterMethodNotImplemented);
    }


}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [WXApi handleOpenURL:url delegate:[FluwxResponseHandler defaultManager]];
}
// NOTE: 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{

    return [WXApi handleOpenURL:url delegate:[FluwxResponseHandler defaultManager]];
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
