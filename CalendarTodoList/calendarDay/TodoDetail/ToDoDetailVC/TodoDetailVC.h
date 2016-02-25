//
//  TodoDetailVC.h
//  CalendarTodoList
//
//  Created by 牛严 on 16/1/31.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Todo;

@interface TodoDetailVC : UIViewController

@property (nonatomic, strong) Todo *todo;

- (instancetype)initWithDate:(NSDate *)date;

@end
