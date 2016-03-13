//
//  FMDayList.m
//  CalendarTodoList
//
//  Created by 牛严 on 16/3/13.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import "FMDayList.h"
#import <LKDBHelper/LKDBHelper.h>

@implementation FMDayList

+ (NSString *)getPrimaryKey
{
    return @"dayID";
}

+(LKDBHelper *)getUsingLKDBHelper
{
    static LKDBHelper* db;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        db = [[LKDBHelper alloc]init];
    });
    return db;
}
@end
