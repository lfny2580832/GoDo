//
//  DeleteMissionAPI.m
//  GoDo
//
//  Created by 牛严 on 16/4/21.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import "DeleteMissionAPI.h"

@implementation DeleteMissionAPI

{
    NSString *_missionId;
}

- (id)initWithMissionId:(NSString *)missionId
{
    self = [super init];
    if (self) {
        _missionId = missionId;
    }
    return self;
}

- (NSString *)requestUrl {
    NSString *url = [NSString stringWithFormat:@"/missions/%@",_missionId];
    return url;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodDelete;
}

- (NSDictionary *)requestHeaderFieldValueDictionary
{
    return @{
             @"Authorization": [UserDefaultManager token],
             };
}

@end
