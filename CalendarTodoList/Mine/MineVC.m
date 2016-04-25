//
//  MineVC.m
//  GoDo
//
//  Created by 牛严 on 16/4/23.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import "MineVC.h"
#import "MineCell.h"
#import "MineInfoCell.h"
#import "MineInfoVC.h"

#import "LoginVC.h"

@interface MineVC ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation MineVC
{
    UITableView *_tableView;
    NSString *_headImageUrl;

    BOOL _isFirst;
    
    MineInfoCell *_mineInfoCell;
}

#pragma mark TableViewDelegate DataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0) {
        return _mineInfoCell;
    }else if(indexPath.section == 1 && indexPath.row == 0)
    {
        MineCell *cell = [[MineCell alloc]init];
        cell.titleLabel.text = @"我的消息";
        return cell;
    }else
    {
        MineCell *cell = [[MineCell alloc]init];
        cell.titleLabel.text = @"设置";
        return cell;
    }
    return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
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
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.section == 0 && indexPath.row == 0) {
        MineInfoVC *vc = [[MineInfoVC alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

#pragma mark 登录界面
- (void)login
{
    _isFirst = YES;
    LoginVC *loginVC = [[LoginVC alloc]init];
    [self presentViewController:loginVC animated:YES completion:nil];
}



#pragma mark 通知方法，加载头像
- (void)loadHeadImageWithNotification:(NSNotification *)notification
{
    NSString *imageUrl = notification.object;
    [_mineInfoCell loadHeadImageWithUrl:imageUrl];
}


#pragma mark 初始化
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [_mineInfoCell loadHeadImage];
    
    if (![UserDefaultManager token] && _isFirst == NO) {
        [self login];
    }
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _isFirst = NO;
        self.view.backgroundColor = RGBA(232, 232, 232, 1.0);
        _mineInfoCell = [[MineInfoCell alloc]init];
        [self setCustomTitle:@"我的"];
        [self initViews];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadHeadImageWithNotification:) name:@"loadHeadImage" object:nil];
    }
    return self;
}

- (void)initViews
{
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
    _tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.equalTo(self.view);
    }];
}

@end
