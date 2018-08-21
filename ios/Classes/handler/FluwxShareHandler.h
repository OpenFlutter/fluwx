//
// Created by mo on 2018/8/16.
//

#import <Foundation/Foundation.h>
#import "CallResults.h"
#import "WXApiRequestHandler.h"
#import "FluwxKeys.h"
#import "StringToWeChatScene.h"
#import "WXApi.h"
#import "FluwxMethods.h"
#import <Flutter/Flutter.h>
#import "FluwxPlugin.h"
#import "ThumbnailHelper.h"
#import "NSStringWrapper.h"
@class StringUtil;

@interface FluwxShareHandler : NSObject
-(instancetype) initWithRegistrar:(NSObject<FlutterPluginRegistrar> *)registrar;
- (void)handleShare:(FlutterMethodCall *)call result:(FlutterResult)result;
@end