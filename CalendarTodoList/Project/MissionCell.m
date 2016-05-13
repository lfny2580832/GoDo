//
//  MissionCell.m
//  GoDo
//
//  Created by 牛严 on 16/4/13.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import "MissionCell.h"
#import "MissionModel.h"

#import "TodoDetailVC.h"

#import <SDWebImage/UIImageView+WebCache.h>

#import "ZoomImageView.h"
#import "NSString+ZZExtends.h"

@implementation MissionCell
{
    UIView *_backView;
    UIImageView *_avatarView;
    UILabel *_createTimeLabel;
    UILabel *_textLabel;        //任务内容
    UILabel *_deadLineLabel;        //几月几号
    UILabel *_createInfoLabel;  //xxx创建了任务
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

    [self.delegate acceptMissionWithMission:_mission images:_images];
}

- (void)setMission:(MissionModel *)mission
{
    _mission = mission;
    _textLabel.text = mission.name;
    _createInfoLabel.text = [NSString stringWithFormat:@"%@ 创建了任务",mission.creatorName];
    NSString *deadLineStr = [NSString dateStringsWithTimeStamp:mission.deadline];
    _deadLineLabel.text = [NSString stringWithFormat:@"截止日期：%@",deadLineStr];
    _createTimeLabel.text = [NSString monthDayDateStringWithTimeStamp:mission.createTime];
    [_avatarView sd_setImageWithURL:[NSURL URLWithString:mission.creatorAvatar]];
    
    if (mission.pictures.count) {
        _images = [NSMutableArray new];
        NSInteger imageCount = mission.pictures.count;
        NSInteger imageEdge = 10;
        [_textLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(_backView).offset(-101);
        }];
        //创建imageView
        for (int i = 0; i < 4; i ++) {
            UIImageView *missionImageView = [_imageViews objectAtIndex:i];
            if (i < imageCount) {
                missionImageView.userInteractionEnabled = YES;
                missionImageView.contentMode= UIViewContentModeScaleAspectFill;
                missionImageView.clipsToBounds = YES;
                [missionImageView sd_setImageWithURL:mission.pictures[i] placeholderImage:[UIImage imageNamed:@"default.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    [_images addObject:image];
                }];
                UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(enlargeImageWithImageView:)];
                [missionImageView addGestureRecognizer:recognizer];
            }else{
                missionImageView.image = nil;
            }
            [self.contentView addSubview:missionImageView];
            [missionImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_textLabel).offset(i*(50+imageEdge));
                make.size.mas_equalTo(CGSizeMake(50, 50));
                make.top.equalTo(_textLabel.mas_bottom).offset(15);
            }];
            [_imageViews addObject:missionImageView];
        }
    }else{
        for(UIImageView *imageView in _imageViews)
        {
            imageView.image = nil;
        }
        [_textLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(_backView).offset(-41);
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
        make.top.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView).offset(-60);
        make.left.right.equalTo(self.contentView);
    }];

    _avatarView = [[UIImageView alloc]init];
    _avatarView.backgroundColor = KMainGray;
    _avatarView.contentMode= UIViewContentModeScaleAspectFill;
    _avatarView.clipsToBounds = YES;
    _avatarView.layer.cornerRadius = 19;
    _avatarView.layer.masksToBounds = YES;
    [_backView addSubview:_avatarView];
    [_avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_backView).offset(13);
        make.left.equalTo(_backView).offset(12);
        make.size.mas_equalTo(CGSizeMake(38, 38));
    }];

    _createInfoLabel = [[UILabel alloc]init];
    _createInfoLabel.font = [UIFont systemFontOfSize:12];
    _createInfoLabel.textColor = KMainGray;
    [_backView addSubview:_createInfoLabel];
    [_createInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_avatarView);
        make.left.equalTo(_avatarView.mas_right).offset(10);
    }];
    
    _createTimeLabel = [[UILabel alloc]init];
    _createTimeLabel.font = [UIFont systemFontOfSize:12];
    _createTimeLabel.textColor = KMainGray;
    [_backView addSubview:_createTimeLabel];
    [_createTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_createInfoLabel);
        make.right.equalTo(_backView).offset(-18);
    }];
    
    _textLabel = [[UILabel alloc]init];
    _textLabel.font = [UIFont boldSystemFontOfSize:16];
    _textLabel.numberOfLines = 0;
    [_backView addSubview:_textLabel];
    [_textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_backView).offset(34);
        make.bottom.equalTo(_backView).offset(-10);
        make.left.equalTo(_createInfoLabel);
        make.right.equalTo(_backView).offset(-18);
    }];
    
    _deadLineLabel = [[UILabel alloc]init];
    _deadLineLabel.font = [UIFont systemFontOfSize:14];
    _deadLineLabel.textColor = [UIColor blackColor];
    [_backView addSubview:_deadLineLabel];
    [_deadLineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_backView);
        make.bottom.equalTo(_backView).offset(-10);
    }];
    
    UIView *seperateLine = [[UIView alloc]init];
    seperateLine.backgroundColor = KMainGray;
    [_backView addSubview:seperateLine];
    [seperateLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_backView).offset(18);
        make.bottom.equalTo(_backView);
        make.height.mas_equalTo(@1);
        make.right.equalTo(_backView);
    }];
    
    _acceptLabel = [[UILabel alloc]init];
    _acceptLabel.text = @"领取任务";
    _acceptLabel.font = [UIFont systemFontOfSize:14];
    _acceptLabel.textColor = KNaviColor;
    _acceptLabel.backgroundColor = [UIColor whiteColor];
    _acceptLabel.userInteractionEnabled = YES;
    _acceptLabel.textAlignment = NSTextAlignmentCenter;
    UITapGestureRecognizer *acceptGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(acceptMission)];
    [_acceptLabel addGestureRecognizer:acceptGes];
    [self.contentView addSubview:_acceptLabel];
    [_acceptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_backView.mas_bottom);
        make.centerX.equalTo(_backView);
        make.left.right.equalTo(_backView);
        make.bottom.equalTo(self.contentView).offset(-20);
    }];
}

@end
