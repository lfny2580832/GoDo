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
#import "MineVC.h"

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
    _calendarNavVC = [[BaseNavigationController alloc]initWithRootViewController:calendarVC];
    [_calendarNavVC setTitle:@"日程"];
    _calendarNavVC.tabBarItem.image = [UIImage imageNamed:@"ico_calendar.png"];

    
    ProjectVC *projectVC = [[ProjectVC alloc]init];
    _projectNavVC = [[BaseNavigationController alloc]initWithRootViewController:projectVC];
    [_projectNavVC setTitle:@"项目"];
    _projectNavVC.tabBarItem.image = [UIImage imageNamed:@"ico_project.png"];
    
    MineVC *mineVC = [[MineVC alloc]init];
    _mineNavVC = [[BaseNavigationController alloc]initWithRootViewController:mineVC];
    [_mineNavVC setTitle:@"我的"];
    _mineNavVC.tabBarItem.image = [UIImage imageNamed:@"ico_mine.png"];

    [self setViewControllers:@[_calendarNavVC,_projectNavVC,_mineNavVC]];
}

@end
