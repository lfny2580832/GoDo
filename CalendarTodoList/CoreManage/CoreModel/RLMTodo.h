//
//  TodoListModel.h
//  CalendarTodoList
//
//  Created by 牛严 on 16/1/5.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import <Realm/Realm.h>
#import "RLMProject.h"
#import "RLMImage.h"

//完成状态
typedef NS_ENUM(NSInteger, DoneType)
{
    NotDone,            //未完成
    Done                //已完成
};
//重复状态
typedef NS_ENUM(NSInteger, RepeatMode)
{
    Never = 0,          //不重复
    EveryDay,           //每天
    EveryWeek,          //每周当天
    EveryMonth,         //每月当天
    EveryWorkDay,       //每个工作日
    EveryWeekend       //每个周末
};

@interface RLMTodo : RLMObject

@property (nonatomic, assign) NSInteger tableId;
/////dayId 为年月日，如 20160106
//@property (nonatomic, assign) NSInteger dayId;
///开始时间戳 精确到秒
@property (nonatomic, assign) long long startTime;
/////结束时间
//@property (nonatomic, assign) long long endTime;
///事件类型
@property RLMProject *project;
///项目ID
@property NSInteger projectId;
///事件字符串
@property NSString *thingStr;
///图片数组
@property RLMArray <RLMImage>* imageDatas;
//完成情况
@property (nonatomic, assign) DoneType doneType;
//重复模式
@property (nonatomic, assign) RepeatMode repeatMode;
//每周几 或者 每月几号，int 
@property (nonatomic, assign) NSInteger repeatParam;

@end
