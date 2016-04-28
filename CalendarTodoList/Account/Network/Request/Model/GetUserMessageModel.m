//
//  GetUserMessageModel.m
//  GoDo
//
//  Created by 牛严 on 16/4/27.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import "GetUserMessageModel.h"
#import "UserMessageModel.h"

@implementation GetUserMessageModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"messages" : [UserMessageModel class],
             };
}

@end
