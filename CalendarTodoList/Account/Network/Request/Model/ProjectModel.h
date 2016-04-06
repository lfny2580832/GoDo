//
//  ProjectModel.h
//  GoDo
//
//  Created by 牛严 on 16/4/6.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserModel.h"

@interface ProjectModel : NSObject

@property (nonatomic, copy) NSString *id;

@property (nonatomic, copy) NSString *name;
///创立时间
@property (nonatomic, assign) long long createTime;
///项目描述
@property (nonatomic, copy) NSString *desc;
///是否私有
@property (nonatomic, assign) BOOL private;
///创建者
@property (nonatomic, strong) UserModel *creator;

@property (nonatomic, strong) NSArray<UserModel *> *members;

@end
