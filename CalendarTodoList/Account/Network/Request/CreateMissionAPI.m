//
//  CreateMissionAPI.m
//  GoDo
//
//  Created by 牛严 on 16/4/14.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import "CreateMissionAPI.h"

@implementation CreateMissionAPI

{
    NSString *_name;
    NSString *_desc;
    NSString *_projectId;
    NSArray *_receiversId;
    
}

- (id)initWithName:(NSString *)name desc:(NSString *)desc projectId:(NSString *)projectId receiversId:(NSArray *)receiversId
{
    self = [super init];
    if (self) {
        _name = name;
        _desc = @"森森森";
        _projectId = projectId;
        _receiversId = @[[UserDefaultManager id]];
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
             @"receiversId":_receiversId
             };
}

@end
