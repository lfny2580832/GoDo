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

#import "Todo.h"
#import "Project.h"

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
- (void)createTodoWithProject:(Project *)project contentStr:(NSString *)contentStr contentImages:(NSArray *)images startDate:(NSDate *)startDate endDate:(NSDate *)endDate tableId:(NSInteger)tableId
{
    RLMRealm *realm = [RLMRealm defaultRealm];

    RLMTodo *todoModel = [[RLMTodo alloc]init];
    todoModel.startTime = [startDate timeIntervalSinceReferenceDate];
    todoModel.endTime = [endDate timeIntervalSinceReferenceDate];
    
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
    }else
        todoModel.tableId = tableId;

    [realm beginWriteTransaction];
    [RLMTodo createOrUpdateInRealm:realm withValue:todoModel];
    [realm commitWriteTransaction];
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
