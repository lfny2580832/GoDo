//
//  ProjectAvatarCell.m
//  GoDo
//
//  Created by 牛严 on 16/5/1.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import "AvatarCollectionViewCell.h"

@implementation AvatarCollectionViewCell
{
    UIImageView *_avatarImageView;
}


#pragma mark 初始化
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
    _avatarImageView = [[UIImageView alloc]init];
    _avatarImageView.layer.cornerRadius = 13;
    _avatarImageView.backgroundColor = KMainGray;
    [self.contentView addSubview:_avatarImageView];
    [_avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.equalTo(self.contentView);
    }];
}

@end
