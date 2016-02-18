//
//  TodoTableViewCell.h
//  CalendarTodoList
//
//  Created by 牛严 on 16/1/19.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TodoList.h"
#import "Thing.h"

@interface TodoTableViewCell : UITableViewCell

@property (nonatomic, strong) TodoList *todoList;

@end
