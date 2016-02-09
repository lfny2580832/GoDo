//
//  TodoDetailVC.m
//  CalendarTodoList
//
//  Created by 牛严 on 16/1/31.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import "TodoDetailVC.h"
#import "TodoList.h"

#import "TodoContentView.h"
#import "TodoProjectView.h"
#import "ChooseProjectVC.h"
#import "DatePickerCell.h"

#import "RealmManage.h"

@interface TodoDetailVC ()<TodoContentViewDelegate,TodoProjectViewDelegate,ChooseProjectVCDelegate,UITableViewDataSource,UITableViewDelegate>

@end

@implementation TodoDetailVC
{
    TodoContentView *_todoContentView;
    TodoProjectView *_todoProjectView;
    UITableView *_tableView;
    
    NSMutableDictionary *_selectedIndexes;
    
    NSString *_todoContentStr;
    ThingType *_todoThingType;
}

#pragma mark ChooseProjectVC Delegate 获取返回的type类型
- (void)returnProjectWithThingType:(ThingType *)type
{
    _todoThingType = type;
    _todoProjectView.thingType = type;
}

#pragma mark 选择todo所属项目
- (void)chooseTodoProject
{
    ChooseProjectVC *vc = [[ChooseProjectVC alloc]init];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark Set Methods
- (void)setTodoList:(TodoList *)todoList
{
    if(!todoList)
    {
        ThingType *defaultType = [[RealmManager getThingTypeArray] firstObject];
        _todoContentView.todoContentField.text = @"";
        _todoProjectView.thingType = defaultType;
        return;
    }
    _todoList = todoList;
    _todoContentView.todoContentField.text = _todoList.thing.thingStr;
    _todoProjectView.thingType = [RealmManager getThingTypeWithThingTypeId:_todoList.thing.thingType.typeId];
}

#pragma mark 获取TodoContent
- (void)getTodoContentWith:(NSString *)todoContentStr
{
    if ([_todoContentStr isEqualToString:@""]) {
        //不能提交
        
        return;
    }
    _todoContentStr = todoContentStr;
}

#pragma mark 点击保存
- (void)rightbarButtonItemOnclick:(id)sender
{
    
}

#pragma mark TableView DataSource Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [NSString stringWithFormat:@"%ld",(long)section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DatePickerCell *cell = [[DatePickerCell alloc]init];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([self cellIsSelected:indexPath]) {
        return 50 * 2.0;
    }
    
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:TRUE];
    
    _selectedIndexes = [[NSMutableDictionary alloc] init];
    BOOL isSelected = ![self cellIsSelected:indexPath];
    
    NSNumber *selectedIndex = [NSNumber numberWithBool:isSelected];
    [_selectedIndexes setObject:selectedIndex forKey:indexPath];
    
    [tableView beginUpdates];
    [tableView endUpdates];
}

- (BOOL)cellIsSelected:(NSIndexPath *)indexPath
{
    NSNumber *selectedIndex = [_selectedIndexes objectForKey:indexPath];
    return selectedIndex == nil ? FALSE : [selectedIndex boolValue];
}

#pragma mark 初始化
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.view.backgroundColor = RGBA(247, 247, 247, 1.0);
        [self setRightBackButtontile:@"保存"];
        [self initViews];
    }
    return self;
}

- (void)initViews
{
    UIView *headView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 125)];
    
    _todoContentView = [[TodoContentView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 75)];
    _todoContentView.delegate = self;
    [headView addSubview:_todoContentView];
    
    _todoProjectView = [[TodoProjectView alloc]initWithFrame:CGRectMake(0, 75, SCREEN_WIDTH, 50)];
    _todoProjectView.delegate = self;
    [headView addSubview:_todoProjectView];
    
    _tableView = [[UITableView alloc]init];
    _tableView.tableHeaderView = headView;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.equalTo(self.view);
    }];
    
}

@end
