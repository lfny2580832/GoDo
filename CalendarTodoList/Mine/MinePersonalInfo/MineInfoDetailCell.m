//
//  MineInfoDetailCell.m
//  GoDo
//
//  Created by 牛严 on 16/4/25.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import "MineInfoDetailCell.h"

@implementation MineInfoDetailCell
{
    UILabel *_titleLabel;
    UILabel *_contentLabel;
}

- (void)loadTitle:(NSString *)title content:(NSString *)content
{
    _titleLabel.text = title;
    _contentLabel.text = content;
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
    [self.contentView addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(18);
        make.top.equalTo(self.contentView).offset(15);
        make.bottom.equalTo(self.contentView).offset(-15);
        make.height.mas_equalTo(@15);
    }];
    
    _contentLabel = [[UILabel alloc]init];
    [self.contentView addSubview:_contentLabel];
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-18);
        make.centerY.equalTo(self.contentView);
    }];
}

@end
