//
//  MineCell.m
//  GoDo
//
//  Created by 牛严 on 16/4/23.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import "MineCell.h"

@implementation MineCell

#pragma mark 初始化
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initView];
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return self;
}

- (void)initView
{
    _titleLabel = [[UILabel alloc]init];
    [self.contentView addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(18);
        make.top.equalTo(self.contentView).offset(15);
        make.bottom.equalTo(self.contentView).offset(-15);
        make.height.mas_equalTo(@15);
    }];
}

@end
