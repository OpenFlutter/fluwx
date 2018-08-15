//
// Created by mo on 2018/8/15.
//

#import "StringToWeChatScene.h"


@implementation StringToWeChatScene
+ (enum WXScene) toScene:(NSString *)string {

    if ([string caseInsensitiveCompare:@"SESSION"]) {
        return WXSceneSession;
    }
    if ([string caseInsensitiveCompare:@"FAVORITE"]) {
        return WXSceneFavorite;
    } else {
        return WXSceneTimeline;
    }
}

@end