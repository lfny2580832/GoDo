//
//  DatePickerCell.h
//  CalendarTodoList
//
//  Created by 牛严 on 16/2/9.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DatePickerCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIDatePicker *datePicker;

@property (nonatomic, assign) UIDatePickerMode datePickerMode;

- (void)setDatePickerMode:(UIDatePickerMode )datePickerMode date:(NSDate *)date;

@end
