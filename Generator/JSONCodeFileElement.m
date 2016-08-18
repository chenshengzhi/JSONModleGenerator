//
//  JSONCodeFileElement.m
//  JSONModelGenerator
//
//  Created by 陈圣治 on 16/4/22.
//  Copyright © 2016年 富德胜. All rights reserved.
//

#import "JSONCodeFileElement.h"
#import "NSString+BundleFileContent.h"
#import "NSString+ShortReplace.h"

@implementation JSONCodeFileElement

- (NSString *)interfaceCode {
    NSString *interfaceFormart = [@"interface.txt" bundleFileContent];
    return [NSString stringWithFormat:interfaceFormart, self.className, self.superClassName, self.propertys];
}

- (NSString *)implementationCode {
    NSString *implementationBody = @"";
    if (self.classInArray.allKeys.count > 0) {
        implementationBody = [implementationBody stringByAppendingString:@"\n"];

        NSString *classInArrayFormart = [@"classInArray.txt" bundleFileContent];
        NSMutableArray *snippets = [NSMutableArray array];
        [self.classInArray enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            NSString *snippet = [NSString stringWithFormat:@"@\"%@\" : [%@ class]", key, obj];
            [snippets addObject:snippet];
        }];
        NSString *text = [NSString stringWithFormat:classInArrayFormart, [snippets componentsJoinedByString:@",\n             "]];
        implementationBody = [implementationBody stringByAppendingFormat:@"%@\n", text];
    }

    if (self.keyMapping.allKeys.count > 0) {
        implementationBody = [implementationBody stringByAppendingString:@"\n"];

        NSString *keyMappingFormart = [@"keyMapping.txt" bundleFileContent];
        NSMutableArray *snippets = [NSMutableArray array];
        [self.keyMapping enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            NSString *snippet = [NSString stringWithFormat:@"@\"%@\" : @\"%@\"", key, obj];
            [snippets addObject:snippet];
        }];
        NSString *text = [NSString stringWithFormat:keyMappingFormart, [snippets componentsJoinedByString:@",\n             "]];
        implementationBody = [implementationBody stringByAppendingString:text];
    }

    if (implementationBody.length > 0) {
        implementationBody = [implementationBody stringByAppendingString:@"\n"];
    }

    NSString *implementationFormart = [@"implementation.txt" bundleFileContent];

    if (implementationBody.length > 0) {
        return [NSString stringWithFormat:implementationFormart, self.className, implementationBody];
    } else {
        return [NSString stringWithFormat:implementationFormart, self.className, @""];
    }
}

@end
