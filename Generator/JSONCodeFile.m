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

- (void)parseJSON:(id)json {
    if (isDictionary(json)) {
        [self parseDictionaryElementWithClassName:self.parameter.fileName subJSON:json];
    } else if (isArray(json)) {
        [self parseArrayElementWithClassName:self.parameter.fileName subJSON:json];
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

    NSArray *sortedKeys = [subJson.allKeys sortedArrayUsingSelector:@selector(compare:)];
    for (NSString *key in sortedKeys) {
        id value = subJson[key];
        NSString *modelKey = key;
        if ([modelKey containsString:@"_"]) {
            modelKey = [modelKey littleCamelCase];
            keyMapping[modelKey] = key;
        } else if ([modelKey isEqualToString:@"id"]) {
            modelKey = @"ID";
            keyMapping[modelKey]  = key;
        }

        if (isDictionary(value)) {
            NSString *newClassName = [className stringByAppendingString:[modelKey capitalizedString]];
            [self parseDictionaryElementWithClassName:newClassName subJSON:value];
            [propertys appendFormat:@"@property (nonatomic, strong) %@ *%@;\n\n", newClassName, modelKey];
        } else if (isArray(value)) {
            NSString *newClassName = [className stringByAppendingString:[modelKey capitalizedString]];
            [propertys appendString:[NSString stringWithFormat:@"@property (nonatomic, strong) NSArray *%@;\n\n", modelKey]];
            if ([self parseArrayElementWithClassName:newClassName subJSON:value]) {
                classInArray[modelKey] = newClassName;
            }
        } else {
            if ([value isKindOfClass:[NSNumber class]]) {
                NSString *typeName = JSONTypeNameFromNumber(value);
                [propertys appendFormat:@"@property (nonatomic) %@ %@;\n\n", typeName, modelKey];
            } else {
                [propertys appendFormat:@"@property (nonatomic, strong) NSString *%@;\n\n", modelKey];
            }
        }
    }

    JSONCodeFileElement *element = [[JSONCodeFileElement alloc] init];
    element.className = className;
    element.superClassName = self.parameter.superClassName;
    element.propertys = [propertys trimmingWhitespaceAndNewlines];
    element.classInArray = classInArray;
    element.keyMapping = keyMapping;

    [self.classArray addObject:element];
    return YES;
}

- (void)generateCodeFileWithJSON:(id)json {
    [self parseJSON:json];

    NSDate *today = [NSDate date];
    NSDateFormatter *formatter = JSONShareDateFormartter();
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

    NSURL *url = [self.parameter.saveURL URLByAppendingPathComponent:self.parameter.fileName];

    NSError *error = nil;
    [interface writeToURL:[url URLByAppendingPathExtension:@"h"]
               atomically:YES
                 encoding:NSUTF8StringEncoding
                    error:&error];

    [implementation writeToURL:[url URLByAppendingPathExtension:@"m"]
                    atomically:YES
                      encoding:NSUTF8StringEncoding
                         error:&error];
}


static NSDateFormatter *_shareDateFormartter;
NSDateFormatter *JSONShareDateFormartter() {
    if (!_shareDateFormartter) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _shareDateFormartter = [[NSDateFormatter alloc] init];
        });
    }
    return _shareDateFormartter;
}

static NSArray *_numberTypeNameArray;
NSString *JSONTypeNameFromNumber(NSNumber *number) {
    if (!_numberTypeNameArray) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _numberTypeNameArray = @[
                                     @"",
                                     @"SInt8",
                                     @"SInt16",
                                     @"SInt32",
                                     @"SInt64",
                                     @"Float32",
                                     @"Float64",

                                     @"bool",
                                     @"short",
                                     @"int",
                                     @"long",
                                     @"long long",
                                     @"float",
                                     @"double",

                                     @"CFIndex",
                                     @"NSInteger",
                                     @"CGFloat",
                                     ];
        });
    }
    return _numberTypeNameArray[CFNumberGetType((__bridge CFNumberRef)number)];
}

@end
