//
//  MessageExtraInfoModel.h
//  GoDo
//
//  Created by 牛严 on 16/4/28.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageExtraInfoModel : NSObject

@property (nonatomic, copy) NSString *invitor;

@property (nonatomic, copy) NSString *invitorName;

@property (nonatomic, copy) NSString *invitorAvatar;

@property (nonatomic, copy) NSString *targetId;

@property (nonatomic, copy) NSString *targetName;

@property (nonatomic, copy) NSString *projectId;

@property (nonatomic, copy) NSString *remark;

@end
