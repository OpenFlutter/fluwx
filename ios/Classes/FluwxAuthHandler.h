//
// Created by mo on 2020/3/7.
//

#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>
#import "FluwxPlugin.h"
#import "WXApiRequestHandler.h"
#import <WechatOpenSDK/WechatAuthSDK.h>

@class FluwxStringUtil;

@interface FluwxAuthHandler : NSObject <WechatAuthAPIDelegate>
- (instancetype)initWithRegistrar:(NSObject <FlutterPluginRegistrar> *)registrar methodChannel:(FlutterMethodChannel *)flutterMethodChannel;

- (void)handleAuth:(FlutterMethodCall *)call result:(FlutterResult)result;

- (void)authByQRCode:(FlutterMethodCall *)call result:(FlutterResult)result;

- (void)stopAuthByQRCode:(FlutterMethodCall *)call result:(FlutterResult)result;
@end
