// RDVCalendarView.m
// RDVCalendarView
//
// Copyright (c) 2013 Robert Dimitrov
//

#import "RDVCalendarView.h"
#import "RDVCalendarDayCell.h"
#import "UILabelZoomable.h"
#import "GradientView.h"
#import "RLMTodo.h"

@interface RDVCalendarView () {
    NSMutableArray *_visibleCells;
    NSMutableArray *_dayCells;
    
    NSInteger _numberOfDays;
    
    NSMutableArray *_separators;
    NSMutableArray *_visibleSeparators;
    
    RDVCalendarDayCell *_selectedDayCell;
    
    NSArray *_weekDays;
    
    Class _dayCellClass;
    
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
        _dayCellEdgeInsets = UIEdgeInsetsZero;
        
        _dayCellClass = [RDVCalendarDayCell class];
        
        _weekDayHeight = 20.0f;

        // Setup header view
        
        UISwipeGestureRecognizer *leftSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipes:)];
        UISwipeGestureRecognizer *rightSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipes:)];
        
        leftSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
        rightSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
        
        [self addGestureRecognizer:leftSwipeGestureRecognizer];
        [self addGestureRecognizer:rightSwipeGestureRecognizer];
        
        _monthLabel = [[UILabelZoomable alloc] init];
        _monthLabel.font = [UIFont systemFontOfSize:22];
        _monthLabel.textColor = [UIColor blackColor];
        _monthLabel.textAlignment = NSTextAlignmentCenter;
        CATiledLayer *listLabelLayer = (CATiledLayer *)_monthLabel.layer;
        listLabelLayer.levelsOfDetail = 2;
        listLabelLayer.levelsOfDetailBias = 2;
        [self addSubview:_monthLabel];
        
        _backButton = [[UIButton alloc] init];
        [_backButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [_backButton setTitle:@"<" forState:UIControlStateNormal];
        [_backButton addTarget:self action:@selector(showPreviousMonth)
              forControlEvents:UIControlEventTouchUpInside];
        _backButton.hidden = YES;
        [self addSubview:_backButton];
        
        _forwardButton = [[UIButton alloc] init];
        [_forwardButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [_forwardButton setTitle:@">" forState:UIControlStateNormal];
        [_forwardButton addTarget:self action:@selector(showNextMonth)
                 forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_forwardButton];
        
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
        
        //周一 周二 周三 7个label
        [self setupWeekDays];
        
        NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
        
        [defaultCenter addObserver:self
                         selector:@selector(currentLocaleDidChange:)
                             name:NSCurrentLocaleDidChangeNotification
                           object:nil];
        
        [defaultCenter addObserver:self
                          selector:@selector(deviceDidChangeOrientation:)
                              name:UIDeviceOrientationDidChangeNotification
                            object:nil];
        
        _orientation = [[UIApplication sharedApplication] statusBarOrientation];
    }
    return self;
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
    CGSize headerSize = CGSizeMake(viewSize.width, 60.0f);
    CGFloat backButtonWidth = MAX([[self backButton] sizeThatFits:CGSizeMake(100, 50)].width, 44);
    CGFloat forwardButtonWidth = MAX([[self forwardButton] sizeThatFits:CGSizeMake(100, 50)].width, 44);
    
    CGSize previousMonthButtonSize = CGSizeMake(backButtonWidth, 50);
    CGSize nextMonthButtonSize = CGSizeMake(forwardButtonWidth, 50);
    CGSize titleSize = CGSizeMake(viewSize.width - previousMonthButtonSize.width - nextMonthButtonSize.width - 10 - 10,60);
    
    // Layout header view
    
    [self.backButton setFrame:CGRectMake(10, roundf(headerSize.height / 2 - previousMonthButtonSize.height / 2),
                                         previousMonthButtonSize.width, previousMonthButtonSize.height)];
    
    [self.monthLabel setFrame:CGRectMake(roundf(headerSize.width / 2 - titleSize.width / 2),
                                         roundf(headerSize.height / 2 - titleSize.height / 2),
                                         titleSize.width, titleSize.height)];
    
    [self.forwardButton setFrame:CGRectMake(headerSize.width - 10 - nextMonthButtonSize.width,
                                            roundf(headerSize.height / 2 - nextMonthButtonSize.height / 2),
                                            nextMonthButtonSize.width, nextMonthButtonSize.height)];
    
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
    
    CGFloat weekDayLabelsEndY = CGRectGetMaxY(self.monthLabel.frame) + self.weekDayHeight;
    
    CGFloat dayHeight = 0;
    if ([self.delegate respondsToSelector:@selector(heightForDayCellInCalendarView:)]) {
        dayHeight = [self.delegate heightForDayCellInCalendarView:self];
    } else if (self.dayCellHeight) {
        dayHeight = self.dayCellHeight;
    } else {
        if (viewSize.width > viewSize.height) {
            dayHeight = roundf((viewSize.height - weekDayLabelsEndY) / 6) -
            self.dayCellEdgeInsets.top - self.dayCellEdgeInsets.bottom;
        } else {
//            dayHeight = dayWidth;
            dayHeight = roundf((viewSize.height - weekDayLabelsEndY) / 6) -
            self.dayCellEdgeInsets.top - self.dayCellEdgeInsets.bottom - 6;
            self.dayCellHeight = dayHeight;
        }
    }
    
    CGFloat elementHorizonralDistance = roundf((viewSize.width - self.dayCellEdgeInsets.left -
                                        self.dayCellEdgeInsets.right - dayWidth * 7) / 6);
    
    // Week days layout,周一到周日 7个label 布局
    
    NSInteger column = 0;
    for (UILabel *weekDayLabel in self.weekDayLabels) {
        CGFloat labelXPosition = self.dayCellEdgeInsets.left + (column * dayWidth) + (column * elementHorizonralDistance);
        [weekDayLabel setFrame:CGRectMake(labelXPosition, 0, dayWidth, 30)];
        column++;
    }
    
    // Calendar grid layout 栅格布局
    
    //日期开始的Y坐标，『周一』label下方
    CGFloat startigCalendarY = CGRectGetMaxY(self.weekDaysView.frame);
    
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
        
        // Layout separators 分割线布局
        
        if (dayIndex == 0 || column == 0) {
            if ([self separatorStyle] & RDVCalendarViewDayCellSeparatorTypeHorizontal) {
                if (dayIndex < self.numberOfDays) {
                    UIView *separator = [self dayCellSeparator];
                    
                    [separator setFrame:CGRectMake(self.separatorEdgeInsets.left, CGRectGetMinY(dayCell.frame) +
                                                   (self.separatorEdgeInsets.top - self.separatorEdgeInsets.bottom),
                                                   viewSize.width - self.separatorEdgeInsets.left -
                                                   self.separatorEdgeInsets.right, 1)];
                }
            }
        }
        
        if (row == 1 && column < [[self weekDayLabels] count]) {
            if (self.separatorStyle & RDVCalendarViewDayCellSeparatorTypeVertical) {
                UIView *separator = self.dayCellSeparator;
                
                [separator setFrame:CGRectMake(self.separatorEdgeInsets.left + CGRectGetMaxX(dayCell.frame) +
                                               roundf(elementHorizonralDistance / 2),
                                               weekDayLabelsEndY + (self.separatorEdgeInsets.top -
                                                                               self.separatorEdgeInsets.bottom),
                                               1, viewSize.height - self.separatorEdgeInsets.top -
                                               self.separatorEdgeInsets.bottom)];
            }
        }
        
        if (column == 6) {
            column = 0;
            
            row++;
        } else {
            column++;
        }
    }
    
    //加载好daycell之后，再加载weekdaylabelview，以放在最daycell的上方
    [_weekDaysView setFrame:CGRectMake(0, CGRectGetMaxY(self.monthLabel.frame), SCREEN_WIDTH, 30)];
    GradientView *view1 = [[GradientView alloc] initWithFrame:CGRectMake(0, 30, SCREEN_WIDTH, 20)];
    _weekDaysView.backgroundColor = [UIColor whiteColor];
    [_weekDaysView addSubview:view1];
    [self addSubview:_weekDaysView];
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

