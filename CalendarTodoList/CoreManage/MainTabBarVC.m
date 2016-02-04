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
#import "RLMThingType.h"
#import "CalendarVC.h"
#import "BaseNavigationController.h"
#import "RLMThingType.h"

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
//    [self simulateThingType];
//
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
    RLMRealm *realm = [RLMRealm defaultRealm];
    RLMThing *thing = [[RLMThing alloc]init];
    RLMThingType *type = [[RLMThingType objectsWhere:@"typeId = 2"] firstObject];
    thing.thingType = type;
    thing.thingStr = @"qq音速";
    RLMTodoList *todolistModel = [[RLMTodoList alloc]init];
    todolistModel.dayId = 20160204;
    todolistModel.startTime = [NSDate timeIntervalSinceReferenceDate];
    todolistModel.endTime = todolistModel.startTime + 60 * 24;
    todolistModel.thing = thing;
    
    [realm beginWriteTransaction];
    [RLMTodoList createOrUpdateInRealm:realm withValue:todolistModel];
    [realm commitWriteTransaction];
}

- (void)simulateThingType
{
    RLMRealm *realm = [RLMRealm defaultRealm];
    RLMThingType *rlmThingType = [[RLMThingType alloc]init];
    rlmThingType.typeId = 2;
    rlmThingType.typeStr = @"社团";
    rlmThingType.red = 59;
    rlmThingType.green = 213;
    rlmThingType.blue = 251;
    
    [realm beginWriteTransaction];
    [RLMThingType createOrUpdateInRealm:realm withValue:rlmThingType];
    [realm commitWriteTransaction];
}

@end
