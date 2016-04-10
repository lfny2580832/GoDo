//
//  UserModel.h
//  GoDo
//
//  Created by 牛严 on 16/4/6.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import "BaseModel.h"

@interface UserModel : BaseModel

@property (nonatomic, copy) NSString *id;

@property (nonatomic, copy) NSString *SamId;
///昵称
@property (nonatomic, copy) NSString *alias;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *phone;

@property (nonatomic, copy) NSString *password;

@property (nonatomic, copy) NSString *email;
///头像地址
@property (nonatomic, copy) NSString *avatar;

@property (nonatomic, copy) NSString *school;
///院系
@property (nonatomic, copy) NSString *department;
///年级
@property (nonatomic, copy) NSString *grade;

@property (nonatomic, copy) NSString *class;

@property (nonatomic, copy) NSString *studentNum;

@end
