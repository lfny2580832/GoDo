//
//  ProjectVC.m
//  GoDo
//
//  Created by 牛严 on 16/3/30.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import "ProjectVC.h"
#import "LoginVC.h"
#import "RegistAPI.h"

@interface ProjectVC ()

@end

@implementation ProjectVC
{
    LoginVC *_loginVC;
}

#pragma mark 登录界面
- (void)login
{
    _loginVC = [[LoginVC alloc]init];
    [self presentViewController:_loginVC animated:YES completion:nil];
}


- (void)regist
{
    RegistAPI *api = [[RegistAPI alloc]initWithName:@"牛严" password:@"111111" phone:@"" email:@"test@samaritan.tech" type:@"mail" verifyCode:@"123456"];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        
        
    } failure:^(__kindof YTKBaseRequest *request) {
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

- (void)initView
{
    UIButton *button = [[UIButton alloc]init];
    button.backgroundColor = [UIColor blueColor];
    [button addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(100, 40));
    }];
}

@end
