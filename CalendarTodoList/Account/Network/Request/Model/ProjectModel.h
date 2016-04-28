//
//  ProjectModel.h
//  GoDo
//
//  Created by 牛严 on 16/4/6.
//  Copyright © 2016年 牛严. All rights reserved.
//
#import "BaseModel.h"
#import "UserModel.h"

@interface ProjectModel : BaseModel

@property (nonatomic, copy) NSString *id;

@property (nonatomic, copy) NSString *name;
///创立时间
//@property (nonatomic, assign) long long<Optional> createTime;
///项目描述
@property (nonatomic, copy) NSString *desc;
///是否私有
@property (nonatomic, assign) BOOL private;
///创建者
@property (nonatomic, copy) NSString *creatorId;

@property (nonatomic, copy) NSString *creatorName;

@property (nonatomic, copy) NSString *type;

@property (nonatomic, strong) NSArray *members;

@end
