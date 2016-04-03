//
//  UserDefaultManage.h
//  CalendarTodoList
//
//  Created by 牛严 on 16/2/17.
//  Copyright © 2016年 牛严. All rights reserved.

//该类中存储需设置的对象

//

#import <Foundation/Foundation.h>

#define UserDefaultManager [UserDefaultManage sharedInstance]

@interface UserDefaultManage : NSObject

//todo的tableId，标示唯一性，需自增处理
@property (nonatomic, assign) NSInteger todoMaxId;
//登录后返回的token，放在请求的header中标识身份
@property (nonatomic, copy) NSString *token;

@property (nonatomic, copy) NSString *userName;

@property (nonatomic, copy) NSString *userPassword;

+ (id)sharedInstance;

@end
