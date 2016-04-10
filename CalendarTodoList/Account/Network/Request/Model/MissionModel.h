//
//  MissionModel.h
//  GoDo
//
//  Created by 牛严 on 16/4/6.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import "UserModel.h"

@interface MissionModel : BaseModel

@property (nonatomic, copy) NSString *id;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, assign) long long createTime;

@property (nonatomic, copy) NSString *desc;

@property (nonatomic, strong) UserModel *publisher;

@property (nonatomic, strong) NSArray<UserModel *> *receivers;
///任务已完成人数
@property (nonatomic, assign) NSInteger completionNum;
///任务完成时间
@property (nonatomic, assign) long long completedTime;


@end
