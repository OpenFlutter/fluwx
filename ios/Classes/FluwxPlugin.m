#import <fluwx/FluwxPlugin.h>
#import <fluwx/FluwxStringUtil.h>
#import <fluwx/FluwxDelegate.h>
#import <fluwx/ThumbnailHelper.h>
#import <fluwx/FluwxStringUtil.h>
#import <fluwx/NSStringWrapper.h>
#import <WXApi.h>
#import <WXApiObject.h>
#import <WechatAuthSDK.h>
#import <WXApi.h>

NSString *const fluwxKeyTitle = @"title";
NSString *const fluwxKeyImage = @ "image";
NSString *const fluwxKeyImageData = @ "imageData";
NSString *const fluwxKeyDescription = @"description";
NSString *const fluwxKeyMsgSignature = @"msgSignature";
NSString *const fluwxKeyThumbData = @"thumbData";
NSString *const fluwxKeyThumbDataHash = @"thumbDataHash";

NSString *const fluwxKeyPackage = @"?package=";

NSString *const fluwxKeyMessageExt = @"messageExt";
NSString *const fluwxKeyMediaTagName = @"mediaTagName";
NSString *const fluwxKeyMessageAction = @"messageAction";

NSString *const fluwxKeyScene = @"scene";
NSString *const fluwxKeyTimeline = @"timeline";
NSString *const fluwxKeySession = @"session";
NSString *const fluwxKeyFavorite = @"favorite";

NSString *const keySource = @"source";
NSString *const keySuffix = @"suffix";

CGFloat thumbnailWidth;

NSUInteger defaultThumbnailSize = 32 * 1024;

@interface FluwxPlugin()<WXApiDelegate,WechatAuthAPIDelegate>

@property (strong, nonatomic)NSString *extMsg;

@end

typedef void(^FluwxWXReqRunnable)(void);

@implementation FluwxPlugin {
    FlutterMethodChannel *_channel;
    WechatAuthSDK *_qrauth;
    BOOL _isRunning;
    BOOL _attemptToResumeMsgFromWxFlag;
    FluwxWXReqRunnable _attemptToResumeMsgFromWxRunnable;
    // cache open url request when WXApi is not registered, and handle it once WXApi is registered
    FluwxWXReqRunnable _cachedOpenUrlRequest;
}

const NSString *errStr = @"errStr";
const NSString *errCode = @"errCode";
const NSString *openId = @"openId";
const NSString *fluwxType = @"type";
const NSString *lang = @"lang";
const NSString *country = @"country";
const NSString *description = @"description";

BOOL handleOpenURLByFluwx = YES;

NSObject <FlutterPluginRegistrar> *_fluwxRegistrar;

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar> *)registrar {
    _fluwxRegistrar = registrar;
    FlutterMethodChannel *channel =
    [FlutterMethodChannel methodChannelWithName:@"com.jarvanmo/fluwx"
                                binaryMessenger:[registrar messenger]];
    FluwxPlugin *instance = [[FluwxPlugin alloc] initWithChannel:channel];
    [registrar addApplicationDelegate:instance];
    [registrar addMethodCallDelegate:instance channel:channel];
}

- (instancetype)initWithChannel:(FlutterMethodChannel *)channel {
    self = [super init];
    if (self) {
        _channel = channel;
        _qrauth = [[WechatAuthSDK alloc] init];
        _qrauth.delegate = self;
        _isRunning = NO;
        thumbnailWidth = 150;
        _attemptToResumeMsgFromWxFlag = NO;
#if WECHAT_LOGGING
        [WXApi startLogByLevel:WXLogLevelDetail logBlock:^(NSString *log) {
            [self logToFlutterWithDetail:log];
        }];
#endif
    }
    return self;
}

- (void)handleMethodCall:(FlutterMethodCall *)call result:(FlutterResult)result {
    if ([@"registerApp" isEqualToString:call.method]) {
        [self registerApp:call result:result];
    } else if ([@"isWeChatInstalled" isEqualToString:call.method]) {
        [self checkWeChatInstallation:call result:result];
    } else if ([@"sendAuth" isEqualToString:call.method]) {
        [self handleAuth:call result:result];
    } else if ([@"authByQRCode" isEqualToString:call.method]) {
        [self authByQRCode:call result:result];
    } else if ([@"stopAuthByQRCode" isEqualToString:call.method]) {
        [self stopAuthByQRCode:call result:result];
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
    } else if ([@"authByPhoneLogin" isEqualToString:call.method]) {
        [self handleAuthByPhoneLogin:call result:result];
    } else if ([@"getExtMsg" isEqualToString:call.method]) {
        [self handelGetExtMsgWithCall:call result:result];
    } else if ([call.method hasPrefix:@"share"]) {
        [self handleShare:call result:result];
    } else if ([@"openWeChatCustomerServiceChat" isEqualToString:call.method]) {
        [self openWeChatCustomerServiceChat:call result:result];
    } else if ([@"checkSupportOpenBusinessView" isEqualToString:call.method]) {
        [self checkSupportOpenBusinessView:call result:result];
    } else if ([@"openRankList" isEqualToString:call.method]) {
        [self handleOpenRankListCall:call result:result];
    } else if ([@"openUrl" isEqualToString:call.method]) {
        [self handleOpenUrlCall:call result:result];
    } else if ([@"openWeChatInvoice" isEqualToString:call.method]) {
        [self openWeChatInvoice:call result:result];
    } else if ([@"selfCheck" isEqualToString:call.method]) {
#ifndef __OPTIMIZE__
        [WXApi checkUniversalLinkReady:^(WXULCheckStep step, WXCheckULStepResult *result) {
            NSString *log = [NSString stringWithFormat:@"%@, %u, %@, %@", @(step), result.success, result.errorInfo, result.suggestion];
            [self logToFlutterWithDetail:log];
        }];
#endif
        result(nil);
    } else if ([@"attemptToResumeMsgFromWx" isEqualToString:call.method]) {
        if (_attemptToResumeMsgFromWxRunnable != nil) {
            _attemptToResumeMsgFromWxRunnable();
            _attemptToResumeMsgFromWxRunnable = nil;
        }
        result(nil);
    } else if ([@"payWithFluwx" isEqualToString:call.method]) {
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
    } else {
        result(FlutterMethodNotImplemented);
    }
}

- (void)openWeChatInvoice:(FlutterMethodCall *)call result:(FlutterResult)result {
    
    NSString *appId = call.arguments[@"appId"];
    
    if ([FluwxStringUtil isBlank:appId]) {
        result([FlutterError
                errorWithCode:@"invalid app id"
                message:@"are you sure your app id is correct ? "
                details:appId]);
        return;
    }
    
    WXChooseInvoiceReq *chooseInvoiceReq = [[WXChooseInvoiceReq alloc] init];
    chooseInvoiceReq.appID = appId;
    chooseInvoiceReq.timeStamp = [[NSDate date] timeIntervalSince1970];
    chooseInvoiceReq.signType = @"SHA1";
    chooseInvoiceReq.cardSign = @"";
    chooseInvoiceReq.nonceStr = @"";
    [WXApi sendReq:chooseInvoiceReq completion:^(BOOL done) {
        result(@(done));
    }];
}

