//
// Created by mo on 2020/3/7.
//

#import "FluwxShareHandler.h"
#import "WXApiRequestHandler.h"
#import "FluwxStringUtil.h"
#import "NSStringWrapper.h"
#import "ThumbnailHelper.h"

@implementation FluwxShareHandler

NSString *const fluwxKeyTitle = @"title";
NSString *const fluwxKeyImage = @ "image";
NSString *const fluwxKeyImageData = @ "imageData";
NSString *const fluwxKeyThumbnail = @"thumbnail";
NSString *const fluwxKeyDescription = @"description";

NSString *const fluwxKeyPackage = @"?package=";

NSString *const fluwxKeyMessageExt = @"messageExt";
NSString *const fluwxKeyMediaTagName = @"mediaTagName ";
NSString *const fluwxKeyMessageAction = @"messageAction";

NSString *const fluwxKeyScene = @"scene";
NSString *const fluwxKeyTimeline = @"timeline";
NSString *const fluwxKeySession = @"session";
NSString *const fluwxKeyFavorite = @"favorite";

NSString *const keySource = @"source";
NSString *const keySuffix = @"suffix";

CGFloat thumbnailWidth;

NSUInteger defaultThumbnailSize = 32 * 1024;

NSObject <FlutterPluginRegistrar> *_fluwxRegistrar;

- (instancetype)initWithRegistrar:(NSObject <FlutterPluginRegistrar> *)registrar {
    self = [super init];
    if (self) {
        _fluwxRegistrar = registrar;
        thumbnailWidth = 150;
    }
    return self;
}

- (void)handleShare:(FlutterMethodCall *)call result:(FlutterResult)result {
    if ([@"shareText" isEqualToString:call.method]) {
        [self shareText:call result:result];
    } else if ([@"shareImage" isEqualToString:call.method]) {
        [self shareImage:call result:result];
    } else if ([@"shareWebPage" isEqualToString:call.method]) {
        [self shareWebPage:call result:result];
    } else if ([@"shareMusic" isEqualToString:call.method]) {
        [self shareMusic:call result:result];
    } else if ([@"shareVideo" isEqualToString:call.method]) {
        [self shareVideo:call result:result];
    } else if ([@"shareMiniProgram" isEqualToString:call.method]) {
        [self shareMiniProgram:call result:result];
    } else if ([@"shareFile" isEqualToString:call.method]) {
        [self shareFile:call result:result];
    }
}

- (void)shareText:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *text = call.arguments[@"source"];
    NSNumber *scene = call.arguments[fluwxKeyScene];
    [WXApiRequestHandler sendText:text InScene:[self intToWeChatScene:scene] completion:^(BOOL done) {
        result(@(done));
    }];
}

- (void)shareImage:(FlutterMethodCall *)call result:(FlutterResult)result {
    dispatch_queue_t globalQueue = dispatch_get_global_queue(0, 0);
    dispatch_async(globalQueue, ^{

        NSDictionary *sourceImage = call.arguments[keySource];
        NSData *sourceImageData = [self getNsDataFromWeChatFile:sourceImage];

        UIImage *thumbnailImage = [self getCommonThumbnail:call];
        UIImage *realThumbnailImage;
        if (thumbnailImage == nil) {
            NSString *suffix = sourceImage[@"suffix"];
            BOOL isPNG = [self isPNG:suffix];
            realThumbnailImage = [self getThumbnailFromNSData:sourceImageData size:defaultThumbnailSize isPNG:isPNG];
        } else {
            realThumbnailImage = thumbnailImage;
        }

        dispatch_async(dispatch_get_main_queue(), ^{

            NSNumber *scene = call.arguments[fluwxKeyScene];
            [WXApiRequestHandler sendImageData:sourceImageData
                                       TagName:call.arguments[fluwxKeyMediaTagName]
                                    MessageExt:call.arguments[fluwxKeyMessageExt]
                                        Action:call.arguments[fluwxKeyMessageAction]
                                    ThumbImage:realThumbnailImage
                                       InScene:[self intToWeChatScene:scene]
                                         title:call.arguments[fluwxKeyTitle]
                                   description:call.arguments[fluwxKeyDescription]
                                    completion:^(BOOL done) {
                                        result(@(done));
                                    }
            ];

        });

    });
}

- (void)shareWebPage:(FlutterMethodCall *)call result:(FlutterResult)result {

    dispatch_queue_t globalQueue = dispatch_get_global_queue(0, 0);
    dispatch_async(globalQueue, ^{

        UIImage *thumbnailImage = [self getCommonThumbnail:call];

        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *webPageUrl = call.arguments[@"webPage"];
            NSNumber *scene = call.arguments[fluwxKeyScene];

            [WXApiRequestHandler sendLinkURL:webPageUrl
                                     TagName:call.arguments[fluwxKeyMediaTagName]
                                       Title:call.arguments[fluwxKeyTitle]
                                 Description:call.arguments[fluwxKeyDescription]
                                  ThumbImage:thumbnailImage
                                  MessageExt:call.arguments[fluwxKeyMessageExt]
                               MessageAction:call.arguments[fluwxKeyMessageAction]
                                     InScene:[self intToWeChatScene:scene]
                                  completion:^(BOOL done) {
                                      result(@(done));
                                  }];
        });

    });
}

