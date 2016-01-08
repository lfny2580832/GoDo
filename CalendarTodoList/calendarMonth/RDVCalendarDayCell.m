// RDVCalendarDayCell.m
// RDVCalendarView
//
// Copyright (c) 2013 Robert Dimitrov
//

#import <QuartzCore/QuartzCore.h>
#import "RDVCalendarDayCell.h"
#import "UILabelZoomable.h"
#import "RLMTodoList.h"
#import "NSString+ZZExtends.h"

@interface RDVCalendarDayCell() {
    BOOL _selected;
    BOOL _highlighted;
}

@end

@implementation RDVCalendarDayCell

#pragma mark 初始化
- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super init];
    if (self) {
        _reuseIdentifier = [reuseIdentifier copy];
        _selectionStyle = RDVCalendarDayCellSelectionStyleDefault;
        
        _backgroundView = [[UIView alloc] init];
        _backgroundView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_backgroundView];
        
//        _selectedBackgroundView = [[UIView alloc] init];
//        _selectedBackgroundView.backgroundColor = [UIColor lightGrayColor];
//        _selectedBackgroundView.alpha = 0;
//        [self addSubview:_selectedBackgroundView];
        
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [UIColor clearColor];
        [self addSubview:_contentView];
        
        [self addCellTodoList];
        
        _textLabel = [[UILabelZoomable alloc]init];
        _textLabel.textColor = [UIColor blackColor];
        _textLabel.highlightedTextColor = [UIColor whiteColor];
        _textLabel.backgroundColor = [UIColor clearColor];
        _textLabel.font = [UIFont systemFontOfSize:20];
        CATiledLayer *listLabelLayer = (CATiledLayer *)_textLabel.layer;
        listLabelLayer.levelsOfDetail = 2;
        listLabelLayer.levelsOfDetailBias = 2;
        [_contentView addSubview:_textLabel];
    }
    return self;
}

- (id)init
{
    return [self initWithReuseIdentifier:@""];
}

- (void)addCellTodoList
{
    _listLabel = [[UILabelZoomable alloc] init];
//    _listLabel.text = @"学习AsyncDisplayKit\n完成日历todolist\n睡觉吃饭上床玩游戏\n是劳斯莱斯";
    _listLabel.numberOfLines = 0;
    _listLabel.alpha = 0;
    _listLabel.textColor = KRedColor;
    _listLabel.highlightedTextColor = [UIColor whiteColor];
    _listLabel.backgroundColor = [UIColor clearColor];
    _listLabel.font = [UIFont systemFontOfSize:7];
    CATiledLayer *listLabelLayer = (CATiledLayer *)_listLabel.layer;
    listLabelLayer.levelsOfDetail = 2;
    listLabelLayer.levelsOfDetailBias = 2;
    [_contentView addSubview:_listLabel];
    [_listLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.left.equalTo(self).offset(0);
        make.right.equalTo(self).offset(0);
    }];
}

- (void)layoutSubviews {
    CGSize frameSize = self.frame.size;
    CGSize dateTitleSize = [self.textLabel sizeThatFits:CGSizeMake(frameSize.width, frameSize.height)];
    CGSize listTitleSize = [self.listLabel sizeThatFits:CGSizeMake(frameSize.width, frameSize.height)];
    
    if(listTitleSize.height >= self.frame.size.height)
    {
        listTitleSize.height = self.frame.size.height;
    }
    
    self.backgroundView.frame = self.bounds;
//    self.selectedBackgroundView.frame = self.bounds;
    self.contentView.frame = self.bounds;
    self.textLabel.frame = CGRectMake(roundf(frameSize.width / 2 - dateTitleSize.width / 2),
                                           roundf(frameSize.height / 2 - dateTitleSize.height / 2),
                                           dateTitleSize.width, dateTitleSize.height);
    self.listLabel.frame = CGRectMake(roundf(frameSize.width / 2 - listTitleSize.width / 2),
                                      roundf(frameSize.height / 2 - listTitleSize.height / 2),
                                      listTitleSize.width, listTitleSize.height);
}

