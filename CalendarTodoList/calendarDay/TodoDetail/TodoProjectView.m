//
//  TodoProjectView.m
//  CalendarTodoList
//
//  Created by 牛严 on 16/2/2.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import "TodoProjectView.h"

@implementation TodoProjectView
{
}

#pragma mark 选择项目
- (void)chooseProject
{
    [self.delegate chooseTodoProject];
}

#pragma mark 初始化
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        UITapGestureRecognizer *chooseProjectRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(chooseProject)];
        [self addGestureRecognizer:chooseProjectRecognizer];
        [self initViews];
    }
    return self;
}

- (void)initViews
{
    UILabel *titleLabel  = [[UILabel alloc]init];
    titleLabel.text = @"项目组";
    titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [self addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(25);
        make.centerY.equalTo(self);
    }];
    
    _contentLabel = [[UILabel alloc]init];
    _contentLabel.font = [UIFont systemFontOfSize:15];
    [self addSubview:_contentLabel];
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-25);
        make.centerY.equalTo(titleLabel);
    }];
}

@end
