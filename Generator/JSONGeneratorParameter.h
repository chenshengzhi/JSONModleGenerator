//
//  JSONGeneratorParameter.h
//  JSONModleGenerator
//
//  Created by 陈圣治 on 16/4/22.
//  Copyright © 2016年 富德胜. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JSONGeneratorParameter : NSObject

@property (nonatomic, strong) id json;
@property (nonatomic, strong) NSString *fileName;
@property (nonatomic, strong) NSString *projectName;
@property (nonatomic, strong) NSString *author;
@property (nonatomic, strong) NSString *organization;
@property (nonatomic, strong) NSString *superClassName;

@end
