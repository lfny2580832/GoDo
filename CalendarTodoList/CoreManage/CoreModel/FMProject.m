//
//  FMProject.m
//  GoDo
//
//  Created by 牛严 on 16/5/4.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import "FMProject.h"
#import <LKDBHelper/LKDBHelper.h>

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
