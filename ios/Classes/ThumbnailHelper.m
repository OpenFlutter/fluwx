//
// Created by mo on 2020/3/7.
//

#import "ThumbnailHelper.h"


@implementation ThumbnailHelper

+ (NSData *)compressImageData:(NSData *)imageData toByte:(NSUInteger)maxLength {
    // Compress by quality
    CGFloat compression = 1;
    NSData *data = imageData;
    NSLog(@"压缩前 %lu %lu", (unsigned long)data.length,maxLength);
    if (data.length < maxLength) return data;
    
    UIImage *image = [UIImage imageWithData:imageData];
    CGFloat max = 1;
    CGFloat min = 0;
    for (int i = 0; i < 6; ++i) {
        compression = (max + min) / 2;
        data = UIImageJPEGRepresentation(image, compression);
        if (data.length < maxLength * 0.9) {
            min = compression;
        } else if (data.length > maxLength) {
            max = compression;
        } else {
            break;
        }
    }
    
    NSLog(@"压缩第一次 %lu %lu", (unsigned long)data.length,maxLength);
    if (data.length < maxLength) return data;
    
    UIImage *resultImage;
    
    resultImage = [UIImage imageWithData:data];
    
    // Compress by size
    NSUInteger lastDataLength = 0;
    while (data.length > maxLength && data.length != lastDataLength) {
        lastDataLength = data.length;
        CGFloat ratio = (CGFloat) maxLength / data.length;
        CGSize size = CGSizeMake((NSUInteger) (resultImage.size.width * sqrtf(ratio)),
                                 (NSUInteger) (resultImage.size.height * sqrtf(ratio))); // Use NSUInteger to prevent white blank
        UIGraphicsBeginImageContext(size);
        [resultImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
        resultImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        data = UIImageJPEGRepresentation(resultImage, compression);
    }
    
    NSLog(@"压缩第二次 %lu %lu", (unsigned long)data.length,maxLength);
    return data;
}

+ (UIImage *)compressImage:(UIImage *)image toByte:(NSUInteger)maxLength isPNG:(BOOL)isPNG {
    // Compress by quality
    CGFloat compression = 1;
    NSData *data = UIImageJPEGRepresentation(image, compression);
    if (data.length < maxLength) return image;
    
    CGFloat max = 1;
    CGFloat min = 0;
    for (int i = 0; i < 6; ++i) {
        compression = (max + min) / 2;
        data = UIImageJPEGRepresentation(image, compression);
        if (data.length < maxLength * 0.9) {
            min = compression;
        } else if (data.length > maxLength) {
            max = compression;
        } else {
            break;
        }
    }
    
    UIImage *resultImage;
    if (isPNG) {
        NSData *tmp = UIImagePNGRepresentation([UIImage imageWithData:data]);
        resultImage = [UIImage imageWithData:tmp];
    } else {
        resultImage = [UIImage imageWithData:data];
    }
    
    
    if (data.length < maxLength) return resultImage;
    
    // Compress by size
    NSUInteger lastDataLength = 0;
    while (data.length > maxLength && data.length != lastDataLength) {
        lastDataLength = data.length;
        CGFloat ratio = (CGFloat) maxLength / data.length;
        CGSize size = CGSizeMake((NSUInteger) (resultImage.size.width * sqrtf(ratio)),
                                 (NSUInteger) (resultImage.size.height * sqrtf(ratio))); // Use NSUInteger to prevent white blank
        UIGraphicsBeginImageContext(size);
        [resultImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
        resultImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        data = UIImageJPEGRepresentation(resultImage, compression);
    }
    
    return resultImage;
}


- (UIImage *)scaleFromImage:(UIImage *)image width:(CGSize)newSize {
    CGSize imageSize = image.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    
    if (width <= newSize.width && height <= newSize.height) {
        return image;
    }
    
    if (width == 0 || height == 0) {
        return image;
    }
    
    CGFloat widthFactor = newSize.width / width;
    CGFloat heightFactor = newSize.height / height;
    CGFloat scaleFactor = (widthFactor < heightFactor ? widthFactor : heightFactor);
    
    CGFloat scaledWidth = width * scaleFactor;
    CGFloat scaledHeight = height * scaleFactor;
    CGSize targetSize = CGSizeMake(scaledWidth, scaledHeight);
    
    UIGraphicsBeginImageContext(targetSize);
    [image drawInRect:CGRectMake(0, 0, scaledWidth, scaledHeight)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end
