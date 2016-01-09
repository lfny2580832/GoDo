//
//  TodoCollectionView.m
//  CalendarTodoList
//
//  Created by 牛严 on 16/1/8.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import "TodoCollectionView.h"
#import "TodoCollectionViewCell.h"

@implementation TodoCollectionView
{
    NSInteger _unitFlags;
    NSCalendar *_calendar;
    NSDate *_firstDayInCurrentMonth;
    NSInteger _daysOfThreeMonths;         //当前月开始的三个月的天数
    NSInteger _firstMonthDays;
    NSInteger _secondMonthDays;
    NSInteger _thirdMonthDays;
}

static NSString * const reuseIdentifier = @"Cell";

- (void)setSelectedDayTodoCellWithChosenDate:(NSDate *)chosenDate
{
    NSInteger pageIndex = [self daysBetweenFirstDayInCurrentMonthAndDate:chosenDate] + 1;
    [self setContentOffset:CGPointMake(SCREEN_WIDTH * pageIndex, 0)];
}

#pragma mark 获取当前日期到本月第一天之间的天数，以便设置第几个cell
- (NSInteger)daysBetweenFirstDayInCurrentMonthAndDate:(NSDate *)chosenDate
{
    NSDateComponents *comps = [_calendar components:_unitFlags fromDate:chosenDate];
    NSDate *newEnd  = [_calendar dateFromComponents:comps];
    
    NSTimeInterval interval = [newEnd timeIntervalSinceDate:_firstDayInCurrentMonth];
    NSInteger beginDays=((NSInteger)interval)/(3600*24);
    
    return beginDays;
}

#pragma mark 根据现在的Indexpath，获取当前日期


#pragma mark 获取当前三个月的天数
- (NSInteger)numberOfDaysOfThreeMonths {
    NSCalendar *currentCalendar = [NSCalendar autoupdatingCurrentCalendar];
    NSDateComponents *currentComponents = [currentCalendar components:NSCalendarUnitYear|
                                           NSCalendarUnitMonth|
                                           NSCalendarUnitDay|
                                           NSCalendarUnitWeekday|
                                           NSCalendarUnitCalendar
                                                             fromDate:[NSDate date]];
    //用来加一个月的component
    NSDateComponents *inc = [[NSDateComponents alloc] init];
    inc.month = 1;
    //第一个月的日期和天数
    _firstMonthDays = [currentCalendar rangeOfUnit:NSCalendarUnitDay
                                                     inUnit:NSCalendarUnitMonth
                                                    forDate:[NSDate date]].length;
    
    NSDate *currentDate = [currentCalendar dateFromComponents:currentComponents];
    //第二个月的日期和天数
    NSDate *secondDate = [currentCalendar dateByAddingComponents:inc toDate:currentDate options:0];
    _secondMonthDays = [currentCalendar rangeOfUnit:NSCalendarUnitDay
                                                      inUnit:NSCalendarUnitMonth
                                                     forDate:secondDate].length;
    //第三个月的日期和天数
    NSDate *thirdDate = [currentCalendar dateByAddingComponents:inc toDate:secondDate options:0];
    _thirdMonthDays = [currentCalendar rangeOfUnit:NSCalendarUnitDay
                                                     inUnit:NSCalendarUnitMonth
                                                    forDate:thirdDate].length;
    
    return _firstMonthDays + _secondMonthDays + _thirdMonthDays;
}

#pragma mark 初始化方法
- (instancetype)initWithFrame:(CGRect)frame
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setItemSize:frame.size];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    [flowLayout setMinimumLineSpacing:0];
    self = [super initWithFrame:frame collectionViewLayout:flowLayout];
    if (self) {
        [self initDateParameters];
        [self initView];
    }
    return self;
}

- (void)initDateParameters
{
    _daysOfThreeMonths = [self numberOfDaysOfThreeMonths];
    _calendar = [NSCalendar currentCalendar];
    _unitFlags = NSCalendarUnitDay| NSCalendarUnitMonth | NSCalendarUnitYear;
    //获取当前月第一天的日期
    NSDateComponents *comps = [_calendar components:_unitFlags fromDate:[NSDate date]];
    comps.day = 1;
    comps.hour = 16;
    _firstDayInCurrentMonth = [_calendar dateFromComponents:comps];
}

- (void)initView
{
    self.delegate = self;
    self.dataSource = self;
    self.backgroundColor = [UIColor whiteColor];
    self.pagingEnabled = YES;
    [self registerClass:[TodoCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

#pragma mark CollectionView返回三个月天数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _daysOfThreeMonths;
}

- (UIColor *)randomColor
{
    CGFloat hue = ( arc4random() % 256 / 256.0 );  //0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  // 0.5 to 1.0,away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //0.5 to 1.0,away from black
    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
}

#pragma mark 生成CollectionView的Item
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TodoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    //计算indexpath 是哪一天，拿数据
    NSLog(@"index %ld",(long)indexPath.row);
    cell.backgroundColor = [self randomColor];
    return cell;
}

@end
