//
//  RemindModeChooseCell.m
//  CalendarTodoList
//
//  Created by 牛严 on 16/3/27.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import "RemindModeChooseCell.h"

@implementation RemindModeChooseCell

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initView];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    return self;
}

- (void)initView
{
    _modeLabel = [[UILabel alloc]init];
    _modeLabel.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:_modeLabel];
    [_modeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(18);
    }];
}

@end
