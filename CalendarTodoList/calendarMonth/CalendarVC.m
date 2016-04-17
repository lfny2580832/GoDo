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
#import <LKDBHelper/LKDBHelper.h>
#import "UserDefaultManage.h"
#import "FMTodoModel.h"
#import "FMDayList.h"
#import "NSObject+NYExtends.h"
#import "WeekDayLabelView.h"

#import "QiNiuUploadImageTool.h"

@interface NYScrollView : UIScrollView

@end

@implementation NYScrollView

#pragma mark 模拟zoomToRect动画，并获得中间点
- (void)zoomToRect:(CGRect)rect point:(CGPoint)point duration:(NSTimeInterval)duration
{
    CGFloat finalScale = 3.0;
    CGSize scrollViewSize=self.bounds.size;
    //宽高是小的，以放大，point是zoomscale为1时的point
    CGFloat width = scrollViewSize.width/finalScale;
    CGFloat height = scrollViewSize.height /finalScale;
    CGFloat x = point.x-(width/2.0);
    CGFloat y = point.y-(height/2.0);
    CGRect zoomRect = CGRectMake(x, y, width, height);
    
    [UIView animateWithDuration:duration
                          delay:0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         [self zoomToRect:rect animated:NO];
                     }
                     completion:^(BOOL finished){
                         [self zoomToRect:zoomRect animated:YES];
                     }];
}

@end


@interface CalendarVC ()<UIScrollViewDelegate,RDVCalendarViewDelegate>
@property (nonatomic, strong) NYScrollView *bigScrollView;
@property (nonatomic, strong) CalendarTodoDetailVC *calendarTodoDetailVC;

@end

@implementation CalendarVC
{
    WeekDayLabelView *_weekDayView;
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

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)didChangeTitleDateWith:(NSString *)dateStr
{
    [self setCustomTitle:dateStr];
}

#pragma mark 回到今日
- (void)rightbarButtonItemOnclick:(id)sender
{
    [self.bigScrollView setZoomScale:1.0 animated:YES];
    [_calendarView showCurrentMonth];
}

#pragma mark 单击手势
- (void)singleTap:(UIGestureRecognizer *)sender
{
    [_calendarView tapDayCellWithGesture:sender];
}

