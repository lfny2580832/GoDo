//
//  TodoDetailVC.h
//  CalendarTodoList
//
//  Created by 牛严 on 16/1/31.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FMTodoModel;

@interface TodoDetailVC : UIViewController

@property (nonatomic, strong) FMTodoModel *todo;

- (instancetype)initWithDate:(NSDate *)date;

@end
