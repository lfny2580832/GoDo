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
    UIImageView *_circleView;
}


#pragma mark KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"isSelected"] && object == self) {
        if ([[change objectForKey:@"new"]boolValue] == 1) {
//            self.backgroundColor = [UIColor blackColor];
            _circleView.hidden = NO;
        }else if ([[change objectForKey:@"new"]boolValue] == 0){
            _circleView.hidden = YES;

        }
    }
}

#pragma mark Set方法
- (void)setIndex:(NSString *)index
{
    _index = index;
//    _indexLabel.text = index;
}

- (void)setDate:(NSDate *)date
{
    _date = date;
    NSDateComponents *comps = [[NSCalendar currentCalendar] components:NSCalendarUnitWeekOfYear|NSCalendarUnitWeekday|NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear |NSCalendarUnitHour |NSCalendarUnitMinute fromDate:_date];
    NSString *weekDay;
    if (comps.weekday == 1) {
        weekDay = @"周日";
    }else if (comps.weekday == 2){
        weekDay = @"周一";
    }else if (comps.weekday == 3){
        weekDay = @"周二";
    }else if (comps.weekday == 4){
        weekDay = @"周三";
    }else if (comps.weekday == 5){
        weekDay = @"周四";
    }else if (comps.weekday == 6){
        weekDay = @"周五";
    }else if (comps.weekday == 7){
        weekDay = @"周六";
    }
    _indexLabel.text = weekDay;
    NSString *dateStr = [_monthDayFormatter stringFromDate:date];
    _dateLabel.text = dateStr;
}

- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"isSelected"];
}

#pragma mark 初始化
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = KNaviColor;

        _monthDayFormatter = [[NSDateFormatter alloc]init];
        [_monthDayFormatter setDateFormat:@"M-d"];
        [self initView];
        
        [self addObserver:self forKeyPath:@"isSelected" options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}

- (void)initView
{
    _circleView = [[UIImageView alloc]init];
    _circleView.backgroundColor = RGBA(255, 204, 153, 0.5);
    _circleView.layer.masksToBounds = YES;
    _circleView.hidden = YES;
    _circleView.layer.cornerRadius = self.frame.size.height/4+1;

    [self addSubview:_circleView];
    [_circleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self).offset(5);
        make.centerX.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(self.frame.size.height/2+4, self.frame.size.height/2+4));
    }];
    
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
        make.centerY.equalTo(self).offset(5);
        make.centerX.equalTo(self);
    }];
 

}

@end
