//
//  SearchUserAPI.m
//  GoDo
//
//  Created by 牛严 on 16/4/10.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import "SearchUserAPI.h"

@implementation SearchUserAPI
{
    NSString *_mail;
}

- (id)initWithMail:(NSString *)mail
{
    self = [super init];
    if (self) {
        _mail = mail;

    }
    return self;
}

- (NSString *)requestUrl {
    NSString *url = [NSString stringWithFormat:@"/users/%@",_mail];
    return url;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGet;
}
@end
