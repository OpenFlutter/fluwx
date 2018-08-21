//
// Created by mo on 2018/8/16.
//


#import "FluwxShareHandler.h"
#import "ImageSchema.h"
#import "StringUtil.h"


@implementation FluwxShareHandler

CGFloat thumbnailWidth;

NSObject <FlutterPluginRegistrar> *_registrar;


- (instancetype)initWithRegistrar:(NSObject <FlutterPluginRegistrar> *)registrar {
    self = [super init];
    if (self) {
        _registrar = registrar;
        thumbnailWidth = 150;
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
        [self shareAssetImage:call result:result imagePath:imagePath];
    } else if ([imagePath hasPrefix:SCHEMA_FILE]) {

    } else {
        [self shareNetworkImage:call result:result imagePath:imagePath];
    }


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


        UIImage *thumbnailImage = [self getThumbnail:thumbnail size:32 * 1024];



        dispatch_async(dispatch_get_main_queue(), ^{

            NSString *scene = call.arguments[fluwxKeyScene];
            BOOL done = [WXApiRequestHandler sendImageData:imageData
                                                   TagName:call.arguments[fluwxKeyMediaTagName]
                                                MessageExt:fluwxKeyMessageExt
                                                    Action:fluwxKeyMessageAction
                                                ThumbImage:thumbnailImage
                                                   InScene:[StringToWeChatScene toScene:scene]];
            result(@{fluwxKeyPlatform:fluwxKeyIOS,fluwxKeyResult:@(done)});

        });

    });

}



- (void)shareAssetImage:(FlutterMethodCall *)call result:(FlutterResult)result imagePath:(NSString *)imagePath {


    NSString *thumbnail = call.arguments[fluwxKeyThumbnail];

    if ([StringUtil isBlank:thumbnail]) {
        thumbnail = imagePath;
    }


    dispatch_queue_t globalQueue = dispatch_get_global_queue(0, 0);
    dispatch_async(globalQueue, ^{

        NSData *imageData =  [NSData dataWithContentsOfFile:[self readImageFromAssets:imagePath]];

        UIImage *thumbnailImage = [self getThumbnail:thumbnail size:32 * 1024];

        dispatch_async(dispatch_get_main_queue(), ^{

            NSString *scene = call.arguments[fluwxKeyScene];
            BOOL done = [WXApiRequestHandler sendImageData:imageData
                                                   TagName:call.arguments[fluwxKeyMediaTagName]
                                                MessageExt:fluwxKeyMessageExt
                                                    Action:fluwxKeyMessageAction
                                                ThumbImage:thumbnailImage
                                                   InScene:[StringToWeChatScene toScene:scene]];
            result(@{fluwxKeyPlatform:fluwxKeyIOS,fluwxKeyResult:@(done)});

        });

    });

}



- (void)shareWebPage:(FlutterMethodCall *)call result:(FlutterResult)result {

    dispatch_queue_t globalQueue = dispatch_get_global_queue(1, 1);
    dispatch_async(globalQueue, ^{

        NSString *thumbnail = call.arguments[fluwxKeyThumbnail];

        UIImage *thumbnailImage =[self getThumbnail:thumbnail size:32 * 1024];

        NSData *imageData =  [NSData dataWithContentsOfFile:[self readImageFromAssets:@""]];


        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *webPageUrl = call.arguments[@"webPage"];
            NSString *scene = call.arguments[fluwxKeyScene];
            BOOL done = [WXApiRequestHandler sendImageData:imageData
                                                   TagName:call.arguments[fluwxKeyMediaTagName]
                                                MessageExt:fluwxKeyMessageExt
                                                    Action:fluwxKeyMessageAction
                                                ThumbImage:thumbnailImage
                                                   InScene:[StringToWeChatScene toScene:scene]];
            result(@{fluwxKeyPlatform:fluwxKeyIOS,fluwxKeyResult:@(done)});

        });

    });






    NSString *imagePath = call.arguments[fluwxKeyImage];


    NSString *text = call.arguments[fluwxKeyText];
    NSString *scene = call.arguments[fluwxKeyScene];
    BOOL done = [WXApiRequestHandler sendText:text InScene:[StringToWeChatScene toScene:scene]];
    result(@(done));
}





- (UIImage *) getThumbnail:(NSString *) thumbnail size:(NSUInteger) size{


    UIImage *thumbnailImage = nil;

    if ([StringUtil isBlank:thumbnail]) {
        return nil;
    }


    if ([thumbnail hasPrefix:SCHEMA_ASSETS]) {
        NSData *imageData2 = [NSData dataWithContentsOfFile:[self readImageFromAssets:thumbnail]];
        UIImage *tmp = [UIImage imageWithData:imageData2];
        thumbnailImage = [ThumbnailHelper compressImage:tmp toByte:size isPNG:FALSE];

    } else if ([thumbnail hasPrefix:SCHEMA_FILE]) {

    } else {
        NSURL *thumbnailURL = [NSURL URLWithString:thumbnail];
        NSData *thumbnailData = [NSData dataWithContentsOfURL:thumbnailURL];

        UIImage *tmp = [UIImage imageWithData:thumbnailData];
        thumbnailImage = [ThumbnailHelper compressImage:tmp toByte:size isPNG:FALSE];

    }


    return  thumbnailImage;

}

- (NSString *) readImageFromAssets:(NSString *) imagePath{
    NSArray *array = [self formatAssets:imagePath];
    NSString* key ;
    if(array[1] == nil){
       key = [_registrar lookupKeyForAsset:array[0]];
    } else{
        key = [_registrar lookupKeyForAsset:array[0] fromPackage:array[1]];
    }

    return  [[NSBundle mainBundle] pathForResource:key ofType:nil];

}



-(NSArray *) formatAssets:(NSString *) originPath{
    NSString *path = nil;
    NSString *packageName = nil;
    int from = [SCHEMA_ASSETS length];
    int to = [originPath length];
    NSString *pathWithoutSchema = [originPath substringFromIndex:from toIndex:to];
    int indexOfPackage = [pathWithoutSchema lastIndexOfString:fluwxKeyPackage];

    if( indexOfPackage != JavaNotFound){
        path = [pathWithoutSchema substringFromIndex:0 toIndex:indexOfPackage];
        int begin = indexOfPackage + [fluwxKeyPackage length];
        packageName = [pathWithoutSchema substringFromIndex:begin toIndex:[pathWithoutSchema length]];
    } else{
        path = pathWithoutSchema;
    }

    return @[path, packageName];
}


@end