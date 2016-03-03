//
//  DatePickerCell.m
//  CalendarTodoList
//
//  Created by 牛严 on 16/2/9.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import "DatePickerCell.h"

@implementation DatePickerCell
{    
    NSDateFormatter *_dateFormatter;
    NSDateFormatter *_dateAndTimeFormatter;
    
    UIDatePickerMode _datePickerMode;
}

- (void)datePickerValueChanged:(UIDatePicker *)datePicker
{
    NSDate *date = datePicker.date;
    NSString *dateStr;
    if (_datePickerMode == UIDatePickerModeDateAndTime) {
        dateStr = [_dateAndTimeFormatter stringFromDate:date];
    }else{
        dateStr = [_dateFormatter stringFromDate:date];
    }
    _dateLabel.text = dateStr;
    if ([_titleLabel.text isEqualToString:@"开始"]) {
        [self.delegate returnStartDate:date];
    }
//        else{
//        [self.delegate returnStartDate:nil endDate:date];
//    }
}

- (void)setDatePickerMode:(UIDatePickerMode )datePickerMode date:(NSDate *)date
{
    _datePickerMode = datePickerMode;
    
    if (!_datePicker) {
        dispatch_async(kBgQueue, ^{
            _datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 50, SCREEN_WIDTH, 180)];
            _datePicker.datePickerMode = _datePickerMode;
            [_datePicker addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
            dispatch_async(kMainQueue, ^{
                [self.contentView addSubview:_datePicker];
                [_datePicker setDate:date animated:NO];
            });
        });
    }
    [_datePicker setDatePickerMode:_datePickerMode];

    //设置dateLabel文本
    NSString *dateStr;
    if (_datePickerMode == UIDatePickerModeDate) {
        dateStr = [_dateFormatter stringFromDate:date];
    }else{
        dateStr = [_dateAndTimeFormatter stringFromDate:date];
    }
    _dateLabel.text = dateStr;
}

#pragma mark 初始化

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.clipsToBounds = YES;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _dateFormatter = [[NSDateFormatter alloc]init];
        [_dateFormatter setDateFormat:@"yyyy年M月d日 EEE"];
        _dateAndTimeFormatter = [[NSDateFormatter alloc]init];
        [_dateAndTimeFormatter setDateFormat:@"yyyy年M月d日 aaahh:mm"];
        [self initView];
    }
    return self;
}

- (void)initView
{
    _titleLabel = [[UILabel alloc]init];
    _titleLabel.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(18);
        make.top.equalTo(self.contentView).offset(15);
        make.width.mas_equalTo(@60);
    }];
    
    _dateLabel = [[UILabel alloc]init];
    _dateLabel.font = [UIFont systemFontOfSize:15];
    NSString *dateStr = [_dateAndTimeFormatter stringFromDate:[NSDate date]];
    _dateLabel.text = dateStr;
    _dateLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_dateLabel];
    [_dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_titleLabel);
        make.right.equalTo(self.contentView).offset(-18);
    }];
}

@end
