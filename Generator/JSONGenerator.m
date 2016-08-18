//
//  JSONGenerator.m
//  JSONModelGenerator
//
//  Created by 陈圣治 on 16/4/22.
//  Copyright © 2016年 富德胜. All rights reserved.
//

#import "JSONGenerator.h"
#import "NSString+ShortReplace.h"
#import "JSONCodeFile.h"

@implementation JSONGenerator

- (void)generateWithText:(NSString *)text parameter:(JSONGeneratorParameter *)parameter {
    NSError *error = nil;
    NSObject *json = [NSJSONSerialization JSONObjectWithData:[text dataUsingEncoding:NSUTF8StringEncoding]
                                                     options:0
                                                       error:&error];
    if (error) {
        NSLog(@"%@", error);
    } else {
        NSLog(@"%@", json);
    }

    JSONCodeFile *file = [[JSONCodeFile alloc] init];
    file.parameter = parameter;
    [file generateCodeFileWithJSON:json];
}

@end
