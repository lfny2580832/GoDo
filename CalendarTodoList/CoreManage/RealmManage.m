//
//  RealmManage.m
//  CalendarTodoList
//
//  Created by 牛严 on 16/1/27.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import "RealmManage.h"
#import "UserDefaultManage.h"

#import "RLMProject.h"
#import "RLMDateList.h"

#import "Todo.h"
#import "Project.h"

#import "NSString+ZZExtends.h"
#import "NSObject+NYExtends.h"

#define defalultRealm [RLMRealm defaultRealm]

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
//        todo.endTime = RLMTodo.endTime;
        todo.tableId = RLMTodo.tableId;
        
        todo.thingStr = RLMTodo.thingStr;
        
        todo.project = [[Project alloc]init];
        todo.projectId = RLMTodo.projectId;
        todo.project.projectId = RLMTodo.project.projectId;
        todo.project.projectStr = RLMTodo.project.projectStr;
        todo.project.red = RLMTodo.project.red;
        todo.project.green = RLMTodo.project.green;
        todo.project.blue = RLMTodo.project.blue;
        
        if (RLMTodo.imageDatas.count) {
            NSMutableArray *images = [[NSMutableArray alloc]initWithCapacity:0];
            for(RLMImage *rlmImage in RLMTodo.imageDatas)
            {
                UIImage *image = [UIImage imageWithData:rlmImage.imageData];
                [images addObject:image];
            }
            todo.images = (NSArray *)images;
        }
        
        if (RLMTodo.doneType == Done) {
            todo.doneType = Done;
        }
//        else
//        {
//            long long nowStamp = [[NSDate date] timeIntervalSinceReferenceDate];
//            if (nowStamp > todo.endTime)
//                todo.doneType = OutOfDate;
//            else if (todo.startTime < nowStamp && nowStamp < todo.endTime)
//                todo.doneType = Doing;
//            else if (nowStamp < todo.startTime)
//                todo.doneType = NotStart;
//        }
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
- (void)createTodoWithProject:(Project *)project contentStr:(NSString *)contentStr contentImages:(NSArray *)images startDate:(NSDate *)startDate oldStartDate:(NSDate *)oldStartDate tableId:(NSInteger)tableId repeatMode:(RepeatMode)repeatMode
{
    RLMRealm *realm = [RLMRealm defaultRealm];

    RLMTodo *todoModel = [[RLMTodo alloc]init];

    todoModel.startTime = [startDate timeIntervalSinceReferenceDate];
    //    todoModel.endTime = [endDate timeIntervalSinceReferenceDate];
    RLMProject *rlmProject = [[RLMProject alloc]init];
    rlmProject.projectId = project.projectId;
    rlmProject.projectStr = project.projectStr;
    rlmProject.red = project.red;
    rlmProject.green = project.green;
    rlmProject.blue = project.blue;
    todoModel.project = rlmProject;
    todoModel.projectId = project.projectId;
    todoModel.thingStr = contentStr;
    if (images.count) {
        for(UIImage *image in images)
        {
            RLMImage *rlmImage = [[RLMImage alloc]init];
            NSData *imageData = UIImageJPEGRepresentation(image,1);
            rlmImage.imageData = imageData;
            [todoModel.imageDatas addObject:rlmImage];
        }
    }
    
    if (!tableId) {
        todoModel.tableId = [UserDefaultManager todoMaxId] + 1;
        [UserDefaultManager setTodoMaxId:todoModel.tableId];
    }else{
        todoModel.tableId = tableId;
    }
    [realm beginWriteTransaction];
    [RLMTodo createOrUpdateInRealm:realm withValue:todoModel];
    [realm commitWriteTransaction];
    
    [self CreateOrUpdateDateListWithStartDate:startDate oldStartDate:oldStartDate repeatMode:repeatMode RLMTodo:todoModel];

}

