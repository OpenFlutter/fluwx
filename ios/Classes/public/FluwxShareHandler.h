//
// Created by mo on 2018/8/16.
//

#import <Foundation/Foundation.h>
#import "WXApi.h"
#import <Flutter/Flutter.h>
#import "FluwxPlugin.h"
#import "WXApiRequestHandler.h"

@class FluwxStringUtil;

@interface FluwxShareHandler : NSObject
- (instancetype)initWithRegistrar:(NSObject <FlutterPluginRegistrar> *)registrar;

- (void)handleShare:(FlutterMethodCall *)call result:(FlutterResult)result;
@end
