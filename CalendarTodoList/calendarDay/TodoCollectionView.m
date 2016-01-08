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
    NSInteger _daysOfThreeMonths;         //当前月开始的三个月的天数
}

static NSString * const reuseIdentifier = @"Cell";

#pragma mark 初始化方法
- (instancetype)initWithFrame:(CGRect)frame
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setItemSize:frame.size];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    [flowLayout setMinimumLineSpacing:0];
    self = [super initWithFrame:frame collectionViewLayout:flowLayout];
    if (self) {
        _daysOfThreeMonths = [self numberOfDaysOfThreeMonths];
        [self initView];
    }
    return self;
}

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
    NSInteger firstMonthDays = [currentCalendar rangeOfUnit:NSCalendarUnitDay
                                                     inUnit:NSCalendarUnitMonth
                                                    forDate:[NSDate date]].length;
    
    NSDate *currentDate = [currentCalendar dateFromComponents:currentComponents];
    //第二个月的日期和天数
    NSDate *secondDate = [currentCalendar dateByAddingComponents:inc toDate:currentDate options:0];
    NSInteger secondMonthDays = [currentCalendar rangeOfUnit:NSCalendarUnitDay
                                                      inUnit:NSCalendarUnitMonth
                                                     forDate:secondDate].length;
    //第三个月的日期和天数
    NSDate *thirdDate = [currentCalendar dateByAddingComponents:inc toDate:secondDate options:0];
    NSInteger thirdMonthDays = [currentCalendar rangeOfUnit:NSCalendarUnitDay
                                                      inUnit:NSCalendarUnitMonth
                                                     forDate:thirdDate].length;
    
    return firstMonthDays + secondMonthDays + thirdMonthDays;
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

#pragma mark 生成并重用CollectionView的Item
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TodoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [self randomColor];
    return cell;
}

@end
