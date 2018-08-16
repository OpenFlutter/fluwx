//
// Created by mo on 2018/8/16.
//

#import "FlutterAssetHelper.h"


@implementation FlutterAssetHelper

+ (NSString *)getPackageName:(NSString *)assetPath {

    NSUInteger length = SCHEMA_ASSETS.length;

    return @"";
}

+ (NSString *)getPath:(NSString *)assetPath {

    NSUInteger schemaLength = SCHEMA_ASSETS.length;
    NSUInteger totalLength = assetPath.length;

    NSRange range = NSMakeRange(schemaLength, totalLength-schemaLength);
    NSString *result = [assetPath substringWithRange:range];


    if ([result rangeOfString:fluwxKeyPackage].location != NSNotFound) {
       result = [result stringByReplacingCharactersInRange:<#(NSRange)range#> withString:<#(NSString *)replacement#>]
    }




    return result;
}




@end