//
//  RepeateModeVC.m
//  CalendarTodoList
//
//  Created by 牛严 on 16/3/4.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import "RepeateModeChooseVC.h"
#import "RepeatModeChooseCell.h"

@interface RepeateModeChooseVC ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation RepeateModeChooseVC
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
    RepeatModeChooseCell *cell = [[RepeatModeChooseCell alloc]init];
    cell.modeLabel.text = [NSString stringWithFormat:@"%@",[_modelNames objectAtIndex:indexPath.row]];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _modes.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RepeatMode mode = [[_modes objectAtIndex:indexPath.row] integerValue];
    [self.delegate returnRepeatModeWith:mode modeName:[_modelNames objectAtIndex:indexPath.row]];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 初始化
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self loadSubView];
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
              [NSNumber numberWithInteger:Never],
              [NSNumber numberWithInteger:EveryDay],
              [NSNumber numberWithInteger:EveryMonth],
              [NSNumber numberWithInteger:EveryWeek],
              [NSNumber numberWithInteger:EveryWeekend],
              [NSNumber numberWithInteger:EveryWorkDay],nil];
    _modelNames = [NSMutableArray arrayWithObjects:@"不重复",@"每天",@"每月",@"每周",@"每周末",@"工作日", nil];
}

@end
