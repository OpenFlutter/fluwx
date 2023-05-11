#import "FluwxPlugin.h"
#import "FluwxStringUtil.h"
#import "FluwxAuthHandler.h"
#import "FluwxShareHandler.h"
#import "FluwxDelegate.h"
#import <WXApi.h>
#import <WXApiObject.h>
@interface FluwxPlugin()<WXApiDelegate>
@property (strong,nonatomic)NSString *extMsg;
@end

typedef void(^FluwxWXReqRunnable)(void);

@implementation FluwxPlugin

const NSString *errStr = @"errStr";
const NSString *errCode = @"errCode";
const NSString *openId = @"openId";
const NSString *type = @"type";
const NSString *lang = @"lang";
const NSString *country = @"country";
const NSString *description = @"description";


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
        
#if WECHAT_LOGGING
        [WXApi startLogByLevel:WXLogLevelDetail logBlock:^(NSString *log) {
            [self logToFlutterWithDetail:log];
        }];
#endif
    }
    return self;
}

- (void)handleMethodCall:(FlutterMethodCall *)call result:(FlutterResult)result {
    _isRunning = YES;
    
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
    } else if ([@"openRankList" isEqualToString:call.method]) {
        [self handleOpenRankListCall:call result:result];
    } else if ([@"openUrl" isEqualToString:call.method]) {
        [self handleOpenUrlCall:call result:result];
    } else if([@"openWeChatInvoice" isEqualToString:call.method]) {
        [self openWeChatInvoice:call result:result];
    }
    else if ([@"payWithFluwx" isEqualToString:call.method]) {
#ifndef NO_PAY
        [self handlePayment:call result:result];
#else
        result(@NO);
#endif
    } else if ([@"payWithHongKongWallet" isEqualToString:call.method]) {
#ifndef NO_PAY
        [self handleHongKongWalletPayment:call result:result];
#else
        result(@NO);
#endif
    }
    else {
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
    
#if WECHAT_LOGGING
    if(isWeChatRegistered) {
        [WXApi checkUniversalLinkReady:^(WXULCheckStep step, WXCheckULStepResult* result) {
            NSString *log = [NSString stringWithFormat:@"%@, %u, %@, %@", @(step), result.success, result.errorInfo, result.suggestion];
            [self logToFlutterWithDetail:log];
        }];
    }

#endif
    
    result(@(isWeChatRegistered));
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

#ifndef NO_PAY
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
#endif

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
    return [WXApi handleOpenURL:url delegate:self];
}

// NOTE: 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *, id> *)options {
    return [WXApi handleOpenURL:url delegate:self];
}

- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray * _Nonnull))restorationHandler{
        return [WXApi handleOpenUniversalLink:userActivity delegate:self];
}
- (void)scene:(UIScene *)scene continueUserActivity:(NSUserActivity *)userActivity  API_AVAILABLE(ios(13.0)){
    [WXApi handleOpenUniversalLink:userActivity delegate:self];
}

- (void)handleOpenUrlCall:(FlutterMethodCall *)call
                   result:(FlutterResult)result {
    OpenWebviewReq *req = [[OpenWebviewReq alloc] init];
    req.url = call.arguments[@"url"];
    [WXApi sendReq:req
        completion:^(BOOL success){
        result(@(success));
        }];
}

- (void)handleOpenRankListCall:(FlutterMethodCall *)call
                        result:(FlutterResult)result {
    OpenRankListReq *req = [[OpenRankListReq alloc] init];
    [WXApi sendReq:req
        completion:^(BOOL success){
        result(@(success));
        }];
}

- (BOOL)handleOpenURL:(NSNotification *)aNotification {
    if (handleOpenURLByFluwx) {
        NSString *aURLString = [aNotification userInfo][@"url"];
        NSURL *aURL = [NSURL URLWithString:aURLString];
        return [WXApi handleOpenURL:aURL delegate:self];
    } else {
        return NO;
    }
}

