//
//  AcceptInvitationCell.m
//  GoDo
//
//  Created by 牛严 on 16/4/28.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import "AcceptInvitationCell.h"

#import "UserMessageModel.h"

#import <SDWebImage/UIImageView+WebCache.h>
#import "NSString+ZZExtends.h"

@implementation AcceptInvitationCell
{
    UIImageView *_headImageView;
    UILabel *_titleLabel;
    UILabel *_timeLabel;
    UILabel *_contentLabel;
    UILabel *_acceptLabel;
    UIImageView *_arrowView;
}



- (void)setMessage:(UserMessageModel *)messageModel
{
    _message = messageModel;
    NSURL *headUrl = [NSURL URLWithString:messageModel.extraInfo.invitorAvatar];
    [_headImageView sd_setImageWithURL:headUrl placeholderImage:nil];
    _timeLabel.text = [NSString monthDayDateStringWithTimeStamp:messageModel.time];
    _contentLabel.text = messageModel.extraInfo.targetName;
    if (messageModel.type == 4) {
        _titleLabel.text = [NSString stringWithFormat:@"%@ 邀请你加入项目",messageModel.extraInfo.invitorName];
        _acceptLabel.hidden = NO;
        [_contentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.contentView).offset(-67);
        }];
        _arrowView.hidden = YES;
        [_timeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).offset(-18);
        }];
    }else if (messageModel.type == 7)
    {
        _titleLabel.text = [NSString stringWithFormat:@"%@ 邀请你接受任务",messageModel.extraInfo.invitorName];
        _acceptLabel.hidden = YES;
        [_contentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.contentView).offset(-14);
        }];
        _arrowView.hidden = NO;
        [_timeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).offset(-39);
        }];
    }
    _acceptLabel.text = (messageModel.dealt)? @"已处理":@"确认";
}

#pragma mark 点击cell
- (void)didSelectCell
{
    switch (_message.type) {
        case 4:
            return;
            break;
           
        case 7:
        {
            //跳至项目页面
            [self.delegate jumpToProjectInfoVCWithId:_message.extraInfo.projectId];
        }
        default:
            break;
    }
}

#pragma mark 加入项目
- (void)joinProject
{
    if (_message.dealt == YES) {
        return;
    }
    [self.delegate joinProjectWithId:_message.extraInfo.targetId messageId:_message.id];
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
    UITapGestureRecognizer *selectGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didSelectCell)];
    [self.contentView addGestureRecognizer:selectGes];
    
    _headImageView = [[UIImageView alloc]init];
    _headImageView.layer.cornerRadius = 19;
    _headImageView.backgroundColor = [UIColor grayColor];
    [self.contentView addSubview:_headImageView];
    [_headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(14);
        make.left.equalTo(self.contentView).offset(15);
        make.size.mas_equalTo(CGSizeMake(38, 38));
    }];
    
    _titleLabel = [[UILabel alloc]init];
    _titleLabel.font = [UIFont systemFontOfSize:12];
    _titleLabel.text = @"";
    _titleLabel.textColor = RGBA(134, 134, 134, 1.0);
    [self.contentView addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_headImageView);
        make.left.equalTo(_headImageView.mas_right).offset(10);
        make.right.equalTo(self.contentView).offset(-77);
    }];
    
    _timeLabel = [[UILabel alloc]init];
    _timeLabel.text = @"";
    _timeLabel.font = [UIFont systemFontOfSize:12];
    _timeLabel.textColor = RGBA(134, 134, 134, 1.0);
    [self.contentView addSubview:_timeLabel];
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleLabel);
        make.right.equalTo(self.contentView).offset(-39);
    }];
    
    _contentLabel = [[UILabel alloc]init];
    _contentLabel.font = [UIFont boldSystemFontOfSize:16];
    _contentLabel.text = @"";
    [self.contentView addSubview:_contentLabel];
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleLabel.mas_bottom).offset(10);
        make.left.equalTo(_titleLabel);
        make.right.equalTo(self.contentView).offset(-18);
        make.bottom.equalTo(self.contentView).offset(-67);
    }];
    
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = RGBA(146, 146, 146, 1.0);
    [self.contentView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@1);
        make.left.equalTo(self.contentView).offset(16);
        make.right.equalTo(self.contentView);
        make.top.equalTo(_contentLabel.mas_bottom).offset(14);
    }];
    
    _acceptLabel = [[UILabel alloc]init];
    _acceptLabel.font = [UIFont systemFontOfSize:14];
    _acceptLabel.textAlignment = NSTextAlignmentCenter;
    _acceptLabel.userInteractionEnabled = YES;
//    _acceptLabel.text = @"确认";
    _acceptLabel.textColor = RGBA(146, 146, 146, 1.0);
    UITapGestureRecognizer *acceptGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(joinProject)];
    [_acceptLabel addGestureRecognizer:acceptGes];
    [self.contentView addSubview:_acceptLabel];
    [_acceptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineView);
        make.left.right.bottom.equalTo(self.contentView);
    }];
    
    _arrowView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ico_arrow_right.png"]];
    [self.contentView addSubview:_arrowView];
    [_arrowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_timeLabel);
        make.right.equalTo(self.contentView).offset(-18);
    }];
    
}

@end
