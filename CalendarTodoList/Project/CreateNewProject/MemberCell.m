//
//  MemberCell.m
//  GoDo
//
//  Created by 牛严 on 16/5/1.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import "MemberCell.h"

@implementation MemberCell
{
    UILabel *_contentLabel;
}

- (void)setMemberName:(NSString *)memberName
{
    _contentLabel.text = memberName;
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
    _contentLabel = [[UILabel alloc]init];
    [self.contentView addSubview:_contentLabel];
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(10);
        make.left.equalTo(self.contentView).offset(50);
        make.bottom.equalTo(self.contentView).offset(-10);
    }];
}
@end
