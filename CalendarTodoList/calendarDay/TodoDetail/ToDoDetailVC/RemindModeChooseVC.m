//
//  RemindModeChooseVC.m
//  CalendarTodoList
//
//  Created by 牛严 on 16/3/27.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import "RemindModeChooseVC.h"
#import "RemindModeChooseCell.h"

@interface RemindModeChooseVC ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation RemindModeChooseVC

{
    UITableView *_tableView;
    NSMutableArray *_modes;
    NSMutableArray *_modelNames;
}

#pragma mark TableView Delegate DataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RemindModeChooseCell *cell = [[RemindModeChooseCell alloc]init];
    cell.modeLabel.text = [NSString stringWithFormat:@"%@",[_modelNames objectAtIndex:indexPath.row]];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _modes.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RemindMode mode = [[_modes objectAtIndex:indexPath.row] integerValue];
    [self.delegate returnRemindModeWith:mode modeName:[_modelNames objectAtIndex:indexPath.row]];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 初始化
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self loadSubView];
        [self setCustomTitle:@"选择提醒时间"];
        [self setLeftBackButtonImage:[UIImage imageNamed:@"ico_nav_back_white.png"]];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadData];
}

- (void)loadSubView
{
    _tableView = [[UITableView alloc]init];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.tableFooterView = [UIView new];
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.equalTo(self.view);
    }];
}

- (void)loadData
{
    _modes = [NSMutableArray arrayWithObjects:
              [NSNumber numberWithInteger:NoRemind],
              [NSNumber numberWithInteger:OnTime],
              [NSNumber numberWithInteger:FiveMinutesEarlier],
              [NSNumber numberWithInteger:TenMinutesEarlier],
              [NSNumber numberWithInteger:FifteenMinutesEarlier],
              [NSNumber numberWithInteger:ThirtyMinutesEarlier],nil];
    _modelNames = [NSMutableArray arrayWithObjects:@"不提醒",@"准时提醒",@"提前5分钟",@"提前10分钟",@"提前15分钟",@"提前半小时", nil];
}

@end
