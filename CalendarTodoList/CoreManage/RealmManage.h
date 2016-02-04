//
//  RealmManage.h
//  CalendarTodoList
//
//  Created by 牛严 on 16/1/27.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import <Foundation/Foundation.h>

#define RealmManager [RealmManage sharedInstance]

@interface RealmManage : NSObject

+ (id)sharedInstance;

#pragma mark 根据dayId获取概要数组，概要（hh:mm 体育）
- (NSArray *)getDayInfoFromRealmWithDayId:(NSInteger)dayId;

#pragma mark 根据thingType返回类型字符串
- (NSString *)getThingTypeStrWithThingType:(NSInteger)typeId;

#pragma mark 获取ThingType数组
- (NSArray *)getThingTypeArray;

@end