- (void)registerApp:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSNumber *doOnIOS = call.arguments[@"iOS"];
    
    if (![doOnIOS boolValue]) {
        result(@NO);
        return;
    }
    
    NSString *appId = call.arguments[@"appId"];
    if ([FluwxStringUtil isBlank:appId]) {
        result([FlutterError
                errorWithCode:@"invalid app id"
                message:@"are you sure your app id is correct ? "
                details:appId]);
        return;
    }
    
    NSString *universalLink = call.arguments[@"universalLink"];
    
    if ([FluwxStringUtil isBlank:universalLink]) {
        result([FlutterError
                errorWithCode:@"invalid universal link"
                message:@"are you sure your universal link is correct ? "
                details:universalLink]);
        return;
    }
    
    BOOL isWeChatRegistered = [WXApi registerApp:appId universalLink:universalLink];
    
    // If registration fails, we can return immediately
    if (!isWeChatRegistered) {
        result(@(isWeChatRegistered));
        _isRunning = NO;
        return;
    }
    
    // Otherwise, since WXApi is now registered successfully,
    // we can (and should) immediately handle the previously cached `app:openURL` event (if any)
    if (_cachedOpenUrlRequest != nil) {
        _cachedOpenUrlRequest();
        _cachedOpenUrlRequest = nil;
    }
    
    // Set `_isRunning` after calling `_cachedOpenUrlRequest` to ensure that
    // the `onReq` triggered by this call to `_cachedOpenUrlRequest` will
    // be stored in `_attemptToResumeMsgFromWxRunnable` which can be obtained
    // by triggering `attemptToResumeMsgFromWx`.
    //
    // At the same time, this also coincides with the approach on the Android side:
    // cold start events are cached and triggered through `attemptToResumeMsgFromWx`
    _isRunning = isWeChatRegistered;
    
    result(@(isWeChatRegistered));
}

- (void)checkWeChatInstallation:(FlutterMethodCall *)call result:(FlutterResult)result {
    result(@([WXApi isWXAppInstalled]));
}

- (void)openWeChatCustomerServiceChat:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *url = call.arguments[@"url"];
    NSString *corpId = call.arguments[@"corpId"];
    
    WXOpenCustomerServiceReq *req = [[WXOpenCustomerServiceReq alloc] init];
    req.corpid = corpId; //企业ID
    req.url = url;       //客服URL
    return [WXApi sendReq:req completion:^(BOOL success) {
        result(@(success));
    }];
}

- (void)checkSupportOpenBusinessView:(FlutterMethodCall *)call result:(FlutterResult)result {
    if (![WXApi isWXAppInstalled]) {
        result([FlutterError errorWithCode:@"WeChat Not Installed" message:@"Please install the WeChat first" details:nil]);
    } else {
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
    
    NSString *appId = call.arguments[@"appId"];
    PayReq *req = [[PayReq alloc] init];
    req.openID = (appId == (id) [NSNull null]) ? nil : appId;
    req.partnerId = partnerId;
    req.prepayId = prepayId;
    req.nonceStr = nonceStr;
    req.timeStamp = timeStamp;
    req.package = packageValue;
    req.sign = sign;
    
    [WXApi sendReq:req completion:^(BOOL done) {
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
    //WXMiniProgramType *miniProgramType = call.arguments[@"miniProgramType"];
    
    NSNumber *typeInt = call.arguments[@"miniProgramType"];
    WXMiniProgramType miniProgramType = WXMiniProgramTypeRelease;
    if ([typeInt isEqualToNumber:@1]) {
        miniProgramType = WXMiniProgramTypeTest;
    } else if ([typeInt isEqualToNumber:@2]) {
        miniProgramType = WXMiniProgramTypePreview;
    }
    
    WXLaunchMiniProgramReq *launchMiniProgramReq = [WXLaunchMiniProgramReq object];
    launchMiniProgramReq.userName = userName;
    launchMiniProgramReq.path = (path == (id) [NSNull null]) ? nil : path;
    launchMiniProgramReq.miniProgramType = miniProgramType;
    
    [WXApi sendReq:launchMiniProgramReq completion:^(BOOL done) {
        result(@(done));
    }];
}


- (void)handleSubscribeWithCall:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSDictionary *params = call.arguments;
    NSString *appId = [params valueForKey:@"appId"];
    NSNumber *scene = [params valueForKey:@"scene"];
    NSString *templateId = [params valueForKey:@"templateId"];
    NSString *reserved = [params valueForKey:@"reserved"];
    
    WXSubscribeMsgReq *req = [WXSubscribeMsgReq new];
#if __LP64__
    req.scene = [scene unsignedIntValue];
#else
    req.scene = [scene unsignedLongValue];
#endif
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
    [FluwxDelegate defaultManager].extMsg = nil;
}


// Deprecated since iOS 9
// See https://developer.apple.com/documentation/uikit/uiapplicationdelegate/1623073-application?language=objc
// Use `application:openURL:options:` instead.
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    // Since flutter has minimum iOS version requirement of 11.0, we don't need to change the implementation here.
    return [WXApi handleOpenURL:url delegate:self];
}

// Deprecated since iOS 9
// See https://developer.apple.com/documentation/uikit/uiapplicationdelegate/1622964-application?language=objc
// Use `application:openURL:options:` instead.
//- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
//    // Since flutter has minimum iOS version requirement of 11.0, we don't need to change the implementation here.
//    return [WXApi handleOpenURL:url delegate:self];
//}

// Available on iOS 9.0 and later
// See https://developer.apple.com/documentation/uikit/uiapplicationdelegate/1623112-application?language=objc
- (BOOL)application:(UIApplication *)app
            openURL:(NSURL *)url
             options:(NSDictionary<NSString *, id> *)options {
    // ↓ previous solution -- according to document, this may fail if the WXApi hasn't registered yet.
    // return [WXApi handleOpenURL:url delegate:self];
    
    if (_isRunning) {
        // registered -- directly handle open url request by WXApi
        return [WXApi handleOpenURL:url delegate:self];
    } else {
        // unregistered -- cache open url request and handle it once WXApi is registered
        __weak typeof(self) weakSelf = self;
        _cachedOpenUrlRequest = ^() {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [WXApi handleOpenURL:url delegate:strongSelf];
        };
        // Let's hold this until the PR contributor send feedback.
        //return [url.absoluteString contains:[self fetchWeChatAppId]];
        
        // simply return YES to indicate that we can handle open url request later
        return NO;
    }
}

#ifndef SCENE_DELEGATE
- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray *_Nonnull))restorationHandler{
    // TODO: (if need) cache userActivity and handle it once WXApi is registered
    return [WXApi handleOpenUniversalLink:userActivity delegate:self];
}
#endif

#ifdef SCENE_DELEGATE
- (void)scene:(UIScene *)scene continueUserActivity:(NSUserActivity *)userActivity API_AVAILABLE(ios(13.0)) {
    // TODO: (if need) cache userActivity and handle it once WXApi is registered
    [WXApi handleOpenUniversalLink:userActivity delegate:self];
}
#endif

- (void)handleOpenUrlCall:(FlutterMethodCall *)call
                   result:(FlutterResult)result {
    OpenWebviewReq *req = [[OpenWebviewReq alloc] init];
    req.url = call.arguments[@"url"];
    [WXApi sendReq:req
        completion:^(BOOL success) {
        result(@(success));
    }];
}

