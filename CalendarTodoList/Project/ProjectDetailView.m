//
//  ProjectDetailView.m
//  GoDo
//
//  Created by 牛严 on 16/4/12.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import "ProjectDetailView.h"
#import "MissionCell.h"
#import "ProjectModel.h"
#import "AvatarCollectionView.h"
#import "ProjectMemberModel.h"

@interface ProjectDetailView ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation ProjectDetailView
{
    UILabel *_projectNameLabel;
    UILabel *_projectDesLabel;
    UILabel *_memberNamesLabel;
    AvatarCollectionView *_avatarView;
    id _target;
}


- (void)setProject:(ProjectModel *)project
{
    if (project) {
        _project = project;
        _avatarView.project = _project;
        _projectNameLabel.text = project.name;
        _projectDesLabel.text = project.desc;
        NSMutableString *membersStr = [NSMutableString new];
        for(ProjectMemberModel *member in project.members)
        {
            [membersStr appendFormat:@"%@,",member.name];
        }
        NSString *baseStr = [membersStr substringToIndex:[membersStr length] - 1];
        
        _memberNamesLabel.text = [NSString stringWithFormat:@"%@ 等 %lu 人",baseStr,(unsigned long)project.members.count];
    }
}

#pragma mark TableViewDelegate DataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseIdentifier = @"missionCell";
    
    MissionCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if(!cell){
        cell = [[MissionCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }
    cell.delegate = _target;
    cell.mission = _missions[indexPath.row];
    return cell;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _missions.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [self.delegate didSelectCellAtIndexPath:indexPath];
}

#pragma mark 初始化
- (instancetype)initWithTarget:(id)target
{
    self = [super init];
    if (self) {
        _target = target;
        self.backgroundColor = [UIColor whiteColor];
        [self initView];
    }
    return self;
}

- (void)initView
{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 120)];
    headerView.backgroundColor = [UIColor whiteColor];
    
    _projectNameLabel = [[UILabel alloc]init];
    _projectNameLabel.font = [UIFont boldSystemFontOfSize:17];
    _projectNameLabel.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:_projectNameLabel];
    [_projectNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerView).offset(20);
        make.centerX.equalTo(headerView);
//        make.left.equalTo(headerView).offset(18);
//        make.right.equalTo(headerView).offset(-18);
    }];
    
    _projectDesLabel = [[UILabel alloc]init];
    _projectDesLabel.font = [UIFont systemFontOfSize:12];
    _projectDesLabel.textColor = RGBA(146, 146, 146, 1.0);
    _projectDesLabel.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:_projectDesLabel];
    [_projectDesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_projectNameLabel.mas_bottom).offset(4);
        make.centerX.equalTo(_projectNameLabel);
        make.width.equalTo(_projectNameLabel);
    }];
    
    _avatarView = [[AvatarCollectionView alloc]initWithFrame:CGRectMake(50, 64, SCREEN_WIDTH - 100, 55)];
    _avatarView.mdelegate = _target;
    [headerView addSubview:_avatarView];
    

    _tableView = [[UITableView alloc]init];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.tableFooterView = [UIView new];
    _tableView.estimatedRowHeight = 50.0;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.rowHeight = UITableViewAutomaticDimension;
    _tableView.scrollEnabled = NO;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.scrollEnabled = YES;
    _tableView.tableHeaderView = headerView;
    [self addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.equalTo(self);
    }];

}

@end
