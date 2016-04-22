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
        NSArray *components = [obj componentsSeparatedByString:@"="];
        if (components.count == 2) {
            NSString *key = components[0];
            if (![key hasPrefix:@"\""]) {
                key = [NSString stringWithFormat:@"\"%@\"", key];
            }
            NSString *value = [components[1] replace:@";" withString:@""];
            if (![value hasPrefix:@"\""] && ![value isEqualToString:@"{"] && ![value isEqualToString:@"["]) {
                value = [NSString stringWithFormat:@"\"%@\"", value];
            }
            NSString *convertedLine = [NSString stringWithFormat:@"%@:%@%@", key, value, ([components[1] hasSuffix:@";"] ? @"," : @"")];
            [newPairs addObject:convertedLine];
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
