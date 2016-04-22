//
//  NSString+ShortReplace.m
//  JSONModelGenerator
//
//  Created by 陈圣治 on 16/4/22.
//  Copyright © 2016年 富德胜. All rights reserved.
//

#import "NSString+ShortReplace.h"

@implementation NSString (ShortReplace)

- (NSString *)replace:(NSString *)from withString:(NSString *)to {
    return [self stringByReplacingOccurrencesOfString:from withString:to];
}

@end
