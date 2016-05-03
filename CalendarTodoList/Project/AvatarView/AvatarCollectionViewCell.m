//
//  ProjectAvatarCell.m
//  GoDo
//
//  Created by 牛严 on 16/5/1.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import "AvatarCollectionViewCell.h"
#import "ProjectMemberModel.h"

#import <SDWebImage/UIImageView+WebCache.h>

@implementation AvatarCollectionViewCell
{
    UIImageView *_avatarImageView;
}

- (void)loadAddMemberImage
{
    _avatarImageView.image = [UIImage imageNamed:@"ico_add.png"];
}

- (void)loadMemberImagesWithMember:(ProjectMemberModel *)member
{
    [_avatarImageView sd_setImageWithURL:[NSURL URLWithString:member.avatar]];
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
    _avatarImageView.layer.cornerRadius = 14;
    _avatarImageView.contentMode= UIViewContentModeScaleAspectFill;
    _avatarImageView.clipsToBounds = YES;
    _avatarImageView.backgroundColor = KMainGray;
    _avatarImageView.layer.masksToBounds = YES;
    [self.contentView addSubview:_avatarImageView];
    [_avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.equalTo(self.contentView);
    }];
}

@end
