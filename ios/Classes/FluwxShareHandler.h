//
// Created by mo on 2020/3/7.
//

#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>

@class FluwxStringUtil;

@interface FluwxShareHandler : NSObject
- (instancetype)initWithRegistrar:(NSObject <FlutterPluginRegistrar> *)registrar;

- (void)handleShare:(FlutterMethodCall *)call result:(FlutterResult)result;
@end
