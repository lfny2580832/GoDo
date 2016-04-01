//
//  LoginVC.m
//  CalendarTodoList
//
//  Created by 牛严 on 16/3/28.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import "LoginVC.h"
#import "LoginView.h"

@interface LoginVC ()

@end

@implementation LoginVC

#pragma mark 初始化
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)initView
{
    LoginView *loginView =  [[LoginView alloc]init];
    [self.view addSubview:loginView];
    [loginView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.equalTo(self.view);
    }];
    
}
@end
