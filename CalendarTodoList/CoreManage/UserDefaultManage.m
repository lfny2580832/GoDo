//
//  UserDefaultManage.m
//  CalendarTodoList
//
//  Created by 牛严 on 16/2/17.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import "UserDefaultManage.h"

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

@end
