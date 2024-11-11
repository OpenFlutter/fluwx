//
// Created by mo on 2020/3/7.
//

#import <Foundation/Foundation.h>


@interface ThumbnailHelper : NSObject

+ (UIImage *)compressImage:(UIImage *)image toByte:(NSUInteger)maxLength isPNG:(BOOL)isPNG;

/// NSData 压缩后转NSData
/// @param imageData 来源data
/// @param maxLength 压缩目标值，压缩结果在maxLength的0.9~1之间
+ (NSData *)compressImageData:(NSData *)imageData toByte:(NSUInteger)maxLength;

@end
