//
//  RepeateModeVC.h
//  CalendarTodoList
//
//  Created by 牛严 on 16/3/4.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMTodoModel.h"

@protocol RepeatModeChooseVCDelegate <NSObject>

- (void)returnRepeatModeWith:(RepeatMode)repeatMode modeName:(NSString *)modeName;

@end

@interface RepeateModeChooseVC : UIViewController

@property (nonatomic ,weak)id <RepeatModeChooseVCDelegate>delegate;

@end
