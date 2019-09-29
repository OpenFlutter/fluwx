//
//  FluwxSubscribeMsgHandler.m
//  fluwx
//
//  Created by cjl on 2018/12/19.
//

#import "FluwxSubscribeMsgHandler.h"
#import <WXApiRequestHandler.h>

@implementation FluwxSubscribeMsgHandler {
    NSObject <FlutterPluginRegistrar> *_fluwxRegistrar;
}
- (instancetype)initWithRegistrar:(NSObject <FlutterPluginRegistrar> *)registrar {
    self = [super init];
    if (self) {
        _fluwxRegistrar = registrar;
    }
    return self;
}

- (void)handleSubscribeWithCall:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSDictionary *params = call.arguments;
    NSString *appId = [params valueForKey:@"appId"];
    int scene = [[params valueForKey:@"scene"] intValue];
    NSString *templateId = [params valueForKey:@"templateId"];
    NSString *reserved = [params valueForKey:@"reserved"];

    WXSubscribeMsgReq *req = [WXSubscribeMsgReq new];
    req.scene = (UInt32) scene;
    req.templateId = templateId;
    req.reserved = reserved;
    req.openID = appId;

    [WXApi sendReq:req completion:^(BOOL done) {result(@(done));}];

   
}


@end
