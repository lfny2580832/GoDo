//
//  ChooseProjectVC.m
//  CalendarTodoList
//
//  Created by 牛严 on 16/2/4.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import "ChooseProjectVC.h"
#import "ChooseProjectTableCell.h"
#import "AddNewProjectVC.h"

#import "ThingType.h"

#import "RealmManage.h"

@interface ChooseProjectVC ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation ChooseProjectVC
{
    UITableView *_tableView;
    NSMutableArray *_projects;
}

#pragma mark TableView Delegate DataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == _projects.count) {
        ChooseProjectTableCell *cell = [[ChooseProjectTableCell alloc]initWithContentLabel];
        return cell;
    }
    ChooseProjectTableCell *cell = [[ChooseProjectTableCell alloc]init];
    cell.type = _projects[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _projects.count + 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == _projects.count) {
        AddNewProjectVC *vc = [[AddNewProjectVC alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    [self.delegate returnProjectWithThingType:_projects[indexPath.row]];
    [self.navigationController popViewControllerAnimated:YES];
}

//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return YES;
//}
//
//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        [_projects removeObjectAtIndex:indexPath.row];
//        [_tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
//        
//    }
//    else if (editingStyle == UITableViewCellEditingStyleInsert) {
//        //插入
//    }
//}
//
//- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return @"删除项目";
//}

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
    dispatch_async(kBgQueue, ^{
        _projects = [RealmManager getThingTypeArray];
        dispatch_async(kMainQueue, ^{
            if (_projects) {
                [_tableView reloadData];
            }
        });
    });
}

@end