- (void)handleOpenRankListCall:(FlutterMethodCall *)call
                        result:(FlutterResult)result {
    OpenRankListReq *req = [[OpenRankListReq alloc] init];
    [WXApi sendReq:req
        completion:^(BOOL success) {
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
    if (_channel != nil) {
        NSDictionary *result = @{
            @"detail":detail
        };
        [_channel invokeMethod:@"wechatLog" arguments:result];
    }
}

- (void)handleShare:(FlutterMethodCall *)call result:(FlutterResult)result {
    if ([@"shareText" isEqualToString:call.method]) {
        [self shareText:call result:result];
    } else if ([@"shareImage" isEqualToString:call.method]) {
        [self shareImage:call result:result];
    } else if ([@"shareWebPage" isEqualToString:call.method]) {
        [self shareWebPage:call result:result];
    } else if ([@"shareMusic" isEqualToString:call.method]) {
        [self shareMusic:call result:result];
    } else if ([@"shareVideo" isEqualToString:call.method]) {
        [self shareVideo:call result:result];
    } else if ([@"shareMiniProgram" isEqualToString:call.method]) {
        [self shareMiniProgram:call result:result];
    } else if ([@"shareFile" isEqualToString:call.method]) {
        [self shareFile:call result:result];
    }
}

- (void)shareText:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *text = call.arguments[@"source"];
    NSNumber *scene = call.arguments[fluwxKeyScene];
    
    [self sendText:text InScene:[self intToWeChatScene:scene] completion:^(BOOL done) {
        result(@(done));
    }];
}

- (void)shareImage:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSNumber *scene = call.arguments[fluwxKeyScene];
    
    NSDictionary *sourceImage = call.arguments[keySource];
    
    FlutterStandardTypedData *flutterImageData = sourceImage[@"uint8List"];
    NSData *imageData = nil;
    if (flutterImageData != nil) {
        imageData = flutterImageData.data;
    }
    
    NSString *imageDataHash = sourceImage[@"imgDataHash"];
    
    FlutterStandardTypedData *flutterThumbData = call.arguments[fluwxKeyThumbData];
    NSData *thumbData = nil;
    if (![flutterThumbData isKindOfClass:[NSNull class]]) {
        thumbData = flutterThumbData.data;
    }
    
    dispatch_queue_t globalQueue = dispatch_get_global_queue(0, 0);
    dispatch_async(globalQueue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self sendImageData:imageData
                    ImgDataHash:imageDataHash
                        TagName:call.arguments[fluwxKeyMediaTagName]
                     MessageExt:call.arguments[fluwxKeyMessageExt]
                         Action:call.arguments[fluwxKeyMessageAction]
                        InScene:[self intToWeChatScene:scene]
                          title:call.arguments[fluwxKeyTitle]
                    description:call.arguments[fluwxKeyDescription]
                   MsgSignature:call.arguments[fluwxKeyMsgSignature]
                      ThumbData:thumbData
                  ThumbDataHash:call.arguments[fluwxKeyThumbDataHash]
                     completion:^(BOOL done) {
                result(@(done));
            }];
        });
        
    });
}

- (void)shareWebPage:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *webPageUrl = call.arguments[@"webPage"];
    NSNumber *scene = call.arguments[fluwxKeyScene];
    
    FlutterStandardTypedData *flutterThumbData = call.arguments[fluwxKeyThumbData];
    NSData *thumbData = nil;
    if (![flutterThumbData isKindOfClass:[NSNull class]]) {
        thumbData = flutterThumbData.data;
    }
    
    dispatch_queue_t globalQueue = dispatch_get_global_queue(0, 0);
    dispatch_async(globalQueue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self sendLinkURL:webPageUrl
                      TagName:call.arguments[fluwxKeyMediaTagName]
                        Title:call.arguments[fluwxKeyTitle]
                  Description:call.arguments[fluwxKeyDescription]
                   MessageExt:call.arguments[fluwxKeyMessageExt]
                MessageAction:call.arguments[fluwxKeyMessageAction]
                      InScene:[self intToWeChatScene:scene]
                 MsgSignature:call.arguments[fluwxKeyMsgSignature]
                    ThumbData:thumbData
                ThumbDataHash:call.arguments[fluwxKeyThumbDataHash]
                   completion:^(BOOL done) {
                result(@(done));
            }];
        });
        
    });
}

- (void)shareMusic:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSNumber *scene = call.arguments[fluwxKeyScene];
    
    FlutterStandardTypedData *flutterThumbData = call.arguments[fluwxKeyThumbData];
    NSData *thumbData = nil;
    if (![flutterThumbData isKindOfClass:[NSNull class]]) {
        thumbData = flutterThumbData.data;
    }
    
    dispatch_queue_t globalQueue = dispatch_get_global_queue(0, 0);
    dispatch_async(globalQueue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self sendMusicURL:call.arguments[@"musicUrl"]
                       dataURL:call.arguments[@"musicDataUrl"]
               MusicLowBandUrl:call.arguments[@"musicLowBandUrl"]
           MusicLowBandDataUrl:call.arguments[@"musicLowBandDataUrl"]
                         Title:call.arguments[fluwxKeyTitle]
                   Description:call.arguments[fluwxKeyDescription]
                    MessageExt:call.arguments[fluwxKeyMessageExt]
                 MessageAction:call.arguments[fluwxKeyMessageAction]
                       TagName:call.arguments[fluwxKeyMediaTagName]
                       InScene:[self intToWeChatScene:scene]
                  MsgSignature:call.arguments[fluwxKeyMsgSignature]
                     ThumbData:thumbData
                 ThumbDataHash:call.arguments[fluwxKeyThumbDataHash]
                    completion:^(BOOL done) {
                result(@(done));
            }];
        });
    });
}

- (void)shareVideo:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSNumber *scene = call.arguments[fluwxKeyScene];
    
    FlutterStandardTypedData *flutterThumbData = call.arguments[fluwxKeyThumbData];
    NSData *thumbData = nil;
    if (![flutterThumbData isKindOfClass:[NSNull class]]) {
        thumbData = flutterThumbData.data;
    }
    
    dispatch_queue_t globalQueue = dispatch_get_global_queue(0, 0);
    dispatch_async(globalQueue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self sendVideoURL:call.arguments[@"videoUrl"]
               VideoLowBandUrl:call.arguments[@"videoLowBandUrl"]
                         Title:call.arguments[fluwxKeyTitle]
                   Description:call.arguments[fluwxKeyDescription]
                    MessageExt:call.arguments[fluwxKeyMessageExt]
                 MessageAction:call.arguments[fluwxKeyMessageAction]
                       TagName:call.arguments[fluwxKeyMediaTagName]
                       InScene:[self intToWeChatScene:scene]
                  MsgSignature:call.arguments[fluwxKeyMsgSignature]
                     ThumbData:thumbData
                 ThumbDataHash:call.arguments[fluwxKeyThumbDataHash]
                    completion:^(BOOL done) {
                result(@(done));
            }];
        });
    });
}

- (void)shareFile:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSDictionary *sourceFile = call.arguments[keySource];
    NSString *fileExtension;
    NSString *suffix = sourceFile[keySuffix];
    fileExtension = suffix;
    if ([suffix hasPrefix:@"."]) {
        NSRange range = NSMakeRange(0, 1);
        fileExtension = [suffix stringByReplacingCharactersInRange:range withString:@""];
    }
    
    NSData *data = [self getNsDataFromWeChatFile:sourceFile];
    NSNumber *scene = call.arguments[fluwxKeyScene];
    
    FlutterStandardTypedData *flutterThumbData = call.arguments[fluwxKeyThumbData];
    NSData *thumbData = nil;
    if (![flutterThumbData isKindOfClass:[NSNull class]]) {
        thumbData = flutterThumbData.data;
    }
    
    dispatch_queue_t globalQueue = dispatch_get_global_queue(0, 0);
    dispatch_async(globalQueue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self sendFileData:data
                 fileExtension:fileExtension
                         Title:call.arguments[fluwxKeyTitle]
                   Description:call.arguments[fluwxKeyDescription]
                       InScene:[self intToWeChatScene:scene]
                  MsgSignature:call.arguments[fluwxKeyMsgSignature]
                     ThumbData:thumbData
                 ThumbDataHash:call.arguments[fluwxKeyThumbDataHash]
                    completion:^(BOOL success) {
                result(@(success));
            }];
        });
    });
}

