//
// Created by mo on 2018/8/23.
//

#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>


@interface FluwxWXApiHandler : NSObject
- (void)registerApp:(FlutterMethodCall *)call result:(FlutterResult)result;

- (void)checkWeChatInstallation:(FlutterMethodCall *)call result:(FlutterResult)result;
@end