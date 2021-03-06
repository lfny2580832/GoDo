//
//  UserDefaultManage.h
//  CalendarTodoList
//
//  Created by 牛严 on 16/2/17.
//  Copyright © 2016年 牛严. All rights reserved.

//该类中存储需设置的对象

//

#import <Foundation/Foundation.h>

@class LoginVC;

#define UserDefaultManager [UserDefaultManage sharedInstance]

@interface UserDefaultManage : NSObject

@property (nonatomic, strong) LoginVC *loginVC;

- (void)showLoginVCWith:(id)target;

@property (nonatomic, copy) NSString *deviceToken;
///todo的tableId，标示唯一性，需自增处理
@property (nonatomic, assign) NSInteger todoMaxId;
///登录后返回的token，放在请求的header中标识身份
@property (nonatomic, copy) NSString *token;
///登录后返回的Id
@property (nonatomic, copy) NSString *id;
///用户名，暂时是邮箱
@property (nonatomic, copy) NSString *userName;

@property (nonatomic, copy) NSString *nickName;

@property (nonatomic, copy) NSString *stuNumber;

@property (nonatomic, strong) UIImage *headImage;
//@property (nonatomic, copy) NSString *userPassword;
///七牛token
@property (nonatomic, copy) NSString *qiNiuToken;
///第一次启动
@property (nonatomic, assign) BOOL firstStart;

+ (id)sharedInstance;

@end
