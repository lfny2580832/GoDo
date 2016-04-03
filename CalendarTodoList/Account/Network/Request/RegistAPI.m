//
//  RegistAPI.m
//  GoDo
//
//  Created by 牛严 on 16/3/30.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import "RegistAPI.h"

@implementation RegistAPI
{
    NSString *_name;
    NSString *_mail;
    NSString *_password;
    NSString *_type;
    NSString *_verifyCode;
}

- (id)initWithName:(NSString *)name password:(NSString *)password mail:(NSString *)mail verifyCode:(NSString *)verifyCode
{
    self = [super init];
    if (self) {
        _name = name;
        _password = password;
        _mail = mail;
        _type = @"mail";
        _verifyCode = verifyCode;
    }
    return self;
}

- (NSString *)requestUrl {
    return @"/users";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPost;
}

- (id)requestArgument {
    return @{
             @"name": _name,
             @"password": _password,
             @"mail": _mail,
             @"type": _type,
             @"verifyCode": _verifyCode
             };
}

@end
