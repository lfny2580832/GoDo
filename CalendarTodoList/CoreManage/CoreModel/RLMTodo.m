//
//  TodoListModel.m
//  CalendarTodoList
//
//  Created by 牛严 on 16/1/5.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import "RLMTodo.h"
#import "NSObject+NYExtends.h"

@implementation RLMTodo

+ (NSString *) primaryKey
{
    return @"tableId";
}

- (void)setStartTime:(long long)startTime
{
    _startTime = startTime;
    _dayId = [NSObject getDayIdWithDateStamp:startTime];
}

@end
