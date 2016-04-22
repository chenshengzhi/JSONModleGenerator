//
//  NSString+BundleFileContent.m
//  JSONModelGenerator
//
//  Created by 陈圣治 on 16/4/22.
//  Copyright © 2016年 富德胜. All rights reserved.
//

#import "NSString+BundleFileContent.h"

@implementation NSString (BundleFileContent)

- (NSString *)bundleFileContent {
    NSString *path = [[NSBundle mainBundle] pathForResource:self ofType:nil];
    return [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
}

@end
