//
//  ModifyPersonalInfoVC.m
//  GoDo
//
//  Created by 牛严 on 16/4/26.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import "ModifyPersonalInfoVC.h"

@implementation ModifyPersonalInfoVC
{
    UITextField *_textField;
}


#pragma mark 保存
- (void)rightbarButtonItemOnclick:(id)sender
{
    if (_textField.text.length > 0) {
        [self.delegate modidfyNameWith:_textField.text];
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [NYProgressHUD showToastText:@"请输入名称"];
    }
}

#pragma MARK 初始化
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.view.backgroundColor = RGBA(232, 232, 232, 1.0);
        [self setCustomTitle:@"修改名称"];
        [self setLeftBackButtonImage:[UIImage imageNamed:@"ico_nav_back_white.png"]];
        [self setRightBackButtontile:@"保存"];
        [self initView];
    }
    return self;
}

- (void)initView
{
    _textField = [[UITextField alloc]init];
    _textField.text = [UserDefaultManager nickName];
    _textField.backgroundColor = [UIColor whiteColor];
    _textField.leftViewMode = UITextFieldViewModeAlways;
    CGRect frame = [_textField frame];
    frame.size.width = 18.0f;
    UIView *leftView = [[UIView alloc] initWithFrame:frame];
    _textField.leftView = leftView;
    [_textField becomeFirstResponder];
    [self.view addSubview:_textField];
    [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(20);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(@50);
    }];
}

@end
