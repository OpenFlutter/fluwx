#import "FluwxPlugin.h"
#import "FluwxResponseHandler.h"
#import "FluwxStringUtil.h"
#import "FluwxAuthHandler.h"
#import "FluwxShareHandler.h"

@implementation FluwxPlugin
FluwxAuthHandler *_fluwxAuthHandler;
FluwxShareHandler *_fluwxShareHandler;

BOOL handleOpenURLByFluwx = YES;

+ (void)registerWithRegistrar:(NSObject <FlutterPluginRegistrar> *)registrar {
    FlutterMethodChannel *channel = [FlutterMethodChannel
            methodChannelWithName:@"com.jarvanmo/fluwx"
                  binaryMessenger:[registrar messenger]];
    FluwxPlugin *instance = [[FluwxPlugin alloc] initWithRegistrar:registrar methodChannel:channel];
    [registrar addMethodCallDelegate:instance channel:channel];
    [[FluwxResponseHandler defaultManager] setMethodChannel:channel];
    [registrar addApplicationDelegate:instance];

}

- (instancetype)initWithRegistrar:(NSObject <FlutterPluginRegistrar> *)registrar methodChannel:(FlutterMethodChannel *)flutterMethodChannel {
    self = [super init];
    if (self) {
        _fluwxAuthHandler = [[FluwxAuthHandler alloc] initWithRegistrar:registrar methodChannel:flutterMethodChannel];
        _fluwxShareHandler = [[FluwxShareHandler alloc] initWithRegistrar:registrar];
    }

    return self;
}

- (void)handleMethodCall:(FlutterMethodCall *)call result:(FlutterResult)result {
    if ([@"registerApp" isEqualToString:call.method]) {
        [self registerApp:call result:result];
    } else if ([@"isWeChatInstalled" isEqualToString:call.method]) {
        [self checkWeChatInstallation:call result:result];
    } else if ([@"sendAuth" isEqualToString:call.method]) {
        [_fluwxAuthHandler handleAuth:call result:result];
    } else if ([@"authByQRCode" isEqualToString:call.method]) {
        [_fluwxAuthHandler authByQRCode:call result:result];
    } else if ([@"stopAuthByQRCode" isEqualToString:call.method]) {
        [_fluwxAuthHandler stopAuthByQRCode:call result:result];
    } else if ([@"openWXApp" isEqualToString:call.method]) {
        result(@([WXApi openWXApp]));
    } else if ([@"payWithFluwx" isEqualToString:call.method]) {
        [self handlePayment:call result:result];
    } else if ([@"payWithHongKongWallet" isEqualToString:call.method]) {
        [self handleHongKongWalletPayment:call result:result];
    } else if ([@"launchMiniProgram" isEqualToString:call.method]) {
        [self handleLaunchMiniProgram:call result:result];
    } else if ([@"subscribeMsg" isEqualToString:call.method]) {
        [self handleSubscribeWithCall:call result:result];
    } else if ([@"autoDeduct" isEqualToString:call.method]) {
        [self handleAutoDeductWithCall:call result:result];
    } else if ([call.method hasPrefix:@"share"]) {
        [_fluwxShareHandler handleShare:call result:result];
    } else {
        result(FlutterMethodNotImplemented);
    }
}

