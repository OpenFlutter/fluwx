//
// Created by mo on 2018/8/15.
//

#import <Foundation/Foundation.h>


@interface StringUtil : NSObject
+ (BOOL) isBlank:(NSString *)string;
+ (NSString *) nilToEmpty:(NSString *) string;
@end