//
//  MissionCell.m
//  GoDo
//
//  Created by 牛严 on 16/4/13.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import "MissionCell.h"
#import "MissionModel.h"

#import <SDWebImage/UIImageView+WebCache.h>

#import "ZoomImageView.h"
#import "NSString+ZZExtends.h"

@implementation MissionCell
{
    UIView *_backView;
    UILabel *_textLabel;        //任务内容
    UILabel *_timeLabel;        //几点几分
    UILabel *_dateLabel;        //几月几号
    UILabel *_createInfoLabel;  //xxx创建了任务
    UIView *_misInfoView;
    UILabel *_acceptLabel;
    
    NSMutableArray *_imageViews;

}

//- (void)layoutSubviews
//{
//    _backView.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:_backView.bounds cornerRadius:5].CGPath;
//    _backView.layer.shadowOffset = CGSizeMake(2, 2);
//    _backView.layer.shadowRadius = 1;
//    _backView.layer.shadowOpacity = 0.2;
//    _backView.layer.cornerRadius = 5;
//}

- (void)acceptMission
{
    NSLog(@"领取任务");
}

- (void)loadDataWithMission:(MissionModel *)mission
{
    _textLabel.text = mission.name;
    _createInfoLabel.text = [NSString stringWithFormat:@"%@ 创建了任务",mission.creatorName];
    NSDictionary *dateStrDic = [NSString dateStringsWithTimeStamp:mission.createTime];
    _dateLabel.text = dateStrDic[@"date"];
    _timeLabel.text = dateStrDic[@"time"];
    if (mission.pictures.count) {
        NSInteger imageCount = mission.pictures.count;
        NSInteger imageEdge = 10;
        [_textLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(_misInfoView).offset(-77);
        }];
        //创建imageView
        for (int i = 0; i < 4; i ++) {
            UIImageView *missionImageView = [_imageViews objectAtIndex:i];
            if (i < imageCount) {
                missionImageView.userInteractionEnabled = YES;
                missionImageView.contentMode= UIViewContentModeScaleAspectFill;
                missionImageView.clipsToBounds = YES;
                [missionImageView sd_setImageWithURL:mission.pictures[i] placeholderImage:[UIImage imageNamed:@"default.png"]];
                UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(enlargeImageWithImageView:)];
                [missionImageView addGestureRecognizer:recognizer];
            }else{
                missionImageView.image = nil;
            }
            [self.contentView addSubview:missionImageView];
            [missionImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_textLabel).offset(10 + i*(50+imageEdge));
                make.size.mas_equalTo(CGSizeMake(50, 50));
                make.top.equalTo(_textLabel.mas_bottom).offset(15);
            }];
            [_imageViews addObject:missionImageView];
        }
    }else{
        [_textLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(_misInfoView).offset(-12);
        }];
    }

}
#pragma mark 放大ImageView中的图片
- (void)enlargeImageWithImageView:(id)sender
{
    UITapGestureRecognizer * singleTap = (UITapGestureRecognizer *)sender;
    ZoomImageView *zoomImageView = [[ZoomImageView alloc]initWithImageView:(UIImageView *)[singleTap view]];
    [zoomImageView showBigImageView];
}

#pragma mark 初始化
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.clipsToBounds = YES;
        self.backgroundColor = RGBA(232, 232, 232, 1.0);
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _imageViews = [NSMutableArray arrayWithCapacity:4];
        for(int i = 0 ;i < 4 ; i ++)
        {
            UIImageView *imageView = [[UIImageView alloc]init];
            [_imageViews addObject:imageView];
        }
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
    

    
    _misInfoView = [[UIView alloc]init];
    [_backView addSubview:_misInfoView];
    [_misInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_backView).offset(20);
        make.left.right.equalTo(_backView);
        make.bottom.equalTo(_backView).offset(-30);
    }];
    
    _textLabel = [[UILabel alloc]init];
    _textLabel.textColor = [UIColor blackColor];
    _textLabel.font = [UIFont systemFontOfSize:18];
    _textLabel.textAlignment = NSTextAlignmentCenter;
    _textLabel.numberOfLines = 0;
    _textLabel.text = @"拿下xx项目";
    [_misInfoView addSubview:_textLabel];
    [_textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_misInfoView).offset(12);
        make.bottom.equalTo(_misInfoView).offset(-12);
        make.left.equalTo(_misInfoView).offset(100);
        make.right.equalTo(_misInfoView).offset(-10);
    }];
    
    _dateLabel = [[UILabel alloc]init];
    _dateLabel.text = @"11月12日";
    _dateLabel.font = [UIFont systemFontOfSize:18];
    [_misInfoView addSubview:_dateLabel];
    [_dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_misInfoView).offset(15);
        make.centerY.equalTo(_misInfoView).offset(-10);
    }];

    _timeLabel = [[UILabel alloc]init];
    _timeLabel.textColor = [UIColor blackColor];
    _timeLabel.text = @"15:30";
    _timeLabel.font = [UIFont systemFontOfSize:18];
    [_misInfoView addSubview:_timeLabel];
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_misInfoView).offset(10);
        make.centerX.equalTo(_dateLabel);
    }];
    
    UIView *seperateLine = [[UIView alloc]init];
    seperateLine.backgroundColor = [UIColor grayColor];
    [_misInfoView addSubview:seperateLine];
    [seperateLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_misInfoView).offset(8);
        make.bottom.equalTo(_misInfoView).offset(-8);
        make.width.mas_equalTo(@1);
        make.left.equalTo(_dateLabel.mas_right).offset(10);
    }];
    
    _acceptLabel = [[UILabel alloc]init];
    _acceptLabel.text = @"领取任务";
    _acceptLabel.textColor = KNaviColor;
    _acceptLabel.userInteractionEnabled = YES;
    _acceptLabel.textAlignment = NSTextAlignmentCenter;
    UITapGestureRecognizer *acceptGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(acceptMission)];
    [_acceptLabel addGestureRecognizer:acceptGes];
    [_backView addSubview:_acceptLabel];
    [_acceptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_misInfoView.mas_bottom).offset(5);
        make.centerX.equalTo(_backView);
        make.left.right.equalTo(_backView);
    }];
}

@end
