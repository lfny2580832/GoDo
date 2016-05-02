//
//  MineInfoAvatarCell.m
//  GoDo
//
//  Created by 牛严 on 16/4/25.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import "MineInfoAvatarCell.h"

@implementation MineInfoAvatarCell
{
    UIImageView *_imageView;
}

#pragma mark 初始化
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
    _titleLabel.text = @"头像";
    [self.contentView addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(18);
    }];
    
    _imageView = [[UIImageView alloc]initWithImage:[UserDefaultManager headImage]];
    _imageView.contentMode= UIViewContentModeScaleAspectFill;
    _imageView.clipsToBounds = YES;
    [self.contentView addSubview:_imageView];
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(5);
        make.bottom.equalTo(self.contentView).offset(-5);
        make.right.equalTo(self.contentView).offset(-18);
        make.size.mas_equalTo(CGSizeMake(70, 70));
    }];
}

@end
