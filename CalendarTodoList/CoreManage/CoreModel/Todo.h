//
//  TodoList.h
//  CalendarTodoList
//
//  Created by 牛严 on 16/1/28.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RLMTodo.h"
#import "Project.h"

@interface Todo : NSObject

@property (nonatomic, assign) NSInteger tableId;
/////dayId 为年月日，如 20160106
//@property (nonatomic, assign) NSInteger dayId;

///开始时间戳 精确到秒
@property (nonatomic, assign) long long startTime;
/////结束时间
//@property (nonatomic, assign) long long endTime;
///事件类型
@property (nonatomic, strong) Project *project;
///项目ID
@property NSInteger projectId;
///事件字符串
@property (nonatomic, copy)   NSString *thingStr;
///图片数组
@property (nonatomic, strong) NSArray *images;
///完成情况
@property (nonatomic, assign) DoneType doneType;
//重复模式
@property (nonatomic, assign) RepeatMode repeatMode;
//每周几 或者 每月几号，int
@property (nonatomic, assign) NSInteger repeatParam;

@end