#pragma mark 根据老时间和todo.tableID 删除那天对应的任务
- (void)deleteOldTodoWithOldStartDate:(NSDate *)oldStartDate tableID:(NSInteger)tableID
{
    NSInteger dayID = [NSObject getDayIdWithDate:oldStartDate];
    RLMResults *result = [RLMDateList objectsWhere:@"dayID = %d",dayID];
    RLMDateList *rlmDateList = [result firstObject];
    for (int i = 0 ; i < rlmDateList.todoIDs.count; i++)
    {
        RLMTodoID *rlmTodoID = [rlmDateList.todoIDs objectAtIndex:i];
        NSInteger todoID = [rlmTodoID.tableId integerValue];
        if (todoID == tableID)
        {
            [rlmDateList.todoIDs removeObjectAtIndex:i];
            
            [defalultRealm beginWriteTransaction];
            [RLMTodo createOrUpdateInRealm:defalultRealm withValue:rlmDateList];
            [defalultRealm commitWriteTransaction];
            
            return;
        }
    }
}

#pragma mark 新建更新day与tableId关系数据
- (void)CreateOrUpdateDateListWithStartDate:(NSDate *)startDate oldStartDate:(NSDate *)oldStartDate repeatMode:(RepeatMode)repeatMode RLMTodo:(RLMTodo *)rlmTodo
{
    if (oldStartDate) {
        //存在表示修改过时间，删除之前的记录
        [self deleteOldTodoWithOldStartDate:oldStartDate tableID:rlmTodo.tableId];
    }
    
    NSInteger dayID = [NSObject getDayIdWithDate:startDate];
    if (repeatMode == Never)
    {
        RLMResults *result = [RLMDateList objectsWhere:@"dayID = %d",dayID];
        RLMDateList *rlmDateList = [result firstObject];
        if (rlmDateList)
        {
            BOOL exsit = NO;
            for(RLMTodoID *rlmTodoID in rlmDateList.todoIDs)
            {
                NSInteger tableId = [rlmTodoID.tableId integerValue];
                if (tableId == rlmTodo.tableId ) {
                    //任务已存在，不进行操作
                    exsit = YES;
                }
            }
            if (!exsit)
            {
                //任务不存在，添加元素
                RLMTodoID *rlmTodoID = [[RLMTodoID alloc]init];
                rlmTodoID.tableId = [NSNumber numberWithInteger:rlmTodo.tableId];
                [rlmDateList.todoIDs addObject:rlmTodoID];
            }
        }
        else
        {
            //当天日期任务对应表不存在，先建表再插入数据
            rlmDateList = [[RLMDateList alloc]init];
            rlmDateList.dayID = dayID;
            
            RLMTodoID *rlmTodoID = [[RLMTodoID alloc]init];
            rlmTodoID.tableId = [NSNumber numberWithInteger:rlmTodo.tableId];
            [rlmDateList.todoIDs addObject:rlmTodoID];
        }
    }
}

#pragma mark 根据todo tableID 修改todo 的doneType完成情况
- (void)changeTodoDoneTypeWithTableId:(NSInteger)tableId doneType:(DoneType)doneType
{
    RLMRealm *realm = [RLMRealm defaultRealm];
    RLMResults *result = [RLMTodo objectsWhere:@"tableId = %ld",tableId];
    
    [realm beginWriteTransaction];
    
    RLMTodo *rlmTodo = [result firstObject];
    rlmTodo.doneType = doneType;
    [RLMTodo createOrUpdateInRealm:realm withValue:rlmTodo];
    
    [realm commitWriteTransaction];
    
}

#pragma mark 根据projectId返回project
- (Project *)getProjectWithId:(NSInteger)projectId
{
    RLMResults *result = [RLMProject objectsWhere:@"projectId = %ld",projectId];
    RLMProject *rlmProject = [result firstObject];
    Project *project = [[Project alloc]init];
    project.projectId = rlmProject.projectId;
    project.projectStr = rlmProject.projectStr;
    project.red = rlmProject.red;
    project.green = rlmProject.green;
    project.blue = rlmProject.blue;
    
    return project;
}

#pragma mark 获取project数组
- (NSMutableArray *)getProjectArray
{
    RLMResults *result = [RLMProject allObjects];
    NSMutableArray *resultArray = [NSMutableArray arrayWithCapacity:0];
    if (result.count == 0) {
        return nil;
    }
    if (result) {
        for (int i = 0; i < result.count; i ++) {
            RLMProject *rlmProject = [result objectAtIndex:i];
            Project *project = [[Project alloc]init];
            project.projectId = rlmProject.projectId;
            project.projectStr = rlmProject.projectStr;
            project.red = rlmProject.red;
            project.green = rlmProject.green;
            project.blue = rlmProject.blue;
            
            [resultArray addObject:project];
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
