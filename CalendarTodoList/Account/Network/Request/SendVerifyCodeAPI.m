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
}

- (id)initWithTo:(NSString *)to
{
    self = [super init];
    if (self) {
        _source = @"mail";
        _to = to;
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
             };
}

@end
