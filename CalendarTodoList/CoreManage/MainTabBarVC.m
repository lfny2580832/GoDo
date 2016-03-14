//
//  MainTabBarVC.m
//  CalendarTodoList
//
//  Created by 牛严 on 15/12/25.
//  Copyright © 2015年 牛严. All rights reserved.
//

#import "MainTabBarVC.h"
#import "CalendarVC.h"
#import "BaseNavigationController.h"
#import "UserDefaultManage.h"

#import "FMTodoModel.h"
#import "FMDayList.h"

#import <LKDBHelper/LKDBHelper.h>
#import "NSObject+NYExtends.h"

@interface MainTabBarVC ()

@end

@implementation MainTabBarVC

#pragma mark 初始化方法
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initViews];
    }
    return self;
}

- (void)initViews
{
    [self simulateProject];
    [self simulateTodoList];
    [self dayIDsForEveryMonthRepeatWithStartDate:[NSDate date]];
    
    CalendarVC *calendarVC = [[CalendarVC alloc]init];
    BaseNavigationController *calendarNavVC = [[BaseNavigationController alloc]initWithRootViewController:calendarVC];
    [calendarVC setTitle:@"日历"];
    
    UINavigationController *secondController = [[UINavigationController alloc]init];
    [secondController setTitle:@"second"];
    
    [self setViewControllers:@[calendarNavVC, secondController]];
    
}
#pragma mark 根据当前日期返回repeatMode为EveryMonth的DayID
- (void)dayIDsForEveryMonthRepeatWithStartDate:(NSDate *)startDate
{
    NSMutableArray *dayIDs = [[NSMutableArray alloc]initWithCapacity:0];
    long long  currentDayTimeStamp = [startDate timeIntervalSinceReferenceDate];
    
    NSDateComponents *comps = [[NSCalendar currentCalendar] components:NSCalendarUnitWeekOfYear|NSCalendarUnitWeekday|NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear |NSCalendarUnitHour |NSCalendarUnitMinute fromDate:startDate];
    //第一周的dayIDs
    long long timeStamp = 0;
    NSInteger firstWeekNum = comps.weekday > 1 ? 9-comps.weekday:1;
    
    for(int i = 0 ; i < firstWeekNum; i ++)
    {
        timeStamp = currentDayTimeStamp + 60 * 60 * 24 * i;
        if (i < 5) {
            NSInteger dayID = [NSObject getDayIdWithDateStamp:timeStamp];
            [dayIDs addObject:[NSNumber numberWithInteger:dayID]];
        }
    }
    //中间周的dayIDs
    NSInteger otherDayNum = 365 - firstWeekNum;
    NSInteger midWeekNum = floorf(otherDayNum/7);//去头去尾，中间有多少个周
    for(int i = 0 ;i < midWeekNum; i ++)
    {
        for(int j = 0;j < 7;j ++)
        {
            timeStamp = timeStamp + 60 * 60 * 24;
            if (j < 5) {
                NSInteger dayID = [NSObject getDayIdWithDateStamp:timeStamp];
                [dayIDs addObject:[NSNumber numberWithInteger:dayID]];
            }
        }
    }
    //最后一周
    for(int i = 0; i < otherDayNum - 7*midWeekNum; i ++)
    {
        if (i < 5) {
            timeStamp = timeStamp + 60 * 60 * 24;
            NSInteger dayID = [NSObject getDayIdWithDateStamp:timeStamp];
            [dayIDs addObject:[NSNumber numberWithInteger:dayID]];
        }
    }
}

- (void)simulateTodoList
{
    [UserDefaultManager setTodoMaxId:1];
    
    LKDBHelper *DBHelper = [FMTodoModel getUsingLKDBHelper];
    [LKDBHelper clearTableData:[FMTodoModel class]];
    
    FMTodoModel *todoModel = [[FMTodoModel alloc]init];
    todoModel.tableId = 1;
    todoModel.thingStr = @"开始创建你的任务吧！";
    NSDate *startDate = [NSDate dateWithTimeInterval:60*10 sinceDate:[NSDate date]];
    todoModel.startTime = [startDate timeIntervalSinceReferenceDate];
    todoModel.doneType = NotDone;
    todoModel.repeatMode = Never;
    FMProject *project = [[DBHelper searchWithSQL:@"select * from @t where projectId = '3'" toClass:[FMProject class]] firstObject];
    todoModel.project = project;
    
    [DBHelper insertToDB:todoModel];
    
    FMDayList *dayList = [[FMDayList alloc]init];
    dayList.dayID = [NSObject getDayIdWithDateStamp:[startDate timeIntervalSinceReferenceDate]];
    dayList.tableIDs = [[NSMutableArray alloc]init];
    [dayList.tableIDs addObject:[NSNumber numberWithInteger:todoModel.tableId]];
    
    [[FMDayList getUsingLKDBHelper] insertToDB:dayList];
}

- (void)simulateProject
{
    LKDBHelper *DBHelper = [[LKDBHelper alloc]init];
    [LKDBHelper clearTableData:[FMProject class]];
    FMProject *project = [[FMProject alloc]init];
    project.projectId = 1;
    project.projectStr = @"学习";
    project.red = 251;
    project.green = 136;
    project.blue = 110;
    
    [DBHelper insertToDB:project];
    
    project.projectId = 2;
    project.projectStr = @"社团";
    project.red = 59;
    project.green = 213;
    project.blue = 251;
    
    [DBHelper insertToDB:project];
    
    project.projectId = 3;
    project.projectStr = @"个人";
    project.red = 255;
    project.green = 204;
    project.blue = 0;
    
    [DBHelper insertToDB:project];
    
    project.projectId = 4;
    project.projectStr = @"工作";
    project.red = 226;
    project.green = 168;
    project.blue = 228;
    
    [DBHelper insertToDB:project];
    
    project.projectId = 5;
    project.projectStr = @"休闲";
    project.red = 210;
    project.green = 184;
    project.blue = 163;
    
    [DBHelper insertToDB:project];
    
    NSMutableArray *projectArray = [DBHelper searchWithSQL:@"select * from @t" toClass:[FMProject class]];
    for (int i = 0; i < projectArray.count; i ++) {
        FMProject *resultproject = projectArray[i];
        NSLog(@"shit %@",resultproject.projectStr);
    }
}

@end
