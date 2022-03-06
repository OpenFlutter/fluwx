//
//  FluwxDelegate.m
//  fluwx
//
//  Created by Mo on 2022/3/6.
//

#import <Foundation/Foundation.h>
#import "FluwxDelegate.h"
#import "WXApi.h"

@implementation FluwxDelegate

- (void) registerWxAPI:(NSString *)appId universalLink:(NSString *)universalLink {
    [WXApi registerApp:appId universalLink:universalLink];
}
@end
