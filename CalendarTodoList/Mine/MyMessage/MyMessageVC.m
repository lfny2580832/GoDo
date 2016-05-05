//
//  MyMessageVC.m
//  GoDo
//
//  Created by 牛严 on 16/4/26.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import "MyMessageVC.h"
#import "GetUserMessageModel.h"
#import "GetUserMessageAPI.h"
#import "JoinProjectAPI.h"
#import "UserMessageModel.h"
#import "DealWithMessageAPI.h"

#import "AcceptInvitationCell.h"
#import "ProjectDetailVC.h"

#import "TypeColor.h"
#import "ChooseTypeColorVC.h"

#import "DBManage.h"

@interface MyMessageVC ()<UITableViewDataSource,UITableViewDelegate,AcceptInvitationCellDelegate,ChooseTypeColorDelegate>

@end

@implementation MyMessageVC
{
    UITableView *_tableView;
    NSArray *_messages;
    TypeColor *_joinProColor;
    NSString *_joinProjectId;
    NSString *_joinProjectName;
}

#pragma mark 选择颜色回调
- (void)returnTypeColorWithTypeColor:(TypeColor *)color
{
    _joinProColor = color;
    
    NYProgressHUD *hud = [NYProgressHUD new];
    [hud showAnimationWithText:@"正在加入项目"];
    JoinProjectAPI *api = [[JoinProjectAPI alloc]initWithProjectId:_joinProjectId];
    [api startWithSuccessBlock:^{
        [DBManager saveProjectInDBWithId:_joinProjectId projectName:_joinProjectName color:_joinProColor];
        [hud hide];
        [NYProgressHUD showToastText:@"加入项目成功"];
    } failure:^{
        [hud hide];
        [NYProgressHUD showToastText:@"加入项目失败"];
    }];
}

#pragma mark 跳转至项目信息页面
- (void)jumpToProjectInfoVCWithId:(NSString *)projectId
{
    ProjectDetailVC *vc = [[ProjectDetailVC alloc]initWithProjectId:projectId];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark 加入项目
- (void)joinProjectWithId:(NSString *)projectId name:(NSString *)projectName
{
    _joinProjectId = projectId;
    _joinProjectName = projectName;
    
    ChooseTypeColorVC *vc = [[ChooseTypeColorVC alloc]init];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark 获取用户信息
- (void)requestForUserMessage
{
    GetUserMessageAPI *api = [[GetUserMessageAPI alloc]init];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        GetUserMessageModel *model = [GetUserMessageModel yy_modelWithJSON:request.responseString];
        if (model.code == 0) {
            _messages = model.messages;
            [_tableView reloadData];
//            NSLog(@"---%@",request.responseString);
        }
    } failure:^(__kindof YTKBaseRequest *request) {
        [NYProgressHUD showToastText:@"获取消息失败"];
    }];
}

#pragma mark TableViewDelegate DataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseIdentifier = @"messageCell";
    
    AcceptInvitationCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if(!cell){
        cell = [[AcceptInvitationCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }
    cell.message = _messages[indexPath.section];
    cell.delegate = self;
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _messages.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}

#pragma mark 初始化
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.view.backgroundColor = RGBA(232, 232, 232, 1.0);
        [self setCustomTitle:@"我的消息"];
        [self setLeftBackButtonImage:[UIImage imageNamed:@"ico_nav_back_white.png"]];
        [self initView];
        [self requestForUserMessage];
    }
    return self;
}

- (void)initView
{
    _tableView = [[UITableView alloc]init];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.tableFooterView = [UIView new];
    _tableView.estimatedRowHeight = 82.0;
    _tableView.rowHeight = UITableViewAutomaticDimension;
    _tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 8)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.equalTo(self.view);
    }];
}

@end
