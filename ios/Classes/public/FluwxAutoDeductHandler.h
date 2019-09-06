//
//  FluwxAutoDeductHandler.h
//  fluwx
//
//  Created by realm on 2019/5/22.
//

#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>

NS_ASSUME_NONNULL_BEGIN

@interface FluwxAutoDeductHandler : NSObject
- (instancetype)initWithRegistrar:(NSObject <FlutterPluginRegistrar> *)registrar;

- (void)handleAutoDeductWithCall:(FlutterMethodCall *)call result:(FlutterResult)result;
@end

NS_ASSUME_NONNULL_END
