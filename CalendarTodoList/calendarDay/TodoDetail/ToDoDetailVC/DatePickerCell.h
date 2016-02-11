//
//  DatePickerCell.h
//  CalendarTodoList
//
//  Created by 牛严 on 16/2/9.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DatePickerCellDelegate <NSObject>

- (void)returnStartDate:(NSDate *)startDate endDate:(NSDate *)endDate;

@end

@interface DatePickerCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIDatePicker *datePicker;
@property (nonatomic, strong) UILabel *dateLabel;

@property (nonatomic, assign) UIDatePickerMode datePickerMode;

@property (nonatomic, weak) id<DatePickerCellDelegate> delegate;

- (void)setDatePickerMode:(UIDatePickerMode )datePickerMode date:(NSDate *)date;

@end
