//
//  DBManage.h
//  CalendarTodoList
//
//  Created by 牛严 on 16/1/27.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <LKDBHelper/LKDBHelper.h>
#import "FMTodoModel.h"

@class TypeColor;

#define DBManager [DBManage sharedInstance]

@interface DBManage : NSObject

+ (id)sharedInstance;

#pragma mark 根据dayId获取todo数组
- (NSArray *)getDayInfoFromDateList:(NSInteger)dayId;

#pragma mark 根据project返回类型字符串
- (FMProject *)getProjectWithId:(NSString *)projectId;

#pragma mark 获取project数组
- (NSMutableArray *)getProjectArray;

#pragma mark 创建RLMTodo
- (void)createTodoWithProject:(FMProject *)project contentStr:(NSString *)contentStr contentImages:(NSArray *)images startDate:(NSDate *)startDate oldStartDate:(NSDate *)oldStartDate isAllDay:(BOOL)isAllDay tableId:(NSString *)tableId repeatMode:(RepeatMode)repeatMode remindMode:(RemindMode)remindMode missionId:(NSString *)missionId;

#pragma mark 根据todo tableID 修改todo 的doneType完成情况
- (void)changeTodoDoneTypeWithTableId:(NSString *)tableId doneType:(DoneType)doneType;

#pragma mark 删除todo
- (void)deleteTodoWithTableId:(NSString *)tableId;

#pragma mark 保存本地
- (void)saveProjectInDBWithId:(NSString *)projectId projectName:(NSString *)projectName color:(TypeColor *)color;

@end
