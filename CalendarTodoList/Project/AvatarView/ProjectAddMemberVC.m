//
//  ProjectAddMemberVC.m
//  GoDo
//
//  Created by 牛严 on 16/5/2.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import "ProjectAddMemberVC.h"

@implementation ProjectAddMemberVC

#pragma mark 初始化
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.view.backgroundColor = [UIColor whiteColor];
        [self setLeftBackButtonImage:[UIImage imageNamed:@"ico_nav_back_white.png"]];
        [self setCustomTitle:@"添加成员"];
        [self initView];
    }
    return self;
}

- (void)initView
{

}

@end
