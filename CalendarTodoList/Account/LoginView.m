//
//  LoginView.m
//  GoDo
//
//  Created by 牛严 on 16/3/30.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import "LoginView.h"

@implementation LoginView
{    
    id _vc;
}

#pragma mark 初始化
- (instancetype)initWithVC:(id)vc
{
    self = [super init];
    if (self) {
        _vc = vc;
        [self loadSubViews];
    }
    return self;
}

- (void)loadSubViews
{
    UIImageView *backView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"login_background.png"]];
    [self addSubview:backView];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.equalTo(self);
    }];
    
    _mailTextField = [[UITextField alloc]init];
    _mailTextField.placeholder = @"请输入邮箱";
    _mailTextField.backgroundColor = [UIColor whiteColor];
    [self addSubview:_mailTextField];
    [_mailTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self).offset(-54);
        make.left.equalTo(self).offset(30);
        make.right.equalTo(self).offset(-30);
        make.height.mas_equalTo(@44);

    }];
    
    UIImageView *logoView = [[UIImageView alloc]init];
    logoView.backgroundColor = [UIColor whiteColor];
    [self addSubview:logoView];
    [logoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(50, 50));
        make.centerX.equalTo(self);
        make.bottom.equalTo(_mailTextField.mas_top).offset(-20);
    }];

    _passwordTextField = [[UITextField alloc]init];
    _passwordTextField.placeholder = @"请输入密码";
    _passwordTextField.backgroundColor = [UIColor whiteColor];
    [self addSubview:_passwordTextField];
    [_passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_mailTextField.mas_bottom).offset(20);
        make.centerX.equalTo(self);
        make.left.right.equalTo(_mailTextField);
        make.height.mas_equalTo(@44);
    }];
    
    UIButton *loginButton = [[UIButton alloc]init];
    loginButton.backgroundColor = KNaviColor;
    loginButton.titleLabel.text = @"登录";
    SEL login = NSSelectorFromString(@"login");
    [loginButton addTarget:_vc action:login forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:loginButton];
    [loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_passwordTextField.mas_bottom).offset(20);
        make.centerX.equalTo(self);
        make.left.equalTo(self).offset(40);
        make.right.equalTo(self).offset(-40);
    }];
    
    UIButton *dismissButton = [[UIButton alloc]init];
    dismissButton.backgroundColor = [UIColor whiteColor];
    SEL dismissLoginView = NSSelectorFromString(@"dismissLoginView");
    [dismissButton addTarget:_vc action:dismissLoginView forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:dismissButton];
    [dismissButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(loginButton.mas_bottom).offset(20);
        make.centerX.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(30, 60));
    }];
}

@end
