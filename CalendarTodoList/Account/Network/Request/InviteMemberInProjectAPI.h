//
//  InviteMemberInProjectAPI.h
//  GoDo
//
//  Created by 牛严 on 16/5/3.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>

@interface InviteMemberInProjectAPI : YTKRequest

- (id)initWithInvitee:(NSString *)inviteeId projectId:(NSString *)projectId projectName:(NSString *)projectName;

@end
