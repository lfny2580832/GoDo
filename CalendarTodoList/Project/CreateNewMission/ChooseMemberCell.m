//
//  ChooseMemberCell.m
//  GoDo
//
//  Created by 牛严 on 16/4/30.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import "ChooseMemberCell.h"

@implementation ChooseMemberCell
{
    UILabel *_titleLabel;
    UILabel *_contentLabel;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)initView
{
    _titleLabel = [[UILabel alloc]init];
    _titleLabel.font = [UIFont systemFontOfSize:15];
    _titleLabel.text = @"选择任务执行者";
    [self.contentView addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(18);
        make.top.equalTo(self.contentView).offset(15);
        make.width.mas_equalTo(@120);
    }];
    
    _contentLabel = [[UILabel alloc]init];
    _contentLabel.font = [UIFont systemFontOfSize:15];
    _contentLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_contentLabel];
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_titleLabel);
        make.right.equalTo(self.contentView).offset(-18);
    }];

}

@end