- (void)shareMiniProgram:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSNumber *scene = call.arguments[fluwxKeyScene];
    
    FlutterStandardTypedData *flutterThumbData = call.arguments[fluwxKeyThumbData];
    NSData *thumbData = nil;
    if (![flutterThumbData isKindOfClass:[NSNull class]]) {
        thumbData = flutterThumbData.data;
    }
    
    FlutterStandardTypedData *hdImageDataPayload = call.arguments[@"hdImageData"];
    NSData *hdImageData = nil;
    if (![hdImageDataPayload isKindOfClass:[NSNull class]]) {
        hdImageData = hdImageDataPayload.data;
    }
    
    NSNumber *typeInt = call.arguments[@"miniProgramType"];
    WXMiniProgramType miniProgramType = WXMiniProgramTypeRelease;
    if ([typeInt isEqualToNumber:@1]) {
        miniProgramType = WXMiniProgramTypeTest;
    } else if ([typeInt isEqualToNumber:@2]) {
        miniProgramType = WXMiniProgramTypePreview;
    }
    dispatch_queue_t globalQueue = dispatch_get_global_queue(0, 0);
    dispatch_async(globalQueue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self sendMiniProgramWebpageUrl:call.arguments[@"webPageUrl"]
                                   userName:call.arguments[@"userName"]
                                       path:call.arguments[@"path"]
                                      title:call.arguments[fluwxKeyTitle]
                                Description:call.arguments[fluwxKeyDescription]
                            withShareTicket:[call.arguments[@"withShareTicket"] boolValue]
                            miniProgramType:miniProgramType
                                 MessageExt:call.arguments[fluwxKeyMessageExt]
                              MessageAction:call.arguments[fluwxKeyMessageAction]
                                    TagName:call.arguments[fluwxKeyMediaTagName]
                                    InScene:[self intToWeChatScene:scene]
                               MsgSignature:call.arguments[fluwxKeyMsgSignature]
                                HdImageData:hdImageData
                                  ThumbData:thumbData
                              ThumbDataHash:call.arguments[fluwxKeyThumbDataHash]
                                 completion:^(BOOL done) {
                result(@(done));
            }];
        });
    });
}

- (NSData *)getNsDataFromWeChatFile:(NSDictionary *)weChatFile {
    NSNumber *schema = weChatFile[@"schema"];
    
    if ([schema isEqualToNumber:@0]) {
        NSString *source = weChatFile[keySource];
        NSURL *imageURL = [NSURL URLWithString:source];
        //下载图片
        return [NSData dataWithContentsOfURL:imageURL];
    } else if ([schema isEqualToNumber:@1]) {
        NSString *source = weChatFile[keySource];
        return [NSData dataWithContentsOfFile:[self readFileFromAssets:source]];
    } else if ([schema isEqualToNumber:@2]) {
        NSString *source = weChatFile[keySource];
        return [NSData dataWithContentsOfFile:source];
    } else if ([schema isEqualToNumber:@3]) {
        FlutterStandardTypedData *imageData = weChatFile[@"source"];
        return imageData.data;
    } else {
        return nil;
    }
}

- (UIImage *)getThumbnailFromNSData:(NSData *)data size:(NSUInteger)size isPNG:(BOOL)isPNG compress:(BOOL)compress {
    UIImage *uiImage = [UIImage imageWithData:data];
    if (compress) {
        return [ThumbnailHelper compressImage:uiImage toByte:size isPNG:isPNG];
    } else {
        return uiImage;
    }
}

- (NSData *)getThumbnailDataFromNSData:(NSData *)data size:(NSUInteger)size compress:(BOOL)compress {
    if (compress) {
        return [ThumbnailHelper compressImageData:data toByte:size];
    } else {
        return data;
    }
}

- (NSString *)readFileFromAssets:(NSString *)imagePath {
    NSArray *array = [self formatAssets:imagePath];
    NSString *key;
    if ([FluwxStringUtil isBlank:array[1]]) {
        key = [_fluwxRegistrar lookupKeyForAsset:array[0]];
    } else {
        key = [_fluwxRegistrar lookupKeyForAsset:array[0] fromPackage:array[1]];
    }
    
    return [[NSBundle mainBundle] pathForResource:key ofType:nil];
}

- (NSArray *)formatAssets:(NSString *)originPath {
    NSString *path = nil;
    NSString *packageName = @"";
    NSString *pathWithoutSchema = originPath;
    NSInteger indexOfPackage = [pathWithoutSchema lastIndexOfString:@"?package="];
    
    if (indexOfPackage != JavaNotFound) {
        path = [pathWithoutSchema substringFromIndex:0 toIndex:indexOfPackage];
        NSInteger begin = indexOfPackage + [fluwxKeyPackage length];
        packageName = [pathWithoutSchema substringFromIndex:begin toIndex:[pathWithoutSchema length]];
    } else {
        path = pathWithoutSchema;
    }
    
    return @[path, packageName];
}

- (BOOL)isPNG:(NSString *)suffix {
    return [@".png" equals:suffix];
}

