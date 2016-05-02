//
//  ProjectMembersVC.m
//  GoDo
//
//  Created by 牛严 on 16/5/2.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import "ProjectMembersVC.h"
#import "ProjectMembersCell.h"
#import "ProjectAddMemberVC.h"
#import "ProjectModel.h"

@interface ProjectMembersVC ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation ProjectMembersVC
{
    UITableView *_tableView;
    NSArray *_members;
}

- (void)setProject:(ProjectModel *)project
{
    _project = project;
    _members = project.members;
    [_tableView reloadData];
}

#pragma mark 点击添加成员
- (void)rightbarButtonItemOnclick:(id)sender
{
    ProjectAddMemberVC *vc = [[ProjectAddMemberVC alloc]initWithProject:_project];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark UITableViewDelegate DataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseIdentifier = @"projectMemberCell";
    
    ProjectMembersCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if(!cell){
        cell = [[ProjectMembersCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }
    cell.member = _members[indexPath.row];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _members.count;
}

#pragma mark 初始化
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.view.backgroundColor = [UIColor whiteColor];
        [self setLeftBackButtonImage:[UIImage imageNamed:@"ico_nav_back_white.png"]];
        [self setCustomTitle:@"项目成员"];
        [self setRightBackButtonImage:[UIImage imageNamed:@"ico_add.png"]];
        [self initView];
    }
    return self;
}

- (void)initView
{
    _tableView = [[UITableView alloc]init];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.tableFooterView = [UIView new];
    _tableView.estimatedRowHeight = 60.0;
    _tableView.rowHeight = UITableViewAutomaticDimension;
    _tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 8)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.equalTo(self.view);
    }];
}

@end