- (void)shareMusic:(FlutterMethodCall *)call result:(FlutterResult)result {
    dispatch_queue_t globalQueue = dispatch_get_global_queue(0, 0);
    dispatch_async(globalQueue, ^{

        UIImage *thumbnailImage = [self getCommonThumbnail:call];

        dispatch_async(dispatch_get_main_queue(), ^{

            NSNumber *scene = call.arguments[fluwxKeyScene];
            [WXApiRequestHandler sendMusicURL:call.arguments[@"musicUrl"]
                                      dataURL:call.arguments[@"musicDataUrl"]
                              MusicLowBandUrl:call.arguments[@"musicLowBandUrl"]
                          MusicLowBandDataUrl:call.arguments[@"musicLowBandDataUrl"]
                                        Title:call.arguments[fluwxKeyTitle]
                                  Description:call.arguments[fluwxKeyDescription]
                                   ThumbImage:thumbnailImage
                                   MessageExt:call.arguments[fluwxKeyMessageExt]
                                MessageAction:call.arguments[fluwxKeyMessageAction]
                                      TagName:call.arguments[fluwxKeyMediaTagName]
                                      InScene:[self intToWeChatScene:scene]
                                   completion:^(BOOL done) {
                                       result(@(done));
                                   }
            ];
        });
    });
}

- (void)shareVideo:(FlutterMethodCall *)call result:(FlutterResult)result {
    dispatch_queue_t globalQueue = dispatch_get_global_queue(0, 0);
    dispatch_async(globalQueue, ^{

        UIImage *thumbnailImage = [self getCommonThumbnail:call];

        dispatch_async(dispatch_get_main_queue(), ^{

            NSNumber *scene = call.arguments[fluwxKeyScene];

            [WXApiRequestHandler sendVideoURL:call.arguments[@"videoUrl"]
                              VideoLowBandUrl:call.arguments[@"videoLowBandUrl"]
                                        Title:call.arguments[fluwxKeyTitle]
                                  Description:call.arguments[fluwxKeyDescription]
                                   ThumbImage:thumbnailImage
                                   MessageExt:call.arguments[fluwxKeyMessageExt]
                                MessageAction:call.arguments[fluwxKeyMessageAction]
                                      TagName:call.arguments[fluwxKeyMediaTagName]
                                      InScene:[self intToWeChatScene:scene]
                                   completion:^(BOOL done) {
                                       result(@(done));
                                   }];
        });
    });
}

- (void)shareFile:(FlutterMethodCall *)call result:(FlutterResult)result {
    dispatch_queue_t globalQueue = dispatch_get_global_queue(0, 0);
    dispatch_async(globalQueue, ^{
        NSDictionary *sourceFile = call.arguments[keySource];
        UIImage *thumbnailImage = [self getCommonThumbnail:call];
        NSString *fileExtension;
        NSString *suffix = sourceFile[keySuffix];
        fileExtension = suffix;
        if ([suffix hasPrefix:@"."]) {
            NSRange range = NSMakeRange(0, 1);
            fileExtension = [suffix stringByReplacingCharactersInRange:range withString:@""];
        }

        NSData *data = [self getNsDataFromWeChatFile:sourceFile];

        dispatch_async(dispatch_get_main_queue(), ^{
            NSNumber *scene = call.arguments[fluwxKeyScene];
            [WXApiRequestHandler sendFileData:data
                                fileExtension:fileExtension
                                        Title:call.arguments[fluwxKeyTitle]
                                  Description:call.arguments[fluwxKeyDescription]
                                   ThumbImage:thumbnailImage
                                      InScene:[self intToWeChatScene:scene]
                                   completion:^(BOOL success) {
                                       result(@(success));
                                   }];
        });
    });
}

