//
//  MainTabBarVC.m
//  CalendarTodoList
//
//  Created by 牛严 on 15/12/25.
//  Copyright © 2015年 牛严. All rights reserved.
//

#import "MainTabBarVC.h"
#import "CalendarVC.h"
#import "ProjectVC.h"

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
    CalendarVC *calendarVC = [[CalendarVC alloc]init];
    BaseNavigationController *calendarNavVC = [[BaseNavigationController alloc]initWithRootViewController:calendarVC];
    [calendarVC setTitle:@"日历"];
    
    ProjectVC *projectVC = [[ProjectVC alloc]init];
    BaseNavigationController *projectNavVC = [[BaseNavigationController alloc]initWithRootViewController:projectVC];

    [projectNavVC setTitle:@"项目"];
    
    [self setViewControllers:@[calendarNavVC,projectNavVC]];
}

@end
