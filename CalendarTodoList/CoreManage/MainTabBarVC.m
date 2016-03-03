//
//  MainTabBarVC.m
//  CalendarTodoList
//
//  Created by 牛严 on 15/12/25.
//  Copyright © 2015年 牛严. All rights reserved.
//

#import "MainTabBarVC.h"
#import "CalendarVC.h"
#import <Realm/Realm.h>
#import "RLMTodo.h"
#import "RLMProject.h"
#import "CalendarVC.h"
#import "BaseNavigationController.h"
#import "RLMProject.h"
#import "UserDefaultManage.h"

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
//    [self simulateProject];
//    [self simulateTodoList];
    
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
    
    RLMRealm *realm = [RLMRealm defaultRealm];
    RLMTodo *todoModel = [[RLMTodo alloc]init];

    RLMProject *type = [[RLMProject objectsWhere:@"projectId = 3"] firstObject];
    todoModel.project = type;
    todoModel.thingStr = @"开始创建你的任务吧！";
    NSDate *startDate = [NSDate dateWithTimeInterval:60*10 sinceDate:[NSDate date]];
    todoModel.startTime = [startDate timeIntervalSinceReferenceDate];
//    todoModel.endTime = todoModel.startTime + 60 * 60;
    todoModel.tableId = 1;
    todoModel.doneType = NotStart;
    
    [realm beginWriteTransaction];
    [RLMTodo createOrUpdateInRealm:realm withValue:todoModel];
    [realm commitWriteTransaction];
    
}

- (void)simulateProject
{
    RLMRealm *realm = [RLMRealm defaultRealm];
    RLMProject *rlmProject = [[RLMProject alloc]init];
    
    rlmProject.projectId = 1;
    rlmProject.projectStr = @"学习";
    rlmProject.red = 251;
    rlmProject.green = 136;
    rlmProject.blue = 110;
    [realm beginWriteTransaction];
    [RLMProject createOrUpdateInRealm:realm withValue:rlmProject];
    [realm commitWriteTransaction];
    
    rlmProject.projectId = 2;
    rlmProject.projectStr = @"社团";
    rlmProject.red = 59;
    rlmProject.green = 213;
    rlmProject.blue = 251;
    [realm beginWriteTransaction];
    [RLMProject createOrUpdateInRealm:realm withValue:rlmProject];
    [realm commitWriteTransaction];
    
    rlmProject.projectId = 3;
    rlmProject.projectStr = @"个人";
    rlmProject.red = 255;
    rlmProject.green = 204;
    rlmProject.blue = 0;
    
    [realm beginWriteTransaction];
    [RLMProject createOrUpdateInRealm:realm withValue:rlmProject];
    [realm commitWriteTransaction];
    
    rlmProject.projectId = 4;
    rlmProject.projectStr = @"工作";
    rlmProject.red = 226;
    rlmProject.green = 168;
    rlmProject.blue = 228;
    
    [realm beginWriteTransaction];
    [RLMProject createOrUpdateInRealm:realm withValue:rlmProject];
    [realm commitWriteTransaction];
    
    rlmProject.projectId = 5;
    rlmProject.projectStr = @"休闲";
    rlmProject.red = 210;
    rlmProject.green = 184;
    rlmProject.blue = 163;
    
    [realm beginWriteTransaction];
    [RLMProject createOrUpdateInRealm:realm withValue:rlmProject];
    [realm commitWriteTransaction];
}

@end
