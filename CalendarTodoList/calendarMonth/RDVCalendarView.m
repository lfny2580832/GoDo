// RDVCalendarView.m
// RDVCalendarView
//
// Copyright (c) 2013 Robert Dimitrov
//

#import "RDVCalendarView.h"
#import "RDVCalendarDayCell.h"
#import "UILabelZoomable.h"
#import "GradientView.h"

@interface RDVCalendarView () {
    NSMutableArray *_visibleCells;
    NSMutableArray *_dayCells;
    
    NSInteger _numberOfDays;
    
    NSMutableArray *_separators;
    NSMutableArray *_visibleSeparators;
    
    RDVCalendarDayCell *_selectedDayCell;
    
//    NSArray *_weekDays;
    Class _dayCellClass;
    UIView *_maskView;
    
    UIInterfaceOrientation _orientation;
}

@property (nonatomic, strong) NSDateComponents *selectedDay;
@property (nonatomic, strong, readwrite) NSDateComponents *month;
@property (nonatomic, strong) NSDateComponents *currentDay;
@property (nonatomic, strong) NSDate *firstDay;

@end

@implementation RDVCalendarView

//static NSString *DayIdentifier = @"DayCell";

#pragma mark 初始化view
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _dayCells = [[NSMutableArray alloc] initWithCapacity:31];
        _visibleCells = [[NSMutableArray alloc] initWithCapacity:31];
        
        _visibleSeparators = [[NSMutableArray alloc] initWithCapacity:12];
        _separators = [[NSMutableArray alloc] initWithCapacity:12];
        
        // Setup defaults
        
        _currentDayColor = [UIColor colorWithRed:80/255.0 green:200/255.0 blue:240/255.0 alpha:1.0];
        _selectedDayColor = [UIColor grayColor];
        _separatorColor = [UIColor lightGrayColor];
        
        _separatorEdgeInsets = UIEdgeInsetsZero;
        _dayCellEdgeInsets = UIEdgeInsetsMake(1, 1, 1, 1);
        
        _dayCellClass = [RDVCalendarDayCell class];
        
        _maskView = [[UIView alloc]initWithFrame:CGRectMake(0, 30, SCREEN_WIDTH, self.frame.size.height - 30)];
        _maskView.backgroundColor = [UIColor whiteColor];
        
        // Setup header view
        [self setupWeekDays];
        
        UISwipeGestureRecognizer *leftSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipes:)];
        UISwipeGestureRecognizer *rightSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipes:)];
        
        leftSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
        rightSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
        
        [self addGestureRecognizer:leftSwipeGestureRecognizer];
        [self addGestureRecognizer:rightSwipeGestureRecognizer];
        
        // Setup calendar
        
        NSCalendar *calendar = [self calendar];
        NSDate *currentDate = [NSDate date];
        
        _currentDay = [calendar components:NSCalendarUnitDay|
                                           NSCalendarUnitMonth|
                                           NSCalendarUnitYear
                                  fromDate:currentDate];
        
        _month = [calendar components:NSCalendarUnitYear|
                                      NSCalendarUnitMonth|
                                      NSCalendarUnitDay|
                                      NSCalendarUnitWeekday|
                                      NSCalendarUnitCalendar
                             fromDate:currentDate];
        _month.day = 1;
        [self updateMonthLabelMonth:_month];
        [self updateMonthViewMonth:_month];
    }
    return self;
}

