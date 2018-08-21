//
// Created by mo on 2018/8/21.
//

#import <Foundation/Foundation.h>


@interface ThumbnailHelper : NSObject
+ (UIImage *)compressImage:(UIImage *)image toByte:(NSUInteger)maxLength isPNG:(BOOL)isPNG;
@end