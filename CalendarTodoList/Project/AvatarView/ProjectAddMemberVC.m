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

#import <SDWebImage/UIImageView+WebCache.h>

@interface ProjectAddMemberVC ()<UISearchBarDelegate>

@end

@implementation ProjectAddMemberVC
{
    UIImageView *_avatarView;
    UILabel *_nameLabel;
    UIView *_resultView;
    
    SearchUserModel *_searchResult;
}

#pragma mark 点击搜索
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
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

#pragma mark 初始化
- (instancetype)init
{
    self = [super init];
    if (self) {
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
