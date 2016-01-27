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
#import "RLMTodoList.h"
#import "RLMThing.h"
#import "CalendarVC.h"
#import "BaseNavigationController.h"

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
    RLMRealm *realm = [RLMRealm defaultRealm];
    RLMThing *thing = [[RLMThing alloc]init];
    thing.thingType = Study;
    thing.thingStr = @"学习《iOS编程实战》";
    RLMTodoList *todolistModel = [[RLMTodoList alloc]init];
    todolistModel.dayId = 20160118;
    todolistModel.timeStamp = [NSDate timeIntervalSinceReferenceDate];
    todolistModel.thing = thing;
    
    [realm beginWriteTransaction];
    [RLMTodoList createOrUpdateInRealm:realm withValue:todolistModel];
    [realm commitWriteTransaction];
    
    CalendarVC *calendarVC = [[CalendarVC alloc]init];
    BaseNavigationController *calendarNavVC = [[BaseNavigationController alloc]initWithRootViewController:calendarVC];
    [calendarVC setTitle:@"日历"];
    
    UINavigationController *secondController = [[UINavigationController alloc]init];
    [secondController setTitle:@"second"];
    
    [self setViewControllers:@[calendarNavVC, secondController]];
    
}


@end
