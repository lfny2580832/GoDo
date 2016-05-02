//
//  GetProjectInfoAPI.m
//  GoDo
//
//  Created by 牛严 on 16/5/2.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import "GetProjectInfoAPI.h"

@implementation GetProjectInfoAPI
{
    NSString *_projectId;
}

- (id)initWithProjectId:(NSString *)projectId
{
    self = [super init];
    if (self) {
        _projectId = projectId;
    }
    return self;
}

- (NSString *)requestUrl {
    NSString *url = [NSString stringWithFormat:@"/projects/%@",_projectId];
    return url;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGet;
}

- (NSDictionary *)requestHeaderFieldValueDictionary
{
    return @{
             @"Authorization": [UserDefaultManager token],
             };
}

@end
