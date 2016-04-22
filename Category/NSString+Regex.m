//
//  NSString+Regex.m
//  JSONModelGenerator
//
//  Created by 陈圣治 on 16/4/22.
//  Copyright © 2016年 富德胜. All rights reserved.
//

#import "NSString+Regex.h"

@implementation NSString (Regex)

- (BOOL)matchRegex:(NSString *)regex {
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [pre evaluateWithObject:self];
}

- (BOOL)isFloat {
    return [self matchRegex:@"^\\d+\\.\\d+$"];
}

- (BOOL)isInt {
    return [self matchRegex:@"^\\d+$"];
}

@end
