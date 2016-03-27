//
//  AddTodoFooterView.m
//  CalendarTodoList
//
//  Created by 牛严 on 16/2/18.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import "AddTodoFooterView.h"

@implementation AddTodoFooterView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)initView
{
    UILabel *contentLabel  = [[UILabel alloc]init];
    contentLabel.text = @"+添加项目";
    contentLabel.textColor = [UIColor blackColor];
    contentLabel.font = [UIFont systemFontOfSize:15];
    [self addSubview:contentLabel];
    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(18);
        make.centerY.equalTo(self);
    }];
}

@end
