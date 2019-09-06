//
//  FluwxSubscribeMsgHandler.h
//  fluwx
//
//  Created by cjl on 2018/12/19.
//

#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>

NS_ASSUME_NONNULL_BEGIN

@interface FluwxSubscribeMsgHandler : NSObject
- (instancetype)initWithRegistrar:(NSObject <FlutterPluginRegistrar> *)registrar;

- (void)handleSubscribeWithCall:(FlutterMethodCall *)call result:(FlutterResult)result;
@end

NS_ASSUME_NONNULL_END
