//
//  JSONCodeFile.h
//  JSONModelGenerator
//
//  Created by 陈圣治 on 16/4/22.
//  Copyright © 2016年 富德胜. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONGeneratorParameter.h"

@interface JSONCodeFile : NSObject

@property (nonatomic, strong) JSONGeneratorParameter *parameter;

- (void)generateCodeFileWithJSON:(id)json;

@end
