#import <fluwx/FluwxPlugin.h>



#import "FluwxPaymentHandler.h"
#import "FluwxMethods.h"
#import "FluwxWXApiHandler.h"


@implementation FluwxPlugin

BOOL isWeChatRegistered = NO;
BOOL handleOpenURLByFluwx = YES;


FluwxWXApiHandler *_fluwxWXApiHandler;
FluwxPaymentHandler *_fluwxPaymentHandler;

- (void)dealloc {
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

+ (void)registerWithRegistrar:(NSObject <FlutterPluginRegistrar> *)registrar {
    FlutterMethodChannel *channel = [FlutterMethodChannel
            methodChannelWithName:@"com.jarvanmo/fluwx_pay_only"
                  binaryMessenger:[registrar messenger]];

    FluwxPlugin *instance = [[FluwxPlugin alloc] initWithRegistrar:registrar methodChannel:channel];
    [[FluwxResponseHandler defaultManager] setMethodChannel:channel];
    [registrar addMethodCallDelegate:instance channel:channel];
    [registrar addApplicationDelegate:instance];

}

- (instancetype)initWithRegistrar:(NSObject <FlutterPluginRegistrar> *)registrar methodChannel:(FlutterMethodChannel *)flutterMethodChannel {
    self = [super init];
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(handleOpenURL:)
//                                                 name:@"WeChat"
//                                               object:nil];
    if (self) {
       
        _fluwxWXApiHandler = [[FluwxWXApiHandler alloc] init];
        _fluwxPaymentHandler = [[FluwxPaymentHandler alloc] initWithRegistrar:registrar];
       
    }

    return self;
}


- (void)handleMethodCall:(FlutterMethodCall *)call result:(FlutterResult)result {


    if ([registerApp isEqualToString:call.method]) {
        [_fluwxWXApiHandler registerApp:call result:result];
        return;
    }

    if ([@"isWeChatInstalled" isEqualToString:call.method]) {
        [_fluwxWXApiHandler checkWeChatInstallation:call result:result];
        return;
    }


   

    if ([@"payWithFluwx" isEqualToString:call.method]) {
        [_fluwxPaymentHandler handlePayment:call result:result];
        return;
    }
    
    result(FlutterMethodNotImplemented);
    


}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    if ([sourceApplication isEqualToString:@"com.tencent.xin"] && [url.host isEqualToString:@"pay"]) {
        return  [WXApi handleOpenURL:url delegate:[FluwxResponseHandler defaultManager]];
    }else {
        return NO;
    }

}

// NOTE: 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *, id> *)options {
    
    if ([options[UIApplicationOpenURLOptionsSourceApplicationKey] isEqualToString:@"com.tencent.xin"] && [url.absoluteString containsString:@"pay"]) {
        return  [WXApi handleOpenURL:url delegate:[FluwxResponseHandler defaultManager]];
    }else {
        return NO;
    }

    
}

- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void(^)(NSArray<id<UIUserActivityRestoring>> * __nullable restorableObjects))restorationHandler
{
    [WXApi handleOpenUniversalLink:userActivity delegate:[FluwxResponseHandler defaultManager]];
    return NO;
}


- (BOOL)handleOpenURL:(NSNotification *)aNotification {

    if (handleOpenURLByFluwx) {
        NSString *aURLString = [aNotification userInfo][@"url"];
        NSURL *aURL = [NSURL URLWithString:aURLString];
        return [WXApi handleOpenURL:aURL delegate:[FluwxResponseHandler defaultManager]];
    } else {
        return NO;
    }

}

- (void)unregisterApp:(FlutterMethodCall *)call result:(FlutterResult)result {

    isWeChatRegistered = false;
    result(@YES);
}


@end
