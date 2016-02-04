//
//  RealmManage.m
//  CalendarTodoList
//
//  Created by 牛严 on 16/1/27.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import "RealmManage.h"

#import "RLMThing.h"
#import "RLMTodoList.h"
#import "Thing.h"
#import "TodoList.h"

#import "NSString+ZZExtends.h"

@implementation RealmManage

+ (id)sharedInstance
{
    static RealmManage *sharedInstance = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

#pragma mark 根据dayId获取todolist数组
- (NSArray *)getDayInfoFromRealmWithDayId:(NSInteger)dayId
{
    RLMResults *result = [RLMTodoList objectsWhere:@"dayId = %ld",dayId];
    NSMutableArray *resultArray = [NSMutableArray arrayWithCapacity:result.count];
    if (result.count == 0) {
        return nil;
    }
    for (int i = 0; i < result.count; i ++)
    {
        RLMTodoList *RLMTodoList = [result objectAtIndex:i];
        
        TodoList *todolist = [[TodoList alloc]init];
        todolist.dayId = RLMTodoList.dayId;
        todolist.startTime = RLMTodoList.startTime;
        todolist.endTime = RLMTodoList.endTime;
        
        todolist.thing = [[Thing alloc]init];
        todolist.thing.thingStr = RLMTodoList.thing.thingStr;
        
        todolist.thing.thingType = [[ThingType alloc]init];
        todolist.thing.thingType.typeId = RLMTodoList.thing.thingType.typeId;
        todolist.thing.thingType.typeStr = RLMTodoList.thing.thingType.typeStr;
        todolist.thing.thingType.red = RLMTodoList.thing.thingType.red;
        todolist.thing.thingType.green = RLMTodoList.thing.thingType.green;
        todolist.thing.thingType.blue = RLMTodoList.thing.thingType.blue;
        
        NSString *todoListStr;
        if (RLMTodoList) {
            NSString *timeStr = [NSString getHourMinuteDateFromTimeInterval:RLMTodoList.startTime];
            todoListStr = [NSString stringWithFormat:@"%@  %@",timeStr,RLMTodoList.thing.thingStr];
            todolist.briefStr = todoListStr;
            [resultArray addObject:todolist];
        }
    }
    return resultArray;
}

#pragma mark 根据thingTypeId返回类型字符串
- (NSString *)getThingTypeStrWithThingType:(NSInteger)typeId
{
    RLMResults *result = [RLMThingType objectsWhere:@"typeId = %ld",typeId];
    RLMThingType *type = [result firstObject];
    NSString *typeStr = type.typeStr;
    return typeStr;
}

#pragma mark 获取ThingType数组
- (NSArray *)getThingTypeArray
{
    RLMResults *result = [RLMThingType allObjects];
    NSMutableArray *resultArray = [NSMutableArray arrayWithCapacity:0];
    if (result.count == 0) {
        return nil;
    }
    if (result) {
        for (int i = 0; i < result.count; i ++) {
            RLMThingType *rlmThingType = [result objectAtIndex:i];
            ThingType *thingType = [[ThingType alloc]init];
            thingType.typeId = rlmThingType.typeId;
            thingType.typeStr = rlmThingType.typeStr;
            thingType.red = rlmThingType.red;
            thingType.green = rlmThingType.green;
            thingType.blue = rlmThingType.blue;
            
            [resultArray addObject:thingType];
        }
    }
    return resultArray;
}

@end
