//
//  LoginVC.m
//  CalendarTodoList
//
//  Created by 牛严 on 16/3/28.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import "LoginVC.h"
#import "LoginView.h"
#import "SignupView.h"
#import "ResetView.h"

#import "LogInAPI.h"
#import "LoginTokenModel.h"
#import "RegistAPI.h"
#import "ResetAPI.h"
#import "PostDeviceTokenAPI.h"

@interface LoginVC ()<UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@end

@implementation LoginVC
{
    ResetView *_resetView;
    LoginView *_loginView;
    SignupView *_signupView;
}

#pragma mark postDeviceToken
- (void)postDeviceToken
{
//    NSLog(@"deviceToken:%@",[UserDefaultManager deviceToken]);
//    return;
    PostDeviceTokenAPI *api = [[PostDeviceTokenAPI alloc]initWithDeviceToken:[UserDefaultManager deviceToken]];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        NSLog(@"--%@",request.responseString);
    } failure:^(__kindof YTKBaseRequest *request) {
        
    }];
}

#pragma mark 登录
- (void)login
{
    NSString *mail = _loginView.mailTextField.text;
    NSString *password = _loginView.passwordTextField.text;
    LogInAPI *api = [[LogInAPI alloc]initWithmail:mail password:password];
    NYProgressHUD *hud = [NYProgressHUD new];
    [hud showAnimationWithText:@"登录中"];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        LoginTokenModel *loginTokenModel = [LoginTokenModel yy_modelWithJSON:request.responseString];
        [hud hide];
        
        NSString *token = loginTokenModel.token;
        NSString *id = loginTokenModel.id;
        [UserDefaultManager setId:id];
        [UserDefaultManager setToken:token];
        [UserDefaultManager setUserName:mail];
        [UserDefaultManager setUserPassword:password];
        [self postDeviceToken];
        [NYProgressHUD showToastText:@"登录成功" completion:^{
            [self dismissLoginView];
        }];
    } failure:^(__kindof YTKBaseRequest *request) {
        [hud hide];
        [NYProgressHUD showToastText:@"登录失败"];
    }];
}

#pragma mark 注册
- (void)regist
{
    NSString *name = _signupView.nameTextField.text;
    NSString *password = _signupView.passwordTextField.text;
    NSString *mail = _signupView.mailTextField.text;
    NSString *verifyCode = _signupView.verifyCodeTextField.text;
    RegistAPI *api = [[RegistAPI alloc]initWithName:name password:password mail:mail verifyCode:verifyCode];
    NYProgressHUD *hud = [NYProgressHUD new];
    [hud showAnimationWithText:@"注册中"];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        [hud hide];
        LoginTokenModel *loginTokenModel = [LoginTokenModel yy_modelWithJSON:request.responseString];
        [hud hide];
        NSString *token = loginTokenModel.token;
        NSString *id = loginTokenModel.id;
        [UserDefaultManager setId:id];
        [UserDefaultManager setToken:token];
        [UserDefaultManager setUserName:mail];
        [UserDefaultManager setUserPassword:password];
        [self postDeviceToken];
        [NYProgressHUD showToastText:@"注册成功" completion:^{
            [self dismissLoginView];
        }];
    } failure:^(__kindof YTKBaseRequest *request) {
        [hud hide];
        [NYProgressHUD showToastText:@"注册失败"];
    }];
}

#pragma mark 重置密码
- (void)reset
{
    NSString *mail = _resetView.mailTextField.text;
    NSString *password = _resetView.passwordTextField.text;
    NSString *verifyCode = _resetView.verifyCodeTextField.text;
    ResetAPI *api = [[ResetAPI alloc]initWithMail:mail password:password verifyCode:verifyCode];
    NYProgressHUD *hud = [NYProgressHUD new];
    [hud showAnimationWithText:@"重置中"];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        [hud hide];
        [NYProgressHUD showToastText:@"重置成功，请重新登录" completion:^{
            [self jumpToLogIn];
        }];
    } failure:^(__kindof YTKBaseRequest *request) {
        [hud hide];
        [NYProgressHUD showToastText:@"重置失败"];
    }];
}

#pragma mark 取消登录
- (void)dismissLoginView
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark 跳转至登录页面
- (void)jumpToLogIn
{
    [_scrollView setContentOffset:CGPointMake(SCREEN_WIDTH, 0) animated:YES];
}

#pragma mark 跳转至重置密码页面
- (void)jumpToReset
{
    [_scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}

#pragma mark 跳转至注册页面
- (void)jumpToSignUp
{
    [_scrollView setContentOffset:CGPointMake(SCREEN_WIDTH * 2, 0) animated:YES];
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
    UIImageView *backView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"login_background.png"]];
    [self.view addSubview:backView];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.equalTo(self.view);
    }];
    
    _scrollView = [[UIScrollView alloc]initWithFrame:self.view.frame];
    [_scrollView setContentSize:CGSizeMake(SCREEN_WIDTH * 3, SCREEN_HEIGHT)];
    _scrollView.scrollEnabled = NO;
    _scrollView.delegate = self;
    [self.view addSubview:_scrollView];

    _resetView = [[ResetView alloc]initWithTarget:self frame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [_scrollView addSubview:_resetView];
    
    _loginView =  [[LoginView alloc]initWithTarget:self frame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [_scrollView addSubview:_loginView];
    
    _signupView = [[SignupView alloc]initWithTarget:self frame:CGRectMake(SCREEN_WIDTH * 2, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [_scrollView addSubview:_signupView];
    
    [_scrollView setContentOffset:CGPointMake(SCREEN_WIDTH, 0)];
}

@end
