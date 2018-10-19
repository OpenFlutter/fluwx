#import "FluwxLaunchMiniProgramHandler.h"
#import "CallResults.h"
#import "FluwxKeys.h"
#import "StringToWeChatScene.h"
#import "FluwxMethods.h"
#import "ThumbnailHelper.h"
#import "NSStringWrapper.h"

@implementation FluwxLaunchMiniProgramHandler

- (instancetype)initWithRegistrar:(NSObject <FlutterPluginRegistrar> *)registrar {
    self = [super init];
//    if (self) {
//
//    }

    return self;
}

- (void)handleLaunchMiniProgram:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *userName = call.arguments[@"userName"];
    NSString *path = call.arguments[@"path"];
    WXMiniProgramType *miniProgramType = (call.arguments[@"miniProgramType"]

    [WXApiRequestHandler launchMiniProgramWithUserName:userName
                                        path:path
                                        type:miniProgramType;
}
@end
