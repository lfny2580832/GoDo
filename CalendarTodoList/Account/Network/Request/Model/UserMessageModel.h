//
//  UserMessageModel.h
//  GoDo
//
//  Created by 牛严 on 16/4/27.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MessageExtraInfoModel.h"

@interface UserMessageModel : NSObject

@property (nonatomic, copy) NSString *id;

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, assign) long long time;
//0	私信
//1	群聊
//2	其他用户加入项目
//3	其他用户离开项目
//4	被邀请加入项目
//5	被踢出项目
//6	任务发布
//7	被邀请接受任务
@property (nonatomic, assign) NSInteger type;

@property (nonatomic, assign) BOOL dealt;

@property (nonatomic, strong) MessageExtraInfoModel *extraInfo;

@end