#pragma mark 双击手势
- (void)doubleTap:(UIGestureRecognizer *)sender
{
    CGFloat outScale = 2.0;
    CGPoint tapPoint = [sender locationInView:self.bigScrollView];
    if (self.bigScrollView.zoomScale > 1) {
        [_calendarView changeCellTransparentWithAlpha: 0];
        [self.bigScrollView setZoomScale:1.0 animated:YES];
    }
    else
    {
        CGSize scrollViewSize=self.bigScrollView.bounds.size;
        //宽高是小的，以放大，point是zoomscale为1时的point
        CGFloat width = scrollViewSize.width/outScale;
        CGFloat height = scrollViewSize.height /outScale;
        CGFloat x = tapPoint.x-(width/2.0);
        CGFloat y = tapPoint.y-(height/2.0);
        CGRect zoomRect = CGRectMake(x, y, width, height);
        [self.bigScrollView zoomToRect:zoomRect point:tapPoint duration:0.3];
        
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark 初始化方法
- (instancetype)init
{
    self = [super init];
    if (self)
    {
        [self simulateData];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyy年M月";
        NSString *dateStr = [formatter stringFromDate:[NSDate date]];
        [self setCustomTitle:dateStr];
        [self setRightBackButtontile:@"回到今日"];
        [self initScrollView];
        [self initView];
    }
    return self;
}

- (void)simulateData
{
    if(![UserDefaultManager firstStart]){
        [UserDefaultManager setFirstStart:NO];
        [self simulateProject];
        [self simulateTodoList];
    }
}

- (void)simulateTodoList
{
    [UserDefaultManager setTodoMaxId:1];
    
    LKDBHelper *DBHelper = [FMTodoModel getUsingLKDBHelper];
    [LKDBHelper clearTableData:[FMTodoModel class]];
    
    FMTodoModel *todoModel = [[FMTodoModel alloc]init];
    todoModel.tableId = 1;
    todoModel.thingStr = @"开始创建你的任务吧！";
    NSDate *startDate = [NSDate dateWithTimeInterval:60*10 sinceDate:[NSDate date]];
    todoModel.startTime = [startDate timeIntervalSince1970];
    todoModel.isAllDay = NO;
    todoModel.doneType = NotDone;
    todoModel.repeatMode = Never;
    todoModel.remindMode = NoRemind;
    FMProject *project = [[DBHelper searchWithSQL:@"select * from @t where projectId = '3'" toClass:[FMProject class]] firstObject];
    todoModel.project = project;
    
    [DBHelper insertToDB:todoModel];
    
    FMDayList *dayList = [[FMDayList alloc]init];
    dayList.dayID = [NSObject getDayIdWithDateStamp:[startDate timeIntervalSince1970]];
    dayList.tableIDs = [[NSMutableArray alloc]init];
    [dayList.tableIDs addObject:[NSNumber numberWithInteger:todoModel.tableId]];
    
    [[FMDayList getUsingLKDBHelper] insertToDB:dayList];
}

- (void)simulateProject
{
    LKDBHelper *DBHelper = [[LKDBHelper alloc]init];
    [LKDBHelper clearTableData:[FMProject class]];
    FMProject *project = [[FMProject alloc]init];
    project.projectId = 1;
    project.projectStr = @"学习";
    project.red = 251;
    project.green = 136;
    project.blue = 110;
    
    [DBHelper insertToDB:project];
    
    project.projectId = 2;
    project.projectStr = @"社团";
    project.red = 59;
    project.green = 213;
    project.blue = 251;
    
    [DBHelper insertToDB:project];
    
    project.projectId = 3;
    project.projectStr = @"个人";
    project.red = 255;
    project.green = 204;
    project.blue = 0;
    
    [DBHelper insertToDB:project];
    
    project.projectId = 4;
    project.projectStr = @"工作";
    project.red = 226;
    project.green = 168;
    project.blue = 228;
    
    [DBHelper insertToDB:project];
    
    project.projectId = 5;
    project.projectStr = @"休闲";
    project.red = 210;
    project.green = 184;
    project.blue = 163;
    
    [DBHelper insertToDB:project];
}

- (void)initScrollView
{
    self.bigScrollView = [[NYScrollView alloc]initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 )];
    self.bigScrollView.delegate = self;
    self.bigScrollView.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.bigScrollView.showsHorizontalScrollIndicator = NO;
    self.bigScrollView.showsVerticalScrollIndicator = NO;
    self.bigScrollView.scrollEnabled = YES;
    //缩放、滑动弹性动画
    self.bigScrollView.bouncesZoom = NO;
    self.bigScrollView.bounces = NO;
    //锁定方位，但是可以斜着滑
    self.bigScrollView.directionalLockEnabled = YES;
    self.bigScrollView.minimumZoomScale = 1.0f;
    self.bigScrollView.maximumZoomScale = 4.5f;
    self.bigScrollView.zoomScale = self.bigScrollView.minimumZoomScale;
    [self.view addSubview:self.bigScrollView];
    
    UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singleTap:)];
    [singleTapGestureRecognizer setNumberOfTapsRequired:1];
    [self.bigScrollView addGestureRecognizer:singleTapGestureRecognizer];
    
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doubleTap:)];
    doubleTap.numberOfTapsRequired = 2;
    doubleTap.numberOfTouchesRequired = 1;
    [self.bigScrollView addGestureRecognizer:doubleTap];
    
    [singleTapGestureRecognizer requireGestureRecognizerToFail:doubleTap];

    //年月日日期格式，生成dayId
    _YMDformatter = [[NSDateFormatter alloc]init];
    [_YMDformatter setDateFormat:@"yyyyMMdd"];
    
}

- (void)initView
{
    _calendarView = [[RDVCalendarView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.bigScrollView.frame.size.height)];
    [_calendarView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    _calendarView.backgroundColor = [UIColor whiteColor];
    _calendarView.delegate = self;
    [self.bigScrollView addSubview:_calendarView];
    
    self.bigScrollView.contentSize = _calendarView.frame.size;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshCalendarViewAfterCreateOrDeleteTodo) name:@"ReloadTodoTableView" object:nil];

}

#pragma mark 刷新calendarview
- (void)refreshCalendarViewAfterCreateOrDeleteTodo
{
    [self.bigScrollView setZoomScale:1.0];
    [_calendarView refreshAfterCreateTodo];
}

#pragma mark 返回放大的View
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _calendarView;
}

#pragma mark 实时获取zoomscale的值
- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
        if (self.bigScrollView.zoomScale <= 4.5f && self.bigScrollView.zoomScale > 2.0f) {
            [_calendarView changeCellTransparentWithAlpha: self.bigScrollView.zoomScale / 2 - 1];
        }
        else if (self.bigScrollView.zoomScale < 2.0f) {
            [_calendarView changeCellTransparentWithAlpha:0];
        }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat weekLabelOffset = scrollView.contentOffset.y/scrollView.zoomScale;
    if(weekLabelOffset >= 0)
    {
        CGRect temp = _calendarView.weekDaysView.frame;
        temp.origin.y = weekLabelOffset;
        _calendarView.weekDaysView.frame = temp;
    }

}

#pragma mark RDVClendarView Delegate
- (void)calendarView:(RDVCalendarView *)calendarView didSelectDate:(NSDate *)date
{
    //leftbaritem被覆盖后，侧滑手势delegate自动置为nil。设置delegate为self实现侧滑
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    [self.navigationController pushViewController:self.calendarTodoDetailVC animated:YES];
    [_calendarTodoDetailVC setSelectedDayWithChosenDate:date];
}

@end
