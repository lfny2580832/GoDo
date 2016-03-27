//
//  FMTodoModel.h
//  CalendarTodoList
//
//  Created by 牛严 on 16/3/13.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <LKDBHelper/LKDBHelper.h>

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
};
//提醒模式
typedef NS_ENUM(NSInteger, RemindMode)
{
    NoRemind = 0,               //不提醒
    OnTime,                     //准时提醒
    FiveMinutesEarlier,         //五分钟前
    TenMinutesEarlier,
    FifteenMinutesEarlier,
    ThirtyMinutesEarlier
};

@interface FMProject : NSObject
///事件类型ID 主键
@property (nonatomic, assign) NSInteger projectId;
///事件类型字符串
@property (nonatomic, copy) NSString *projectStr;
///事件类型标记颜色
@property (nonatomic, assign) NSInteger red;
@property (nonatomic, assign) NSInteger green;
@property (nonatomic, assign) NSInteger blue;

@end

@interface FMTodoModel : NSObject

@property (nonatomic, assign) NSInteger tableId;
///开始时间戳 精确到秒
@property (nonatomic, assign) long long startTime;
///是否全天
@property (nonatomic, assign) BOOL isAllDay;
///事件类型
@property (nonatomic, strong) FMProject *project;
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
//提醒模式(重复任务不能设置提醒)
@property (nonatomic, assign) RemindMode remindMode;

@end

