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
    UILabel *_contentLabel;
}

#pragma mark 初始化
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
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
    
    
}

@end
