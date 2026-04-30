//
// Created by mo on 2020/3/8.
//


#import <Foundation/Foundation.h>

#define JavaNotFound -1

@interface NSString (Wrapper)

/**  Return the char value at the specified index. */
- (unichar)charAt:(int)index;

/**
 * Compares two strings lexicographically.
 * the value 0 if the argument string is equal to this string;
 * a value less than 0 if this string is lexicographically less than the string argument;
 * and a value greater than 0 if this string is lexicographically greater than the string argument.
 */
- (int)compareTo:(NSString *)anotherString;

- (int)compareToIgnoreCase:(NSString *)str;

- (BOOL)contains:(NSString *)str;

- (BOOL)startsWith:(NSString *)prefix;

- (BOOL)endsWith:(NSString *)suffix;

- (BOOL)equals:(NSString *)anotherString;

- (BOOL)equalsIgnoreCase:(NSString *)anotherString;

- (int)indexOfChar:(unichar)ch;

- (int)indexOfChar:(unichar)ch fromIndex:(int)index;

- (int)indexOfString:(NSString *)str;

- (int)indexOfString:(NSString *)str fromIndex:(int)index;

- (int)lastIndexOfChar:(unichar)ch;

- (int)lastIndexOfChar:(unichar)ch fromIndex:(int)index;

- (int)lastIndexOfString:(NSString *)str;

- (int)lastIndexOfString:(NSString *)str fromIndex:(int)index;

- (NSString *)substringFromIndex:(NSInteger)beginIndex
                         toIndex:(NSInteger)endIndex;

- (NSString *)toLowerCase;

- (NSString *)toUpperCase;

- (NSString *)trim;

- (NSString *)replaceAll:(NSString *)origin with:(NSString *)replacement;

- (NSArray *)split:(NSString *)separator;

@end
