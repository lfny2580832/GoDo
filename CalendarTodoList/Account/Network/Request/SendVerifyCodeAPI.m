//
//  SendVerifyCodeAPI.m
//  GoDo
//
//  Created by 牛严 on 16/4/3.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import "SendVerifyCodeAPI.h"

@implementation SendVerifyCodeAPI

{
    NSString *_source;  //mail/sms
    NSString *_to;      //发送对象（手机号/邮箱地址）
    NSString *_use;     //用途 （"register"/"forgetPasswd"/"resetPasswd"）
}

- (id)initWithSource:(NSString *)source to:(NSString *)to use:(NSString *)use
{
    self = [super init];
    if (self) {
        _source = source;
        _to = to;
        _use = use;
    }
    return self;
}

- (NSString *)requestUrl {
    NSString *url = [NSString stringWithFormat:@"/verifyCode/:%@",_source];
    return url;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPost;
}

- (id)requestArgument {
    return @{
             @"to": _to,
             @"use": _use
             };
}

@end