#pragma mark 创建周一至周末七个label
- (void)setupWeekDays {
    NSCalendar *calendar = [self calendar];
    
    //firstweekday = 1 代表周日 ； 传入星期日，返回0
    NSInteger firstWeekDay = [calendar firstWeekday] - 1;
    
    // We need an NSDateFormatter to have access to the localized weekday strings
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    //周日 周一 周二 .....
    NSArray *weekSymbols = [formatter shortWeekdaySymbols];
    
    // weekdaySymbols returns and array of strings
    NSMutableArray *weekDays = [[NSMutableArray alloc] initWithCapacity:[weekSymbols count]];
    for (NSInteger day = firstWeekDay; day < [weekSymbols count]; day++) {
        [weekDays addObject:[weekSymbols objectAtIndex:day]];
    }
    
    if (firstWeekDay != 0) {
        for (NSInteger day = 0; day < firstWeekDay; day++) {
            [weekDays addObject:[weekSymbols objectAtIndex:day]];
        }
    }
    
    _weekDays = [NSArray arrayWithArray:weekDays];
    
    //包含七个周xlabel的view，便于控制整体位置
    _weekDaysView = [[UIView alloc]init];
//    _weekDaysView.backgroundColor = [UIColor whiteColor];
    
    if (![_weekDayLabels count]) {
        NSMutableArray *weekDayLabels = [[NSMutableArray alloc] initWithCapacity:[_weekDays count]];
        
        for (NSString *weekDayString in _weekDays) {
            UILabelZoomable *weekDayLabel = [[UILabelZoomable alloc] init];
            weekDayLabel.font = [UIFont systemFontOfSize:14];
            weekDayLabel.textColor = KRedColor;
            weekDayLabel.textAlignment = NSTextAlignmentCenter;
            weekDayLabel.text = weekDayString;
            CATiledLayer *listLabelLayer = (CATiledLayer *)weekDayLabel.layer;
            listLabelLayer.levelsOfDetail = 2;
            listLabelLayer.levelsOfDetailBias = 2;
            
            [weekDayLabels addObject:weekDayLabel];
            [_weekDaysView addSubview:weekDayLabel];
        }
        
        _weekDayLabels = [NSArray arrayWithArray:weekDayLabels];
    } else {
        NSInteger index = 0;
        for (NSString *weekDayString in _weekDays) {
            UILabel *weekDayLabel = self.weekDayLabels[index];
            weekDayLabel.text = weekDayString;
            index++;
        }
    }
}