#pragma mark 创建周一至周末七个label
- (void)setupWeekDays {
    
    NSArray *weekDays = [NSArray arrayWithObjects:@"周日",@"周一",@"周二",@"周三",@"周四",@"周五",@"周六", nil];
    
    //包含七个周xlabel的view，便于控制整体位置
    _weekDaysView = [[UIView alloc]init];
    
    NSMutableArray *weekDayLabels = [[NSMutableArray alloc] initWithCapacity:7];
    
    for (int i = 0; i < 7; i ++) {
        UILabelZoomable *weekDayLabel = [[UILabelZoomable alloc] init];
        weekDayLabel.font = [UIFont systemFontOfSize:14];
        weekDayLabel.textColor = [UIColor whiteColor];
        weekDayLabel.textAlignment = NSTextAlignmentCenter;
        weekDayLabel.text = weekDays[i];
        CATiledLayer *listLabelLayer = (CATiledLayer *)weekDayLabel.layer;
        listLabelLayer.levelsOfDetail = 2;
        listLabelLayer.levelsOfDetailBias = 2;
        [weekDayLabels addObject:weekDayLabel];
        [_weekDaysView addSubview:weekDayLabel];
        CGFloat left = i * (SCREEN_WIDTH/7);
        [weekDayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(_weekDaysView);
            make.width.mas_equalTo(SCREEN_WIDTH/7);
            make.left.equalTo(_weekDaysView).offset(left);
        }];

    }
    _weekDayLabels = [NSArray arrayWithArray:weekDayLabels];
    [_weekDaysView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
    GradientView *view1 = [[GradientView alloc] initWithFrame:CGRectMake(0, 30, SCREEN_WIDTH, 10)];
    _weekDaysView.backgroundColor = KNaviColor;
    [_weekDaysView addSubview:view1];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark 刷新
- (void)refreshAfterCreateTodo
{
    [self setDisplayedMonth:self.month];
}

#pragma mark 布局方法
- (void)layoutSubviews {
    CGSize viewSize = self.frame.size;

    // Calculate sizes and distances
    
    CGFloat rowCount = 6; // 6 is the maximum number of weeks in a month
    
    CGFloat dayWidth = 0;
    if ([self.delegate respondsToSelector:@selector(widthForDayCellInCalendarView:)]) {
        dayWidth = [self.delegate widthForDayCellInCalendarView:self];
    } else if (self.dayCellWidth) {
        dayWidth = self.dayCellWidth;
    } else {
        if (viewSize.width > viewSize.height) {
            dayWidth = roundf(viewSize.width / 10);
        } else {
            dayWidth = roundf(viewSize.width / 7)-1;
        }
    }
    
    
    CGFloat dayHeight = 0;
    if ([self.delegate respondsToSelector:@selector(heightForDayCellInCalendarView:)]) {
        dayHeight = [self.delegate heightForDayCellInCalendarView:self];
    } else if (self.dayCellHeight) {
        dayHeight = self.dayCellHeight;
    } else {
        if (viewSize.width > viewSize.height) {
            dayHeight = roundf((viewSize.height ) / 6) -
            self.dayCellEdgeInsets.top - self.dayCellEdgeInsets.bottom;
        } else {
//            dayHeight = dayWidth;
            dayHeight = roundf((viewSize.height ) / 6) -
            self.dayCellEdgeInsets.top - self.dayCellEdgeInsets.bottom - 6;
            self.dayCellHeight = dayHeight;
        }
    }
    
    CGFloat elementHorizonralDistance = roundf((viewSize.width - self.dayCellEdgeInsets.left -
                                        self.dayCellEdgeInsets.right - dayWidth * 7) / 6);
    
    // Week days layout,周一到周日 7个label 布局
    
    NSInteger column = 0;
    
    // Calendar grid layout 栅格布局
    
    //日期开始的Y坐标，『周一』label下方
    CGFloat startigCalendarY = 30;
    
    CGFloat elementVerticalDistance = round(((viewSize.height - startigCalendarY - 20) - self.dayCellEdgeInsets.top - self.dayCellEdgeInsets.bottom - (dayHeight * rowCount)) / rowCount);
    
    //该月第一天从第几竖列开始
    column = 7 - [self numberOfDaysInFirstWeek];
    
    NSInteger row = 0;
    
    for (NSInteger dayIndex = 0; dayIndex < self.numberOfDays; dayIndex++)
    {
        //如果没有则创建，有则重置数据颜色进行复用
        RDVCalendarDayCell *dayCell = [self dayCellForIndex:dayIndex];
        if (![self.visibleCells containsObject:dayCell])
        {
            [_visibleCells addObject:dayCell];
            [self addSubview:dayCell];
        }
        
        if (self.selectedDay && (dayIndex + 1 == self.selectedDay.day &&
                                   self.month.month == self.selectedDay.month &&
                                   self.month.year == self.selectedDay.year))
        {
            
            [dayCell setSelected:YES animated:NO];
            _selectedDayCell = dayCell;
        }
        
        if ([self.delegate respondsToSelector:@selector(calendarView:configureDayCell:atIndex:)]) {
            [self.delegate calendarView:self configureDayCell:dayCell atIndex:dayIndex];
        }
        
        CGFloat dayCellXPosition = self.dayCellEdgeInsets.left + (column * dayWidth) + (column * elementHorizonralDistance);
        CGFloat dayCellYPosition = self.dayCellEdgeInsets.top + (row * dayHeight) + (row * elementVerticalDistance);
        
        [dayCell setFrame:CGRectMake(dayCellXPosition, startigCalendarY + dayCellYPosition + 20, dayWidth, dayHeight)];
        
        if (dayCell.superview != self) {
            [self addSubview:dayCell];
        }
        
        if (column == 6) {
            column = 0;
            
            row++;
        } else {
            column++;
        }
    }
    
    //加载好daycell之后，再加载weekdaylabelview，以放在最daycell的上方


    [self addSubview:_weekDaysView];
    [self addSubview:_maskView];
    _maskView.hidden = YES;
}

#pragma mark - Creating Calendar View Day Cells

- (void)registerDayCellClass:(Class)cellClass {
    _dayCellClass = cellClass;
}

#pragma mark - 创建calendar单例
- (NSCalendar *)calendar {
    static NSCalendar *calendar = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        calendar = [NSCalendar autoupdatingCurrentCalendar];
    });
    return calendar;
}

