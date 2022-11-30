//
// Created by mo on 2020/3/7.
//


#import "FluwxAuthHandler.h"

@implementation FluwxAuthHandler

WechatAuthSDK *_qrauth;
FlutterMethodChannel *_fluwxMethodChannel = nil;

- (instancetype)initWithRegistrar:(NSObject <FlutterPluginRegistrar> *)registrar methodChannel:(FlutterMethodChannel *)flutterMethodChannel {
    self = [super init];
    if (self) {
        _qrauth = [[WechatAuthSDK alloc] init];
        _qrauth.delegate = self;
        _fluwxMethodChannel = flutterMethodChannel;
    }

    return self;
}

- (void)handleAuthByPhoneLogin:(FlutterMethodCall *)call result:(FlutterResult)result {
    UIViewController *vc = UIApplication.sharedApplication.keyWindow.rootViewController;
    SendAuthReq *authReq = [[SendAuthReq alloc] init];
    authReq.scope = call.arguments[@"scope"];
    authReq.state = (call.arguments[@"state"] == (id) [NSNull null]) ? nil : call.arguments[@"state"];
    [WXApi sendAuthReq:authReq viewController:vc delegate:[FluwxResponseHandler defaultManager] completion:^(BOOL success) {
        result(@(success));
    }];
}

- (void)handleAuth:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *openId = call.arguments[@"openId"];

    [WXApiRequestHandler sendAuthRequestScope:call.arguments[@"scope"]
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
    [_fluwxMethodChannel invokeMethod:@"onQRCodeScanned" arguments:@{@"errCode": @0}];
}

- (void)onAuthGotQrcode:(UIImage *)image {
    NSData *imageData = UIImagePNGRepresentation(image);
//    if (imageData == nil) {
//        imageData = UIImageJPEGRepresentation(image, 1);
//    }

    [_fluwxMethodChannel invokeMethod:@"onAuthGotQRCode" arguments:@{@"errCode": @0, @"qrCode": imageData}];
}

- (void)onAuthFinish:(int)errCode AuthCode:(nullable NSString *)authCode {
    NSDictionary *errorCode = @{@"errCode": @(errCode)};
    NSMutableDictionary *result = [NSMutableDictionary dictionaryWithDictionary:errorCode];
    if (authCode != nil) {
        result[@"authCode"] = authCode;
    }
    [_fluwxMethodChannel invokeMethod:@"onAuthByQRCodeFinished" arguments:result];
}
@end
