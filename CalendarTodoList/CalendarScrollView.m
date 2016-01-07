//
//  CalendarScrollView.m
//  CalendarTodoList
//
//  Created by 牛严 on 15/12/28.
//  Copyright © 2015年 牛严. All rights reserved.
//

#import "CalendarScrollView.h"
#import "RDVCalendarView.h"
#import "CalendarTodoDetailVC.h"

@interface CalendarScrollView ()<UIScrollViewDelegate,RDVCalendarViewDelegate>

@end

@implementation CalendarScrollView
{
    UIView *_backView;
    RDVCalendarView *_calendarView;
    NSDateFormatter *_YMDformatter;
}

#pragma mark 初始化方法
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        
        self.delegate = self;
        self.backgroundColor = [UIColor whiteColor];

        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        
        self.scrollEnabled = YES;
        
        //缩放、滑动弹性动画
        self.bouncesZoom = NO;
        self.bounces = NO;
        
        self.directionalLockEnabled = YES;
        
        self.minimumZoomScale = 1.0f;
        self.maximumZoomScale = 4.5f;
        self.zoomScale = self.minimumZoomScale;
        
        _YMDformatter = [[NSDateFormatter alloc]init];
        [_YMDformatter setDateFormat:@"yyyyMMdd"];
        
        [self initView];
    }
    return self;
}

- (void)initView
{
    _calendarView = [[RDVCalendarView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.frame.size.height)];
    [_calendarView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    _calendarView.backgroundColor = [UIColor whiteColor];
    _calendarView.delegate = self;
    [self addSubview:_calendarView];

    self.contentSize = _calendarView.frame.size;
}

#pragma mark 返回放大的View
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _calendarView;
}

#pragma mark 实时获取zoomscale的值
- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    if (self.zoomScale <= 4.5f && self.zoomScale > 1.5f) {
        [_calendarView changeCellTransparentWithAlpha: self.zoomScale / 3 - 0.5];
    }
    else if (self.zoomScale <= 1.5f) {
        [_calendarView changeCellTransparentWithAlpha:0];
    }
    //防止放大状态切换月份，不能用hidden，会导致可以滑到其他月份
    if (self.zoomScale > 1) {
        _calendarView.forwardButton.alpha = 0;
        _calendarView.forwardButton.enabled = NO;
        _calendarView.backButton.alpha = 0;
        _calendarView.backButton.enabled = NO;
    }else{
        _calendarView.forwardButton.alpha = 1;
        _calendarView.forwardButton.enabled = YES;
        _calendarView.backButton.alpha = 1;
        _calendarView.backButton.enabled = YES;
    }
}

//检测scrollview的contentoffset，到了60说明weekdaylabel到了屏幕顶端;此时将weekdaylabel悬在self的顶端
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat weekLabelOffset = self.contentOffset.y/self.zoomScale;
    if(weekLabelOffset >= 60)
    {
        CGRect temp = _calendarView.weekDaysView.frame;
        temp.origin.y = weekLabelOffset;
        _calendarView.weekDaysView.frame = temp;
    }
    else
    {
        CGRect temp = _calendarView.weekDaysView.frame;
        temp.origin.y = 60;
        _calendarView.weekDaysView.frame = temp;
    }
}

#pragma mark RDVClendarView Delegate
- (void)calendarView:(RDVCalendarView *)calendarView didSelectDate:(NSDate *)date
{
    NSInteger dayId = [[_YMDformatter stringFromDate:date] integerValue];
    CalendarTodoDetailVC *vc = [[CalendarTodoDetailVC alloc]initWithDayId:dayId];
}

@end
