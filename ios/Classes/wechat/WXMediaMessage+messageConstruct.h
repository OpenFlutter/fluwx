//
//  WXMediaMessage+messageConstruct.h
//  SDKSample
//
//  Created by Jeason on 15/7/14.
//
//

#import "WXApiObject.h"

@interface WXMediaMessage (messageConstruct)

+ (WXMediaMessage *)messageWithTitle:(NSString *)title
                         Description:(NSString *)description
                              Object:(id)mediaObject
                          MessageExt:(NSString *)messageExt
                       MessageAction:(NSString *)action
                          ThumbImage:(UIImage *)thumbImage
                            MediaTag:(NSString *)tagName;
@end
