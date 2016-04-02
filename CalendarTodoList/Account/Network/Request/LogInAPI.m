//
//  LogInAPI.m
//  GoDo
//
//  Created by 牛严 on 16/4/2.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import "LogInAPI.h"

@implementation LogInAPI
{
    NSString *_mail;
    NSString *_password;
    NSString *_type;
}

- (id)initWithmail:(NSString *)mail password:(NSString *)password
{
    self = [super init];
    if (self) {
        _password = password;
        _mail = mail;
        _type = @"mail";
    }
    return self;
}

- (NSString *)requestUrl {
    return @"/accessToken";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPost;
}

- (id)requestArgument {
    return @{
             @"password": _password,
             @"mail": _mail,
             @"type": _type
             };
}

@end