- (enum WXScene)intToWeChatScene:(NSNumber *)value {
    //    enum WeChatScene { SESSION, TIMELINE, FAVORITE }
    if ([value isEqual:@0]) {
        return WXSceneSession;
    } else if ([value isEqual:@1]) {
        return WXSceneTimeline;
    } else if ([value isEqual:@2]) {
        return WXSceneFavorite;
    } else {
        return WXSceneSession;
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
            fluwxType: @(messageResp.type),
            country: messageResp.country == nil ? @"" : messageResp.country,
            lang: messageResp.lang == nil ? @"" : messageResp.lang};
        if (_channel != nil) {
            [_channel invokeMethod:@"onShareResponse" arguments:result];
        }
    } else if ([resp isKindOfClass:[SendAuthResp class]]) {
        SendAuthResp *authResp = (SendAuthResp *) resp;
        NSDictionary *result = @{
            description: authResp.description == nil ? @"" : authResp.description,
            errStr: authResp.errStr == nil ? @"" : authResp.errStr,
            errCode: @(authResp.errCode),
            fluwxType: @(authResp.type),
            country: authResp.country == nil ? @"" : authResp.country,
            lang: authResp.lang == nil ? @"" : authResp.lang,
            @"code": [FluwxStringUtil nilToEmpty:authResp.code],
            @"state": [FluwxStringUtil nilToEmpty:authResp.state]
            
        };
        
        if (_channel != nil) {
            [_channel invokeMethod:@"onAuthResponse" arguments:result];
        }
    } else if ([resp isKindOfClass:[AddCardToWXCardPackageResp class]]) {
        // pass
    } else if ([resp isKindOfClass:[WXChooseCardResp class]]) {
        // pass
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
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:mutableArray
                                                           options:NSJSONWritingPrettyPrinted
                                                             error: &error];
        NSString *cardItemList = @"";
        if ([jsonData length] && error == nil) {
            cardItemList = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        }
        
        NSDictionary *result = @{
            description: chooseInvoiceResp.description == nil ? @"" : chooseInvoiceResp.description,
            errStr: chooseInvoiceResp.errStr == nil ? @"" : chooseInvoiceResp.errStr,
            errCode: @(chooseInvoiceResp.errCode),
            fluwxType: @(chooseInvoiceResp.type),
            @"cardItemList":cardItemList
        };
        
        if (_channel != nil) {
            [_channel invokeMethod:@"onOpenWechatInvoiceResponse" arguments:result];
        }
    } else if ([resp isKindOfClass:[WXSubscribeMsgResp class]]) {
        WXSubscribeMsgResp *subscribeMsgResp = (WXSubscribeMsgResp *) resp;
        NSMutableDictionary *result = [NSMutableDictionary dictionary];
        NSString *openid = subscribeMsgResp.openId;
        if (openid != nil && openid != NULL && ![openid isKindOfClass:[NSNull class]]) {
            result[@"openid"] = openid;
        }
        
        NSString *templateId = subscribeMsgResp.templateId;
        if (templateId != nil && templateId != NULL && ![templateId isKindOfClass:[NSNull class]]) {
            result[@"templateId"] = templateId;
        }
        
        NSString *action = subscribeMsgResp.action;
        if (action != nil && action != NULL && ![action isKindOfClass:[NSNull class]]) {
            result[@"action"] = action;
        }
        
        NSString *reserved = subscribeMsgResp.action;
        if (reserved != nil && reserved != NULL && ![reserved isKindOfClass:[NSNull class]]) {
            result[@"reserved"] = reserved;
        }
        
        UInt32 scene = subscribeMsgResp.scene;
        result[@"scene"] = @(scene);
        if (_channel != nil) {
            [_channel invokeMethod:@"onSubscribeMsgResp" arguments:result];
        }
    } else if ([resp isKindOfClass:[WXLaunchMiniProgramResp class]]) {
        WXLaunchMiniProgramResp *miniProgramResp = (WXLaunchMiniProgramResp *) resp;
        NSDictionary *commonResult = @{
            description: miniProgramResp.description == nil ? @"" : miniProgramResp.description,
            errStr: miniProgramResp.errStr == nil ? @"" : miniProgramResp.errStr,
            errCode: @(miniProgramResp.errCode),
            fluwxType: @(miniProgramResp.type),
        };
        
        NSMutableDictionary *result = [NSMutableDictionary dictionaryWithDictionary:commonResult];
        if (miniProgramResp.extMsg != nil) {
            result[@"extMsg"] = miniProgramResp.extMsg;
        }
        if (_channel != nil) {
            [_channel invokeMethod:@"onLaunchMiniProgramResponse" arguments:result];
        }
    } else if ([resp isKindOfClass:[WXInvoiceAuthInsertResp class]]) {
        // pass
    } else if ([resp isKindOfClass:[WXOpenBusinessWebViewResp class]]) {
        WXOpenBusinessWebViewResp *businessResp = (WXOpenBusinessWebViewResp *) resp;
        NSDictionary *result = @{
            description: [FluwxStringUtil nilToEmpty:businessResp.description],
            errStr: [FluwxStringUtil nilToEmpty:resp.errStr],
            errCode: @(businessResp.errCode),
            fluwxType: @(businessResp.type),
            @"resultInfo": [FluwxStringUtil nilToEmpty:businessResp.result],
            @"businessType": @(businessResp.businessType),
        };
        if (_channel != nil) {
            [_channel invokeMethod:@"onWXOpenBusinessWebviewResponse" arguments:result];
        }
    } else if ([resp isKindOfClass:[WXOpenCustomerServiceResp class]]) {
        WXOpenCustomerServiceResp *customerResp = (WXOpenCustomerServiceResp *) resp;
        NSDictionary *result = @{
            description: [FluwxStringUtil nilToEmpty:customerResp.description],
            errStr: [FluwxStringUtil nilToEmpty:resp.errStr],
            errCode: @(customerResp.errCode),
            fluwxType: @(customerResp.type),
            @"extMsg":[FluwxStringUtil nilToEmpty:customerResp.extMsg]
        };
        if (_channel != nil) {
            [_channel invokeMethod:@"onWXOpenBusinessWebviewResponse" arguments:result];
        }
        // 相关错误信息
    } else if ([resp isKindOfClass:[WXOpenBusinessViewResp class]]) {
        WXOpenBusinessViewResp *openBusinessViewResp = (WXOpenBusinessViewResp *) resp;
        NSDictionary *result = @{
            description: [FluwxStringUtil nilToEmpty:openBusinessViewResp.description],
            errStr: [FluwxStringUtil nilToEmpty:resp.errStr],
            errCode: @(openBusinessViewResp.errCode),
            @"businessType":openBusinessViewResp.businessType,
            fluwxType: @(openBusinessViewResp.type),
            @"extMsg":[FluwxStringUtil nilToEmpty:openBusinessViewResp.extMsg]
        };
        if (_channel != nil) {
            [_channel invokeMethod:@"onOpenBusinessViewResponse" arguments:result];
        }
        // 相关错误信息
    }
#ifndef NO_PAY
    else if ([resp isKindOfClass:[WXPayInsuranceResp class]]) {
        // pass
    } else if ([resp isKindOfClass:[PayResp class]]) {
        PayResp *payResp = (PayResp *) resp;
        NSDictionary *result = @{
            description: [FluwxStringUtil nilToEmpty:payResp.description],
            errStr: [FluwxStringUtil nilToEmpty:resp.errStr],
            errCode: @(payResp.errCode),
            fluwxType: @(payResp.type),
            @"extData": [FluwxStringUtil nilToEmpty:[FluwxDelegate defaultManager].extData],
            @"returnKey": [FluwxStringUtil nilToEmpty:payResp.returnKey],
        };
        [FluwxDelegate defaultManager].extData = nil;
        if (_channel != nil) {
            [_channel invokeMethod:@"onPayResponse" arguments:result];
        }
    } else if ([resp isKindOfClass:[WXNontaxPayResp class]]) {
        // pass
    }
#endif
}

- (void)onReq:(BaseReq *)req {
    if ([req isKindOfClass:[GetMessageFromWXReq class]]) {
        // pass
    } else if ([req isKindOfClass:[ShowMessageFromWXReq class]]) {
        // ShowMessageFromWXReq -- android spec
        ShowMessageFromWXReq *showMessageFromWXReq = (ShowMessageFromWXReq *) req;
        WXMediaMessage *wmm = showMessageFromWXReq.message;
        
        NSMutableDictionary *result = [NSMutableDictionary dictionary];
        [result setValue:wmm.messageAction forKey:@"messageAction"];
        [result setValue:wmm.messageExt forKey:@"extMsg"];
        [result setValue:showMessageFromWXReq.lang forKey:@"lang"];
        [result setValue:showMessageFromWXReq.country forKey:@"country"];
        
        // Cache extMsg for later use (by calling 'getExtMsg')
        [FluwxDelegate defaultManager].extMsg = wmm.messageExt;
        
        if (_isRunning) {
            [_channel invokeMethod:@"onWXShowMessageFromWX" arguments:result];
        } else {
            __weak typeof(self) weakSelf = self;
            _attemptToResumeMsgFromWxRunnable = ^() {
                __strong typeof(weakSelf) strongSelf = weakSelf;
                [strongSelf->_channel invokeMethod:@"onWXShowMessageFromWX" arguments:result];
            };
        }
    } else if ([req isKindOfClass:[LaunchFromWXReq class]]) {
        // ShowMessageFromWXReq -- ios spec
        LaunchFromWXReq *launchFromWXReq = (LaunchFromWXReq *) req;
        WXMediaMessage *wmm = launchFromWXReq.message;
        
        NSMutableDictionary *result = [NSMutableDictionary dictionary];
        [result setValue:wmm.messageAction forKey:@"messageAction"];
        [result setValue:wmm.messageExt forKey:@"extMsg"];
        [result setValue:launchFromWXReq.lang forKey:@"lang"];
        [result setValue:launchFromWXReq.country forKey:@"country"];
        
        // Cache extMsg for later use (by calling 'getExtMsg')
        [FluwxDelegate defaultManager].extMsg = wmm.messageExt;
        
        if (_isRunning) {
            [_channel invokeMethod:@"onWXLaunchFromWX" arguments:result];
        } else {
            __weak typeof(self) weakSelf = self;
            _attemptToResumeMsgFromWxRunnable = ^() {
                __strong typeof(weakSelf) strongSelf = weakSelf;
                [strongSelf->_channel invokeMethod:@"onWXLaunchFromWX" arguments:result];
            };
        }
    }
}

