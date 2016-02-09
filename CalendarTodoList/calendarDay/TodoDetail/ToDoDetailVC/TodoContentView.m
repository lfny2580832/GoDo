//
//  TodoContentView.m
//  CalendarTodoList
//
//  Created by 牛严 on 16/2/2.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import "TodoContentView.h"

@implementation TodoContentView

#pragma mark UITextField Delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *str = [textField.text substringToIndex:[textField.text length] - 1];
    [self.delegate getTodoContentWith:str];
    return YES;
}

#pragma mark 初始化
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self initViews];
    }
    return self;
}

- (void)initViews
{
    UIView *lineView1 = [[UIView alloc]init];
    lineView1.backgroundColor = RGBA(220, 219, 224, 1.0);
    [self addSubview:lineView1];
    [lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.mas_equalTo(@1);
    }];
    
    _todoContentField = [[UITextField alloc]init];
    _todoContentField.placeholder = @"内容";
    _todoContentField.delegate = self;
    _todoContentField.font = [UIFont systemFontOfSize:18];
    [self addSubview:_todoContentField];
    [_todoContentField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(27);
        make.bottom.equalTo(self).offset(-26);
        make.left.equalTo(self).offset(25);
        make.right.equalTo(self).offset(-25);
    }];
    
    UIView *lineView2 = [[UIView alloc]init];
    lineView2.backgroundColor = RGBA(220, 219, 224, 1.0);
    [self addSubview:lineView2];
    [lineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self);
        make.height.mas_equalTo(@1);
    }];
}

@end
