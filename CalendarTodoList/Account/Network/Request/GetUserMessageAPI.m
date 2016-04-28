//
//  GetUserMessage.m
//  GoDo
//
//  Created by 牛严 on 16/4/27.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import "GetUserMessageAPI.h"

@implementation GetUserMessageAPI

- (id)init
{
    self = [super init];
    return self;
}

- (NSString *)requestUrl {
    return @"/offlineMessages";
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