//更新顶部年月
- (void)updateMonthLabelMonth:(NSDateComponents*)month {
    
    if (month.year <= _currentDay.year && month.month <= _currentDay.month)
    {
        _backButton.hidden = YES;
    }
    else if (month.year >= _currentDay.year && month.month < _currentDay.month + 2)
    {
        _backButton.hidden = NO;
        _forwardButton.hidden = NO;
    }
    else if(month.year >= _currentDay.year && month.month == _currentDay.month + 2)
    {
        _forwardButton.hidden = YES;
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy年LLLL";
    
    NSDate *date = [month.calendar dateFromComponents:month];
    self.monthLabel.text = [formatter stringFromDate:date];
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
    
    for (UIView *separator in _visibleSeparators) {
        [_separators addObject:separator];
        [separator removeFromSuperview];
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

#pragma mark - Separators

- (UIView *)dayCellSeparator {
    UIView *separator = nil;
    if (_separators.count) {
        separator = _separators.lastObject;
        [_separators removeObject:separator];
        [_visibleSeparators addObject:separator];
    } else {
        separator = [[UIView alloc] init];
        [_visibleSeparators addObject:separator];
    }
    
    [separator setBackgroundColor:self.separatorColor];
    
    if ([separator superview] != self) {
        [self addSubview:separator];
    }
    
    return separator;
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
//            dayCell.backgroundView.backgroundColor = self.currentDayColor;
            dayCell.backgroundView.backgroundColor = RGBA(255, 204, 153, 0.5);
            dayCell.backgroundView.layer.borderWidth = 1.0f;
        } else {
//            dayCell.backgroundView.backgroundColor = self.normalDayColor;
            dayCell.backgroundView.layer.borderWidth = 0.0f;
        }

//        dayCell.selectedBackgroundView.backgroundColor = self.selectedDayColor;

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

- (void)setDisplayedMonth:(NSDateComponents *)month {
    
    if (month.year <= _currentDay.year && month.month <= _currentDay.month)
    {
        _backButton.hidden = YES;
    }
    else if (month.year >= _currentDay.year && month.month < _currentDay.month + 2)
    {
        _backButton.hidden = NO;
        _forwardButton.hidden = NO;
    }
    else if(month.year >= _currentDay.year && month.month == _currentDay.month + 2)
    {
        _forwardButton.hidden = YES;
    }
    
    [self updateMonthLabelMonth:self.month];
    [self updateMonthViewMonth:self.month];
    
    if ([self.delegate respondsToSelector:@selector(calendarView:didChangeMonth:)]) {
        [self.delegate calendarView:self didChangeMonth:self.month];
    }
}

- (void)showCurrentMonth {
    [self.month setMonth:self.currentDay.month];
    [self.month setYear:self.currentDay.year];
 
    [self setDisplayedMonth:self.month];
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
    
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self setDisplayedMonth:self.month];
        [UIView animateWithDuration:0.2 animations:^{
            self.alpha = 1;
        }];
    }];
}

