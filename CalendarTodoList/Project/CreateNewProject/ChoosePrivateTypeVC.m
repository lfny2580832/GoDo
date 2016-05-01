//
//  ChoosePrivateTypeVC.m
//  GoDo
//
//  Created by 牛严 on 16/4/11.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import "ChoosePrivateTypeVC.h"

@interface ChoosePrivateTypeVC ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation ChoosePrivateTypeVC
{
    UITableView *_tableView;
    NSMutableArray *_cells;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PrivateTypeCell *cell;
    if (indexPath.row == 0) {
        cell = [[PrivateTypeCell alloc]initWithPrivteType];
        [_cells addObject:cell];
    }else if(indexPath.row == 1){
        cell = [[PrivateTypeCell alloc]initWithPublicType];
        [_cells addObject:cell];
    }
    return cell;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PrivateTypeCell *cell;
    for (int i = 0; i < 2; i ++) {
        cell = [_cells objectAtIndex:i];
        if (indexPath.row == i) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            [self.delegate getPrivateTypeWith:cell.privateStr];
        }else{
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 初始化
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.view.backgroundColor = [UIColor whiteColor];
        _cells = [NSMutableArray arrayWithCapacity:2];
        [self setCustomTitle:@"设置项目权限"];
        [self setLeftBackButtonImage:[UIImage imageNamed:@"ico_nav_back_white.png"]];
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
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _tableView.estimatedRowHeight = 50.0;
    _tableView.rowHeight = UITableViewAutomaticDimension;
    _tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 8)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.scrollEnabled = NO;
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.equalTo(self.view);
    }];
}

@end

@implementation PrivateTypeCell
{
    UIImageView *_checkView;
}

- (instancetype)initWithPrivteType
{
    self = [super init];
    if (self) {
        _privateStr = @"私有";
        [self initViewWithType:_privateStr des:@"只有创建者能发布任务"];
    }
    return self;
}

- (instancetype)initWithPublicType
{
    self = [super init];
    if (self) {
        _privateStr = @"公有";
        [self initViewWithType:_privateStr des:@"项目成员均可发布任务"];
    }
    return self;
}

- (void)initViewWithType:(NSString *)type des:(NSString *)des
{
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.text = type;
    titleLabel.font = [UIFont systemFontOfSize:17];
    [self.contentView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(18);
        make.bottom.equalTo(self.contentView).offset(-20);
    }];
    
    UILabel *desLabel = [[UILabel alloc]init];
    desLabel.text = des;
    desLabel.font = [UIFont systemFontOfSize:13];
    [self.contentView addSubview:desLabel];
    [desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).offset(2);
        make.left.equalTo(titleLabel);
    }];
}

@end
