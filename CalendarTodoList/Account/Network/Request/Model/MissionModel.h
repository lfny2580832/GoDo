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

@property (nonatomic, copy) NSString *creatorId;

@property (nonatomic, copy) NSString *creatorName;

@property (nonatomic, strong) NSArray *pictures;

@property (nonatomic ,assign) long long deadline;

@property (nonatomic ,strong) NSArray *receiversName;

@end