- (void)sendText:(NSString *)text
         InScene:(enum WXScene)scene
      completion:(void (^ __nullable)(BOOL success))completion {
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.scene = scene;
    req.bText = YES;
    req.text = text;
    [WXApi sendReq:req completion:completion];
}

- (void)sendImageData:(NSData *)imageData
          ImgDataHash:(NSString *) imgDataHash
              TagName:(NSString *)tagName
           MessageExt:(NSString *)messageExt
               Action:(NSString *)action
              InScene:(enum WXScene)scene
                title:(NSString *)title
          description:(NSString *)description
         MsgSignature:(NSString *)msgSignature
            ThumbData:(NSData *)thumbData
        ThumbDataHash:(NSString*)thumbDataHash
           completion:(void (^ __nullable)(BOOL success))completion {
    WXImageObject *ext = [WXImageObject object];
    ext.imageData = imageData;
    ext.imgDataHash = (imgDataHash == (id) [NSNull null]) ? nil : imgDataHash;
    
    WXMediaMessage *message = [self messageWithTitle:(title == (id) [NSNull null]) ? nil : title
                                         Description:(description == (id) [NSNull null]) ? nil : description
                                              Object:ext
                                          MessageExt:(messageExt == (id) [NSNull null]) ? nil : messageExt
                                       MessageAction:(action == (id) [NSNull null]) ? nil : action
                                            MediaTag:(tagName == (id) [NSNull null]) ? nil : tagName
                                        MsgSignature:(msgSignature == (id) [NSNull null]) ? nil : msgSignature
                                           ThumbData: thumbData
                                       ThumbDataHash:(thumbDataHash == (id) [NSNull null]) ? nil : thumbDataHash
                               
    ];;
    
    SendMessageToWXReq *req = [self requestWithText:nil
                                     OrMediaMessage:message
                                              bText:NO
                                            InScene:scene];
    
    [WXApi sendReq:req completion:completion];
}

- (void)sendLinkURL:(NSString *)urlString
            TagName:(NSString *)tagName
              Title:(NSString *)title
        Description:(NSString *)description
         MessageExt:(NSString *)messageExt
      MessageAction:(NSString *)messageAction
            InScene:(enum WXScene)scene
       MsgSignature:(NSString *)msgSignature
          ThumbData:(NSData *)thumbData
      ThumbDataHash:(NSString*)thumbDataHash
         completion:(void (^ __nullable)(BOOL success))completion {
    WXWebpageObject *ext = [WXWebpageObject object];
    ext.webpageUrl = urlString;
    
    WXMediaMessage *message = [self messageWithTitle:(title == (id) [NSNull null]) ? nil :title
                                         Description:(description == (id) [NSNull null]) ? nil : description
                                              Object:ext
                                          MessageExt:(messageExt == (id) [NSNull null]) ? nil : messageExt
                                       MessageAction:(messageAction == (id) [NSNull null]) ? nil : messageAction
                                            MediaTag:(tagName == (id) [NSNull null]) ? nil : tagName
                                        MsgSignature:(msgSignature == (id) [NSNull null]) ? nil : msgSignature
                                           ThumbData: thumbData
                                       ThumbDataHash:(thumbDataHash == (id) [NSNull null]) ? nil : thumbDataHash
    ];
    
    SendMessageToWXReq *req = [self requestWithText:nil
                                     OrMediaMessage:message
                                              bText:NO
                                            InScene:scene];
    [WXApi sendReq:req completion:completion];
}

- (void)sendMusicURL:(NSString *)musicURL
             dataURL:(NSString *)dataURL
     MusicLowBandUrl:(NSString *)musicLowBandUrl
 MusicLowBandDataUrl:(NSString *)musicLowBandDataUrl
               Title:(NSString *)title
         Description:(NSString *)description
          MessageExt:(NSString *)messageExt
       MessageAction:(NSString *)messageAction
             TagName:(NSString *)tagName
             InScene:(enum WXScene)scene
        MsgSignature:(NSString *)msgSignature
           ThumbData:(NSData *)thumbData
       ThumbDataHash:(NSString*)thumbDataHash
          completion:(void (^ __nullable)(BOOL success))completion {
    WXMusicObject *ext = [WXMusicObject object];
    
    if ([FluwxStringUtil isBlank:musicURL]) {
        ext.musicLowBandUrl = musicLowBandUrl;
        ext.musicLowBandDataUrl = (musicLowBandDataUrl == (id) [NSNull null]) ? nil : musicLowBandDataUrl;
    } else {
        ext.musicUrl = musicURL;
        ext.musicDataUrl = (dataURL == (id) [NSNull null]) ? nil : dataURL;
    }
    
    
    WXMediaMessage *message = [self messageWithTitle:(title == (id) [NSNull null]) ? nil : title
                                         Description:description
                                              Object:ext
                                          MessageExt:(messageExt == (id) [NSNull null]) ? nil : messageExt
                                       MessageAction:(messageAction == (id) [NSNull null]) ? nil : messageAction
                                            MediaTag:(tagName == (id) [NSNull null]) ? nil : tagName
                                        MsgSignature:(msgSignature == (id) [NSNull null]) ? nil : msgSignature
                                           ThumbData: thumbData
                                       ThumbDataHash:(thumbDataHash == (id) [NSNull null]) ? nil : thumbDataHash
    ];
    
    SendMessageToWXReq *req = [self requestWithText:nil
                                     OrMediaMessage:message
                                              bText:NO
                                            InScene:scene];
    
    [WXApi sendReq:req completion:completion];
}

- (void)sendVideoURL:(NSString *)videoURL
     VideoLowBandUrl:(NSString *)videoLowBandUrl
               Title:(NSString *)title
         Description:(NSString *)description
          MessageExt:(NSString *)messageExt
       MessageAction:(NSString *)messageAction
             TagName:(NSString *)tagName
             InScene:(enum WXScene)scene
        MsgSignature:(NSString *)msgSignature
           ThumbData:(NSData *)thumbData
       ThumbDataHash:(NSString*)thumbDataHash
          completion:(void (^ __nullable)(BOOL success))completion {
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = (title == (id) [NSNull null]) ? nil : title;
    message.description = (description == (id) [NSNull null]) ? nil : description;
    message.messageExt = (messageExt == (id) [NSNull null]) ? nil : messageExt;
    message.messageAction = (messageAction == (id) [NSNull null]) ? nil : messageAction;
    message.mediaTagName = (tagName == (id) [NSNull null]) ? nil : tagName;
    message.thumbData = (thumbData == (id) [NSNull null]) ? nil : thumbData;
    message.thumbDataHash = (thumbDataHash == (id) [NSNull null]) ? nil : thumbDataHash;
    
    WXVideoObject *ext = [WXVideoObject object];
    if ([FluwxStringUtil isBlank:videoURL]) {
        ext.videoLowBandUrl = videoLowBandUrl;
    } else {
        ext.videoUrl = videoURL;
    }
    message.mediaObject = ext;
    
    SendMessageToWXReq *req = [self requestWithText:nil OrMediaMessage:message bText:NO InScene:scene];
    [WXApi sendReq:req completion:completion];
}

