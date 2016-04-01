//
//  LoginView.m
//  GoDo
//
//  Created by 牛严 on 16/3/30.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import "LoginView.h"

@implementation LoginView

- (instancetype)init
{
    self = [super init];
    if (self) {
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
}

@end
