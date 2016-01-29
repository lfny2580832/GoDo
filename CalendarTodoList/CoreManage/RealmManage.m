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

#pragma mark 根据dayId获取概要数组，概要（hh:mm 体育）
- (NSArray *)getDayInfoBriefFromRealmWithDayId:(NSInteger)dayId
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
        todolist.thing.thingType = RLMTodoList.thing.thingType;
                
        NSString *todoListStr;
        if (RLMTodoList) {
            NSString *typeStr;
            switch (RLMTodoList.thing.thingType)
            {
                case 0:typeStr = @"学习";break;
                case 1:typeStr = @"娱乐";break;
                case 2:typeStr = @"体育";break;
                case 3:typeStr = @"社团";break;
                case 4:typeStr = @"组织";break;
                default:break;
            }
            NSString *timeStr = [NSString getHourMinuteDateFromTimeInterval:RLMTodoList.startTime];
            todoListStr = [NSString stringWithFormat:@"%@%@",timeStr,RLMTodoList.thing.thingStr];
            todolist.briefStr = todoListStr;
            [resultArray addObject:todolist];
        }
    }
    return resultArray;
}

@end