//更新顶部年月
- (void)updateMonthLabelMonth:(NSDateComponents*)month {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy年M月";
    
    NSDate *date = [month.calendar dateFromComponents:month];
    NSString *dateStr = [formatter stringFromDate:date];
    [self.delegate didChangeTitleDateWith:dateStr];
}

//更新每月的daycell
- (void)updateMonthViewMonth:(NSDateComponents *)month {
    self.firstDay = [month.calendar dateFromComponents:month];
    [self reloadData];
}

#pragma mark - Reloading the Calendar view

- (void)reloadData {
    for (RDVCalendarDayCell *visibleCell in [self visibleCells]) {
        [visibleCell removeFromSuperview];
        [visibleCell prepareForReuse];
        [_dayCells addObject:visibleCell];
    }
    
    [_visibleSeparators removeAllObjects];
    [_visibleCells removeAllObjects];
}

#pragma mark 改变cell内容的透明度值
- (void)changeCellTransparentWithAlpha:(CGFloat)alpha
{
    for (RDVCalendarDayCell *visibleCell in [self visibleCells])
    {
        visibleCell.scaleAlpha = alpha;
    }
}

#pragma mark - Date selection

- (void)setSelectedDate:(NSDate *)selectedDate {
    NSDate *oldDate = [self selectedDate];
    
    if (![oldDate isEqualToDate:selectedDate]) {
        NSCalendar *calendar = [self calendar];
       
        _selectedDay = [calendar components:NSCalendarUnitYear|
                                           NSCalendarUnitMonth|
                                              NSCalendarUnitDay
                                   fromDate:selectedDate];
 
        self.month = [calendar components:NSCalendarUnitYear|
                                          NSCalendarUnitMonth|
                                          NSCalendarUnitDay|
                                          NSCalendarUnitWeekday|
                                          NSCalendarUnitCalendar
                                 fromDate:selectedDate];
        self.month.day = 1;
        [self updateMonthLabelMonth:self.month];
        
        [self updateMonthViewMonth:self.month];
    }
}

- (NSDate *)selectedDate {
    if ([self selectedDay]) {
        return [[self calendar] dateFromComponents:self.selectedDay];
    }
    return nil;
}

#pragma mark - Accessing day cells

- (NSArray *)visibleCells {
    return _visibleCells;
}

