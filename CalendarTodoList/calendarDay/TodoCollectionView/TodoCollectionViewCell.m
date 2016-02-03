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

#import "NSString+ZZExtends.h"

@interface TodoCollectionViewCell ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation TodoCollectionViewCell
{
    NSArray <TodoList *> *_todoListArray;
    
    UITableView *_tableView;
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
    dispatch_async(kBgQueue, ^{
        _todoListArray = [RealmManager getDayInfoFromRealmWithDayId:dayId];
        dispatch_async(kMainQueue, ^{
            if (_todoListArray) {
                [_tableView reloadData];
            }
        });
    });
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
    [self addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.equalTo(self.contentView);
    }];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40.f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _todoListArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.delegate didSelectedTodoTableCellWithTodoList:_todoListArray[indexPath.row]];
}

@end
