//
//  InviteMemberInProjectAPI.m
//  GoDo
//
//  Created by 牛严 on 16/5/3.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import "InviteMemberInProjectAPI.h"

@implementation InviteMemberInProjectAPI

{
    NSString *_inviteeId;
    NSString *_projectId;
    NSString *_projectName;
}

- (id)initWithInvitee:(NSString *)inviteeId projectId:(NSString *)projectId projectName:(NSString *)projectName
{
    self = [super init];
    if (self) {
        _inviteeId = inviteeId;
        _projectId = projectId;
        _projectName = projectName;
    }
    return self;
}

- (NSString *)requestUrl {
    return @"/invitations/project";
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
             @"invitee": _inviteeId,
             @"projectId":_projectId,
             @"projectName":_projectName,
             };
}

@end
