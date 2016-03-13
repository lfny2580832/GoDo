//
//  FMTodoModel.m
//  CalendarTodoList
//
//  Created by 牛严 on 16/3/13.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import "FMTodoModel.h"

@implementation FMProject

+ (NSString *)getPrimaryKey
{
    return @"projectId";
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

@implementation FMTodoModel

+(LKDBHelper *)getUsingLKDBHelper
{
    static LKDBHelper* db;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        db = [[LKDBHelper alloc]init];
    });
    return db;
}

+(void)initialize
{
    [self removePropertyWithColumnName:@"error"];
}

//主键
+(NSString *)getPrimaryKey
{
    return @"tableId";
}

@end

