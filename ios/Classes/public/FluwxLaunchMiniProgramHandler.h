#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>
#import "FluwxPlugin.h"


@class FluwxStringUtil;

@interface FluwxLaunchMiniProgramHandler : NSObject
- (instancetype)initWithRegistrar:(NSObject <FlutterPluginRegistrar> *)registrar;

- (void)handleLaunchMiniProgram:(FlutterMethodCall *)call result:(FlutterResult)result;
@end
