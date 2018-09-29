//
// Created by mo on 2018/8/23.
//

#import <Foundation/Foundation.h>
#import "CallResults.h"
#import "WXApiRequestHandler.h"
#import "FluwxKeys.h"
#import "StringToWeChatScene.h"
#import <OpenWeChatSDK/WXApi.h>
#import "FluwxMethods.h"
#import <Flutter/Flutter.h>
#import "FluwxPlugin.h"
#import "ThumbnailHelper.h"
#import "NSStringWrapper.h"
@class StringUtil;

@interface FluwxAuthHandler : NSObject
-(instancetype) initWithRegistrar:(NSObject<FlutterPluginRegistrar> *)registrar;
- (void)handleAuth:(FlutterMethodCall *)call result:(FlutterResult)result;
@end