- (RDVCalendarDayCell *)dayCellForIndex:(NSInteger)index {
    
    RDVCalendarDayCell *dayCell = nil;
    
    if ([self visibleCells].count == [self numberOfDays]) {
        dayCell = [self visibleCells][index];
    } else {
        [_dayCells removeAllObjects];
        dayCell = [[_dayCellClass alloc] init];
    }
    
    if (![[self visibleCells] containsObject:dayCell]) {
        [dayCell prepareForReuse];
    
        dayCell.textLabel.text = [NSString stringWithFormat:@"%ld", index + 1];
        NSInteger dayId = [[NSString stringWithFormat:@"%ld%02ld%02ld",self.month.year,self.month.month,index + 1] integerValue];
        [dayCell setDayInfoWithDayId:dayId];
        
        if (index + 1 == self.currentDay.day &&
            self.month.month == self.currentDay.month &&
            self.month.year == self.currentDay.year) {
            dayCell.backgroundView.backgroundColor = RGBA(255, 204, 153, 0.5);
            dayCell.layer.masksToBounds = YES;
            dayCell.layer.cornerRadius = 2.f;
        } else {

        }
        //setneedslayout 会默认调用layoutsubviews
        [dayCell setNeedsLayout];
    }
    
    return dayCell;
}

- (NSInteger)indexForDayCell:(RDVCalendarDayCell *)cell {
    return [[self visibleCells] indexOfObject:cell];
}

- (NSInteger)indexForDayCellAtPoint:(CGPoint)point {
    RDVCalendarDayCell *cell = [self viewAtLocation:point];
    
    if (cell) {
        return [self indexForDayCell:cell];
    }
    
    return 0;
}

- (NSDate *)dateForIndex:(NSInteger)index {
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setYear:[[self month] year]];
    [dateComponents setMonth:[[self month] month]];
    [dateComponents setDay:(index + 1)];
    
    NSDate *date = [[self calendar] dateFromComponents:dateComponents];
    
    return date;
}

#pragma mark - Managing selections

- (NSInteger)indexForSelectedDayCell {
    if (_selectedDayCell) {
        return [_visibleCells indexOfObject:_selectedDayCell];
    }
    return 0;
}

- (void)selectDayCellAtIndex:(NSInteger)index animated:(BOOL)animated {
    if ([[self visibleCells] count] > index) {
        if ([self.delegate respondsToSelector:@selector(calendarView:willSelectDate:)]) {
            [self.delegate calendarView:self willSelectDate:[self dateForIndex:index]];
        }
        
        if ([self.delegate respondsToSelector:@selector(calendarView:willSelectCellAtIndex:)]) {
            [self.delegate calendarView:self willSelectCellAtIndex:index];
        }
        
        _selectedDayCell = [self dayCellForIndex:index];
        [_selectedDayCell setSelected:YES animated:animated];
        
        if (!self.selectedDay) {
            self.selectedDay = [[NSDateComponents alloc] init];
        }
        
        [self.selectedDay setMonth:self.month.month];
        [self.selectedDay setYear:self.month.year];
        [self.selectedDay setDay:index + 1];
        
        if ([self.delegate respondsToSelector:@selector(calendarView:didSelectDate:)]) {
            [self.delegate calendarView:self didSelectDate:[self dateForIndex:index]];
        }
        
        if ([self.delegate respondsToSelector:@selector(calendarView:didSelectCellAtIndex:)]) {
            [self.delegate calendarView:self didSelectCellAtIndex:index];
        }
    }
}

- (void)deselectDayCellAtIndex:(NSInteger)index animated:(BOOL)animated {
    if ([[self visibleCells] count] > index) {
        RDVCalendarDayCell *dayCell = [self visibleCells][index];
        
        if ([dayCell isSelected]) {
            [dayCell setSelected:NO animated:animated];
        } else if ([dayCell isHighlighted]) {
            [dayCell setHighlighted:NO animated:animated];
        }
        
        if (_selectedDayCell == dayCell) {
            _selectedDayCell = nil;
        }
        
        self.selectedDay = nil;
    }
}

