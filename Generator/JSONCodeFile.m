//
//  JSONCodeFile.m
//  JSONModelGenerator
//
//  Created by 陈圣治 on 16/4/22.
//  Copyright © 2016年 富德胜. All rights reserved.
//

#import "JSONCodeFile.h"
#import "NSString+Regex.h"
#import "NSString+Trims.h"
#import "JSONCodeFileElement.h"
#import "NSString+CamelCase.h"
#import "NSString+BundleFileContent.h"
#import "NSString+Trims.h"

#define isDictionary(obj) [obj isKindOfClass:[NSDictionary class]]
#define isArray(obj) [obj isKindOfClass:[NSArray class]]

@interface JSONCodeFile ()

@property (nonatomic, strong) NSMutableArray *classArray;

@end

@implementation JSONCodeFile

- (instancetype)init {
    if (self = [super init]) {
        self.classArray = [NSMutableArray array];
    }
    return self;
}

- (void)parse {
    if (isDictionary(self.parameter.json)) {
        [self parseDictionaryElementWithClassName:self.parameter.fileName subJSON:self.parameter.json];
    } else if (isArray(self.parameter.json)) {
        [self parseArrayElementWithClassName:self.parameter.fileName subJSON:self.parameter.json];
    } else {
        NSAssert(NO, @"not support this model");
    }
}

- (BOOL)parseArrayElementWithClassName:(NSString *)className subJSON:(NSArray *)subJson {
    if (isDictionary(subJson.firstObject)) {
        NSDictionary *dict = subJson.firstObject;
        return [self parseDictionaryElementWithClassName:className subJSON:dict];
    } else if (isArray(subJson.firstObject)) {
        NSAssert(NO, @"do not support this model");
    }
    return NO;
}

- (BOOL)parseDictionaryElementWithClassName:(NSString *)className subJSON:(NSDictionary *)subJson {
    NSMutableString *propertys = [NSMutableString string];
    NSMutableDictionary *classInArray = [NSMutableDictionary dictionary];
    NSMutableDictionary *keyMapping = [NSMutableDictionary dictionary];
    
    [subJson enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        NSString *modelKey = key;
        if ([modelKey containsString:@"_"]) {
            modelKey = [modelKey littleCamelCase];
            keyMapping[modelKey] = key;
        } else if ([modelKey isEqualToString:@"id"]) {
            modelKey = @"ID";
            keyMapping[modelKey]  = key;
        }
        
        if (isDictionary(obj)) {
            NSString *newClassName = [className stringByAppendingString:[modelKey capitalizedString]];
            [self parseDictionaryElementWithClassName:newClassName subJSON:obj];
            [propertys appendFormat:@"@property (nonatomic, strong) %@ *%@;\n\n", newClassName, modelKey];
        } else if (isArray(obj)) {
            NSString *newClassName = [className stringByAppendingString:[modelKey capitalizedString]];
            if ([self parseArrayElementWithClassName:newClassName subJSON:obj]) {
                [propertys appendString:[NSString stringWithFormat:@"@property (nonatomic, strong) NSArray *%@;\n\n", modelKey]];
                classInArray[modelKey] = newClassName;
            }
        } else {
            [propertys appendFormat:@"@property (nonatomic, strong) NSString *%@;\n\n", modelKey];
        }
    }];
    
    JSONCodeFileElement *element = [[JSONCodeFileElement alloc] init];
    element.className = className;
    element.superClassName = self.parameter.superClassName;
    element.propertys = [propertys trimmingWhitespaceAndNewlines];
    element.classInArray = classInArray;
    element.keyMapping = keyMapping;
    
    [self.classArray addObject:element];
    return YES;
}

- (void)generateCodeFile {
    [self parse];
    
    NSDate *today = [NSDate date];
    NSDateFormatter *formatter = [self.class dateFormatter];
    [formatter setDateFormat:@"yy/MM/dd"];
    NSString *dateString = [formatter stringFromDate:today];
    
    [formatter setDateFormat:@"yyyy"];
    NSString *yearString = [formatter stringFromDate:today];
    
    NSString *fileComment = [NSString stringWithFormat:
                             [@"fileComment.txt" bundleFileContent],
                             self.parameter.fileName,
                             self.parameter.projectName,
                             self.parameter.author,
                             dateString,
                             yearString,
                             self.parameter.organization];
    
    NSMutableString *interface = [NSMutableString string];
    NSMutableString *implementation = [NSMutableString string];
    
    [interface appendString:fileComment];
    [interface appendString:@"\n\n#import <Foundation/Foundation.h>"];

    if (self.parameter.superClassName) {
        [interface appendFormat:@"\n#import \"%@.h\"", self.parameter.superClassName];
    }
    
    [implementation appendString:fileComment];
    [implementation appendFormat:@"\n\n#import \"%@.h\"", self.parameter.fileName];
    
    for (JSONCodeFileElement *ele in self.classArray) {
        [interface appendString:[ele interfaceCode]];
        [implementation appendString:[ele implementationCode]];
    }
    
    NSString *desktop = NSSearchPathForDirectoriesInDomains(NSDesktopDirectory, NSUserDomainMask, YES)[0];
    
    [interface writeToFile:[NSString stringWithFormat:@"%@/%@.h", desktop, self.parameter.fileName]
                atomically:YES
                  encoding:NSUTF8StringEncoding
                     error:nil];
    
    [implementation writeToFile:[NSString stringWithFormat:@"%@/%@.m", desktop, self.parameter.fileName]
                     atomically:YES
                       encoding:NSUTF8StringEncoding
                          error:nil];
}


static NSDateFormatter *_shareDateFormartter;

+ (NSDateFormatter *)dateFormatter {
    if (!_shareDateFormartter) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _shareDateFormartter = [[NSDateFormatter alloc] init];
        });
    }
    return _shareDateFormartter;
}

@end
