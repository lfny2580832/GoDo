// RDVCalendarDayCell.h
// RDVCalendarView
//
// Copyright (c) 2013 Robert Dimitrov
//

#import <UIKit/UIKit.h>
#import <Realm/Realm.h>

typedef NS_ENUM(NSInteger, RDVCalendarDayCellSelectionStyle) {
    RDVCalendarDayCellSelectionStyleNone,
    RDVCalendarDayCellSelectionStyleDefault,
};

@interface RDVCalendarDayCell : UIView

/**
 * A string used to identify a day cell that is reusable. (read-only)
 */
@property(nonatomic, readonly, copy) NSString *reuseIdentifier;

/**
 * Returns the label used for the main textual content of the day cell. (read-only)
 */
@property (nonatomic, readonly) UILabel *textLabel;

@property (nonatomic, assign) CGFloat scaleAlpha;
///todolist 内容
@property (nonatomic,strong) UILabel *listLabel;
/**
 * Returns the content view of the day cell object. (read-only)
 */
@property (nonatomic, readonly) UIView *contentView;

/**
 * The view used as the background of the day cell.
 */
@property (nonatomic, strong) UIView *backgroundView;

/**
 * The view used as the background of the day cell when it is selected.
 */
//@property (nonatomic, strong) UIView *selectedBackgroundView;

/**
 * The style of selection for a cell.
 */
@property(nonatomic) RDVCalendarDayCellSelectionStyle selectionStyle;

/**
 * A Boolean value that indicates whether the cell is selected.
 */
@property(nonatomic, getter = isSelected) BOOL selected;

/**
 * A Boolean value that indicates whether the cell is highlighted.
 */
@property(nonatomic, getter = isHighlighted) BOOL highlighted;

/**
 * Initializes a day cell with a reuse identifier and returns it to the caller.
 */
- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier;

/**
 * Sets the selected state of the cell, optionally animating the transition between states.
 */
- (void)setSelected:(BOOL)selected animated:(BOOL)animated;

/**
 * Sets the highlighted state of the cell, optionally animating the transition between states.
 */
- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated;

/**
 * Prepares a reusable day cell for reuse by the calendar view.
 */
- (void)prepareForReuse;

@end
