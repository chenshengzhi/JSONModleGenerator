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

- (void)generateWithParameter:(JSONGeneratorParameter *)parameter {
    parameter.json = [self JSONFromDescriptionText:parameter.json];
    
    JSONCodeFile *file = [[JSONCodeFile alloc] init];
    file.parameter = parameter;
    
    [file generateCodeFile];
}

- (id)JSONFromDescriptionText:(NSString *)description {
    description = [description replace:@"(" withString:@"["];
    description = [description replace:@")" withString:@"]"];
    description = [description replace:@" " withString:@""];
    
    NSArray<NSString *> *pairs = [description componentsSeparatedByString:@"\n"];
    NSMutableArray *newPairs = [NSMutableArray array];
    [pairs enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSRange equalSignRange = [obj rangeOfString:@"="];
        if (equalSignRange.location != NSNotFound) {
            NSString *key = [obj substringToIndex:equalSignRange.location];
            NSString *value = [obj substringFromIndex:NSMaxRange(equalSignRange)];

            if (![key hasPrefix:@"\""]) {
                key = [NSString stringWithFormat:@"\"%@\"", key];
            }

            if ([value isEqualToString:@"{"] || [value isEqualToString:@"["]) {
                [newPairs addObject:[NSString stringWithFormat:@"%@:%@", key, value]];
            } else {
                NSString *convertedLine = [NSString stringWithFormat:@"%@:1%@", key, (idx < pairs.count-1 ? @"," : @"")];
                [newPairs addObject:convertedLine];
            }
        } else {
            [newPairs addObject:obj];
        }
    }];
    NSString *JSONString = [newPairs componentsJoinedByString:@""];
    JSONString = [JSONString replace:@";" withString:@","];
    JSONString = [JSONString replace:@",}" withString:@"}"];
    NSLog(@"%@", JSONString);
    
    NSError *error = nil;
    NSObject *json = [NSJSONSerialization JSONObjectWithData:[JSONString dataUsingEncoding:NSUTF8StringEncoding]
                                                     options:0
                                                       error:&error];
    if (error) {
        NSLog(@"%@", error);
    } else {
        NSLog(@"%@", json);
    }
    return json;
}

@end
