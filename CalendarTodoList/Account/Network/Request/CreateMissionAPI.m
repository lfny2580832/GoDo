//
//  CreateMissionAPI.m
//  GoDo
//
//  Created by 牛严 on 16/4/14.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import "CreateMissionAPI.h"
#import "MissionModel.h"

@implementation CreateMissionAPI

{
    NSString *_name;
    NSString *_desc;
    NSString *_projectId;
    NSArray *_receiversId;
    long long _deadline;
    
}

- (id)initWithMissionName:(NSString *)name deadline:(NSDate *)deadline projectId:(NSString *)projectId receiversId:(NSArray *)receiversId
{
    self = [super init];
    if (self) {
        _name = name;
        _desc = @"无";
        _projectId = projectId;
        _deadline = [deadline timeIntervalSince1970];
        _receiversId = receiversId;
    }
    return self;
}

- (NSString *)requestUrl {
    return @"/missions";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPost;
}


- (NSDictionary *)requestHeaderFieldValueDictionary
{
    return @{
             @"Authorization": [UserDefaultManager token],
             };
}

- (id)requestArgument {
    return @{
             @"name": _name,
             @"desc": _desc,
             @"projectId":_projectId,
             @"receiversId":_receiversId,
             @"deadline":@(_deadline)
             };
}

@end
