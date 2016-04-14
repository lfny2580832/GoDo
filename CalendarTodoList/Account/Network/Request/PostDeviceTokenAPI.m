//
//  PostDeviceToken.m
//  GoDo
//
//  Created by 牛严 on 16/4/15.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import "PostDeviceTokenAPI.h"

@implementation PostDeviceTokenAPI
{
    NSString *_deviceToken;

}

- (id)initWithDeviceToken:(NSString *)deviceToken
{
    self = [super init];
    if (self) {
        _deviceToken = deviceToken;
    }
    return self;
}

- (NSString *)requestUrl {
    return @"/deviceTokens";
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
             @"deviceToken": _deviceToken,
             };
}
@end
