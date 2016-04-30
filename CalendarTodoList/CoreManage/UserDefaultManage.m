//
//  UserDefaultManage.m
//  CalendarTodoList
//
//  Created by 牛严 on 16/2/17.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import "UserDefaultManage.h"
#import "LoginVC.h"

#define UserDefault [NSUserDefaults standardUserDefaults]

@implementation UserDefaultManage

+ (id)sharedInstance
{
    static UserDefaultManage *sharedInstance = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

- (LoginVC *)loginVC
{
    if (!_loginVC) {
        _loginVC = [[LoginVC alloc]init];
    }
    return _loginVC;
}

- (void)showLoginVCWith:(id)target
{
    [target presentViewController:self.loginVC animated:YES completion:nil];
}

#pragma mark 存取deviceToken
- (void)setDeviceToken:(NSString *)deviceToken
{
    [UserDefault setObject:deviceToken forKey:@"deviceToken"];
}

- (NSString *)deviceToken
{
    return  [UserDefault objectForKey:@"deviceToken"];
}

#pragma mark 存取 todoMaxId
- (void)setTodoMaxId:(NSInteger)todoMaxId
{
    [UserDefault setInteger:todoMaxId forKey:@"todoMaxId"];
}

- (NSInteger)todoMaxId
{
    return  [UserDefault integerForKey:@"todoMaxId"];
}

#pragma mark 存取token
- (void)setToken:(NSString *)token
{
    [UserDefault setObject:token forKey:@"token"];

}

- (NSString *)token
{
    return  [UserDefault objectForKey:@"token"];
}

#pragma mark 存取Id
- (void)setId:(NSString *)id
{
    [UserDefault setObject:id forKey:@"id"];
}

- (NSString *)id
{
    return [UserDefault objectForKey:@"id"];
}

#pragma mark 存取用户名
-(void)setUserName:(NSString *)userName
{
    [UserDefault setObject:userName forKey:@"userName"];
}

- (NSString *)userName
{
    return  [UserDefault objectForKey:@"userName"];
}

#pragma mark 存取密码
- (void)setUserPassword:(NSString *)password
{
    [UserDefault setObject:password forKey:@"userPassword"];
}

- (NSString *)userPassword
{
    return  [UserDefault objectForKey:@"userPassword"];
}

#pragma mark 存取头像
- (void)setHeadImage:(UIImage *)headImage
{
    NSData *imageData = UIImageJPEGRepresentation(headImage, 1.0);
    [UserDefault setObject:imageData forKey:@"headImage"];
}

- (UIImage *)headImage
{
    NSData *imageData = [UserDefault objectForKey:@"headImage"];
    return  [UIImage imageWithData:imageData];
}

#pragma mark 存取用户名称
- (void)setNickName:(NSString *)nickName
{
    [UserDefault setObject:nickName forKey:@"nickName"];
}

- (NSString *)nickName
{
    return  [UserDefault objectForKey:@"nickName"];
}


#pragma mark 存取学号
- (void)setStuNumber:(NSString *)stuNumber
{
    [UserDefault setObject:stuNumber forKey:@"stuNumber"];
}

- (NSString *)stuNumber
{
    return [UserDefault objectForKey:@"stuNumber"];
}

#pragma mark 存取七牛token
- (void)setQiNiuToken:(NSString *)qiNiuToken
{
    [UserDefault setObject:qiNiuToken forKey:@"qiNiuToken"];

}

- (NSString *)qiNiuToken
{
    return  [UserDefault objectForKey:@"qiNiuToken"];
}

#pragma mark 存取是否第一次启动
- (void)setFirstStart:(BOOL)firstStart
{
    [UserDefault setBool:firstStart forKey:@"firstStart"];
}

- (BOOL)firstStart
{
    return  [UserDefault boolForKey:@"firstStart"];
}

@end