#pragma mark 滑动手势
- (void)handleSwipes:(UISwipeGestureRecognizer *)sender
{
    if (sender.direction == UISwipeGestureRecognizerDirectionLeft)
    {
        if (_forwardButton.hidden == YES) {
            return;
        }
        [self showNextMonth];
    }
    
    if (sender.direction == UISwipeGestureRecognizerDirectionRight)
    {
        if (_backButton.hidden == YES) {
            return;
        }
        [self showPreviousMonth];
    }
}

#pragma mark - Locale change handling

- (void)currentLocaleDidChange:(NSNotification *)notification {
    [self setupWeekDays];
    [self updateMonthLabelMonth:self.month];
    [self setNeedsLayout];
}

#pragma mark - Orientation cnahge handling

- (void)deviceDidChangeOrientation:(NSNotification *)notification {
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    
    // orientation has changed to a new one
    if (UIInterfaceOrientationIsLandscape(orientation) != UIInterfaceOrientationIsLandscape(_orientation)) {
        _orientation = orientation;
        [self reloadData];
    }
}

#pragma mark - Touch handling

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [[event allTouches] anyObject];
    
    CGPoint touchLocation = [touch locationInView:self];
    
    if (touchLocation.y >= CGRectGetMaxY([self.weekDayLabels[0] frame])) {
        RDVCalendarDayCell *selectedDayCell = [self viewAtLocation:touchLocation];
        
        if (selectedDayCell && selectedDayCell != _selectedDayCell) {
            NSInteger cellIndex = [self indexForDayCell:selectedDayCell];
            
            if ([self.delegate respondsToSelector:@selector(calendarView:shouldSelectDate:)]) {
                if (![self.delegate calendarView:self shouldSelectDate:[self dateForIndex:cellIndex]]) {
                    return;
                }
            }
            
            if ([self.delegate respondsToSelector:@selector(calendarView:shouldSelectCellAtIndex:)]) {
                if (![self.delegate calendarView:self shouldSelectCellAtIndex:cellIndex]) {
                    return;
                }
            }
            
            [self deselectDayCellAtIndex:[self indexForDayCell:_selectedDayCell]
                                animated:NO];
            _selectedDayCell = selectedDayCell;
            _selectedDayCell.highlighted = YES;
        }
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [[event allTouches] anyObject];
    
    CGPoint touchLocation = [touch locationInView:self];
    
    if (touchLocation.y >= CGRectGetMaxY([self.weekDayLabels[0] frame])) {
        RDVCalendarDayCell *selectedDayCell = [self viewAtLocation:touchLocation];
        
        if (selectedDayCell != _selectedDayCell) {
            [self deselectDayCellAtIndex:[self indexForDayCell:_selectedDayCell]
                                animated:NO];
        }
    } else if (_selectedDayCell.isHighlighted) {
        _selectedDayCell.highlighted = NO;
        _selectedDayCell = nil;
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    if (_selectedDayCell.isHighlighted) {
        _selectedDayCell.highlighted = NO;
        _selectedDayCell = nil;
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [[event allTouches] anyObject];
    
    RDVCalendarDayCell *selectedDayCell = [self viewAtLocation:[touch locationInView:self]];
    
    if (selectedDayCell) {
        if (selectedDayCell == _selectedDayCell) {
            NSInteger cellIndex = [self indexForDayCell:selectedDayCell];
            
            [self selectDayCellAtIndex:cellIndex animated:NO];
        } else {
            [self deselectDayCellAtIndex:[self indexForDayCell:_selectedDayCell]
                                animated:NO];
        }
    }
}

@end
