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

@interface CalendarTodoDetailVC ()
@property (nonatomic,strong) TodoCollectionView *todoCollectionView;
@property (nonatomic,strong) WeekCollectionView *weekCollectionView;
@end

@implementation CalendarTodoDetailVC
{
    NSDate *_chosenDate;
}

- (void)setSelectedDayWithChosenDate:(NSDate *)chosenDate
{
    [_todoCollectionView setSelectedDayTodoCellWithChosenDate:chosenDate];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
}

#pragma mark 初始化
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.view.backgroundColor = [UIColor whiteColor];
        [self initView];
    }
    return self;
}

- (void)initView
{
    _weekCollectionView = [[WeekCollectionView alloc]initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, SCREEN_WIDTH/7)];
    [self.view addSubview:_weekCollectionView];
    
    _todoCollectionView = [[TodoCollectionView alloc]initWithFrame:CGRectMake(0, 200, SCREEN_WIDTH, SCREEN_HEIGHT - 200)];
    [self.view addSubview:_todoCollectionView];
}

@end
