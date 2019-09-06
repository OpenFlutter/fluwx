//
// Created by mo on 2018/8/15.
//

#import "StringToWeChatScene.h"


@implementation StringToWeChatScene
+ (enum WXScene)toScene:(NSString *)string {

    if ([string isEqualToString:@"WeChatScene.TIMELINE"]) {
        return WXSceneTimeline;
    } else if ([string isEqualToString:@"WeChatScene.FAVORITE"]) {
        return WXSceneFavorite;
    } else {
        return WXSceneSession;
    }
}

@end
