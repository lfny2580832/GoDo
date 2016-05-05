//
//  ProjectDetailVC.m
//  GoDo
//
//  Created by 牛严 on 16/4/12.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import "ProjectDetailVC.h"
#import "ProjectDetailView.h"
#import "MissionCell.h"
#import "TodoDetailVC.h"

#import "GetMissionAPI.h"
#import "ProjectModel.h"

#import "CreateMissionAPI.h"
#import "GetMissionModel.h"

#import "CreateMissionVC.h"
#import "ProjectMembersVC.h"
#import "AvatarCollectionView.h"
#import "ProjectAddMemberVC.h"

#import "GetProjectInfoAPI.h"
#import "ProjectModel.h"


@interface ProjectDetailVC ()<ProjectDetailViewDelegate,MissionCellDelegate,AvatarCollectionViewDelegate>

@end

@implementation ProjectDetailVC
{
    ProjectDetailView *_projectDetailView;
    NSArray *_missions;
    
    NSString *_projectId;
    ProjectModel *_project;
}

#pragma mark 点击头像
- (void)didSelectAvatarViewWith:(ProjectModel *)project
{
    ProjectMembersVC *vc = [[ProjectMembersVC alloc]init];
    vc.project = project;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didSelectAvatarViewToAddMember
{
    ProjectAddMemberVC *vc = [[ProjectAddMemberVC alloc]initWithProject:_project];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark 接受任务
- (void)acceptMissionWithMission:(MissionModel *)mission images:(NSArray *)images
{
    TodoDetailVC *vc = [[TodoDetailVC alloc]initWithDate:[NSDate dateWithTimeInterval:60*10 sinceDate:[NSDate date]]];
    [vc loadMissionModel:mission images:images projectId:_projectId];
    [vc setCustomTitle:@"领取任务"];
    [vc setRightBackButtontile:@"确认"];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark 获取项目信息
- (void)getProjectInfo
{
    GetProjectInfoAPI *api = [[GetProjectInfoAPI alloc]initWithProjectId:_projectId];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        _project = [ProjectModel yy_modelWithJSON:request.responseString];
        
        if (_project.code == 0) {
            
            _projectDetailView.project = _project;
            [self getProjectMission];

        }
    } failure:^(__kindof YTKBaseRequest *request) {
        
    }];
}

#pragma mark 获取项目mission
- (void)getProjectMission
{
    GetMissionAPI *api = [[GetMissionAPI alloc]initWithMissionId:_projectId];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        GetMissionModel *model = [GetMissionModel yy_modelWithJSON:request.responseString];
        if (model.code == 0) {
            _missions = model.missions;
            _projectDetailView.missions = _missions;
            [_projectDetailView.tableView reloadData];
        }else{
            [NYProgressHUD showToastText:model.msg];
        }

    } failure:^(__kindof YTKBaseRequest *request) {
        [NYProgressHUD showToastText:@"获取任务失败"];
    }];
}

//#pragma mark 进入mission详情页面
//- (void)didSelectCellAtIndexPath:(NSIndexPath *)indexPath
//{
//    CreateMissionVC *vc = [[CreateMissionVC alloc]initWithProject:_project];
//    vc.mission = _missions[indexPath.row];
//    [self.navigationController pushViewController:vc animated:YES];
//}

#pragma mark 邮件添加mission
- (void)rightbarButtonItemOnclick:(id)sender
{
    CreateMissionVC *vc = [[CreateMissionVC alloc]initWithProject:_project];
    vc.mission = nil;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark 发布任务成功后返回刷新
- (void)refreshMissions
{
    [self getProjectMission];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshMissions) name:@"refreshMission" object:nil];
}

#pragma mark 初始化
- (instancetype)initWithProjectId:(NSString *)projectId
{
    self = [super init];
    if (self) {
        _projectId = projectId;
        self.view.backgroundColor = RGBA(232, 232, 232, 1.0);
        [self setCustomTitle:@"项目详情"];
        [self setLeftBackButtonImage:[UIImage imageNamed:@"ico_nav_back_white.png"]];
        [self setRightBackButtontile:@"添加任务"];
        [self initView];
        [self getProjectInfo];
        
    }
    return self;
}

- (void)initView
{
    _projectDetailView = [[ProjectDetailView alloc]initWithTarget:self];
    _projectDetailView.project = _project;
    _projectDetailView.delegate = self;
    _projectDetailView.backgroundColor = RGBA(232, 232, 232, 1.0);
    [self.view addSubview:_projectDetailView];
    [_projectDetailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.equalTo(self.view);
    }];
}

@end