- (void)shareMiniProgram:(FlutterMethodCall *)call result:(FlutterResult)result {
    dispatch_queue_t globalQueue = dispatch_get_global_queue(0, 0);
    dispatch_async(globalQueue, ^{

        UIImage *thumbnailImage = [self getCommonThumbnail:call];

        NSData *hdImageData = nil;

        NSDictionary *hdImagePath = call.arguments[@"hdImagePath"];
        if (hdImagePath != (id) [NSNull null]) {
            NSData *imageData = [self getNsDataFromWeChatFile:hdImagePath];
            NSString *suffix = hdImagePath[@"suffix"];
            BOOL isPNG = [self isPNG:suffix];
            UIImage *uiImage = [self getThumbnailFromNSData:imageData size:120 * 1024 isPNG:isPNG];
            if (isPNG) {
                hdImageData = UIImagePNGRepresentation(uiImage);
            } else {
                hdImageData = UIImageJPEGRepresentation(uiImage, 1);
            }
        }

        dispatch_async(dispatch_get_main_queue(), ^{

            NSNumber *scene = call.arguments[fluwxKeyScene];

            NSNumber *typeInt = call.arguments[@"miniProgramType"];
            WXMiniProgramType miniProgramType = WXMiniProgramTypeRelease;
            if ([typeInt isEqualToNumber:@1]) {
                miniProgramType = WXMiniProgramTypeTest;
            } else if ([typeInt isEqualToNumber:@2]) {
                miniProgramType = WXMiniProgramTypePreview;
            }

            [WXApiRequestHandler sendMiniProgramWebpageUrl:call.arguments[@"webPageUrl"]
                                                  userName:call.arguments[@"userName"]
                                                      path:call.arguments[@"path"]
                                                     title:call.arguments[fluwxKeyTitle]
                                               Description:call.arguments[fluwxKeyDescription]
                                                ThumbImage:thumbnailImage
                                               hdImageData:hdImageData
                                           withShareTicket:[call.arguments[@"withShareTicket"] boolValue]
                                           miniProgramType:miniProgramType
                                                MessageExt:call.arguments[fluwxKeyMessageExt]
                                             MessageAction:call.arguments[fluwxKeyMessageAction]
                                                   TagName:call.arguments[fluwxKeyMediaTagName]
                                                   InScene:[self intToWeChatScene:scene]
                                                completion:^(BOOL done) {
                                                    result(@(done));
                                                }
            ];

        });

    });
}


- (UIImage *)getCommonThumbnail:(FlutterMethodCall *)call {
    NSDictionary *thumbnail = call.arguments[fluwxKeyThumbnail];
    if (thumbnail == nil || thumbnail == (id) [NSNull null]) {
        return nil;
    }

    NSString *suffix = thumbnail[@"suffix"];
    NSData *thumbnailData = [self getNsDataFromWeChatFile:thumbnail];
    UIImage *thumbnailImage = [self getThumbnailFromNSData:thumbnailData size:defaultThumbnailSize isPNG:[self isPNG:suffix]];
    return thumbnailImage;
}

//enum ImageSchema {
//    NETWORK,
//    ASSET,
//    FILE,
//    BINARY,
//}
- (NSData *)getNsDataFromWeChatFile:(NSDictionary *)weChatFile {
    NSNumber *schema = weChatFile[@"schema"];

    if ([schema isEqualToNumber:@0]) {
        NSString *source = weChatFile[keySource];
        NSURL *imageURL = [NSURL URLWithString:source];
        //下载图片
        return [NSData dataWithContentsOfURL:imageURL];
    } else if ([schema isEqualToNumber:@1]) {
        NSString *source = weChatFile[keySource];
        return [NSData dataWithContentsOfFile:[self readFileFromAssets:source]];
    } else if ([schema isEqualToNumber:@2]) {
        NSString *source = weChatFile[keySource];
        return [NSData dataWithContentsOfFile:source];
    } else if ([schema isEqualToNumber:@3]) {
        FlutterStandardTypedData *imageData = weChatFile[@"source"];
        return imageData.data;
    } else {
        return nil;
    }
}

- (UIImage *)getThumbnailFromNSData:(NSData *)data size:(NSUInteger)size isPNG:(BOOL)isPNG {
    UIImage *uiImage = [UIImage imageWithData:data];
    return [ThumbnailHelper compressImage:uiImage toByte:size isPNG:isPNG];
}

- (NSString *)readFileFromAssets:(NSString *)imagePath {
    NSArray *array = [self formatAssets:imagePath];
    NSString *key;
    if ([FluwxStringUtil isBlank:array[1]]) {
        key = [_fluwxRegistrar lookupKeyForAsset:array[0]];
    } else {
        key = [_fluwxRegistrar lookupKeyForAsset:array[0] fromPackage:array[1]];
    }

    return [[NSBundle mainBundle] pathForResource:key ofType:nil];
}

- (NSArray *)formatAssets:(NSString *)originPath {
    NSString *path = nil;
    NSString *packageName = @"";
    NSString *pathWithoutSchema = originPath;
    NSInteger indexOfPackage = [pathWithoutSchema lastIndexOfString:@"?package="];

    if (indexOfPackage != JavaNotFound) {
        path = [pathWithoutSchema substringFromIndex:0 toIndex:indexOfPackage];
        NSInteger begin = indexOfPackage + [fluwxKeyPackage length];
        packageName = [pathWithoutSchema substringFromIndex:begin toIndex:[pathWithoutSchema length]];
    } else {
        path = pathWithoutSchema;
    }

    return @[path, packageName];
}

- (BOOL)isPNG:(NSString *)suffix {
    return [@".png" equals:suffix];
}

- (enum WXScene)intToWeChatScene:(NSNumber *)value {
//    enum WeChatScene { SESSION, TIMELINE, FAVORITE }
    if (value == @0) {
        return WXSceneSession;
    } else if (value == @1) {
        return WXSceneTimeline;
    } else if (value == @2) {
        return WXSceneFavorite;
    } else {
        return WXSceneSession;
    }
}

@end
