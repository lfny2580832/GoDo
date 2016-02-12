//
//  CalendarScrollView.m
//  CalendarTodoList
//
//  Created by 牛严 on 15/12/28.
//  Copyright © 2015年 牛严. All rights reserved.
//

#import "CalendarVC.h"
#import "RDVCalendarView.h"
#import "CalendarTodoDetailVC.h"

@interface CalendarVC ()<UIScrollViewDelegate,RDVCalendarViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) CalendarTodoDetailVC *calendarTodoDetailVC;

@end

@implementation CalendarVC
{
    RDVCalendarView *_calendarView;
    NSDateFormatter *_YMDformatter;
}

- (CalendarTodoDetailVC *)calendarTodoDetailVC
{
    if (!_calendarTodoDetailVC) {
        _calendarTodoDetailVC = [[CalendarTodoDetailVC alloc]init];
    }
    return _calendarTodoDetailVC;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
#pragma mark 初始化方法
- (instancetype)init
{
    self = [super init];
    if (self)
    {
        [self setCustomTitle:@"日历"];
        [self initScrollView];
        [self initView];
    }
    return self;
}

- (void)initScrollView
{
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 49)];
    self.scrollView.delegate = self;
    self.scrollView.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.scrollEnabled = YES;
    //缩放、滑动弹性动画
    self.scrollView.bouncesZoom = NO;
    self.scrollView.bounces = NO;
    //锁定方位，但是可以斜着滑
    self.scrollView.directionalLockEnabled = YES;
    self.scrollView.minimumZoomScale = 1.0f;
    self.scrollView.maximumZoomScale = 4.5f;
    self.scrollView.zoomScale = self.scrollView.minimumZoomScale;
    [self.view addSubview:self.scrollView];
    //年月日日期格式，生成dayId
    _YMDformatter = [[NSDateFormatter alloc]init];
    [_YMDformatter setDateFormat:@"yyyyMMdd"];
}

- (void)initView
{
    _calendarView = [[RDVCalendarView alloc] initWithFrame:CGRectMake(1, 0, SCREEN_WIDTH-2, self.scrollView.frame.size.height)];
    [_calendarView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    _calendarView.backgroundColor = [UIColor whiteColor];
    _calendarView.delegate = self;
    [self.scrollView addSubview:_calendarView];

    self.scrollView.contentSize = _calendarView.frame.size;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshCalendarViewAfterCreateTodolist) name:@"ReloadTodoTableView" object:nil];

}

#pragma mark 刷新calendarview
- (void)refreshCalendarViewAfterCreateTodolist
{
    [self.scrollView setZoomScale:1.0];
    [_calendarView refreshAfterCreateTodolist];
}

#pragma mark 返回放大的View
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _calendarView;
}

#pragma mark 实时获取zoomscale的值
- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    if (self.scrollView.zoomScale <= 3.0f && self.scrollView.zoomScale > 1.5f) {
        [_calendarView changeCellTransparentWithAlpha: self.scrollView.zoomScale / 1.5 - 1];
    }
    else if (self.scrollView.zoomScale <= 1.5f) {
        [_calendarView changeCellTransparentWithAlpha:0];
    }
    //防止放大状态切换月份，不能用hidden，会导致可以滑到其他月份
    if (self.scrollView.zoomScale > 1) {
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
    CGFloat weekLabelOffset = self.scrollView.contentOffset.y/self.scrollView.zoomScale;
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
//    NSInteger dayId = [[_YMDformatter stringFromDate:date] integerValue];
    //leftbaritem被覆盖后，侧滑手势delegate自动置为nil。设置delegate为self实现侧滑
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    [self.navigationController pushViewController:self.calendarTodoDetailVC animated:YES];
    [_calendarTodoDetailVC setSelectedDayWithChosenDate:date];
}

@end
