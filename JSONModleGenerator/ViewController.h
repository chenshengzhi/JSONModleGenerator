//
//  ViewController.h
//  JSONModelGenerator
//
//  Created by 陈圣治 on 16/4/22.
//  Copyright (c) 2016年 富德胜. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ViewController : NSViewController

@property (unsafe_unretained) IBOutlet NSTextView *jsonTextView;
@property (weak) IBOutlet NSTextField *fileNameField;
@property (weak) IBOutlet NSTextField *projectNameField;
@property (weak) IBOutlet NSTextField *authorField;
@property (weak) IBOutlet NSTextField *organizationField;
@property (weak) IBOutlet NSTextField *superClassNameField;

@end