- (void)registerApp:(FlutterMethodCall *)call result:(FlutterResult)result {
    if (!call.arguments[@"iOS"]) {
        result(@NO);
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

    BOOL isWeChatRegistered = [WXApi registerApp:appId universalLink:universalLink];

    result(@(isWeChatRegistered));
}

- (void)checkWeChatInstallation:(FlutterMethodCall *)call result:(FlutterResult)result {
    result(@([WXApi isWXAppInstalled]));
}

- (void)handlePayment:(FlutterMethodCall *)call result:(FlutterResult)result {


    NSNumber *timestamp = call.arguments[@"timeStamp"];

    NSString *partnerId = call.arguments[@"partnerId"];
    NSString *prepayId = call.arguments[@"prepayId"];
    NSString *packageValue = call.arguments[@"packageValue"];
    NSString *nonceStr = call.arguments[@"nonceStr"];
    UInt32 timeStamp = [timestamp unsignedIntValue];
    NSString *sign = call.arguments[@"sign"];
    [WXApiRequestHandler sendPayment:call.arguments[@"appId"]
                           PartnerId:partnerId
                            PrepayId:prepayId
                            NonceStr:nonceStr
                           Timestamp:timeStamp
                             Package:packageValue
                                Sign:sign completion:^(BOOL done) {
                result(@(done));
            }];
}

- (void)handleHongKongWalletPayment:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *partnerId = call.arguments[@"prepayId"];
    
    WXOpenBusinessWebViewReq *req = [[WXOpenBusinessWebViewReq alloc] init];
    req.businessType = 1;
    NSMutableDictionary *queryInfoDic = [NSMutableDictionary dictionary];
    [queryInfoDic setObject:partnerId forKey:@"token"];
    req.queryInfoDic = queryInfoDic;
    [WXApi sendReq:req completion:^(BOOL done) {
        result(@(done));
    }];
}

- (void)handleLaunchMiniProgram:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *userName = call.arguments[@"userName"];
    NSString *path = call.arguments[@"path"];
//    WXMiniProgramType *miniProgramType = call.arguments[@"miniProgramType"];

    NSNumber *typeInt = call.arguments[@"miniProgramType"];
    WXMiniProgramType miniProgramType = WXMiniProgramTypeRelease;
    if ([typeInt isEqualToNumber:@1]) {
        miniProgramType = WXMiniProgramTypeTest;
    } else if ([typeInt isEqualToNumber:@2]) {
        miniProgramType = WXMiniProgramTypePreview;
    }

    [WXApiRequestHandler launchMiniProgramWithUserName:userName
                                                  path:path
                                                  type:miniProgramType completion:^(BOOL done) {
                result(@(done));
            }];
}


- (void)handleSubscribeWithCall:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSDictionary *params = call.arguments;
    NSString *appId = [params valueForKey:@"appId"];
    int scene = [[params valueForKey:@"scene"] intValue];
    NSString *templateId = [params valueForKey:@"templateId"];
    NSString *reserved = [params valueForKey:@"reserved"];

    WXSubscribeMsgReq *req = [WXSubscribeMsgReq new];
    req.scene = (UInt32) scene;
    req.templateId = templateId;
    req.reserved = reserved;
    req.openID = appId;

    [WXApi sendReq:req completion:^(BOOL done) {
        result(@(done));
    }];
}


- (void)handleAutoDeductWithCall:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSMutableDictionary *paramsFromDart = [NSMutableDictionary dictionaryWithDictionary:call.arguments];
    [paramsFromDart removeObjectForKey:@"businessType"];
    WXOpenBusinessWebViewReq *req = [[WXOpenBusinessWebViewReq alloc] init];
    NSNumber *businessType = call.arguments[@"businessType"];
    req.businessType = [businessType unsignedIntValue];
    req.queryInfoDic = paramsFromDart;
    [WXApi sendReq:req completion:^(BOOL done) {
        result(@(done));
    }];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [WXApi handleOpenURL:url delegate:[FluwxResponseHandler defaultManager]];
}

// NOTE: 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *, id> *)options {
    return [WXApi handleOpenURL:url delegate:[FluwxResponseHandler defaultManager]];
}

- (BOOL) application:(UIApplication *)application
continueUserActivity:(nonnull NSUserActivity *)userActivity
  restorationHandler:(nonnull void (^)(NSArray<id> * _Nullable))restorationHandler {
    return [WXApi handleOpenUniversalLink:userActivity delegate:[FluwxResponseHandler defaultManager]];
}

- (void)scene:(UIScene *)scene continueUserActivity:(NSUserActivity *)userActivity  API_AVAILABLE(ios(13.0)){
    [WXApi handleOpenUniversalLink:userActivity delegate:[FluwxResponseHandler defaultManager]];
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

@end
