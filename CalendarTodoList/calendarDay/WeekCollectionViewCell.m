//
//  WeekCollectionViewCell.m
//  CalendarTodoList
//
//  Created by 牛严 on 16/1/11.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import "WeekCollectionViewCell.h"

@implementation WeekCollectionViewCell
{
    NSDateFormatter *_monthDayFormatter;
    UILabel *_indexLabel;
    UILabel *_dateLabel;
}

- (void)setIndex:(NSString *)index
{
    _indexLabel.text = index;
}

- (void)setDate:(NSDate *)date
{
    NSString *dateStr = [_monthDayFormatter stringFromDate:date];
    _dateLabel.text = dateStr;
}

#pragma mark 初始化
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _monthDayFormatter = [[NSDateFormatter alloc]init];
        [_monthDayFormatter setDateFormat:@"M-d"];
        [self initView];
        
    }
    return self;
}

- (void)initView
{
    _indexLabel = [[UILabel alloc]init];
    _indexLabel.textColor = [UIColor whiteColor];
    _indexLabel.font = [UIFont systemFontOfSize:10];
    [self addSubview:_indexLabel];
    [_indexLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.centerX.equalTo(self);
    }];
    
    _dateLabel = [[UILabel alloc]init];
    _dateLabel.textColor = [UIColor whiteColor];
    _dateLabel.font = [UIFont systemFontOfSize:13];
    [self addSubview:_dateLabel];
    [_dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_indexLabel.mas_bottom).offset(3);
        make.centerX.equalTo(self);
    }];
    
}

@end
