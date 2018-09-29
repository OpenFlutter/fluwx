//
// Created by mo on 2018/8/15.
//

#import <Foundation/Foundation.h>
#import <OpenWeChatSDK/WXApiObject.h>

@interface StringToWeChatScene : NSObject
+ (enum WXScene) toScene : (NSString *) string;
@end