
//
//  ChooseMemberVC.m
//  GoDo
//
//  Created by 牛严 on 16/5/1.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import "ChooseMemberVC.h"
#import "MemberCell.h"

@interface ChooseMemberVC ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation ChooseMemberVC
{
    UITableView *_tableView;
    NSArray *_members;
}

- (void)setReceivers:(NSArray *)receivers
{
    
}

#pragma mark UITableView Delegate DataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseIdentifier = @"memberCell";
    
    MemberCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if(!cell){
        cell = [[MemberCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }
    cell.memberName = _members[indexPath.row];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _members.count;
}


#pragma mark 初始化
- (instancetype)initWithMembers:(NSArray *)members
{
    self = [super init];
    if (self) {
        _members = members;
        self.view.backgroundColor = [UIColor whiteColor];
        [self setLeftBackButtonImage:[UIImage imageNamed:@"ico_back_nav_white.png"]];
        [self setCustomTitle:@"选择任务执行者"];
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
    _tableView.estimatedRowHeight = 50.0;
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
