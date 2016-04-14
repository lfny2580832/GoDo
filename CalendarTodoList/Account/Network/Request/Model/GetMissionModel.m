//
//  GetMissionModel.m
//  GoDo
//
//  Created by 牛严 on 16/4/14.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import "GetMissionModel.h"
#import "MissionModel.h"

@implementation GetMissionModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"missions" : [MissionModel class],
             };
}

@end
