//
//  GetProjectAPI.m
//  GoDo
//
//  Created by 牛严 on 16/4/7.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import "GetProjectAPI.h"
#import "UserDefaultManage.h"

@implementation GetProjectAPI
{
    NSString *_type; //joined 、created
}

- (id)initWithType:(NSString *)type
{
    self = [super init];
    if (self) {
        _type = @"";
        if (type.length) {
            _type = [NSString stringWithFormat:@"?type=%@",type];
        }
    }
    return self;
}

- (NSString *)requestUrl {
    NSString *url = [NSString stringWithFormat:@"/projects%@",_type];
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
