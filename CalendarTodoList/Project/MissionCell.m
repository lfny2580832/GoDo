//
//  MissionCell.m
//  GoDo
//
//  Created by 牛严 on 16/4/13.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import "MissionCell.h"
#import "MissionModel.h"

@implementation MissionCell
{
    UIView *_backView;
    UILabel *_textLabel;        //任务内容
    UILabel *_timeLabel;        //几点几分
    UILabel *_dateLabel;        //几月几号
    UILabel *_createInfoLabel;  //xxx创建了任务

}

//- (void)layoutSubviews
//{
//    _backView.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:_backView.bounds cornerRadius:5].CGPath;
//    _backView.layer.shadowOffset = CGSizeMake(2, 2);
//    _backView.layer.shadowRadius = 1;
//    _backView.layer.shadowOpacity = 0.2;
//    _backView.layer.cornerRadius = 5;
//}

- (void)loadDataWithMission:(MissionModel *)mission
{
    _textLabel.text = mission.name;
    _createInfoLabel.text = [NSString stringWithFormat:@"%@ 创建了任务",mission.creatorName];
    
}

#pragma mark 初始化
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.clipsToBounds = YES;
        self.backgroundColor = RGBA(232, 232, 232, 1.0);;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initView];
        
    }
    return self;
}

- (void)initView
{
    
    _backView = [[UIView alloc]init];
    _backView.backgroundColor = [UIColor whiteColor];
    _backView.layer.cornerRadius = 5;
    _backView.layer.masksToBounds = YES;
    [self.contentView addSubview:_backView];
    [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(5);
        make.bottom.equalTo(self.contentView).offset(-6);
        make.left.equalTo(self.contentView).offset(10);
        make.right.equalTo(self.contentView).offset(-10);
    }];

    _createInfoLabel = [[UILabel alloc]init];
    _createInfoLabel.text = @"牛严 创建了任务";
    [_backView addSubview:_createInfoLabel];
    [_createInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_backView);
        make.left.equalTo(_backView).offset(18);
    }];
    

    
    UIView *misInfoView = [[UIView alloc]init];
    [_backView addSubview:misInfoView];
    [misInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_backView).offset(20);
        make.left.right.equalTo(_backView);
        make.bottom.equalTo(_backView).offset(-20);
    }];
    
    _textLabel = [[UILabel alloc]init];
    _textLabel.textColor = [UIColor blackColor];
    _textLabel.font = [UIFont systemFontOfSize:18];
    _textLabel.textAlignment = NSTextAlignmentCenter;
    _textLabel.numberOfLines = 0;
    _textLabel.text = @"拿下xx项目";
    [misInfoView addSubview:_textLabel];
    [_textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(misInfoView).offset(12);
        make.bottom.equalTo(misInfoView).offset(-12);
        make.left.equalTo(misInfoView).offset(100);
        make.right.equalTo(misInfoView).offset(-10);
    }];
    
    _dateLabel = [[UILabel alloc]init];
    _dateLabel.text = @"11月12日";
    _dateLabel.font = [UIFont systemFontOfSize:18];
    [misInfoView addSubview:_dateLabel];
    [_dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(misInfoView).offset(15);
        make.centerY.equalTo(_textLabel).offset(-10);
    }];

    _timeLabel = [[UILabel alloc]init];
    _timeLabel.textColor = [UIColor blackColor];
    _timeLabel.text = @"15:30";
    _timeLabel.font = [UIFont systemFontOfSize:18];
    [misInfoView addSubview:_timeLabel];
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_textLabel).offset(10);
        make.centerX.equalTo(_dateLabel);
    }];
    
    UIView *seperateLine = [[UIView alloc]init];
    seperateLine.backgroundColor = [UIColor grayColor];
    [misInfoView addSubview:seperateLine];
    [seperateLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(misInfoView).offset(8);
        make.bottom.equalTo(misInfoView).offset(-8);
        make.width.mas_equalTo(@1);
        make.left.equalTo(_dateLabel.mas_right).offset(10);
    }];
    

}

@end
