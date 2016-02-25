//
//  RealmManage.m
//  CalendarTodoList
//
//  Created by 牛严 on 16/1/27.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import "RealmManage.h"
#import "UserDefaultManage.h"

#import "RLMThing.h"
#import "RLMTodo.h"
#import "RLMThingType.h"

#import "Thing.h"
#import "Todo.h"
#import "ThingType.h"

#import "NSString+ZZExtends.h"
#import "NSObject+NYExtends.h"

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

#pragma mark 根据dayId获取todo数组
- (NSArray *)getDayInfoFromRealmWithDayId:(NSInteger)dayId
{
    RLMResults *result = [RLMTodo objectsWhere:@"dayId = %ld",dayId];
    NSMutableArray *resultArray = [NSMutableArray arrayWithCapacity:result.count];
    if (result.count == 0) {
        return nil;
    }
    for (int i = 0; i < result.count; i ++)
    {
        RLMTodo *RLMTodo = [result objectAtIndex:i];
        
        Todo *todo = [[Todo alloc]init];
        todo.startTime = RLMTodo.startTime;
        todo.endTime = RLMTodo.endTime;
        todo.tableId = RLMTodo.tableId;
        
        todo.thing = [[Thing alloc]init];
        todo.thing.thingStr = RLMTodo.thing.thingStr;
        
        todo.thing.thingType = [[ThingType alloc]init];
        todo.thing.thingType.typeId = RLMTodo.thing.thingType.typeId;
        todo.thing.thingType.typeStr = RLMTodo.thing.thingType.typeStr;
        todo.thing.thingType.red = RLMTodo.thing.thingType.red;
        todo.thing.thingType.green = RLMTodo.thing.thingType.green;
        todo.thing.thingType.blue = RLMTodo.thing.thingType.blue;
        
        if (RLMTodo.thing.imageDatas.count) {
            NSMutableArray *images = [[NSMutableArray alloc]initWithCapacity:0];
            for(RLMImage *rlmImage in RLMTodo.thing.imageDatas)
            {
                UIImage *image = [UIImage imageWithData:rlmImage.imageData];
                [images addObject:image];
            }
            todo.thing.images = (NSArray *)images;
        }
        
        if (RLMTodo.doneType == Done) {
            todo.doneType = Done;
        }
        else
        {
            long long nowStamp = [[NSDate date] timeIntervalSinceReferenceDate];
            if (nowStamp > todo.endTime)
                todo.doneType = OutOfDate;
            else if (todo.startTime < nowStamp && nowStamp < todo.endTime)
                todo.doneType = Doing;
            else if (nowStamp < todo.startTime)
                todo.doneType = NotStart;
        }
        [resultArray addObject:todo];
    }
    return [self sortArrayByStartTimeWithArray:resultArray];
}

#pragma mark 根据开始时间进行排序
- (NSArray *)sortArrayByStartTimeWithArray:(NSArray *)array
{
    NSComparator cmptr = ^(Todo *todo1, Todo *todo2){
        if (todo1.startTime > todo2.startTime) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        
        if (todo1.startTime < todo2.startTime) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        return (NSComparisonResult)NSOrderedSame;
    };
    
    NSArray *finalArray = [array sortedArrayUsingComparator:cmptr];
    return finalArray;
}


#pragma mark 创建RLMTodo
- (void)createTodoWithThingType:(ThingType *)type contentStr:(NSString *)contentStr contentImages:(NSArray *)images startDate:(NSDate *)startDate endDate:(NSDate *)endDate tableId:(NSInteger)tableId
{
    RLMRealm *realm = [RLMRealm defaultRealm];

    RLMTodo *todoModel = [[RLMTodo alloc]init];
    todoModel.startTime = [startDate timeIntervalSinceReferenceDate];
    todoModel.endTime = [endDate timeIntervalSinceReferenceDate];
    
    RLMThing *thing = [[RLMThing alloc]init];
    RLMThingType *thingType = [[RLMThingType alloc]init];
    thingType.typeId = type.typeId;
    thingType.typeStr = type.typeStr;
    thingType.red = type.red;
    thingType.green = type.green;
    thingType.blue = type.blue;
    thing.thingType = thingType;
    thing.thingStr = contentStr;
    
    if (images.count) {
        for(UIImage *image in images)
        {
            RLMImage *rlmImage = [[RLMImage alloc]init];
            NSData *imageData = UIImageJPEGRepresentation(image,1);
            rlmImage.imageData = imageData;
            [thing.imageDatas addObject:rlmImage];
        }
    }
    
    todoModel.thing = thing;
    
    
    if (!tableId) {
        todoModel.tableId = [UserDefaultManager todoMaxId] + 1;
        [UserDefaultManager setTodoMaxId:todoModel.tableId];
    }else
        todoModel.tableId = tableId;

    
    [realm beginWriteTransaction];
    [RLMTodo createOrUpdateInRealm:realm withValue:todoModel];
    [realm commitWriteTransaction];
}

#pragma mark 根据thingTypeId返回thingType
- (ThingType *)getThingTypeWithThingTypeId:(NSInteger)typeId
{
    RLMResults *result = [RLMThingType objectsWhere:@"typeId = %ld",typeId];
    RLMThingType *rlmThingtype = [result firstObject];
    ThingType *thingType = [[ThingType alloc]init];
    thingType.typeId = rlmThingtype.typeId;
    thingType.typeStr = rlmThingtype.typeStr;
    thingType.red = rlmThingtype.red;
    thingType.green = rlmThingtype.green;
    thingType.blue = rlmThingtype.blue;
    
    return thingType;
}

#pragma mark 获取ThingType数组
- (NSMutableArray *)getThingTypeArray
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

#pragma mark 删除todo
- (void)deleteTodoWithTableId:(NSInteger)tableId
{
    RLMRealm *realm = [RLMRealm defaultRealm];

    RLMResults *results = [RLMTodo objectsWhere:@"tableId = %d",tableId];
    [realm beginWriteTransaction];
    [realm deleteObject:results[0]];
    [realm commitWriteTransaction];
}

@end
