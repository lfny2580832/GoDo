//
//  TodoListModel.m
//  CalendarTodoList
//
//  Created by 牛严 on 16/1/5.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import "RLMTodoList.h"

@implementation RLMTodoList
@synthesize thing;

+ (NSString *) primaryKey
{
    return @"startTime";
}

@end
