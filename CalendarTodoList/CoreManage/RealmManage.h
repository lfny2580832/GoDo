//
//  RealmManage.h
//  CalendarTodoList
//
//  Created by 牛严 on 16/1/27.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import <Foundation/Foundation.h>

#define RealmManager [RealmManage sharedInstance]

@class ThingType;

@interface RealmManage : NSObject

+ (id)sharedInstance;

#pragma mark 根据dayId获取todolist数组
- (NSArray *)getDayInfoFromRealmWithDayId:(NSInteger)dayId;

#pragma mark 根据thingType返回类型字符串
- (ThingType *)getThingTypeWithThingTypeId:(NSInteger)typeId;

#pragma mark 获取ThingType数组
- (NSMutableArray *)getThingTypeArray;

#pragma mark 创建RLMTodolist
- (void)createTodoListWithThingType:(ThingType *)type contentStr:(NSString *)contentStr startDate:(NSDate *)startDate endDate:(NSDate *)endDate tableId:(NSInteger)tableId;

#pragma mark 删除todolist
- (void)deleteTodoListWithTableId:(NSInteger)tableId;
@end
