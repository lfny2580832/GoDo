//
//  AddNewProjectVC.m
//  CalendarTodoList
//
//  Created by 牛严 on 16/2/5.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import "AddNewProjectVC.h"
#import "ChooseTypeColorVC.h"
#import "ChoosePrivateTypeVC.h"
#import "FMTodoModel.h"
#import "TypeColor.h"

#import "CreateProjectAPI.h"
#import "CreateProjectModel.h"

#import "DBManage.h"

@interface AddNewProjectVC ()<ChooseTypeColorDelegate,ChoosePrivateTypeVCDelegate>

@end

@implementation AddNewProjectVC
{
    UITextField *_contentTextField;
    UITextField *_descTextField;
    UIView *_colorView;
    TypeColor *_color;
    UILabel *_privateLabel;
    BOOL _proPrivate;
}

#pragma mark 返回权限
- (void)getPrivateTypeWith:(NSString *)name
{
    _privateLabel.text = name;
    if ([name isEqualToString:@"私有"]) {
        _proPrivate = YES;
    }else{
        _proPrivate = NO;
    }
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

#pragma mark 选择私有性
- (void)choosePrivateType
{
    ChoosePrivateTypeVC *vc = [[ChoosePrivateTypeVC alloc]init];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark 点击保存按钮
- (void)rightbarButtonItemOnclick:(id)sender
{
    [self.view endEditing:YES];
    NSString *name = _contentTextField.text;
    if (!name.length) {
        [NYProgressHUD showToastText:@"请输入项目名称"];
        return;
    }
    
    CreateProjectAPI *api = [[CreateProjectAPI alloc]initWithName:name private:_proPrivate desc:_descTextField.text];
    NYProgressHUD *hud = [NYProgressHUD new];
    [hud showAnimationWithText:@"创建项目中"];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        [hud hide];
        CreateProjectModel *model = [CreateProjectModel yy_modelWithJSON:request.responseString];
        if (model.code == 0) {
            NSString *projectId = model.id;
            [NYProgressHUD showToastText:@"创建成功" completion:^{
                [DBManager saveProjectInDBWithId:projectId projectName:name color:_color];
                [self.navigationController popViewControllerAnimated:YES];
            }];
        }else{
            [NYProgressHUD showToastText:model.msg];
        }
    } failure:^(__kindof YTKBaseRequest *request) {
        [hud hide];
        [NYProgressHUD showToastText:@"创建失败"];
    }];
}

#pragma mark 初始化
- (instancetype)init
{
    self = [super init];
    if (self) {
        _proPrivate = YES;
        self.view.backgroundColor = RGBA(235, 235, 241, 1.0);
        [self setCustomTitle:@"创建新项目"];
        [self setLeftBackButtonImage:[UIImage imageNamed:@"ico_nav_back_white.png"]];
        [self setRightBackButtontile:@"保存"];
        [self initView];
        FMProject *defaultProject = [[FMProject searchWithWhere:nil] firstObject];
        _color = [[TypeColor alloc]init];
        _color.red = defaultProject.red;
        _color.green = defaultProject.green;
        _color.blue = defaultProject.blue;
        _colorView.backgroundColor = RGBA(_color.red, _color.green, _color.blue, 1.0);

    }
    return self;
}

- (void)initView
{
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, 220)];
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
        make.right.equalTo(backView);
        make.left.equalTo(backView).offset(18);
        make.bottom.equalTo(backView).offset(-150);
        make.height.mas_equalTo(@1);
    }];


    _descTextField = [[UITextField alloc]init];
    _descTextField.textAlignment = NSTextAlignmentLeft;
    _descTextField.placeholder = @"请输入项目简介";
    _descTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [backView addSubview:_descTextField];
    [_descTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineView);
        make.left.equalTo(backView).offset(20);
        make.right.equalTo(backView).offset(-20);
        make.height.mas_equalTo(@50);
    }];

    UIView *lineView3 = [[UIView alloc]init];
    lineView3.backgroundColor = RGBA(218, 221, 223, 1.0);
    [backView addSubview:lineView3];
    [lineView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(backView);
        make.left.equalTo(backView).offset(18);
        make.bottom.equalTo(backView).offset(-100);
        make.height.mas_equalTo(@1);
    }];
    
    _privateLabel = [[UILabel alloc]init];
    _privateLabel.text = @"私有";
    _privateLabel.font = [UIFont systemFontOfSize:15];
    [backView addSubview:_privateLabel];
    [_privateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_descTextField.mas_bottom);
        make.right.equalTo(backView).offset(-20);
        make.height.mas_equalTo(@50);
    }];
    
    
    UILabel *privateNameLabel = [[UILabel alloc]init];
    privateNameLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *choosePrivateRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(choosePrivateType)];
    [privateNameLabel addGestureRecognizer:choosePrivateRecognizer];
    privateNameLabel.textAlignment = NSTextAlignmentLeft;
    privateNameLabel.font = [UIFont systemFontOfSize:15];
    privateNameLabel.text = @"权限";
    [backView addSubview:privateNameLabel];
    [privateNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_privateLabel);
        make.left.equalTo(backView).offset(20);
        make.height.mas_equalTo(50);
        make.width.mas_equalTo(@(SCREEN_WIDTH - 20));
    }];
    
    UIView *lineView2 = [[UIView alloc]init];
    lineView2.backgroundColor = RGBA(218, 221, 223, 1.0);
    [backView addSubview:lineView2];
    [lineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(backView);
        make.left.equalTo(backView).offset(18);
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
        make.top.equalTo(lineView2);
        make.left.equalTo(backView).offset(20);
        make.height.mas_equalTo(50);
        make.width.mas_equalTo(@(SCREEN_WIDTH - 20));
    }];
    
    _colorView = [[UIView alloc]init];
    _colorView.layer.cornerRadius = 10.f;
    [backView addSubview:_colorView];
    [_colorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(backView).offset(-20);
        make.centerY.equalTo(titleLabel);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
}

@end
