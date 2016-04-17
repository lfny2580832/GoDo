//
//  GetQiNiuToken.m
//  GoDo
//
//  Created by 牛严 on 16/4/17.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import "GetQiNiuTokenAPI.h"

@implementation GetQiNiuTokenAPI


- (id)init
{
    self = [super init];
    return self;
}

- (NSString *)requestUrl {
    return @"/qiniu/uploadTokens";
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
