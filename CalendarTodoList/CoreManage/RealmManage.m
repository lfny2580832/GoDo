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
#import "RLMDayList.h"

#import "Todo.h"
#import "Project.h"

#import "FMDayList.h"
#import "FMTodoModel.h"
#import "FMTodoImage.h"

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
- (NSArray *)getDayInfoFromDateList:(NSInteger)dayId
{
    NSMutableArray *resultArray = [NSMutableArray arrayWithCapacity:0];
    
    FMDayList *dayList = [[[FMDayList getUsingLKDBHelper] searchWithSQL:[NSString stringWithFormat:@"select * from @t where dayID = '%ld'",(long)dayId] toClass:[FMDayList class]] firstObject];
    for (NSNumber *idNumber in dayList.tableIDs)
    {
        NSInteger tableID = [idNumber integerValue];
        FMTodoModel *todoModel = [[[FMTodoModel getUsingLKDBHelper] searchWithSQL:[NSString stringWithFormat:@"select * from @t where tableId = '%ld'",(long)tableID] toClass:[FMTodoModel class]] firstObject];
        NSMutableArray *fmTodoimageArray = [FMTodoImage searchWithSQL:[NSString stringWithFormat:@"select * from @t where tableId = '%ld'",(long)tableID]];
        NSMutableArray *imageArray = [[NSMutableArray alloc]init];
        for(FMTodoImage *todoImage in fmTodoimageArray)
        {
            UIImage *image = todoImage.image;
            [imageArray addObject:image];
        }
        todoModel.images = imageArray;
        [resultArray addObject:todoModel];
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
- (void)createTodoWithProject:(FMProject *)project contentStr:(NSString *)contentStr contentImages:(NSArray *)images startDate:(NSDate *)startDate oldStartDate:(NSDate *)oldStartDate tableId:(NSInteger)tableId repeatMode:(RepeatMode)repeatMode
{
    FMTodoModel *todoModel = [[FMTodoModel alloc]init];
    todoModel.startTime = [startDate timeIntervalSinceReferenceDate];
    FMProject *fmProject = [[FMProject alloc]init];
    fmProject.projectId = project.projectId;
    fmProject.projectStr = project.projectStr;
    fmProject.red = project.red;
    fmProject.green = project.green;
    fmProject.blue = project.blue;
    todoModel.project = fmProject;
    todoModel.projectId = project.projectId;
    todoModel.thingStr = contentStr;
    
    if (!tableId) {
        todoModel.tableId = [UserDefaultManager todoMaxId] + 1;
        [UserDefaultManager setTodoMaxId:todoModel.tableId];
    }else{
        todoModel.tableId = tableId;
    }
    todoModel.repeatMode = repeatMode;
    [self saveImageWith:todoModel images:images];
    
    [[FMTodoModel getUsingLKDBHelper] insertToDB:todoModel];
    
    [self CreateOrUpdateDateListWithStartDate:startDate oldStartDate:oldStartDate repeatMode:repeatMode FMTodo:todoModel];
    
}

- (void)saveImageWith:(FMTodoModel *)todoModel images:(NSArray *)images
{
    NSInteger tableID = todoModel.tableId;
    
    NSMutableArray *lastImages = [FMTodoImage searchWithSQL:[NSString stringWithFormat:@"select * from @t where tableID = '%ld'",(long)tableID]];
    for(FMTodoImage *todoImage in lastImages)
    {
        [[FMTodoImage getUsingLKDBHelper] deleteToDB:todoImage];
    }
    
    for(UIImage *image in images)
    {
        FMTodoImage *todoImage = [[FMTodoImage alloc]init];
        todoImage.tableID = todoModel.tableId;
        todoImage.image = image;
        [[FMTodoImage getUsingLKDBHelper] insertToDB:todoImage];
    }
}

#pragma mark 新建更新day与tableId关系数据
- (void)CreateOrUpdateDateListWithStartDate:(NSDate *)startDate oldStartDate:(NSDate *)oldStartDate repeatMode:(RepeatMode)repeatMode FMTodo:(FMTodoModel *)fmTodo
{
    NSInteger dayID = [NSObject getDayIdWithDate:startDate];
    
    if (repeatMode == Never)
    {
        if (oldStartDate) {
            //存在表示修改过时间，删除之前的记录
            [self deleteOldTodoWithOldStartDate:oldStartDate tableID:fmTodo.tableId];
        }
        [self updateDayListWithDayID:dayID tableID:fmTodo.tableId];
    }
    else if (repeatMode == EveryDay)
    {
        if (!oldStartDate) {
            //新建的todo，进行表维护操作
            NSArray *dayIDs = [self dayIDsForEveryDayRepeatWithStartDate:startDate];
            for(NSNumber *dayIDNumber in dayIDs)
            {
                NSInteger dayId = [dayIDNumber integerValue];
                [self updateDayListWithDayID:dayId tableID:fmTodo.tableId];
            }
        }else{
            
        }
    }
}

#pragma mark 根据dayID和tableID维护日期-任务关系表
- (void)updateDayListWithDayID:(NSInteger)dayID tableID:(NSInteger)tableID
{
    FMDayList *dayList = [[FMDayList searchWithSQL:[NSString stringWithFormat:@"select * from @t where dayID = '%ld'",(long)dayID]] firstObject];
    NSMutableArray *tableIDs = [NSMutableArray arrayWithArray:dayList.tableIDs];
    if (dayList.dayID > 0) {
        dayList.dayID = dayID;
        if (![tableIDs containsObject:[NSNumber numberWithInteger:tableID]]) {
            [tableIDs addObject:[NSNumber numberWithInteger:tableID]];
        }
        dayList.tableIDs = [NSMutableArray arrayWithArray:tableIDs];
        [[FMDayList getUsingLKDBHelper] updateToDB:dayList where:nil];
    }else{
        dayList = [[FMDayList alloc]init];
        dayList.dayID = dayID;
        dayList.tableIDs = [[NSMutableArray alloc]init];
        [dayList.tableIDs addObject:[NSNumber numberWithInteger:tableID]];
        [[FMDayList getUsingLKDBHelper] insertToDB:dayList];
        
    }
    
    NSLog(@"---%@",dayList.tableIDs.description);
}

#pragma mark 根据当前日期返回repeatMode为EveryDay的DayID
- (NSArray *)dayIDsForEveryDayRepeatWithStartDate:(NSDate *)startDate
{
    NSMutableArray *dayIDs = [[NSMutableArray alloc]initWithCapacity:0];
    NSInteger repeatTimes = [NSObject numberOfDaysInThisYear];
    long long  currentDayTimeStamp = [startDate timeIntervalSinceReferenceDate];
    for (int i = 0; i < repeatTimes; i ++) {
        long long timeStamp = currentDayTimeStamp + 60 * 60 * 24 * i ;
        NSInteger dayID = [NSObject getDayIdWithDateStamp:timeStamp];
        [dayIDs addObject:[NSNumber numberWithInteger:dayID]];
    }
    return dayIDs;
}

#pragma mark 根据老时间和todo.tableID 删除那天对应的任务
- (void)deleteOldTodoWithOldStartDate:(NSDate *)oldStartDate tableID:(NSInteger)tableID
{
    NSInteger dayID = [NSObject getDayIdWithDate:oldStartDate];
    LKDBHelper *helper = [FMDayList getUsingLKDBHelper];
    FMDayList *dayList = [[FMDayList searchWithSQL:[NSString stringWithFormat:@"select * from @t where dayID = '%ld'",(long)dayID]] firstObject];
    NSMutableArray *tableIDs = [NSMutableArray arrayWithArray:dayList.tableIDs];
    if ([tableIDs containsObject:[NSNumber numberWithInteger:tableID]]) {
        [tableIDs removeObject:[NSNumber numberWithInteger:tableID]];
    }
    dayList.tableIDs = [NSMutableArray arrayWithArray:tableIDs];
    [helper updateToDB:dayList where:nil];
}
#pragma mark 根据todo tableID 修改todo 的doneType完成情况
- (void)changeTodoDoneTypeWithTableId:(NSInteger)tableId doneType:(DoneType)doneType
{
    FMTodoModel *todoModel = [[FMTodoModel searchWithSQL:[NSString stringWithFormat:@"select * from @t where tableId = '%ld'",(long)tableId]] firstObject];
    todoModel.doneType = doneType;
    [[FMTodoModel getUsingLKDBHelper] updateToDB:todoModel where:nil];
}

#pragma mark 根据projectId返回project
- (FMProject *)getProjectWithId:(NSInteger)projectId
{
    FMProject *project = [[FMProject searchWithSQL:[NSString stringWithFormat:@"select * from @t where projectId = '%ld'",(long)projectId]] firstObject];
    
    return project;
}
#pragma mark 获取project数组
- (NSMutableArray *)getProjectArray
{
    NSMutableArray *resultArray = [NSMutableArray arrayWithCapacity:0];
    resultArray = [FMProject searchWithSQL:@"select * from @t"];
    if (resultArray) return resultArray;
    return nil;
}

#pragma mark 删除todo
- (void)deleteTodoWithTableId:(NSInteger)tableId
{
    FMTodoModel *todoModel = [[FMTodoModel searchWithSQL:[NSString stringWithFormat:@"select * from @t where tableId = '%ld'",(long)tableId]] firstObject];
    [[FMTodoModel getUsingLKDBHelper] deleteToDB:todoModel];
    
    NSNumber *idNumber = [NSNumber numberWithInteger:tableId];
    NSMutableArray *dayListArray = [FMDayList searchWithSQL:@"select * from @t"];
    for(FMDayList *dayList in dayListArray)
    {
        NSMutableArray *tableIDs = [NSMutableArray arrayWithArray:dayList.tableIDs];
        if ([tableIDs containsObject:idNumber]) {
            [tableIDs removeObject:idNumber];
        }
        dayList.tableIDs = [NSMutableArray arrayWithArray:tableIDs];
        [[FMDayList getUsingLKDBHelper] updateToDB:dayList where:nil];
    }
}

@end
