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

NSString * const kFileCommentInfoSaveKey = @"kFileCommentInfo";
NSString * const kFileSaveDocumentURLKey = @"kFileSaveDocumentURL";

@interface ViewController ()

@property (nonatomic, strong) JSONGenerator *generator;

@property (nonatomic, strong) NSArray *storedFieldArray;

@property (nonatomic, strong) NSMutableArray *fileCommentInfo;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
        
    _generator = [[JSONGenerator alloc] init];
    
    _storedFieldArray = @[_fileNameField, _projectNameField, _authorField, _organizationField, _superClassNameField];
    
    _fileCommentInfo = [[[NSUserDefaults standardUserDefaults] arrayForKey:kFileCommentInfoSaveKey] mutableCopy];
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

    _pathControl.allowedTypes = @[@"public.folder"];

    NSString *urlString = [[NSUserDefaults standardUserDefaults] objectForKey:kFileSaveDocumentURLKey];
    if (urlString) {
        _pathControl.URL = [NSURL URLWithString:urlString];
    }
}

- (IBAction)generateJSON:(id)sender {
    if ([_projectNameField.stringValue trimmingWhitespaceAndNewlines].length == 0) {
        [self alertErrorText:NSLocalizedString(@"请输入项目名称", nil)];
        return;
    }
    
    if ([_authorField.stringValue trimmingWhitespaceAndNewlines].length == 0) {
        [self alertErrorText:NSLocalizedString(@"请输入作者", nil)];
        return;
    }
    
    if ([_organizationField.stringValue trimmingWhitespaceAndNewlines].length == 0) {
        [self alertErrorText:NSLocalizedString(@"请输入团队名称", nil)];
        return;
    }
    
    if ([_superClassNameField.stringValue trimmingWhitespaceAndNewlines].length == 0) {
        [self alertErrorText:NSLocalizedString(@"请输入父类名称", nil)];
        return;
    }

    if ([_fileNameField.stringValue trimmingWhitespaceAndNewlines].length == 0) {
        [self alertErrorText:NSLocalizedString(@"请输入要生成的文件名称", nil)];
        return;
    }
    
    [self saveFileCommentInfoIfChanged];

    [[NSUserDefaults standardUserDefaults] setObject:_pathControl.URL.absoluteString forKey:kFileSaveDocumentURLKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    if ([_jsonTextView.string trimmingWhitespaceAndNewlines].length == 0) {
        [self alertErrorText:NSLocalizedString(@"请输入JSON数据", nil)];
        return;
    }
    
    JSONGeneratorParameter *parameter = [[JSONGeneratorParameter alloc] init];
    parameter.fileName = _fileNameField.stringValue;
    parameter.projectName = _projectNameField.stringValue;
    parameter.author = _authorField.stringValue;
    parameter.organization = _organizationField.stringValue;
    parameter.superClassName = _superClassNameField.stringValue;
    parameter.saveURL = _pathControl.URL;
    
    [_generator generateWithText:_jsonTextView.string parameter:parameter];
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
        [[NSUserDefaults standardUserDefaults] setObject:_fileCommentInfo forKey:kFileCommentInfoSaveKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)alertErrorText:(NSString *)error {
    NSAlert *alert = [[NSAlert alloc] init];
    alert.messageText = error;
    [alert beginSheetModalForWindow:[NSApplication sharedApplication].keyWindow completionHandler:nil];
}

@end
