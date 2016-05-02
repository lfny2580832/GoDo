//
//  ProjectAddMemberVC.m
//  GoDo
//
//  Created by 牛严 on 16/5/2.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import "ProjectAddMemberVC.h"
#import "SearchUserAPI.h"
#import "SearchUserModel.h"
#import "InviteMemberInProjectAPI.h"
#import "ProjectModel.h"

#import <SDWebImage/UIImageView+WebCache.h>

@interface ProjectAddMemberVC ()<UISearchBarDelegate>

@end

@implementation ProjectAddMemberVC
{
    UIImageView *_avatarView;
    UILabel *_nameLabel;
    UIView *_resultView;
    
    SearchUserModel *_searchResult;
    ProjectModel *_project;
}

#pragma mark 点击搜索
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.view endEditing:YES];
    NSString *searchContent = searchBar.text;
    NYProgressHUD *hud = [[NYProgressHUD alloc]init];
    [hud showAnimationWithText:@"搜索中"];
    SearchUserAPI *api = [[SearchUserAPI alloc]initWithMail:searchContent];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        [hud hide];
        _searchResult = [SearchUserModel yy_modelWithJSON:request.responseString];
        _resultView.hidden = NO;
        [_avatarView sd_setImageWithURL:[NSURL URLWithString:_searchResult.avatar]];
        _nameLabel.text = _searchResult.name;
        
    } failure:^(__kindof YTKBaseRequest *request) {
        [hud hide];
        [NYProgressHUD showToastText:@"查找失败"];
    }];
}

#pragma mark 点击邀请
- (void)requestToInviteMemberInProject
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"您将邀请%@加入项目",_searchResult.name] message:[NSString stringWithFormat:@"%@",_project.name] preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action)
    {
        NYProgressHUD *hud = [NYProgressHUD new];
        [hud showAnimationWithText:@"邀请中"];
        InviteMemberInProjectAPI *api = [[InviteMemberInProjectAPI alloc]initWithInvitee:_searchResult.id projectId:_project.id projectName:_project.name];
        [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
            [hud hide];
            BaseModel *model = [BaseModel yy_modelWithJSON:request.responseString];
            if (model.code == 0) {
                [NYProgressHUD showToastText:@"邀请成功"];
            }else{
                [NYProgressHUD showToastText:model.msg];
            }
        } failure:^(__kindof YTKBaseRequest *request) {
            [hud hide];
            [NYProgressHUD showToastText:@"邀请失败"];
        }];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:nil];
    [alertController addAction:okAction];
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark 初始化
- (instancetype)initWithProject:(ProjectModel *)project
{
    self = [super init];
    if (self) {
        _project = project;
        self.view.backgroundColor = RGBA(225, 225, 225, 1.0);
        [self setLeftBackButtonImage:[UIImage imageNamed:@"ico_nav_back_white.png"]];
        [self setCustomTitle:@"添加成员"];
        [self initView];
    }
    return self;
}

- (void)initView
{
    UISearchBar *searchBar = [[UISearchBar alloc]init];
    searchBar.placeholder = @"请输入所查找用户的邮箱";
    searchBar.showsCancelButton = NO;
    searchBar.delegate = self;
    [self.view addSubview:searchBar];
    [searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.right.equalTo(self.view);
    }];
    
    _resultView = [[UIView alloc]init];
    _resultView.hidden = YES;
    UITapGestureRecognizer *inviteGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(requestToInviteMemberInProject)];
    [_resultView addGestureRecognizer:inviteGes];
    _resultView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_resultView];
    [_resultView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(searchBar.mas_bottom).offset(10);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(@60);
    }];
    
    _avatarView = [[UIImageView alloc]init];
    _avatarView.layer.cornerRadius = 18;
    _avatarView.layer.masksToBounds = YES;
    [_resultView addSubview:_avatarView];
    [_avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_resultView);
        make.left.equalTo(_resultView).offset(18);
        make.size.mas_equalTo(CGSizeMake(36, 36));
    }];
    
    _nameLabel = [[UILabel alloc]init];
    [_resultView addSubview:_nameLabel];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_resultView);
        make.left.equalTo(_avatarView.mas_right).offset(10);
    }];
    
}

@end
