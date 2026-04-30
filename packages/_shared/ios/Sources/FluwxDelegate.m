//
//  FluwxDelegate.m
//  fluwx
//
//  Created by Mo on 2022/3/6.
//

#import <Foundation/Foundation.h>
#import "FluwxDelegate.h"
#ifdef FLUWX_WITH_PAY
#import <WechatOpenSDK/WXApi.h>
#endif

@implementation FluwxDelegate

+ (instancetype)defaultManager {
    static dispatch_once_t onceToken;
    static FluwxDelegate *instance;
    dispatch_once(&onceToken, ^{
        instance = [[FluwxDelegate alloc] init];
    });
    return instance;
}

- (void)registerWxAPI:(NSString *)appId universalLink:(NSString *)universalLink {
#ifdef FLUWX_WITH_PAY
    [WXApi registerApp:appId universalLink:universalLink];
#endif
}

@end