- (void)sendEmotionData:(NSData *)emotionData
                InScene:(enum WXScene)scene
           MsgSignature:(NSString *)msgSignature
              ThumbData:(NSData *)thumbData
          ThumbDataHash:(NSString*)thumbDataHash
             completion:(void (^ __nullable)(BOOL success))completion {
    WXMediaMessage *message = [WXMediaMessage message];
    message.thumbData = (thumbData == (id) [NSNull null]) ? nil : thumbData;
    message.thumbDataHash = (thumbDataHash == (id) [NSNull null]) ? nil : thumbDataHash;
    
    WXEmoticonObject *ext = [WXEmoticonObject object];
    ext.emoticonData = emotionData;
    message.mediaObject = ext;
    
    NSString *signature = (msgSignature == (id) [NSNull null]) ? nil : msgSignature;
    if (signature != nil) {
        message.msgSignature = signature;
    }
    
    SendMessageToWXReq *req = [self requestWithText:nil OrMediaMessage:message bText:NO InScene:scene];
    [WXApi sendReq:req completion:completion];
}

- (void)sendFileData:(NSData *)fileData
       fileExtension:(NSString *)extension
               Title:(NSString *)title
         Description:(NSString *)description
             InScene:(enum WXScene)scene
        MsgSignature:(NSString *)msgSignature
           ThumbData:(NSData *)thumbData
       ThumbDataHash:(NSString*)thumbDataHash
          completion:(void (^ __nullable)(BOOL success))completion {
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = title;
    message.description = description;
    message.thumbData = (thumbData == (id) [NSNull null]) ? nil : thumbData;
    message.thumbDataHash = (thumbDataHash == (id) [NSNull null]) ? nil : thumbDataHash;
    
    WXFileObject *ext = [WXFileObject object];
    ext.fileExtension = extension;
    ext.fileData = fileData;
    message.mediaObject = ext;
    
    NSString *signature = (msgSignature == (id) [NSNull null]) ? nil : msgSignature;
    if (signature != nil) {
        message.msgSignature = signature;
    }
    
    SendMessageToWXReq *req = [self requestWithText:nil OrMediaMessage:message bText:NO InScene:scene];
    [WXApi sendReq:req completion:completion];
}

- (void)sendMiniProgramWebpageUrl:(NSString *)webpageUrl
                         userName:(NSString *)userName
                             path:(NSString *)path
                            title:(NSString *)title
                      Description:(NSString *)description
                  withShareTicket:(BOOL)withShareTicket
                  miniProgramType:(WXMiniProgramType)programType
                       MessageExt:(NSString *)messageExt
                    MessageAction:(NSString *)messageAction
                          TagName:(NSString *)tagName
                          InScene:(enum WXScene)scene
                     MsgSignature:(NSString *)msgSignature
                      HdImageData:(NSData *)hdImageData
                        ThumbData:(NSData *)thumbData
                    ThumbDataHash:(NSString*)thumbDataHash
                       completion:(void (^ __nullable)(BOOL success))completion {
    WXMiniProgramObject *ext = [WXMiniProgramObject object];
    ext.webpageUrl = (webpageUrl == (id) [NSNull null]) ? nil : webpageUrl;
    ext.userName = (userName == (id) [NSNull null]) ? nil : userName;
    ext.path = (path == (id) [NSNull null]) ? nil : path;
    ext.withShareTicket = withShareTicket;
    ext.hdImageData = hdImageData;
    ext.miniProgramType = programType;
    
    WXMediaMessage *message = [self messageWithTitle:(title == (id) [NSNull null]) ? nil : title
                                         Description:(description == (id) [NSNull null]) ? nil : description
                                              Object:ext
                                          MessageExt:(messageExt == (id) [NSNull null]) ? nil : messageExt
                                       MessageAction:(messageAction == (id) [NSNull null]) ? nil : messageAction
                                            MediaTag:(tagName == (id) [NSNull null]) ? nil : tagName
                                        MsgSignature:(msgSignature == (id) [NSNull null]) ? nil : msgSignature
                                           ThumbData:(thumbData == (id) [NSNull null] ? nil : thumbData)
                                       ThumbDataHash:(thumbDataHash == (id) [NSNull null]) ? nil : thumbDataHash
    ];
    
    SendMessageToWXReq *req = [self requestWithText:nil OrMediaMessage:message bText:NO InScene:scene];
    [WXApi sendReq:req completion:completion];
}

- (void)sendAppContentData:(NSData *)data
                   ExtInfo:(NSString *)info
                    ExtURL:(NSString *)url
                     Title:(NSString *)title
               Description:(NSString *)description
                MessageExt:(NSString *)messageExt
             MessageAction:(NSString *)action
                   InScene:(enum WXScene)scene
              MsgSignature:(NSString *)msgSignature
                 ThumbData:(NSData *)thumbData
             ThumbDataHash:(NSString*)thumbDataHash
                completion:(void (^ __nullable)(BOOL success))completion {
    WXAppExtendObject *ext = [WXAppExtendObject object];
    ext.extInfo = info;
    ext.url = url;
    ext.fileData = data;
    
    WXMediaMessage *message = [self messageWithTitle:title
                                         Description:description
                                              Object:ext
                                          MessageExt:messageExt
                                       MessageAction:action
                                            MediaTag:nil
                                        MsgSignature:(msgSignature == (id) [NSNull null]) ? nil : msgSignature
                                           ThumbData:(thumbData == (id) [NSNull null]) ? nil : thumbData
                                       ThumbDataHash:(thumbDataHash == (id) [NSNull null]) ? nil : thumbDataHash
    ];
    
    SendMessageToWXReq *req = [self requestWithText:nil OrMediaMessage:message bText:NO InScene:scene];
    [WXApi sendReq:req completion:completion];
}

- (void)addCardsToCardPackage:(NSArray *)cardIds
                     cardExts:(NSArray *)cardExts
                   completion:(void (^ __nullable)(BOOL success))completion {
    NSMutableArray *cardItems = [NSMutableArray array];
    for (NSString *cardId in cardIds) {
        WXCardItem *item = [[WXCardItem alloc] init];
        item.cardId = cardId;
        item.appID = @"wxf8b4f85f3a794e77";
        [cardItems addObject:item];
    }
    
    for (NSInteger index = 0; index < cardItems.count; index++) {
        WXCardItem *item = cardItems[index];
        NSString *ext = cardExts[index];
        item.extMsg = ext;
    }
    
    AddCardToWXCardPackageReq *req = [[AddCardToWXCardPackageReq alloc] init];
    req.cardAry = cardItems;
    [WXApi sendReq:req completion:completion];
}

