//
//  NSString+CamelCase.m
//  JSONModelGenerator
//
//  Created by 陈圣治 on 16/4/22.
//  Copyright © 2016年 富德胜. All rights reserved.
//

#import "NSString+CamelCase.h"

@implementation NSString (CamelCase)

- (NSString *)littleCamelCase {
    NSString *converted = [self capitalizedString];
    converted = [converted stringByReplacingOccurrencesOfString:@"_" withString:@""];
    NSString *firstLetter = [[converted substringToIndex:1] lowercaseString];
    NSString *otherLetters = [converted substringFromIndex:1];
    return [firstLetter stringByAppendingString:otherLetters];
}

- (NSString *)bigCamelCase {
    return [[self capitalizedString] stringByReplacingOccurrencesOfString:@"_" withString:@""];
}

@end
