//
//  RemindModeChooseVC.h
//  CalendarTodoList
//
//  Created by 牛严 on 16/3/27.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMTodoModel.h"


@protocol RemindModeChooseVCDelegate <NSObject>

- (void)returnRemindModeWith:(RemindMode)remindMode modeName:(NSString *)modeName;

@end

@interface RemindModeChooseVC : UIViewController

@property (nonatomic, weak) id <RemindModeChooseVCDelegate> delegate;

@end