- (void)chooseCard:(NSString *)appid
          cardSign:(NSString *)cardSign
          nonceStr:(NSString *)nonceStr
          signType:(NSString *)signType
         timestamp:(UInt32)timestamp
        completion:(void (^ __nullable)(BOOL success))completion {
    WXChooseCardReq *chooseCardReq = [[WXChooseCardReq alloc] init];
    chooseCardReq.appID = appid;
    chooseCardReq.cardSign = cardSign;
    chooseCardReq.nonceStr = nonceStr;
    chooseCardReq.signType = signType;
    chooseCardReq.timeStamp = timestamp;
    [WXApi sendReq:chooseCardReq completion:completion];
}

- (void)sendAuthRequestScope:(NSString *)scope
                       State:(NSString *)state
                      OpenID:(NSString *)openID
            InViewController:(UIViewController *)viewController
                  completion:(void (^ __nullable)(BOOL success))completion {
    SendAuthReq *req = [[SendAuthReq alloc] init];
    req.scope = scope; // @"post_timeline,sns"
    req.state = state;
    req.openID = openID;
    
    return [WXApi sendAuthReq:req
               viewController:viewController
                     delegate:self
                   completion:completion];
}


- (void)sendAuthRequestScope:(NSString *)scope
                       State:(NSString *)state
                      OpenID:(NSString *)openID
                NonAutomatic:(BOOL)nonAutomatic
                  completion:(void (^)(BOOL))completion {
    SendAuthReq *req = [[SendAuthReq alloc] init];
    req.scope = scope; // @"post_timeline,sns"
    req.state = state;
    req.openID = openID;
    req.nonautomatic = nonAutomatic;
    
    [WXApi sendReq:req completion:completion];
    
}


- (void)openUrl:(NSString *)url
     completion:(void (^ __nullable)(BOOL success))completion {
    OpenWebviewReq *req = [[OpenWebviewReq alloc] init];
    req.url = url;
    [WXApi sendReq:req completion:completion];
}

- (void)chooseInvoice:(NSString *)appid
             cardSign:(NSString *)cardSign
             nonceStr:(NSString *)nonceStr
             signType:(NSString *)signType
            timestamp:(UInt32)timestamp
           completion:(void (^ __nullable)(BOOL success))completion {
    WXChooseInvoiceReq *chooseInvoiceReq = [[WXChooseInvoiceReq alloc] init];
    chooseInvoiceReq.appID = appid;
    chooseInvoiceReq.cardSign = cardSign;
    chooseInvoiceReq.nonceStr = nonceStr;
    chooseInvoiceReq.signType = signType;
    //    chooseCardReq.cardType = @"INVOICE";
    chooseInvoiceReq.timeStamp = timestamp;
    //    chooseCardReq.canMultiSelect = 1;
    [WXApi sendReq:chooseInvoiceReq completion:completion];
}


- (void)openCustomerService:(NSString *)url CorpId:(NSString *)corpId completion:(void (^)(BOOL))completion {
    WXOpenCustomerServiceReq *req = [[WXOpenCustomerServiceReq alloc] init];
    req.corpid = corpId; //企业ID
    req.url = url;       //客服URL
    [WXApi sendReq:req completion:completion];
}

- (void)handleAuthByPhoneLogin:(FlutterMethodCall *)call result:(FlutterResult)result {
    UIViewController *vc = UIApplication.sharedApplication.keyWindow.rootViewController;
    SendAuthReq *authReq = [[SendAuthReq alloc] init];
    authReq.scope = call.arguments[@"scope"];
    authReq.state = (call.arguments[@"state"] == (id) [NSNull null]) ? nil : call.arguments[@"state"];
    [WXApi sendAuthReq:authReq viewController:vc delegate:self completion:^(BOOL success) {
        result(@(success));
    }];
}

- (void)handleAuth:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *openId = call.arguments[@"openId"];
    
    [self sendAuthRequestScope:call.arguments[@"scope"]
                         State:(call.arguments[@"state"] == (id) [NSNull null]) ? nil : call.arguments[@"state"]
                        OpenID:(openId == (id) [NSNull null]) ? nil : openId
                  NonAutomatic:[call.arguments[@"nonAutomatic"] boolValue]
                    completion:^(BOOL done) {
        result(@(done));
    }];
}

- (void)authByQRCode:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *appId = call.arguments[@"appId"];
    NSString *scope = call.arguments[@"scope"];
    NSString *nonceStr = call.arguments[@"nonceStr"];
    NSString *timeStamp = call.arguments[@"timeStamp"];
    NSString *signature = call.arguments[@"signature"];
    NSString *schemeData = (call.arguments[@"schemeData"] == (id) [NSNull null]) ? nil : call.arguments[@"schemeData"];
    
    BOOL done = [_qrauth Auth:appId nonceStr:nonceStr timeStamp:timeStamp scope:scope signature:signature schemeData:schemeData];
    result(@(done));
}

- (void)stopAuthByQRCode:(FlutterMethodCall *)call result:(FlutterResult)result {
    BOOL done = [_qrauth StopAuth];
    result(@(done));
}

- (void)onQrcodeScanned {
    if (_channel != nil) {
        [_channel invokeMethod:@"onQRCodeScanned" arguments:@{@"errCode": @0}];
    }
}

- (void)onAuthGotQrcode:(UIImage *)image {
    NSData *imageData = UIImagePNGRepresentation(image);
    //    if (imageData == nil) {
    //        imageData = UIImageJPEGRepresentation(image, 1);
    //    }
    if (_channel != nil) {
        [_channel invokeMethod:@"onAuthGotQRCode" arguments:@{@"errCode": @0, @"qrCode": imageData}];
    }
}

- (void)onAuthFinish:(int)errCode AuthCode:(nullable NSString *)authCode {
    NSDictionary *errorCode = @{@"errCode": @(errCode)};
    NSMutableDictionary *result = [NSMutableDictionary dictionaryWithDictionary:errorCode];
    if (authCode != nil) {
        result[@"authCode"] = authCode;
    }
    if (_channel != nil) {
        [_channel invokeMethod:@"onAuthByQRCodeFinished" arguments:result];
    }
}

- (WXMediaMessage *)messageWithTitle:(NSString *)title
                         Description:(NSString *)description
                              Object:(id)mediaObject
                          MessageExt:(NSString *)messageExt
                       MessageAction:(NSString *)action
                            MediaTag:(NSString *)tagName
                        MsgSignature:(NSString *)msgSignature
                           ThumbData:(NSData *)thumbData
                       ThumbDataHash:(NSString*)thumbDataHash {
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = title;
    message.description = description;
    message.mediaObject = mediaObject;
    message.messageExt = messageExt;
    message.messageAction = action;
    message.mediaTagName = tagName;
    message.thumbData = thumbData;
    message.thumbDataHash = thumbDataHash;
    if (msgSignature != nil) {
        message.msgSignature = msgSignature;
    }
    return message;
}

- (SendMessageToWXReq *)requestWithText:(NSString *)text
                         OrMediaMessage:(WXMediaMessage *)message
                                  bText:(BOOL)bText
                                InScene:(enum WXScene)scene {
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.bText = bText;
    req.scene = scene;
    if (bText) {
        req.text = text;
    } else {
        req.message = message;
    }
    return req;
}

- (NSString*)fetchWeChatAppId {
    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
    NSArray *types = infoDict[@"CFBundleURLTypes"];
    for (NSDictionary *dict in types) {
        if ([@"weixin" isEqualToString:dict[@"CFBundleURLName"]]) {
            return dict[@"CFBundleURLSchemes"][0];
        }
    }
    return nil;
}

@end
