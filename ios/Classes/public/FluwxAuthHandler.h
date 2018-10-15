//
// Created by mo on 2018/8/23.
//

#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>
#import "FluwxPlugin.h"
#import "WXApi.h"
#import "WXApiRequestHandler.h"
@class StringUtil;

@interface FluwxAuthHandler : NSObject
-(instancetype) initWithRegistrar:(NSObject<FlutterPluginRegistrar> *)registrar;
- (void)handleAuth:(FlutterMethodCall *)call result:(FlutterResult)result;
@end
