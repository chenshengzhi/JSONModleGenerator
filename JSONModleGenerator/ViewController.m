//
//  ViewController.m
//  JSONModelGenerator
//
//  Created by 陈圣治 on 16/4/22.
//  Copyright (c) 2016年 富德胜. All rights reserved.
//

#import "ViewController.h"
#import "JSONGenerator.h"
#import "JSONGeneratorParameter.h"
#import "NSString+Trims.h"

@interface ViewController ()

@property (nonatomic, strong) JSONGenerator *generator;

@property (nonatomic, strong) NSArray *storedFieldArray;

@property (nonatomic, strong) NSMutableArray *fileCommentInfo;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
        
    _generator = [[JSONGenerator alloc] init];
    
    _storedFieldArray = @[_projectNameField, _authorField, _organizationField, _superClassNameField];
    
    _fileCommentInfo = [[[NSUserDefaults standardUserDefaults] arrayForKey:@"kFileCommentInfo"] mutableCopy];
    if (_fileCommentInfo.count != _storedFieldArray.count) {
        _fileCommentInfo = [NSMutableArray array];
        for (int i = 0; i < _storedFieldArray.count; i++) {
            [_fileCommentInfo addObject:@""];
        }
    }
    
    for (int i = 0; i < _storedFieldArray.count; i++) {
        NSTextField *field = _storedFieldArray[i];
        field.stringValue = _fileCommentInfo[i];
    }
}

- (IBAction)generateJSON:(id)sender {
    if ([_jsonTextView.string trimmingWhitespaceAndNewlines].length == 0) {
        [self alertErrorText:@"请输入JSON数据"];
        return;
    }
    
    if ([_fileNameField.stringValue trimmingWhitespaceAndNewlines].length == 0) {
        [self alertErrorText:@"请输入要生成的文件名称"];
        return;
    }
    
    if ([_projectNameField.stringValue trimmingWhitespaceAndNewlines].length == 0) {
        [self alertErrorText:@"请输入项目名称"];
        return;
    }
    
    if ([_authorField.stringValue trimmingWhitespaceAndNewlines].length == 0) {
        [self alertErrorText:@"请输入作者"];
        return;
    }
    
    if ([_organizationField.stringValue trimmingWhitespaceAndNewlines].length == 0) {
        [self alertErrorText:@"请输入团队名称"];
        return;
    }
    
    if ([_superClassNameField.stringValue trimmingWhitespaceAndNewlines].length == 0) {
        [self alertErrorText:@"请输入父类名称"];
        return;
    }
    
    [self saveFileCommentInfoIfChanged];
    
    JSONGeneratorParameter *parameter = [[JSONGeneratorParameter alloc] init];
    parameter.json = _jsonTextView.string;
    parameter.fileName = _fileNameField.stringValue;
    parameter.projectName = _projectNameField.stringValue;
    parameter.author = _authorField.stringValue;
    parameter.organization = _organizationField.stringValue;
    parameter.superClassName = _superClassNameField.stringValue;
    
    [_generator generateWithParameter:parameter];
}

- (void)saveFileCommentInfoIfChanged {
    BOOL isChanged = NO;
    for (int i = 0; i < _storedFieldArray.count; i++) {
        NSTextField *field = _storedFieldArray[i];
        if (![field.stringValue isEqualToString:_fileCommentInfo[i]]) {
            isChanged = YES;
            break;
        }
    }
    
    if (isChanged) {
        _fileCommentInfo = [NSMutableArray array];
        for (NSTextField *field in _storedFieldArray) {
            [_fileCommentInfo addObject:field.stringValue];
        }
        [[NSUserDefaults standardUserDefaults] setObject:_fileCommentInfo forKey:@"kFileCommentInfo"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)alertErrorText:(NSString *)error {
    NSAlert *alert = [[NSAlert alloc] init];
    alert.messageText = error;
    [alert beginSheetModalForWindow:[NSApplication sharedApplication].keyWindow completionHandler:nil];
}

@end
