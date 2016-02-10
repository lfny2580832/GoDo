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
#import "ChooseModeCell.h"

#import "RealmManage.h"
#import "NSString+ZZExtends.h"

@interface TodoDetailVC ()<TodoContentViewDelegate,TodoProjectViewDelegate,ChooseProjectVCDelegate,ChooseModeCellDelegate,UITableViewDataSource,UITableViewDelegate>

@end

@implementation TodoDetailVC
{
    TodoContentView *_todoContentView;
    TodoProjectView *_todoProjectView;
    UITableView *_tableView;
    
    NSMutableDictionary *_selectedIndexes; //所有cell高度的数组
    NSIndexPath *_selectedIndexPath; //当前选择的可变高度cell的index
    
    UIDatePickerMode _datePickerMode; //全天 or 时段
    NSIndexPath *_startIndexPath;
    NSIndexPath *_endIndexPath;
    
    
    NSString *_todoContentStr;
    ThingType *_todoThingType;
    NSDate *_startDate;
    NSDate *_endDate;
}

static CGFloat cellHeight = 50.f;
static CGFloat datePickerCellHeight = 240.f;

#pragma mark 返回全天或时段
- (void)datePickerModeValueChanged:(BOOL)value
{
    if (value)  _datePickerMode = UIDatePickerModeDate;
    else _datePickerMode = UIDatePickerModeDateAndTime;
    
    DatePickerCell *startCell = [_tableView cellForRowAtIndexPath:_startIndexPath];
    [startCell setDatePickerMode:_datePickerMode date:_startDate];
    
    DatePickerCell *endCell = [_tableView cellForRowAtIndexPath:_endIndexPath];
    [endCell setDatePickerMode:_datePickerMode date:_endDate];
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
        _startDate = [NSDate date];
        _endDate = [NSDate dateWithTimeInterval:60*60 sinceDate:_startDate];
        return;
    }
    _todoList = todoList;
    _todoContentView.todoContentField.text = _todoList.thing.thingStr;
    _todoProjectView.thingType = [RealmManager getThingTypeWithThingTypeId:_todoList.thing.thingType.typeId];
    _startDate = [NSDate dateWithTimeIntervalSinceReferenceDate:_todoList.startTime];
    _endDate = [NSDate dateWithTimeIntervalSinceReferenceDate:_todoList.endTime];

    [_tableView reloadData];
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
    if(section == 0) return 3;
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0) {
        ChooseModeCell *cell = [[ChooseModeCell alloc]init];
        if (_datePickerMode == UIDatePickerModeDateAndTime) {
            [cell.switchButton setOn:NO];
        }else{
            [cell.switchButton setOn:YES];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        return cell;
    }else if (indexPath.section == 0 && indexPath.row == 1){
        _startIndexPath = indexPath;
        DatePickerCell *cell = [[DatePickerCell alloc]init];
        [cell setDatePickerMode:_datePickerMode date:_startDate];
        cell.titleLabel.text = @"开始";
        return cell;
    }else if (indexPath.section == 0 && indexPath.row == 2){
        _endIndexPath = indexPath;
        DatePickerCell *cell = [[DatePickerCell alloc]init];
        [cell setDatePickerMode:_datePickerMode date:_endDate];
        cell.titleLabel.text = @"结束";
        return cell;
    }else{
        DatePickerCell *cell = [[DatePickerCell alloc]init];
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([self cellIsSelected:indexPath]) return datePickerCellHeight;
    
    return cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && (indexPath.row == 1||indexPath.row == 2))
    {
        //处理datepickercell高度逻辑
        if (_selectedIndexPath == indexPath) {
            _selectedIndexPath = nil;
            _selectedIndexes = [[NSMutableDictionary alloc] init];

        }else{
            _selectedIndexPath = indexPath;
            _selectedIndexes = [[NSMutableDictionary alloc] init];
            BOOL isSelected = ![self cellIsSelected:indexPath];
            NSNumber *selectedIndex = [NSNumber numberWithBool:isSelected];
            [_selectedIndexes setObject:selectedIndex forKey:indexPath];
        }
        //处理cell重新赋值逻辑
        [tableView beginUpdates];
        [tableView endUpdates];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:TRUE];

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
        _datePickerMode = UIDatePickerModeDateAndTime;
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
