// RDVCalendarDayCell.h
// RDVCalendarView
//
// Copyright (c) 2013 Robert Dimitrov
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, RDVCalendarDayCellSelectionStyle) {
    RDVCalendarDayCellSelectionStyleNone,
    RDVCalendarDayCellSelectionStyleDefault,
};

@interface RDVCalendarDayCell : UIView

@property (nonatomic, readonly) UILabel *textLabel;

@property (nonatomic, assign) CGFloat scaleAlpha;

@property (nonatomic, strong) NSMutableArray *labels;

@property (nonatomic, readonly) UIView *contentView;

@property (nonatomic, strong) UIView *backgroundView;


@property(nonatomic) RDVCalendarDayCellSelectionStyle selectionStyle;

@property(nonatomic, getter = isSelected) BOOL selected;


@property(nonatomic, getter = isHighlighted) BOOL highlighted;

- (void)setSelected:(BOOL)selected animated:(BOOL)animated;


- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated;

- (void)prepareForReuse;

///根据年月日tableId获取当天数据
- (void)setDayInfoWithDayId:(NSInteger)dayId;

@end
