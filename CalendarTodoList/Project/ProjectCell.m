//
//  ProjectCell.m
//  GoDo
//
//  Created by 牛严 on 16/4/11.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import "ProjectCell.h"
#import "ProjectModel.h"

@implementation ProjectCell
{
    UILabel *_nameLabel;
    UILabel *_creatorLabel;
    UILabel *_membersLabel;
}

- (void)loadDataWithProjectModel:(ProjectModel *)project
{
    _nameLabel.text = project.name;
    _creatorLabel.text = [NSString stringWithFormat:@"创建者：%@",project.creatorName];
    _membersLabel.text = [NSString stringWithFormat:@"参与人数：%lu",(unsigned long)project.members.count];
    
}

#pragma mark 初始化
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.clipsToBounds = YES;
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [self initView];
        
    }
    return self;
}

- (void)initView
{
    _nameLabel = [[UILabel alloc]init];
    _nameLabel.font = [UIFont boldSystemFontOfSize:16];
    [self.contentView addSubview:_nameLabel];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(10);
        make.left.equalTo(self.contentView).offset(18);
    }];
    
    _creatorLabel = [[UILabel alloc]init];
    _creatorLabel.font = [UIFont systemFontOfSize:12];
    _creatorLabel.textColor = KMainGray;
    [self.contentView addSubview:_creatorLabel];
    [_creatorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_nameLabel.mas_bottom).offset(5);
        make.left.equalTo(_nameLabel);
    }];
    
    _membersLabel = [[UILabel alloc]init];
    _membersLabel.font = [UIFont systemFontOfSize:12];
    _membersLabel.textColor = KMainGray;
    [self.contentView addSubview:_membersLabel];
    [_membersLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_creatorLabel);
        make.left.equalTo(_creatorLabel.mas_right).offset(15);
    }];
}

@end
