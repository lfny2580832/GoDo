//
//  ResetAPI.m
//  GoDo
//
//  Created by 牛严 on 16/4/4.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import "ResetAPI.h"

@implementation ResetAPI
{
    NSString *_verifyCode;
    NSString *_password;
    NSString *_mail;
    NSString *_type;
}

- (id)initWithMail:(NSString *)mail password:(NSString *)password verifyCode:(NSString *)verifyCode
{
    self = [super init];
    if (self) {
        _password = password;
        _mail = mail;
        _verifyCode = verifyCode;
        _type = @"mail";
    }
    return self;
}

- (NSString *)requestUrl {
    NSString *url = [NSString stringWithFormat:@"/password/:%@",_mail];
    return url;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPut;
}

- (id)requestArgument {
    return @{
             @"password": _password,
             @"verifyCode": _verifyCode,
             @"type": _type
             };
}

@end
