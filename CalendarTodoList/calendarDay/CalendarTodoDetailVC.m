//
//  CalendarTodoDetailVC.m
//  CalendarTodoList
//
//  Created by 牛严 on 16/1/7.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import "CalendarTodoDetailVC.h"
#import "TodoCollectionView.h"
#import "WeekCollectionView.h"
#import "TodoDetailVC.h"
#import "FMTodoModel.h"

@interface CalendarTodoDetailVC ()<WeekCellDelegate,TodoCollectionViewDelegate>
@property (nonatomic,strong) TodoCollectionView *todoCollectionView;
@property (nonatomic,strong) WeekCollectionView *weekCollectionView;
@end

@implementation CalendarTodoDetailVC
{
    NSDate *_chosenDate;
}
#pragma mark 点击TodoTableViewCell事件
- (void)didSelectedTodoTableViewCellWithTodo:(FMTodoModel *)todo
{
    TodoDetailVC *vc = [[TodoDetailVC alloc]initWithDate:_chosenDate];
    vc.todo = todo;
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark 添加新项目
- (void)addTodo
{
    TodoDetailVC *vc = [[TodoDetailVC alloc]initWithDate:_chosenDate];
    vc.todo = nil;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark 根据当前日期设置
- (void)setSelectedDayWithChosenDate:(NSDate *)chosenDate
{
    _chosenDate = chosenDate;
    [_todoCollectionView getIndexPageTodoCellWithChosenDate:chosenDate];
}

#pragma mark weekCollectionView Delegate
- (void)weekCellClickedWithIndexRow:(NSInteger)indexRow
{
    [_todoCollectionView setSelectedDayTodoCellWithIndexRow:indexRow];
}

#pragma mark 拿到日页，设置周页和日页
- (void)cellSelectedByChosenDateWithIndexRow:(NSInteger)indexRow
{
    NSInteger weekIndex = ceil(indexRow/7);
    [_weekCollectionView setWeekPageWithIndexItem:weekIndex animated:NO];
    [_todoCollectionView setSelectedDayTodoCellWithIndexRow:indexRow];
}

#pragma mark todocollectionview Delegate
- (void)selectedTodoCellWithIndexItem:(NSInteger)indexItem
{
    NSInteger weekIndex = ceil(indexItem/7);
    [_weekCollectionView setWeekPageWithIndexItem:weekIndex animated:YES];
    //选中week中的cell
    [_weekCollectionView setWeekCellSelectedWithIndexItem:indexItem];
}

#pragma mark 返回当前选择的日期
- (void)returnChosenDate:(NSDate *)chosenDate
{
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    comps = [[NSCalendar currentCalendar] components:
                                           NSCalendarUnitYear|
                                           NSCalendarUnitMonth|
                                           NSCalendarUnitDay|
                                           NSCalendarUnitHour
                                            fromDate:chosenDate];
    [comps setHour:8];
    NSDate *tempDate = [[NSCalendar currentCalendar] dateFromComponents:comps];
    _chosenDate = tempDate;
}

#pragma mark 初始化
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.view.backgroundColor = KNaviColor;
        [self setCustomTitle:@"时间轴"];
        [self setLeftBackButtonImage:[UIImage imageNamed:@"ico_nav_back_white.png"]];
        [self initView];
//        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(<#selector#>) name:@"ChosenDateNow" object:nil];
    }
    return self;
}

- (void)initView
{
    _weekCollectionView = [[WeekCollectionView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH/7)];
    _weekCollectionView.backgroundColor = KNaviColor;
    _weekCollectionView.mdelegate = self;
    [self.view addSubview:_weekCollectionView];
    
    CGFloat timeLineHeight = self.view.frame.size.height - SCREEN_WIDTH/7;
    _todoCollectionView = [[TodoCollectionView alloc]initWithFrame:CGRectMake(0, SCREEN_WIDTH/7, SCREEN_WIDTH, timeLineHeight) cellHeight:timeLineHeight];
    _todoCollectionView.backgroundColor = RGBA(222, 222, 222, 1.0);
    _todoCollectionView.mdelegate = self;
    [self.view addSubview:_todoCollectionView];

    UIButton *addTodoBtn = [[UIButton alloc]init];
    addTodoBtn.backgroundColor = KNaviColor;
    [addTodoBtn addTarget:self action:@selector(addTodo) forControlEvents:UIControlEventTouchUpInside];
    addTodoBtn.layer.cornerRadius = 25;
    [self.view addSubview:addTodoBtn];
    [addTodoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-20);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];

}

@end
