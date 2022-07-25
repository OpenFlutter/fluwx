#import "FluwxPlugin.h"
#import "FluwxResponseHandler.h"
#import "FluwxStringUtil.h"
#import "FluwxAuthHandler.h"
#import "FluwxShareHandler.h"
#import "FluwxDelegate.h"

@interface FluwxPlugin()<WXApiManagerDelegate>
@property (strong,nonatomic)NSString *extMsg;
@end

typedef void(^FluwxWXReqRunnable)(void);

@implementation FluwxPlugin
FluwxAuthHandler *_fluwxAuthHandler;
FluwxShareHandler *_fluwxShareHandler;
BOOL _isRunning;
FluwxWXReqRunnable _initialWXReqRunnable;


BOOL handleOpenURLByFluwx = YES;

FlutterMethodChannel *channel = nil;

+ (void)registerWithRegistrar:(NSObject <FlutterPluginRegistrar> *)registrar {
    
#if TARGET_OS_IPHONE
        if (channel == nil) {
#endif
        channel = [FlutterMethodChannel
                methodChannelWithName:@"com.jarvanmo/fluwx"
                      binaryMessenger:[registrar messenger]];
        FluwxPlugin *instance = [[FluwxPlugin alloc] initWithRegistrar:registrar methodChannel:channel];
        [registrar addMethodCallDelegate:instance channel:channel];
        [[FluwxResponseHandler defaultManager] setMethodChannel:channel];
        
        [registrar addApplicationDelegate:instance];
#if TARGET_OS_IPHONE
        }
#endif

}

- (instancetype)initWithRegistrar:(NSObject <FlutterPluginRegistrar> *)registrar methodChannel:(FlutterMethodChannel *)flutterMethodChannel {
    self = [super init];
    if (self) {
        _fluwxAuthHandler = [[FluwxAuthHandler alloc] initWithRegistrar:registrar methodChannel:flutterMethodChannel];
        _fluwxShareHandler = [[FluwxShareHandler alloc] initWithRegistrar:registrar];
        _isRunning = NO;
        channel = flutterMethodChannel;
        [FluwxResponseHandler defaultManager].delegate = self;
        
    }
    return self;
}

- (void)handleMethodCall:(FlutterMethodCall *)call result:(FlutterResult)result {
    _isRunning = YES;
    
    if ([@"registerApp" isEqualToString:call.method]) {
        [self registerApp:call result:result];
    } else if ([@"startLog" isEqualToString:call.method]) {
        [self startLog:call result:result];
    } else if ([@"stopLog" isEqualToString:call.method]) {
        [self stopLog:call result:result];
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
    } else if ([@"autoDeductV2" isEqualToString:call.method]) {
        [self handleautoDeductV2:call result:result];
    } else if ([@"openBusinessView" isEqualToString:call.method]) {
        [self handleOpenBusinessView:call result:result];
    }else if([@"authByPhoneLogin" isEqualToString:call.method]){
        [_fluwxAuthHandler handleAuthByPhoneLogin:call result:result];
    }else if([@"getExtMsg" isEqualToString:call.method]){
        [self handelGetExtMsgWithCall:call result:result];
    } else if ([call.method hasPrefix:@"share"]) {
        [_fluwxShareHandler handleShare:call result:result];
    } else if ([@"openWeChatCustomerServiceChat" isEqualToString:call.method]) {
        [self openWeChatCustomerServiceChat:call result:result];
    } else if ([@"checkSupportOpenBusinessView" isEqualToString:call.method]) {
        [self checkSupportOpenBusinessView:call result:result];
    } else if([@"openWeChatInvoice" isEqualToString:call.method]) {
        [self openWeChatInvoice:call result:result];
    } else {
        result(FlutterMethodNotImplemented);
    }
}

- (void)openWeChatInvoice:(FlutterMethodCall *)call result:(FlutterResult)result {

    NSString *appId = call.arguments[@"appId"];

    if ([FluwxStringUtil isBlank:appId]) {
        result([FlutterError errorWithCode:@"invalid app id" message:@"are you sure your app id is correct ? " details:appId]);
        return;
    }

    [WXApiRequestHandler chooseInvoice: appId
                          timestamp:[[NSDate date] timeIntervalSince1970]
                         completion:^(BOOL done) {
        result(@(done));
    }];
}

