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
    
    CalendarVC *calendarVC = [[CalendarVC alloc]init];
    BaseNavigationController *calendarNavVC = [[BaseNavigationController alloc]initWithRootViewController:calendarVC];
    [calendarVC setTitle:@"日历"];
    
    UINavigationController *secondController = [[UINavigationController alloc]init];
    [secondController setTitle:@"second"];
    
    [self setViewControllers:@[calendarNavVC, secondController]];
    
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
    todoModel.isAllDay = NO;
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
}

@end
