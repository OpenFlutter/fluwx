//
// Created by mo on 2018/8/24.
//

#import "FluwxPaymentHandler.h"
#import "ThumbnailHelper.h"
#import "NSStringWrapper.h"
#import "CallResults.h"

#import "FluwxKeys.h"
#import "StringToWeChatScene.h"
#import "FluwxMethods.h"

@implementation FluwxPaymentHandler
- (instancetype)initWithRegistrar:(NSObject<FlutterPluginRegistrar> *)registrar {
    self = [super init];

    return self;
}

- (void)handlePayment:(FlutterMethodCall *)call result:(FlutterResult)result {


    if (!isWeChatRegistered) {
        result([FlutterError errorWithCode:resultErrorNeedWeChat message:resultMessageNeedWeChat details:nil]);
        return;
    }

    if (![WXApi isWXAppInstalled]) {
        result([FlutterError errorWithCode:@"wechat not installed" message:@"wechat not installed" details:nil]);
        return;
    }

    NSNumber * timestamp =  call.arguments[@"timeStamp"];

            NSString *partnerId = call.arguments[@"partnerId"];
    NSString *prepayId = call.arguments[@"prepayId"];
    NSString *packageValue = call.arguments[@"packageValue"];
    NSString *nonceStr = call.arguments[@"nonceStr"];
    UInt32 timeStamp = [timestamp unsignedIntValue];
    NSString *sign = call.arguments[@"sign"];
    BOOL done = [WXApiRequestHandler sendPayment:call.arguments[@"appId"]
                                       PartnerId:partnerId
                                        PrepayId:prepayId
                                        NonceStr:nonceStr
                                       Timestamp:timeStamp
                                         Package:packageValue
                                            Sign:sign];
    result(@{fluwxKeyPlatform: fluwxKeyIOS, fluwxKeyResult: @(done)});
}
@end