- (void)logToFlutterWithDetail:(NSString *) detail {
    if(channel != nil){
        NSDictionary *result = @{
            @"detail":detail
        };
        [channel invokeMethod:@"wechatLog" arguments:result];
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


- (void)onResp:(BaseResp *)resp {
    if ([resp isKindOfClass:[SendMessageToWXResp class]]) {

        SendMessageToWXResp *messageResp = (SendMessageToWXResp *) resp;


        NSDictionary *result = @{
                description: messageResp.description == nil ? @"" : messageResp.description,
                errStr: messageResp.errStr == nil ? @"" : messageResp.errStr,
                errCode: @(messageResp.errCode),
                type: @(messageResp.type),
                country: messageResp.country == nil ? @"" : messageResp.country,
                lang: messageResp.lang == nil ? @"" : messageResp.lang};
        if(channel != nil){
            [channel invokeMethod:@"onShareResponse" arguments:result];
        }


    } else if ([resp isKindOfClass:[SendAuthResp class]]) {

        SendAuthResp *authResp = (SendAuthResp *) resp;
        NSDictionary *result = @{
                description: authResp.description == nil ? @"" : authResp.description,
                errStr: authResp.errStr == nil ? @"" : authResp.errStr,
                errCode: @(authResp.errCode),
                type: @(authResp.type),
                country: authResp.country == nil ? @"" : authResp.country,
                lang: authResp.lang == nil ? @"" : authResp.lang,
                @"code": [FluwxStringUtil nilToEmpty:authResp.code],
                @"state": [FluwxStringUtil nilToEmpty:authResp.state]

        };
        
        if(channel != nil){
            [channel invokeMethod:@"onAuthResponse" arguments:result];
        }

    } else if ([resp isKindOfClass:[AddCardToWXCardPackageResp class]]) {

    } else if ([resp isKindOfClass:[WXChooseCardResp class]]) {

    } else if ([resp isKindOfClass:[WXChooseInvoiceResp class]]) {
        //TODO 处理发票返回，并回调Dart
        
        WXChooseInvoiceResp *chooseInvoiceResp = (WXChooseInvoiceResp *) resp;
    
        
        NSArray *array =  chooseInvoiceResp.cardAry;
        
        NSMutableArray *mutableArray = [NSMutableArray arrayWithCapacity:array.count];

        
        for (int i = 0; i< array.count; i++) {
            WXInvoiceItem *item =  array[i];
            
            
            NSDictionary *dict = @{@"app_id":item.appID, @"encrypt_code":item.encryptCode, @"card_id":item.cardId};
            [mutableArray addObject:dict];
        }
        
        NSError *error = nil;
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:mutableArray options:NSJSONWritingPrettyPrinted error: &error];
        
        NSString *cardItemList = @"";
        
        if ([jsonData length] && error == nil) {
            cardItemList = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        }

            NSDictionary *result = @{
                    description: chooseInvoiceResp.description == nil ? @"" : chooseInvoiceResp.description,
                    errStr: chooseInvoiceResp.errStr == nil ? @"" : chooseInvoiceResp.errStr,
                    errCode: @(chooseInvoiceResp.errCode),
                    type: @(chooseInvoiceResp.type),
                    @"cardItemList":cardItemList
            };
        
        if(channel != nil){
    
            [channel invokeMethod:@"onOpenWechatInvoiceResponse" arguments:result];
        
        }
    } else if ([resp isKindOfClass:[WXSubscribeMsgResp class]]) {

        WXSubscribeMsgResp *subscribeMsgResp = (WXSubscribeMsgResp *) resp;
        NSMutableDictionary *result = [NSMutableDictionary dictionary];
        NSString *openid = subscribeMsgResp.openId;
        if(openid != nil && openid != NULL && ![openid isKindOfClass:[NSNull class]]){
           result[@"openid"] = openid;
        }
        
        NSString *templateId = subscribeMsgResp.templateId;
        if(templateId != nil && templateId != NULL && ![templateId isKindOfClass:[NSNull class]]){
           result[@"templateId"] = templateId;
        }
        
        NSString *action = subscribeMsgResp.action;
        if(action != nil && action != NULL && ![action isKindOfClass:[NSNull class]]){
            result[@"action"] = action;
        }
        
        NSString *reserved = subscribeMsgResp.action;
        if(reserved != nil && reserved != NULL && ![reserved isKindOfClass:[NSNull class]]){
          result[@"reserved"] = reserved;
        }
        
        UInt32 scene = subscribeMsgResp.scene;
        result[@"scene"] = @(scene);
        if(channel != nil){
            [channel invokeMethod:@"onSubscribeMsgResp" arguments:result];
        }

    } else if ([resp isKindOfClass:[WXLaunchMiniProgramResp class]]) {

        WXLaunchMiniProgramResp *miniProgramResp = (WXLaunchMiniProgramResp *) resp;


        NSDictionary *commonResult = @{
                description: miniProgramResp.description == nil ? @"" : miniProgramResp.description,
                errStr: miniProgramResp.errStr == nil ? @"" : miniProgramResp.errStr,
                errCode: @(miniProgramResp.errCode),
                type: @(miniProgramResp.type),
        };

        NSMutableDictionary *result = [NSMutableDictionary dictionaryWithDictionary:commonResult];
        if (miniProgramResp.extMsg != nil) {
            result[@"extMsg"] = miniProgramResp.extMsg;
        }


//        @"extMsg":miniProgramResp.extMsg == nil?@"":miniProgramResp.extMsg
            
        if(channel != nil){
            [channel invokeMethod:@"onLaunchMiniProgramResponse" arguments:result];

        }

    } else if ([resp isKindOfClass:[WXInvoiceAuthInsertResp class]]) {

    } else if ([resp isKindOfClass:[WXOpenBusinessWebViewResp class]]) {
        WXOpenBusinessWebViewResp *businessResp = (WXOpenBusinessWebViewResp *) resp;

        NSDictionary *result = @{
                description: [FluwxStringUtil nilToEmpty:businessResp.description],
                errStr: [FluwxStringUtil nilToEmpty:resp.errStr],
                errCode: @(businessResp.errCode),
                type: @(businessResp.type),
                @"resultInfo": [FluwxStringUtil nilToEmpty:businessResp.result],
                @"businessType": @(businessResp.businessType),
        };
        if(channel != nil){
            [channel invokeMethod:@"onWXOpenBusinessWebviewResponse" arguments:result];
        }

    } else if ([resp isKindOfClass:[WXOpenCustomerServiceResp class]])
    {
        
        WXOpenCustomerServiceResp *customerResp = (WXOpenCustomerServiceResp *) resp;
        NSDictionary *result = @{
                description: [FluwxStringUtil nilToEmpty:customerResp.description],
                errStr: [FluwxStringUtil nilToEmpty:resp.errStr],
                errCode: @(customerResp.errCode),
                type: @(customerResp.type),
                @"extMsg":[FluwxStringUtil nilToEmpty:customerResp.extMsg]
        };
        if(channel != nil){
            [channel invokeMethod:@"onWXOpenBusinessWebviewResponse" arguments:result];
        }

     // 相关错误信息
    }else if ([resp isKindOfClass:[WXOpenBusinessViewResp class]])
    {
        
        WXOpenBusinessViewResp *openBusinessViewResp = (WXOpenBusinessViewResp *) resp;
        NSDictionary *result = @{
                description: [FluwxStringUtil nilToEmpty:openBusinessViewResp.description],
                errStr: [FluwxStringUtil nilToEmpty:resp.errStr],
                errCode: @(openBusinessViewResp.errCode),
                @"businessType":openBusinessViewResp.businessType,
                type: @(openBusinessViewResp.type),
                @"extMsg":[FluwxStringUtil nilToEmpty:openBusinessViewResp.extMsg]
        };
        if(channel != nil){
            [channel invokeMethod:@"onOpenBusinessViewResponse" arguments:result];
        }

     // 相关错误信息
    }
#ifndef NO_PAY
    else if ([resp isKindOfClass:[WXPayInsuranceResp class]]) {
       if ([_delegate respondsToSelector:@selector(managerDidRecvPayInsuranceResponse:)]) {
           [_delegate managerDidRecvPayInsuranceResponse:(WXPayInsuranceResp *) resp];
       }
   } else if ([resp isKindOfClass:[PayResp class]]) {

        PayResp *payResp = (PayResp *) resp;

        NSDictionary *result = @{
                description: [FluwxStringUtil nilToEmpty:payResp.description],
                errStr: [FluwxStringUtil nilToEmpty:resp.errStr],
                errCode: @(payResp.errCode),
                type: @(payResp.type),
                @"extData": [FluwxStringUtil nilToEmpty:[FluwxDelegate defaultManager].extData],
                @"returnKey": [FluwxStringUtil nilToEmpty:payResp.returnKey],
        };
        [FluwxDelegate defaultManager].extData = nil;
        [fluwxMethodChannel invokeMethod:@"onPayResponse" arguments:result];
    } else if ([resp isKindOfClass:[WXNontaxPayResp class]]) {
 
    }
#endif
}

- (void)onReq:(BaseReq *)req {
    if ([req isKindOfClass:[GetMessageFromWXReq class]]) {

    } else if ([req isKindOfClass:[ShowMessageFromWXReq class]]) {

    } else if ([req isKindOfClass:[LaunchFromWXReq class]]) {
        LaunchFromWXReq *launchFromWXReq = (LaunchFromWXReq *) req;
        WXMediaMessage *wmm = launchFromWXReq.message;
        NSString *msg = @"";
        if (wmm == nil || wmm == NULL || [wmm isKindOfClass:[NSNull class]]) {
            msg = @"";
        }else {
            msg = wmm.messageExt;
            if (msg == nil || msg == NULL || [msg isKindOfClass:[NSNull class]]) {
                msg = @"";
            }
        }

        NSDictionary *result = @{
                @"extMsg": msg
        };

        if(channel != nil){
            [channel invokeMethod:@"onWXShowMessageFromWX" arguments:result];
        }
    }
    
}
@end
