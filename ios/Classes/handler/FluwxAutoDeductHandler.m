//
//  FluwxAutoDeductHandler.m
//  fluwx
//
//  Created by realm on 2019/5/22.
//

#import "FluwxAutoDeductHandler.h"
#import <WXApiRequestHandler.h>

@implementation FluwxAutoDeductHandler {
    NSObject <FlutterPluginRegistrar> *_registrar;
}
- (instancetype)initWithRegistrar:(NSObject <FlutterPluginRegistrar> *)registrar {
    self = [super init];
    if (self) {
        _registrar = registrar;
    }
    return self;
}

- (void)handleAutoDeductWithCall:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSDictionary *params = call.arguments;
    NSMutableDictionary *paramsFromDart = [NSMutableDictionary dictionaryWithDictionary:call.arguments];
    [paramsFromDart removeObjectForKey:@"businessType"];
    WXOpenBusinessWebViewReq *req = [[WXOpenBusinessWebViewReq alloc] init];
    NSNumber *businessType = call.arguments[@"businessType"];
    req.businessType = [businessType unsignedIntValue];
    req.queryInfoDic = paramsFromDart;
    BOOL b = [WXApi sendReq:req];

    result(@(b));
}

- (NSString *)convertToJsonData:(NSDictionary *)dict {
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString;

    if (!jsonData) {
        NSLog(@"%@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }

    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    //    NSRange range = {0,jsonString.length};
    //    //去掉字符串中的空格
    //    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    NSRange range2 = {0, mutStr.length};
    //去掉字符串中的换行符
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];

    return mutStr;
}

@end
