//
//  FluwxDelegate.h
//  Pods
//
//  Created by Mo on 2022/3/6.
//
#import <Foundation/Foundation.h>

@interface FluwxDelegate : NSObject

@property (strong,nonatomic)NSString *extMsg;

@property (strong,nonatomic)NSString *extData;

+ (instancetype)defaultManager;

- (void)registerWxAPI:(NSString *)appId universalLink:(NSString *)universalLink;
@end
