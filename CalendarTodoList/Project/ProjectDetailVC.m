//
//  ProjectDetailVC.m
//  GoDo
//
//  Created by 牛严 on 16/4/12.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import "ProjectDetailVC.h"
#import "ProjectDetailView.h"

#import "GetMissionAPI.h"
#import "ProjectModel.h"

#import "CreateMissionAPI.h"
#import "GetMissionModel.h"

@implementation ProjectDetailVC
{
    ProjectDetailView *_projectDetailView;
    NSArray *_missions;
    
    ProjectModel *_project;
}

#pragma mark 获取项目mission
- (void)getProjectMission
{
    GetMissionAPI *api = [[GetMissionAPI alloc]initWithMissionId:_project.id];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        NSLog(@"--%@",request.responseString);
        GetMissionModel *model = [GetMissionModel yy_modelWithJSON:request.responseString];
        _missions = model.missions;
        _projectDetailView.missions = _missions;
        [_projectDetailView.tableView reloadData];
    } failure:^(__kindof YTKBaseRequest *request) {
        [NYProgressHUD showToastText:@"获取任务失败"];
    }];
}

#pragma mark 发布任务
- (void)createMission
{
    NYProgressHUD *hud = [[NYProgressHUD alloc]init];
    [hud showAnimationWithText:@"发布任务中"];
    CreateMissionAPI *api = [[CreateMissionAPI alloc]initWithName:@"shit" desc:@"fuck" projectId:_project.id receiversId:nil];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        [hud hide];
        [NYProgressHUD showToastText:@"发布任务成功"];
        NSLog(@"----%@",request.responseString);
    } failure:^(__kindof YTKBaseRequest *request) {
        [hud hide];
        [NYProgressHUD showToastText:@"发布任务失败"];
    }];
}

- (void)rightbarButtonItemOnclick:(id)sender
{
    [self createMission];
}

#pragma mark 初始化
- (instancetype)initWithProject:(ProjectModel *)project
{
    self = [super init];
    if (self) {
        _project = project;
        self.view.backgroundColor = RGBA(232, 232, 232, 1.0);
        [self setCustomTitle:@"项目详情"];
        [self setLeftBackButtonImage:[UIImage imageNamed:@"ico_nav_back_white.png"]];
        [self setRightBackButtontile:@"添加任务"];
        [self initView];
        [self getProjectMission];
    }
    return self;
}

- (void)initView
{
    _projectDetailView = [[ProjectDetailView alloc]init];
    _projectDetailView.project = _project;
    _projectDetailView.backgroundColor = RGBA(232, 232, 232, 1.0);
    [self.view addSubview:_projectDetailView];
    [_projectDetailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.equalTo(self.view);
    }];
}

@end
