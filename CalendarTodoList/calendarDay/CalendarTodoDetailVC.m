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

@end

@implementation CalendarTodoDetailVC
{
    NSInteger _dayId;
}

#pragma mark 初始化
- (instancetype)initWithDayId:(NSInteger)dayId
{
    self = [super init];
    if (self) {
        _dayId = dayId;
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
    TodoCollectionView *todoCollectionView = [[TodoCollectionView alloc]initWithFrame:CGRectMake(0, 100, SCREEN_WIDTH, 400)];
    [self.view addSubview:todoCollectionView];
}

@end
