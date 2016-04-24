//
//  LoginTokenModel.h
//  GoDo
//
//  Created by 牛严 on 16/4/11.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import "BaseModel.h"

@interface LoginTokenModel : BaseModel

@property (nonatomic, copy) NSString *id;

@property (nonatomic, copy) NSString *token;

@property (nonatomic ,copy) NSString *avatar;

@property (nonatomic ,copy) NSString *mail;

@property (nonatomic ,copy) NSString *name;

@end