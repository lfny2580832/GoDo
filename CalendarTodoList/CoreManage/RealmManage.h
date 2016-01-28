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
- (NSArray *)getDayInfoBriefFromRealmWithDayId:(NSInteger)dayId;

@end
