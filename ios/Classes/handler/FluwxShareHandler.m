//
// Created by mo on 2018/8/16.
//


#import "FluwxShareHandler.h"
#import "ImageSchema.h"
#import "StringUtil.h"


@implementation FluwxShareHandler
NSObject <FlutterPluginRegistrar> *_registrar;


- (instancetype)initWithRegistrar:(NSObject <FlutterPluginRegistrar> *)registrar {
    self = [super init];
    if (self) {
        _registrar = registrar;
    }

    return self;
}


- (void)handleShare:(FlutterMethodCall *)call result:(FlutterResult)result {
    if (!isWeChatRegistered) {
        result([FlutterError errorWithCode:resultErrorNeedWeChat message:resultMessageNeedWeChat details:nil]);
        return;
    }

    if (![WXApi isWXAppInstalled]) {
        result([FlutterError errorWithCode:@"wechat not installed" message:@"wechat not installed" details:nil]);
        return;
    }

    if ([shareText isEqualToString:call.method]) {
        [self shareText:call result:result];
    } else if ([shareImage isEqualToString:call.method]) {
        [self shareImage:call result:result];
    } else if ([shareWebPage isEqualToString:call.method]) {
        [self shareWebPage:call result:result];
    }


}

- (void)shareText:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *text = call.arguments[fluwxKeyText];
    NSString *scene = call.arguments[fluwxKeyScene];
    BOOL done = [WXApiRequestHandler sendText:text InScene:[StringToWeChatScene toScene:scene]];
    result(@(done));
}


- (void)shareImage:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *imagePath = call.arguments[fluwxKeyImage];
    if ([imagePath hasPrefix:SCHEMA_ASSETS]) {

    } else if ([imagePath hasPrefix:SCHEMA_FILE]) {

    } else {
        [self shareNetworkImage:call result:result imagePath:imagePath];
    }

    NSString *text = call.arguments[fluwxKeyText];
    NSString *scene = call.arguments[fluwxKeyScene];
    BOOL done = [WXApiRequestHandler sendText:text InScene:[StringToWeChatScene toScene:scene]];
    result(@(done));
}


- (void)shareNetworkImage:(FlutterMethodCall *)call result:(FlutterResult)result imagePath:(NSString *)imagePath {


    NSString *thumbnail = call.arguments[fluwxKeyThumbnail];

    if ([StringUtil isBlank:thumbnail]) {
        thumbnail = imagePath;
    }


    dispatch_queue_t globalQueue = dispatch_get_global_queue(0, 0);
    dispatch_async(globalQueue, ^{

        NSURL *imageURL = [NSURL URLWithString:imagePath];
        //下载图片
        NSData *imageData = [NSData dataWithContentsOfURL:imageURL];


        NSData *thumbnailData;
        UIImage *thumbnailImage;

        if ([thumbnail hasPrefix:SCHEMA_ASSETS]) {

        } else if ([thumbnail hasPrefix:SCHEMA_FILE]) {

        } else {
            NSURL *thumbnailURL = [NSURL URLWithString:thumbnail];
            thumbnailData = [NSData dataWithContentsOfURL:thumbnailURL];
            if ([thumbnailData length] > (32 * 1024)) {

            } else {
                thumbnailImage = [UIImage imageWithData:thumbnailData];
            }
        }


        dispatch_async(dispatch_get_main_queue(), ^{

            NSString *scene = call.arguments[fluwxKeyScene];
            BOOL done = [WXApiRequestHandler sendImageData:imageData
                                                   TagName:call.arguments[fluwxKeyMediaTagName]
                                                MessageExt:fluwxKeyMessageExt
                                                    Action:fluwxKeyMessageAction
                                                ThumbImage:thumbnailImage
                                                   InScene:[StringToWeChatScene toScene:scene]];
            result(@(done));

        });

    });


}


- (void)shareWebPage:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *webPageUrl = call.arguments[@"webPage"];
   

    NSString *imagePath = call.arguments[fluwxKeyImage];
    if ([imagePath hasPrefix:SCHEMA_ASSETS]) {

    } else if ([imagePath hasPrefix:SCHEMA_FILE]) {

    } else {
        [self shareNetworkImage:call result:result imagePath:imagePath];
    }

    NSString *text = call.arguments[fluwxKeyText];
    NSString *scene = call.arguments[fluwxKeyScene];
    BOOL done = [WXApiRequestHandler sendText:text InScene:[StringToWeChatScene toScene:scene]];
    result(@(done));
}


+ (UIImage *)compressImage:(UIImage *)image toByte:(NSUInteger)maxLength {
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
    UIImage *resultImage = [UIImage imageWithData:data];
    if (data.length < maxLength) return resultImage;

    // Compress by size
    NSUInteger lastDataLength = 0;
    while (data.length > maxLength && data.length != lastDataLength) {
        lastDataLength = data.length;
        CGFloat ratio = (CGFloat)maxLength / data.length;
        CGSize size = CGSizeMake((NSUInteger)(resultImage.size.width * sqrtf(ratio)),
                                 (NSUInteger)(resultImage.size.height * sqrtf(ratio))); // Use NSUInteger to prevent white blank
        UIGraphicsBeginImageContext(size);
        [resultImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
        resultImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        data = UIImageJPEGRepresentation(resultImage, compression);
    }

    return resultImage;
}


@end