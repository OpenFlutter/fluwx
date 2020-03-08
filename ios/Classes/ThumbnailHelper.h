//
// Created by mo on 2020/3/7.
//

#import <Foundation/Foundation.h>


@interface ThumbnailHelper : NSObject
+ (UIImage *)compressImage:(UIImage *)image toByte:(NSUInteger)maxLength isPNG:(BOOL)isPNG;
@end