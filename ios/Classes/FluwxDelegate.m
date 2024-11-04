//
//  FluwxDelegate.m
//  fluwx
//
//  Created by Mo on 2022/3/6.
//

#import <Foundation/Foundation.h>
#import <fluwx/FluwxDelegate.h>
#import <WXApi.h>

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
    [WXApi registerApp:appId universalLink:universalLink];
}

@end
