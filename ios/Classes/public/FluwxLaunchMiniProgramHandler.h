#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>
#import "FluwxPlugin.h"


@class StringUtil;

@interface FluwxLaunchMiniProgramHandler : NSObject
- (instancetype)initWithRegistrar:(NSObject <FlutterPluginRegistrar> *)registrar;

- (void)handleLaunchMiniProgram:(FlutterMethodCall *)call result:(FlutterResult)result;
@end
