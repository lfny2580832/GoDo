//
//  CreateProjectAPI.m
//  GoDo
//
//  Created by 牛严 on 16/4/11.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import "CreateProjectAPI.h"

@implementation CreateProjectAPI
{
    NSString *_name;
    NSString *_desc;
    BOOL _private;
}

- (id)initWithName:(NSString *)name private:(BOOL)pri
{
    self = [super init];
    if (self) {
        _name = name;
        _desc = @"";
        _private = pri;
    }
    return self;
}

- (NSString *)requestUrl {
    return @"/projects";
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
             @"private":@(_private),
             };
}

@end