#pragma mark - Helper methods

//该月有几天
- (NSInteger)numberOfDays {
    return [[self calendar] rangeOfUnit:NSCalendarUnitDay
                                 inUnit:NSCalendarUnitMonth
                                forDate:self.firstDay].length;
}

//该月第一周有几天
- (NSInteger)numberOfDaysInFirstWeek {
    return [[self calendar] rangeOfUnit:NSCalendarUnitDay
                                 inUnit:NSCalendarUnitWeekOfMonth
                                forDate:self.firstDay].length;
}

- (RDVCalendarDayCell *)viewAtLocation:(CGPoint)location {
    RDVCalendarDayCell *view = nil;
    
    for (RDVCalendarDayCell *dayView in [self visibleCells]) {
        if (CGRectContainsPoint(dayView.frame, location)) {
            view = dayView;
        }
    }
    
    return view;
}

#pragma mark - Navigation

- (void)setDisplayedMonth:(NSDateComponents *)month
{
    [self updateMonthLabelMonth:self.month];
    [self updateMonthViewMonth:self.month];
    
    if ([self.delegate respondsToSelector:@selector(calendarView:didChangeMonth:)]) {
        [self.delegate calendarView:self didChangeMonth:self.month];
    }
}

- (void)showCurrentMonth {
    [self.month setMonth:self.currentDay.month];
    [self.month setYear:self.currentDay.year];
 
    NSDateComponents *inc = [[NSDateComponents alloc] init];
    inc.month = 0;
    [self showMonthWithComponent:inc];
}

#pragma mark 展示上一个月
- (void)showPreviousMonth
{
    NSDateComponents *inc = [[NSDateComponents alloc] init];
    inc.month = -1;
    [self showMonthWithComponent:inc];
}

#pragma mark 展示下一个月
- (void)showNextMonth
{
    NSDateComponents *inc = [[NSDateComponents alloc] init];
    inc.month = 1;
    [self showMonthWithComponent:inc];
}

- (void)showMonthWithComponent:(NSDateComponents *)inc
{
    NSDate *date = [[self calendar] dateFromComponents:self.month];
    NSDate *newDate = [[self calendar] dateByAddingComponents:inc toDate:date options:0];
    
    self.month = [[self calendar] components:NSCalendarUnitYear|
                  NSCalendarUnitMonth|
                  NSCalendarUnitDay|
                  NSCalendarUnitWeekday|
                  NSCalendarUnitCalendar fromDate:newDate];
    
    _maskView.hidden = NO;
    _maskView.alpha = 0;
    [UIView animateWithDuration:0.15 animations:^{
        _maskView.alpha = 1;
    } completion:^(BOOL finished) {
        [self setDisplayedMonth:self.month];
        [UIView animateWithDuration:0.2 animations:^{
            _maskView.alpha = 0;
            _maskView.hidden = YES;
        }];
    }];
}

#pragma mark 滑动手势
- (void)handleSwipes:(UISwipeGestureRecognizer *)sender
{
    if (sender.direction == UISwipeGestureRecognizerDirectionLeft)
    {
        if (self.month.year == _currentDay.year + 1 && self.month.month == _currentDay.month) {
            return;
        }
        [self showNextMonth];
    }
    
    if (sender.direction == UISwipeGestureRecognizerDirectionRight)
    {
        if (self.month.year < _currentDay.year && self.month.month == 12) {
            return;
        }
        if (self.month.year == _currentDay.year && self.month.month < _currentDay.month)
        {
            return;
        }
        [self showPreviousMonth];
    }
}

#pragma mark - Touch handling
- (void)tapDayCellWithGesture:(UIGestureRecognizer *)sender
{
    CGPoint location = [sender locationInView:self];
    RDVCalendarDayCell *selectedDayCell = [self viewAtLocation:location];
    NSInteger cellIndex = [self indexForDayCell:selectedDayCell];
    [self selectDayCellAtIndex:cellIndex animated:NO];
}

@end
