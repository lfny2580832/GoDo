//
//  ProjectVC.m
//  GoDo
//
//  Created by 牛严 on 16/3/30.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import "ProjectVC.h"
#import "LoginVC.h"
#import "SearchUserAPI.h"
#import "SearchUserModel.h"
#import "GetProjectAPI.h"
#import "GetProjectModel.h"
#import "AddNewProjectVC.h"
#import "AddProjectFooterView.h"

#import "ProjectCell.h"
#import "ProjectDetailVC.h"


@interface ProjectVC ()<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate>

@end

@implementation ProjectVC
{
    LoginVC *_loginVC;
    UITableView *_tableView;
    NSArray *_projects;
    
    BOOL _isFirst;
}

#pragma mark 获取用户项目
- (void)getUserProjects
{
    GetProjectAPI *api = [[GetProjectAPI alloc]initWithType:nil];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        GetProjectModel *model = [GetProjectModel yy_modelWithJSON:request.responseString];
        NSLog(@"---%@",request.responseString);
        _projects = model.projects;
        [_tableView reloadData];
        
    } failure:^(__kindof YTKBaseRequest *request) {
        
        [NYProgressHUD showToastText:@"获取项目失败"];

    }];
}

#pragma mark 创建新项目
- (void)creatNewProject
{
    if (![UserDefaultManager userName]) {
        [UserDefaultManager showLoginVCWith:self];
        return;
    }
    AddNewProjectVC *vc = [[AddNewProjectVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark 点击搜索
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSString *searchContent = @"632176758@qq.com";
    NYProgressHUD *hud = [[NYProgressHUD alloc]init];
    [hud showAnimationWithText:@"搜索中"];
    SearchUserAPI *api = [[SearchUserAPI alloc]initWithMail:searchContent];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        [hud hide];
        SearchUserModel *model = [SearchUserModel yy_modelWithJSON:request.responseString];
        NSLog(@"---%@",model.name);
    } failure:^(__kindof YTKBaseRequest *request) {
        [hud hide];
        [NYProgressHUD showToastText:@"查找失败"];
    }];
}

#pragma mark 登录界面
- (void)login
{
    _isFirst = YES;
    if (![UserDefaultManager userName]) {
        [UserDefaultManager showLoginVCWith:self];
        return;
    }
}

#pragma mark TableViewDelegate DataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseIdentifier = @"projectCell";
    
    ProjectCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if(!cell){
        cell = [[ProjectCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }
    [cell loadDataWithProjectModel:_projects[indexPath.row]];
    return cell;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _projects.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProjectModel *project = _projects[indexPath.row];
    ProjectDetailVC *vc = [[ProjectDetailVC alloc]initWithProject:project];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark 初始化

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setCustomTitle:@"我的项目"];
        [self initView];
        if ([UserDefaultManager token]) {
            [self getUserProjects];
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _isFirst = NO;
//    [self getUserProjects];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    
    if (![UserDefaultManager token] && _isFirst == NO) {
        [self login];
    }else if([UserDefaultManager token]){
        [self getUserProjects];
    }
}

- (void)initView
{
//    UISearchBar *searchBar = [[UISearchBar alloc]init];
//    searchBar.placeholder = @"请输入所查找用户的邮箱";
//    searchBar.showsCancelButton = NO;
//    searchBar.delegate = self;
//    [self.view addSubview:searchBar];
//    [searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.view);
//        make.left.right.equalTo(self.view);
//    }];

    _tableView = [[UITableView alloc]init];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.tableFooterView = [UIView new];
    _tableView.estimatedRowHeight = 50.0;
    _tableView.rowHeight = UITableViewAutomaticDimension;
    
    _tableView.scrollEnabled = NO;
    _tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 8)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.scrollEnabled = NO;
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.equalTo(self.view);
    }];
    
    AddProjectFooterView *footerView = [[AddProjectFooterView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44.0f)];
    _tableView.tableFooterView = footerView;
    UITapGestureRecognizer *addProjectGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(creatNewProject)];
    [footerView addGestureRecognizer:addProjectGes];
}

@end
