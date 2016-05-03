//
//  ProjectMembersCell.m
//  GoDo
//
//  Created by 牛严 on 16/5/2.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import "ProjectMembersCell.h"
#import "ProjectMemberModel.h"

#import <SDWebImage/UIImageView+WebCache.h>

@implementation ProjectMembersCell
{
    UIImageView *_avatarView;
    UILabel *_nameLabel;
}

- (void)setMember:(ProjectMemberModel *)member
{
    _nameLabel.text = member.name;
    [_avatarView sd_setImageWithURL:[NSURL URLWithString:member.avatar]];
}

#pragma mark 初始化
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.clipsToBounds = YES;
        self.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initView];
    }
    return self;
}

- (void)initView
{
    _avatarView = [[UIImageView alloc]init];
    _avatarView.backgroundColor = KMainGray;
    _avatarView.layer.cornerRadius = 18;
    _avatarView.contentMode= UIViewContentModeScaleAspectFill;
    _avatarView.clipsToBounds = YES;
    [self.contentView addSubview:_avatarView];
    [_avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(18);
        make.size.mas_equalTo(CGSizeMake(36, 36));
    }];
    
    _nameLabel = [[UILabel alloc]init];
    _nameLabel.font = [UIFont systemFontOfSize:16];
    [self.contentView addSubview:_nameLabel];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(22);
        make.left.equalTo(_avatarView.mas_right).offset(10);
        make.bottom.equalTo(self.contentView).offset(-12);
        make.height.mas_equalTo(@16);
    }];
}

@end
