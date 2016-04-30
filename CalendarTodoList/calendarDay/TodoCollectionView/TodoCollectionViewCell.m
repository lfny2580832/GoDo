//
//  TodoCollectionViewCell.m
//  CalendarTodoList
//
//  Created by 牛严 on 16/1/8.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import "TodoCollectionViewCell.h"

#import "TodoTableViewCell.h"

#import "NSString+ZZExtends.h"
#import "NSObject+NYExtends.h"

#import "DBManage.h"

@interface TodoCollectionViewCell ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation TodoCollectionViewCell
{
    NSArray <FMTodoModel *> *_todoArray;
}

#pragma mark Set方法
- (void)setDayId:(NSInteger)dayId
{
    _tableView.tableFooterView.hidden = YES;
    _todoArray = nil;
    [_tableView reloadData];

    _dayId = dayId;
    [self realmGetDayInfoFromRealmWithDayId:_dayId];

}

- (void)realmGetDayInfoFromRealmWithDayId:(NSInteger)dayId
{
    dispatch_async(kBgQueue, ^{
        _todoArray = [DBManager getDayInfoFromDateList:dayId];
        dispatch_async(kMainQueue, ^{
            [_tableView reloadData];
            [_tableView layoutIfNeeded];
            if (dayId < [NSObject getDayIdWithDate:[NSDate date]])
                _tableView.tableFooterView.hidden = YES;
            else
                _tableView.tableFooterView.hidden = NO;
            _tableView.alpha = 0;

            [UIView animateWithDuration:0.2 animations:^{
                _tableView.alpha = 1;
            } completion:^(BOOL finished) {
                [_tableView setContentSize:CGSizeMake(_tableView.contentSize.width, _tableView.contentSize.height + 200)];
                if (_tableView.contentSize.height > _tableView.frame.size.height - 60) {
                    _tableView.scrollEnabled = YES;
                }
            }];
        });
    });

}

#pragma mark 新建todo后刷新数据
- (void)refreshTableViewAfterCreateOrDelete
{
    [self realmGetDayInfoFromRealmWithDayId:_dayId];
}

#pragma mark 初始化
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = RGBA(232, 232, 232, 1.0);
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshTableViewAfterCreateOrDelete) name:@"ReloadTodoTableView" object:nil];
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
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.estimatedRowHeight = 80.0;
    _tableView.rowHeight = UITableViewAutomaticDimension;

    _tableView.scrollEnabled = NO;
    _tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 8)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.scrollEnabled = NO;
    [self.contentView addSubview:_tableView];
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
    [cell loadTodo:_todoArray[indexPath.row]];

    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _todoArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [self.delegate didSelectedTodoTableCellWithTodo:_todoArray[indexPath.row]];
}

@end
