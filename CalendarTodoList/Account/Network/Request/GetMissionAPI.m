//
//  GetMissionAPI.m
//  GoDo
//
//  Created by 牛严 on 16/4/14.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import "GetMissionAPI.h"

@implementation GetMissionAPI
{
    NSString *_type; //joined 、created
}

- (id)initWithMissionId:(NSString *)missionId
{
    self = [super init];
    if (self) {
        _type = missionId;
        }
    return self;
}

- (NSString *)requestUrl {
    NSString *url = [NSString stringWithFormat:@"/projects/missions/%@",_type];
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