#pragma mark - Selection

- (BOOL)isSelected {
    return _selected;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    if (selected == _selected) {
        return;
    }
    
    _selected = selected;
    _highlighted = NO;
    
    if ([self selectionStyle] != RDVCalendarDayCellSelectionStyleNone) {
        __weak RDVCalendarDayCell *weakSelf = self;
        
        void (^block)() = ^{
            if (selected) {
                weakSelf.backgroundView.alpha = 1.0f;
                weakSelf.backgroundView.layer.borderWidth = 1.0f;
                weakSelf.backgroundView.layer.borderColor = [UIColor blueColor].CGColor;
//                weakSelf.selectedBackgroundView.alpha = 1.0f;
            } else {
                weakSelf.backgroundView.alpha = 1.0f;
                weakSelf.backgroundView.layer.borderWidth = 0.0f;
//                weakSelf.selectedBackgroundView.alpha = 0.0f;
            }
//            for (id subview in weakSelf.contentView.subviews) {
//                if ([subview respondsToSelector:@selector(setHighlighted:)]) {
//                    [subview setHighlighted:selected];
//                }
//            }
        };
        
        if (animated) {
            [UIView animateWithDuration:0.25f animations:block];
        } else {
            block();
        }
    }
}

- (void)setSelected:(BOOL)selected {
    [self setSelected:selected animated:NO];
}

- (BOOL)isHighlighted {
    return _highlighted;
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    if (highlighted == _highlighted) {
        return;
    }
    
    _highlighted = highlighted;
    _selected = NO;
    
    if (self.selectionStyle != RDVCalendarDayCellSelectionStyleNone) {
        __weak RDVCalendarDayCell *weakSelf = self;
        
        void (^block)() = ^{
            if (highlighted) {
                weakSelf.backgroundView.alpha = 1.0f;
                weakSelf.backgroundView.layer.borderWidth = 1.0f;
                weakSelf.backgroundView.layer.borderColor = [UIColor blueColor].CGColor;
//                weakSelf.selectedBackgroundView.alpha = 1.0f;
            } else {
                weakSelf.backgroundView.alpha = 1.0f;
                weakSelf.backgroundView.layer.borderWidth = 0.0f;

//                weakSelf.selectedBackgroundView.alpha = 0.0f;
            }
//            for (id subview in [weakSelf.contentView subviews]) {
//                if ([subview respondsToSelector:@selector(setHighlighted:)]) {
//                    [subview setHighlighted:highlighted];
//                }
//            }
        };
    
        if (animated) {
            [UIView animateWithDuration:0.25f animations:block];
        } else {
            block();
        }
    }
}

- (void)setHighlighted:(BOOL)highlighted {
    [self setHighlighted:highlighted animated:NO];
}

#pragma mark - Cell reuse

- (void)prepareForReuse {
    self.selected = NO;
    self.highlighted = NO;
    self.textLabel.text = @"";
}

#pragma mark 获取数据库信息
- (void)getDayInfoFromRealmWithDayId:(NSInteger)dayId
{
    RLMResults *result = [RLMTodoList objectsWhere:@"dayId = %ld",dayId];
    RLMTodoList *todolist = [result firstObject];
    if (todolist) {
        NSString *typeStr;
        switch (todolist.thing.thingType) {
            case 0:typeStr = @"学习";break;
            case 1:typeStr = @"娱乐";break;
            case 2:typeStr = @"体育";break;
            case 3:typeStr = @"社团";break;
            case 4:typeStr = @"组织";break;
            default:break;
        }
        NSString *timeStr = [NSString getHourMinuteDateFromTimeInterval:todolist.timeStamp];
        self.listLabel.text = [NSString stringWithFormat:@"%@:%@",timeStr,typeStr];
    }

}

@end
