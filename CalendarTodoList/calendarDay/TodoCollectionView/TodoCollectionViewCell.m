//
//  TodoCollectionViewCell.m
//  CalendarTodoList
//
//  Created by 牛严 on 16/1/8.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import "TodoCollectionViewCell.h"

#import <Realm/Realm.h>
#import "TodoList.h"
#import "Thing.h"
#import "RealmManage.h"

#import "TodoTableViewCell.h"
#import "AddTodoFooterView.h"

#import "NSString+ZZExtends.h"
#import "NSObject+NYExtends.h"

@interface TodoCollectionViewCell ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation TodoCollectionViewCell
{
    NSArray <TodoList *> *_todoListArray;
    
}

#pragma mark - 重用TodoCell时先清空数据
- (void)refreshTableViewBeforQueryData
{
    _todoListArray = nil;
    [_tableView reloadData];
}

#pragma mark Set方法
- (void)setDayId:(NSInteger)dayId
{
    _dayId = dayId;
    [self realmGetDayInfoFromRealmWithDayId:_dayId];
    
    if (dayId < [NSObject getDayIdWithDate:[NSDate date]])
        _tableView.tableFooterView.hidden = YES;
    else
        _tableView.tableFooterView.hidden = NO;
}

- (void)realmGetDayInfoFromRealmWithDayId:(NSInteger)dayId
{
    dispatch_async(kBgQueue, ^{
        _todoListArray = [RealmManager getDayInfoFromRealmWithDayId:dayId];
        dispatch_async(kMainQueue, ^{
            [_tableView reloadData];
        });
    });
}

#pragma mark 添加项目
- (void)addTodoList
{
    [self.delegate didSelectedTodoTableCellWithTodoList:nil];
}

#pragma mark 新建todolist后刷新数据
- (void)refreshTableViewAfterCreateOrDelete
{
    [self realmGetDayInfoFromRealmWithDayId:_dayId];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

#pragma mark 初始化
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)initView
{
    _tableView = [[UITableView alloc]init];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.tableFooterView = [UIView new];
    _tableView.estimatedRowHeight = 40.0;
    _tableView.rowHeight = UITableViewAutomaticDimension;
    [self addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.equalTo(self.contentView);
    }];
    
    AddTodoFooterView *footerView = [[AddTodoFooterView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    UITapGestureRecognizer *footerTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addTodoList)];
    [footerView addGestureRecognizer:footerTap];
    _tableView.tableFooterView = footerView;
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshTableViewAfterCreateOrDelete) name:@"ReloadTodoTableView" object:nil];
}

#pragma mark UITableViewDelegate DataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseIdentifier = @"todotableviewcell";

    TodoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if(!cell){
        cell = [[TodoTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.todoList = _todoListArray[indexPath.row];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _todoListArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [self.delegate didSelectedTodoTableCellWithTodoList:_todoListArray[indexPath.row]];
}

@end