- (void)registerApp:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSNumber* doOnIOS =call.arguments[@"iOS"];

    if (![doOnIOS boolValue]) {
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

- (void)startLog:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSNumber *typeInt = call.arguments[@"logLevel"];
    WXLogLevel logLevel = WXLogLevelDetail;
    if ([typeInt isEqualToNumber:@1]) {
        logLevel = WXLogLevelDetail;
    } else if ([typeInt isEqualToNumber:@0]) {
        logLevel = WXLogLevelNormal;
    }
    NSLog(@"%@",call.arguments);
    [WXApi startLogByLevel:logLevel logBlock:^(NSString * _Nonnull log) {
        NSLog(@"%@",log);
    }];
    result([NSNumber numberWithBool:true]);

}

- (void)stopLog:(FlutterMethodCall *)call result:(FlutterResult)result {
    [WXApi stopLog];
    result([NSNumber numberWithBool:true]);
}

- (void)checkWeChatInstallation:(FlutterMethodCall *)call result:(FlutterResult)result {
    result(@([WXApi isWXAppInstalled]));
}

- (void)openWeChatCustomerServiceChat:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *url = call.arguments[@"url"];
    NSString *corpId = call.arguments[@"corpId"];
    
    
    WXOpenCustomerServiceReq *req = [[WXOpenCustomerServiceReq alloc] init];
    req.corpid = corpId;    //企业ID
    req.url = url;         //客服URL
    return [WXApi sendReq:req completion:^(BOOL success) {
        result(@(success));
    }];
}

- (void)checkSupportOpenBusinessView:(FlutterMethodCall *)call result:(FlutterResult)result {
    if(![WXApi isWXAppInstalled]){
        result([FlutterError errorWithCode:@"WeChat Not Installed" message:@"Please install the WeChat first" details:nil]);
    }else {
        result(@(true));
    }
}

- (void)handlePayment:(FlutterMethodCall *)call result:(FlutterResult)result {


    NSNumber *timestamp = call.arguments[@"timeStamp"];

    NSString *partnerId = call.arguments[@"partnerId"];
    NSString *prepayId = call.arguments[@"prepayId"];
    NSString *packageValue = call.arguments[@"packageValue"];
    NSString *nonceStr = call.arguments[@"nonceStr"];
    UInt32 timeStamp = [timestamp unsignedIntValue];
    NSString *sign = call.arguments[@"sign"];
    [FluwxDelegate defaultManager].extData = call.arguments[@"extData"];
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

- (void)handleautoDeductV2:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSMutableDictionary *paramsFromDart = call.arguments[@"queryInfo"];
//    [paramsFromDart removeObjectForKey:@"businessType"];
    WXOpenBusinessWebViewReq *req = [[WXOpenBusinessWebViewReq alloc] init];
    NSNumber *businessType = call.arguments[@"businessType"];
    req.businessType = [businessType unsignedIntValue];
    req.queryInfoDic = paramsFromDart;
    [WXApi sendReq:req completion:^(BOOL done) {
        result(@(done));
    }];
}

- (void)handleOpenBusinessView:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSDictionary *params = call.arguments;

    WXOpenBusinessViewReq *req = [WXOpenBusinessViewReq object];
    NSString *businessType = [params valueForKey:@"businessType"];
    NSString *query = [params valueForKey:@"query"];
    req.businessType = businessType;
    req.query = query;
    req.extInfo = @"{\"miniProgramType\":0}";
    [WXApi sendReq:req completion:^(BOOL done) {
        result(@(done));
    }];
}

- (void)handelGetExtMsgWithCall:(FlutterMethodCall *)call result:(FlutterResult)result {
    result([FluwxDelegate defaultManager].extMsg);
    [FluwxDelegate defaultManager].extMsg=nil;
}


- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [WXApi handleOpenURL:url delegate:[FluwxResponseHandler defaultManager]];
}

// NOTE: 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *, id> *)options {
    return [WXApi handleOpenURL:url delegate:[FluwxResponseHandler defaultManager]];
}

- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray * _Nonnull))restorationHandler{
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

- (void)managerDidRecvLaunchFromWXReq:(LaunchFromWXReq *)request {
    [FluwxDelegate defaultManager].extMsg = request.message.messageExt;
//    LaunchFromWXReq *launchFromWXReq = (LaunchFromWXReq *)request;
//
//           if (_isRunning) {
//               [FluwxDelegate defaultManager].extMsg = request.message.messageExt;
//           } else {
//               __weak typeof(self) weakSelf = self;
//               _initialWXReqRunnable = ^() {
//                   __strong typeof(weakSelf) strongSelf = weakSelf;
//                   [FluwxDelegate defaultManager].extMsg = request.message.messageExt
//               };
//           }
}

@end
