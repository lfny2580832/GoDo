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
    id _target;
}

#pragma mark 初始化
- (instancetype)initWithTarget:(id)target frame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _target = target;
        [self loadSubViews];
    }
    return self;
}

- (void)loadSubViews
{
    _mailTextField = [[UITextField alloc]init];
    _mailTextField.placeholder = @"请输入邮箱";
    _mailTextField.backgroundColor = [UIColor whiteColor];
    _mailTextField.layer.masksToBounds = YES;
    _mailTextField.layer.cornerRadius = 5;
    _mailTextField.leftViewMode = UITextFieldViewModeAlways;
    CGRect frame = [_mailTextField frame];
    frame.size.width = 7.0f;
    UIView *leftView = [[UIView alloc] initWithFrame:frame];
    _mailTextField.leftView = leftView;
    [self addSubview:_mailTextField];
    [_mailTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self).offset(-54);
        make.left.equalTo(self).offset(30);
        make.right.equalTo(self).offset(-30);
        make.height.mas_equalTo(@44);

    }];
    
//    UIImageView *logoView = [[UIImageView alloc]init];
//    logoView.backgroundColor = [UIColor whiteColor];
//    [self addSubview:logoView];
//    [logoView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.size.mas_equalTo(CGSizeMake(50, 50));
//        make.centerX.equalTo(self);
//        make.bottom.equalTo(_mailTextField.mas_top).offset(-40);
//    }];

    _passwordTextField = [[UITextField alloc]init];
    _passwordTextField.placeholder = @"请输入密码";
    _passwordTextField.backgroundColor = [UIColor whiteColor];
    _passwordTextField.layer.masksToBounds = YES;
    _passwordTextField.layer.cornerRadius = 5;
    _passwordTextField.secureTextEntry = YES;
    _passwordTextField.leftViewMode = UITextFieldViewModeAlways;
    UIView *leftView2 = [[UIView alloc] initWithFrame:frame];
    _passwordTextField.leftView = leftView2;
    [self addSubview:_passwordTextField];
    [_passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_mailTextField.mas_bottom).offset(20);
        make.centerX.equalTo(self);
        make.left.right.equalTo(_mailTextField);
        make.height.mas_equalTo(@44);
    }];
    

    UIButton *loginButton = [[UIButton alloc]init];
    loginButton.backgroundColor = KNaviColor;
    loginButton.layer.masksToBounds = YES;
    loginButton.layer.cornerRadius = 1;
    [loginButton setTitle:@"登 录" forState:UIControlStateNormal];
    loginButton.titleLabel.textColor = [UIColor whiteColor];
    SEL login = NSSelectorFromString(@"login");
    [loginButton addTarget:_target action:login forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:loginButton];
    [loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_passwordTextField.mas_bottom).offset(40);
        make.centerX.equalTo(self);
        make.left.equalTo(self).offset(40);
        make.right.equalTo(self).offset(-40);
    }];
    
    NSMutableAttributedString *registStr = [[NSMutableAttributedString alloc] initWithString:@"注册账号"];
    NSRange strRange = {0,[registStr length]};
    [registStr addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:strRange];

    
    UILabel *registLabel = [[UILabel alloc]init];
    registLabel.userInteractionEnabled = YES;
    registLabel.textColor = [UIColor whiteColor];
    registLabel.font = [UIFont systemFontOfSize:15];
    registLabel.attributedText = registStr;
    SEL jumpToSignUp = NSSelectorFromString(@"jumpToSignUp");
    UITapGestureRecognizer *registRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:_target action:jumpToSignUp];
    [registLabel addGestureRecognizer:registRecognizer];
    [self addSubview:registLabel];
    [registLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(loginButton.mas_bottom).offset(20);
        make.centerX.equalTo(loginButton).offset(70);
    }];
    
    UILabel *resetLabel = [[UILabel alloc]init];
    resetLabel.textColor = [UIColor whiteColor];
    resetLabel.userInteractionEnabled = YES;
    resetLabel.font = [UIFont systemFontOfSize:15];
    NSMutableAttributedString *resetStr = [[NSMutableAttributedString alloc] initWithString:@"忘记密码"];
    NSRange strRange2 = {0,[resetStr length]};
    [resetStr addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:strRange2];
    resetLabel.attributedText = resetStr;
    SEL jumpToReset = NSSelectorFromString(@"jumpToReset");
    UITapGestureRecognizer *resetRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:_target action:jumpToReset];
    [resetLabel addGestureRecognizer:resetRecognizer];
    [self addSubview:resetLabel];
    [resetLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(loginButton.mas_bottom).offset(20);
        make.centerX.equalTo(loginButton).offset(-70);
    }];
    
    UIImageView *dismissView = [[UIImageView alloc]init];
    dismissView.userInteractionEnabled = YES;
    dismissView.backgroundColor = [UIColor clearColor];
    dismissView.image = [UIImage imageNamed:@"ico_down.png"];
    SEL dismissLoginView = NSSelectorFromString(@"dismissLoginView");
    UITapGestureRecognizer *dissmissGes = [[UITapGestureRecognizer alloc]initWithTarget:_target action:dismissLoginView];
    [dismissView addGestureRecognizer:dissmissGes];
    [self addSubview:dismissView];
    [dismissView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(loginButton.mas_bottom).offset(60);
        make.centerX.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(30, 60));
    }];
    
//    UIButton *dismissButton = [[UIButton alloc]init];
//    dismissButton.backgroundColor = [UIColor whiteColor];
//    SEL dismissLoginView = NSSelectorFromString(@"dismissLoginView");
//    [dismissButton addTarget:_target action:dismissLoginView forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:dismissButton];
//    [dismissButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(loginButton.mas_bottom).offset(60);
//        make.centerX.equalTo(self);
//        make.size.mas_equalTo(CGSizeMake(30, 60));
//    }];
}

@end
