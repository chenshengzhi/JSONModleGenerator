//
//  JSONCodeFileElement.h
//  JSONModelGenerator
//
//  Created by 陈圣治 on 16/4/22.
//  Copyright © 2016年 富德胜. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JSONCodeFileElement : NSObject

@property (nonatomic, strong) NSString *className;
@property (nonatomic, strong) NSString *superClassName;
@property (nonatomic, strong) NSString *propertys;
@property (nonatomic, strong) NSDictionary *classInArray;
@property (nonatomic, strong) NSDictionary *keyMapping;

- (NSString *)interfaceCode;

- (NSString *)implementationCode;

@end
