//
//  ChooseModeCell.h
//  CalendarTodoList
//
//  Created by 牛严 on 16/2/10.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ChooseModeCellDelegate <NSObject>

- (void)datePickerModeValueChanged:(BOOL)value;

@end

@interface ChooseModeCell : UITableViewCell

@property (nonatomic, strong)UISwitch *switchButton;

@property (nonatomic, weak) id<ChooseModeCellDelegate> delegate;

@end
