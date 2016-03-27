//
//  RemindModeChooseCell.m
//  CalendarTodoList
//
//  Created by 牛严 on 16/3/27.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import "RemindModeCell.h"

@implementation RemindModeCell

#pragma mark 初始化
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.clipsToBounds = YES;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initView];
    }
    return self;
}

- (void)initView
{
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.text = @"提醒";
    titleLabel.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(18);
        make.top.equalTo(self.contentView).offset(15);
        make.width.mas_equalTo(@60);
    }];
    
    _modeLabel = [[UILabel alloc]init];
    _modeLabel.text = @"不提醒";
    _modeLabel.textAlignment = NSTextAlignmentRight;
    _modeLabel.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:_modeLabel];
    [_modeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-18);
        make.center.equalTo(titleLabel);
    }];
}

@end
