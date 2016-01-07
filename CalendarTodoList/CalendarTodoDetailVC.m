//
//  CalendarTodoDetailVC.m
//  CalendarTodoList
//
//  Created by 牛严 on 16/1/7.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import "CalendarTodoDetailVC.h"

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
        [self initView];
    }
    return self;
}

- (void)leftbarButtonItemOnclick:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)initializationNaviBar
{
    [self setLeftBackButtonImage:[UIImage imageNamed:@"ico_nav_back.png"]];
    NSString *title = [NSString stringWithFormat:@"%ld",_dayId];
    [self setCustomTitle:title];
}

- (void)initView
{
    
}

@end
