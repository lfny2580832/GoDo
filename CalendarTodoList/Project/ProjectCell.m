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
}

- (void)loadDataWithProjectModel:(ProjectModel *)project
{
    _nameLabel.text = project.name;
}

#pragma mark 初始化
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.clipsToBounds = YES;
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initView];
        
    }
    return self;
}

- (void)initView
{
    _nameLabel = [[UILabel alloc]init];
    [self.contentView addSubview:_nameLabel];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(18);
    }];
}

@end
