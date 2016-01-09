//
//  CalendarTodoDetailVC.m
//  CalendarTodoList
//
//  Created by 牛严 on 16/1/7.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import "CalendarTodoDetailVC.h"
#import "TodoCollectionView.h"

@interface CalendarTodoDetailVC ()
@property (nonatomic,strong) TodoCollectionView *todoCollectionView;
@end

@implementation CalendarTodoDetailVC
{
    NSInteger _dayId;
    NSDate *_chosenDate;
}

- (void)setDay
{
}

#pragma mark 初始化
- (instancetype)initWithDayId:(NSInteger)dayId date:(NSDate *)date
{
    self = [super init];
    if (self) {
        _dayId = dayId;
        _chosenDate = date;
        self.view.backgroundColor = [UIColor whiteColor];
        [self initializationNaviBar];
        [self initView];
    }
    return self;
}

- (void)initializationNaviBar
{
    [self setLeftBackButtonImage:[UIImage imageNamed:@"ico_nav_back_white.png"]];
    NSString *title = [NSString stringWithFormat:@"%ld",_dayId];
    [self setCustomTitle:title color:[UIColor whiteColor]];
}

- (void)initView
{
    UIButton *testButton = [[UIButton alloc]initWithFrame:CGRectMake(70, 30, 100, 50)];
    testButton.backgroundColor = [UIColor blackColor];
    [testButton addTarget:self action:@selector(setDay) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:testButton];
    
    _todoCollectionView = [[TodoCollectionView alloc]initWithFrame:CGRectMake(0, 100, SCREEN_WIDTH, SCREEN_HEIGHT - 100)];
    [self.view addSubview:_todoCollectionView];
    [_todoCollectionView setSelectedDayTodoCellWithChosenDate:_chosenDate];

}

@end
