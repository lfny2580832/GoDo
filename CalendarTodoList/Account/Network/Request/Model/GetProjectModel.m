//
//  GetProjectModel.m
//  GoDo
//
//  Created by 牛严 on 16/4/11.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import "GetProjectModel.h"
#import "ProjectModel.h"

@implementation GetProjectModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"projects" : [ProjectModel class],
             };
}
@end
