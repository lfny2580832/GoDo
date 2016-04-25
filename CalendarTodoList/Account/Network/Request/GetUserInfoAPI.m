
//
//  GetUserInfoAPI.m
//  GoDo
//
//  Created by 牛严 on 16/4/26.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import "GetUserInfoAPI.h"

@implementation GetUserInfoAPI

- (id)init
{
    self = [super init];
    return self;
}

- (NSString *)requestUrl {
    return @"/users/personalInfo";
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
