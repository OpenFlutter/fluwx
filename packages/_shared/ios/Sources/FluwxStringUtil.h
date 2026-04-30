//
// Created by mo on 2020/3/7.
//

#import <Foundation/Foundation.h>


@interface FluwxStringUtil : NSObject
+ (BOOL)isBlank:(NSString *)string;

+ (NSString *)nilToEmpty:(NSString *)string;
@end