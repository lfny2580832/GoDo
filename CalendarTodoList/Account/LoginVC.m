//
//  LoginVC.m
//  CalendarTodoList
//
//  Created by 牛严 on 16/3/28.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import "LoginVC.h"
#import "LoginView.h"

#import "LogInAPI.h"
#import "LoginTokenModel.h"

@interface LoginVC ()

@end

@implementation LoginVC
{
    LoginView *_loginView;
}

#pragma mark 登录
- (void)login
{
    NSString *mail = _loginView.mailTextField.text;
    NSString *password = _loginView.passwordTextField.text;
    LogInAPI *api = [[LogInAPI alloc]initWithmail:mail password:password];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        LoginTokenModel *loginTokenModel = [[LoginTokenModel alloc]initWithString:request.responseString error:nil];
        [UserDefaultManager setToken:loginTokenModel.token];
    } failure:^(__kindof YTKBaseRequest *request) {
        
    }];
}


#pragma mark 取消登录
- (void)dismissLoginView
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

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
    _loginView =  [[LoginView alloc]initWithVC:self];
    [self.view addSubview:_loginView];
    [_loginView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.equalTo(self.view);
    }];
    
}
@end
