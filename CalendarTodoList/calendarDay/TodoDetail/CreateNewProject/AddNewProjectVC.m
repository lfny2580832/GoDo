//
//  AddNewProjectVC.m
//  CalendarTodoList
//
//  Created by 牛严 on 16/2/5.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import "AddNewProjectVC.h"
#import "ChooseTypeColorVC.h"

#import "RLMProject.h"
#import "TypeColor.h"

@interface AddNewProjectVC ()<ChooseTypeColorDelegate>

@end

@implementation AddNewProjectVC
{
    UITextField *_contentTextField;
    UIView *_colorView;
    TypeColor *_color;
}

#pragma mark ChooseTypeColorDelegate 返回所选颜色
- (void)returnTypeColorWithTypeColor:(TypeColor *)color
{
    _color = color;
    _colorView.backgroundColor = RGBA(color.red, color.green, color.blue, 1.0);
}

#pragma mark 选择颜色
- (void)chooseTypeColor
{
    ChooseTypeColorVC *vc = [[ChooseTypeColorVC alloc]init];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark 点击保存按钮
- (void)rightbarButtonItemOnclick:(id)sender
{
    RLMResults *result = [RLMProject allObjects];
    NSInteger count = result.count;
    RLMRealm *realm = [RLMRealm defaultRealm];
    RLMProject *rlmProject = [[RLMProject alloc]init];
    
    rlmProject.projectId = count + 1;
    rlmProject.projectStr = _contentTextField.text;
    rlmProject.red = _color.red;
    rlmProject.green = _color.green;
    rlmProject.blue = _color.blue;
    [realm beginWriteTransaction];
    [RLMProject createOrUpdateInRealm:realm withValue:rlmProject];
    [realm commitWriteTransaction];
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 初始化
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.view.backgroundColor = RGBA(235, 235, 241, 1.0);
        [self setRightBackButtontile:@"保存"];
        [self initView];
    }
    return self;
}

- (void)initView
{
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, 120)];
    backView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backView];
    
    _contentTextField = [[UITextField alloc]init];
    _contentTextField.textAlignment = NSTextAlignmentLeft;
    _contentTextField.placeholder = @"请输入项目名称";
    _contentTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [backView addSubview:_contentTextField];
    [_contentTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backView).offset(20);
        make.top.right.equalTo(backView);
        make.height.equalTo(@70);
    }];
    
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = RGBA(218, 221, 223, 1.0);
    [backView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.equalTo(backView);
        make.bottom.equalTo(backView).offset(-50);
        make.height.mas_equalTo(@1);
    }];
    
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *chooseRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(chooseTypeColor)];
    [titleLabel addGestureRecognizer:chooseRecognizer];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.text = @"颜色";
    [backView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineView);
        make.left.equalTo(backView).offset(20);
        make.height.mas_equalTo(50);
        make.width.mas_equalTo(@(SCREEN_WIDTH - 20));
    }];
    
    _colorView = [[UIView alloc]init];
    _colorView.layer.cornerRadius = 10.f;
    _colorView.backgroundColor = RGBA(59, 213, 251, 1.0);
    [backView addSubview:_colorView];
    [_colorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(backView).offset(-20);
        make.centerY.equalTo(titleLabel);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
}

@end
