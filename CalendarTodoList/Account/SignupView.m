//
//  SignupView.m
//  GoDo
//
//  Created by 牛严 on 16/4/3.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import "SignupView.h"
#import "VerifyCodeButton.h"

@implementation SignupView
{
    id _target;
    VerifyCodeButton *_verifyBtn;
}

#pragma mark 发送验证码
- (void)sendVerifyCode
{
    [self endEditing:YES];
    [_verifyBtn sendVerifyCodeWithMail:_mailTextField.text use:@"register"];
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
    CGRect frame = [_mailTextField frame];
    frame.size.width = 7.0f;
    UIView *leftview = [[UIView alloc] initWithFrame:frame];
    _mailTextField.leftViewMode = UITextFieldViewModeAlways;
    _mailTextField.leftView = leftview;
    [self addSubview:_mailTextField];
    [_mailTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self).offset(- 54);
        make.left.equalTo(self).offset(30);
        make.right.equalTo(self).offset(-30);
        make.height.mas_equalTo(@44);
        
    }];
    
    _nameTextField = [[UITextField alloc]init];
    _nameTextField.placeholder = @"请输入姓名";
    _nameTextField.backgroundColor = [UIColor whiteColor];
    _nameTextField.layer.masksToBounds = YES;
    _nameTextField.layer.cornerRadius = 5;
    _nameTextField.leftViewMode = UITextFieldViewModeAlways;
    UIView *leftview2 = [[UIView alloc] initWithFrame:frame];
    _nameTextField.leftView = leftview2;
    [self addSubview:_nameTextField];
    [_nameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.equalTo(_mailTextField.mas_top).offset(-20);
        make.left.equalTo(self).offset(30);
        make.right.equalTo(self).offset(-30);
        make.height.mas_equalTo(@44);
        
    }];
    
    _verifyCodeTextField = [[UITextField alloc]init];
    _verifyCodeTextField.placeholder = @"请输入验证码";
    _verifyCodeTextField.backgroundColor = [UIColor whiteColor];
    _verifyCodeTextField.layer.masksToBounds = YES;
    _verifyCodeTextField.layer.cornerRadius = 5;
    _verifyCodeTextField.leftViewMode = UITextFieldViewModeAlways;
    UIView *leftview4 = [[UIView alloc] initWithFrame:frame];
    _verifyCodeTextField.leftView = leftview4;
    [self addSubview:_verifyCodeTextField];
    [_verifyCodeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_mailTextField.mas_bottom).offset(20);
        make.centerX.equalTo(self);
        make.left.right.equalTo(_mailTextField);
        make.height.mas_equalTo(@44);
    }];
    
    _verifyBtn = [[VerifyCodeButton alloc]init];
    [_verifyBtn addTarget:self action:@selector(sendVerifyCode) forControlEvents:UIControlEventTouchUpInside];
    [_verifyCodeTextField addSubview:_verifyBtn];
    [_verifyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_verifyCodeTextField);
        make.right.equalTo(_verifyCodeTextField).offset(-10);
        make.height.mas_equalTo(@30);
        make.width.mas_equalTo(@100);
    }];
    
    _passwordTextField = [[UITextField alloc]init];
    _passwordTextField.placeholder = @"请输入密码";
    _passwordTextField.backgroundColor = [UIColor whiteColor];
    _passwordTextField.layer.masksToBounds = YES;
    _passwordTextField.layer.cornerRadius = 5;
    _passwordTextField.leftViewMode = UITextFieldViewModeAlways;
    UIView *leftview3 = [[UIView alloc] initWithFrame:frame];
    _passwordTextField.leftView = leftview3;
    [self addSubview:_passwordTextField];
    [_passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_verifyCodeTextField.mas_bottom).offset(20);
        make.centerX.equalTo(self);
        make.left.right.equalTo(_verifyCodeTextField);
        make.height.mas_equalTo(@44);
    }];
    
    _schoolNumTextField = [[UITextField alloc]init];
    _schoolNumTextField.placeholder = @"请输入学号";
    _schoolNumTextField.backgroundColor = [UIColor whiteColor];
    _schoolNumTextField.layer.masksToBounds = YES;
    _schoolNumTextField.layer.cornerRadius = 5;
    _schoolNumTextField.leftViewMode = UITextFieldViewModeAlways;
    UIView *leftview5 = [[UIView alloc] initWithFrame:frame];
    _schoolNumTextField.leftView = leftview5;
    [self addSubview:_schoolNumTextField];
    [_schoolNumTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_nameTextField.mas_top).offset(-20);
        make.centerX.equalTo(self);
        make.left.right.equalTo(_verifyCodeTextField);
        make.height.mas_equalTo(@44);
    }];
    
    UIButton *registButton = [[UIButton alloc]init];
    registButton.backgroundColor = KNaviColor;
    registButton.layer.masksToBounds = YES;
    registButton.layer.cornerRadius = 1;
    [registButton setTitle:@"注 册" forState:UIControlStateNormal];
    registButton.titleLabel.textColor = [UIColor whiteColor];
    SEL regist = NSSelectorFromString(@"regist");
    [registButton addTarget:_target action:regist forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:registButton];
    [registButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_passwordTextField.mas_bottom).offset(40);
        make.centerX.equalTo(self);
        make.left.equalTo(self).offset(40);
        make.right.equalTo(self).offset(-40);
    }];
    
    UILabel *loginLabel = [[UILabel alloc]init];
    loginLabel.userInteractionEnabled = YES;
    loginLabel.textColor = [UIColor whiteColor];
    loginLabel.font = [UIFont systemFontOfSize:15];
    NSMutableAttributedString *loginStr = [[NSMutableAttributedString alloc] initWithString:@"已有账号登录"];
    NSRange strRange = {0,[loginStr length]};
    [loginStr addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:strRange];
    loginLabel.attributedText = loginStr;
    SEL jumpToLogIn = NSSelectorFromString(@"jumpToLogIn");
    UITapGestureRecognizer *registRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:_target action:jumpToLogIn];
    [loginLabel addGestureRecognizer:registRecognizer];
    [self addSubview:loginLabel];
    [loginLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(registButton.mas_bottom).offset(20);
        make.centerX.equalTo(registButton);
    }];
}

@end
