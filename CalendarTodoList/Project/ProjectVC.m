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

- (void)login
{
    LoginVC *vc = [[LoginVC alloc]init];
    [self presentViewController:vc animated:YES completion:nil];
}


- (void)regist
{
    RegistAPI *api = [[RegistAPI alloc]initWithName:@"牛严" password:@"123456" phone:@"18035735959" email:@"" type:@"sms" verifyCode:@"232323"];
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
    [button addTarget:self action:@selector(regist) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(100, 40));
    }];
}

@end
