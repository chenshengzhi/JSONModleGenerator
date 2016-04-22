//
//  NSString+Regex.h
//  JSONModelGenerator
//
//  Created by 陈圣治 on 16/4/22.
//  Copyright © 2016年 富德胜. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Regex)

- (BOOL)matchRegex:(NSString *)regex;

- (BOOL)isFloat;

- (BOOL)isInt;

@end
