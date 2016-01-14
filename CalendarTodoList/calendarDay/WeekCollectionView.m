//
//  WeekCollectionView.m
//  CalendarTodoList
//
//  Created by 牛严 on 16/1/11.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import "WeekCollectionView.h"
#import "WeekCollectionViewCell.h"
#import "NSObject+NYExtends.h"

@implementation WeekCollectionView
{
    NSCalendar *_calendar;
    NSInteger _unitFlags;
    NSDate *_firstDayInCurrentMonth;
    NSDateFormatter *_YMDformatter;

}

static NSString * const reuseIdentifier = @"Cell";

- (void)setWeekPageWithIndexRow:(NSInteger)indexRow animated:(BOOL)animated
{
    [self setContentOffset:CGPointMake(indexRow * SCREEN_WIDTH, 0) animated:animated];
}

#pragma mark 获取当前日期到本月第一天之间的天数，以便设置第几个cell
- (NSInteger)daysBetweenFirstDayInCurrentMonthAndDate:(NSDate *)chosenDate
{
    NSDateComponents *comps = [_calendar components:_unitFlags fromDate:chosenDate];
    comps.hour = 12;
    NSDate *newEnd  = [_calendar dateFromComponents:comps];
    NSTimeInterval interval = [newEnd timeIntervalSinceDate:_firstDayInCurrentMonth];
    NSInteger beginDays=((NSInteger)interval)/(3600*24);
    return beginDays;
}

#pragma mark 根据现在的Indexpath，获取当前日期
- (NSDate *)getChosenDateFromIndexPathRow:(NSInteger)indexpathrow
{
    NSTimeInterval interval = 3600*24*(indexpathrow);
    NSDate * chosenDate = [_firstDayInCurrentMonth dateByAddingTimeInterval:interval];
    return chosenDate;
}

#pragma mark 初始化方法
- (instancetype)initWithFrame:(CGRect)frame
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setItemSize:CGSizeMake(SCREEN_WIDTH/7, SCREEN_WIDTH/7)];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    [flowLayout setMinimumLineSpacing:0];
    [flowLayout setMinimumInteritemSpacing:0];
    self = [super initWithFrame:frame collectionViewLayout:flowLayout];
    if (self) {
        [self initDateParameters];
        [self initView];
    }
    return self;
}

- (void)initDateParameters
{
    _calendar = [NSCalendar currentCalendar];
    _unitFlags = NSCalendarUnitDay| NSCalendarUnitMonth | NSCalendarUnitYear;
    //获取当前月第一天的日期
    NSDateComponents *comps = [_calendar components:_unitFlags fromDate:[NSDate date]];
    comps.day = 1;
    comps.hour = 12;
    _firstDayInCurrentMonth = [_calendar dateFromComponents:comps];
    _YMDformatter = [[NSDateFormatter alloc]init];
    [_YMDformatter setDateFormat:@"yyyyMMdd"];
}

- (void)initView
{
    self.delegate = self;
    self.dataSource = self;
    self.showsHorizontalScrollIndicator = NO;
    self.backgroundColor = [UIColor whiteColor];
    self.pagingEnabled = YES;
    [self registerClass:[WeekCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

#pragma mark CollectionView返回三个月天数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [NSObject numberOfDaysOfThreeMonths];
}

#pragma mark 生成CollectionView的Item
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    WeekCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    NSDate *chosenDate = [self getChosenDateFromIndexPathRow:indexPath.row];
    cell.date = chosenDate;
    cell.index = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
    cell.backgroundColor = [NSObject randomColor];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    WeekCollectionViewCell *cell = (WeekCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.backgroundColor = [UIColor blackColor];
    [self.mdelegate weekCellClickedWithIndexRow:indexPath.row];
}

@end
