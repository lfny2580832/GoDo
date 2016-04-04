// RDVCalendarDayCell.m
// RDVCalendarView
//
// Copyright (c) 2013 Robert Dimitrov
//

#import <QuartzCore/QuartzCore.h>
#import "RDVCalendarDayCell.h"
#import "UILabelZoomable.h"

#import "NSString+ZZExtends.h"
#import "DBManage.h"

@interface RDVCalendarDayCell() {
    BOOL _selected;
    BOOL _highlighted;
}

@end

@implementation RDVCalendarDayCell
{
    NSArray *_todoArray;
    
    UIImageView *_tagView;
}

#pragma mark 初始化
- (id)init
{
    self = [super init];
    if (self) {
        _selectionStyle = RDVCalendarDayCellSelectionStyleDefault;
        
        _backgroundView = [[UIView alloc] init];
        _backgroundView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_backgroundView];
        
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [UIColor clearColor];
        [self addSubview:_contentView];
        
        _textLabel = [[UILabelZoomable alloc]init];
        _textLabel.textColor = [UIColor blackColor];
        _textLabel.highlightedTextColor = [UIColor whiteColor];
        _textLabel.backgroundColor = [UIColor clearColor];
        _textLabel.font = [UIFont systemFontOfSize:16];
        CATiledLayer *listLabelLayer = (CATiledLayer *)_textLabel.layer;
        listLabelLayer.levelsOfDetail = 2;
        listLabelLayer.levelsOfDetailBias = 2;
        [_contentView addSubview:_textLabel];
        [_textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.centerY.equalTo(self).offset(-15);
        }];
        
        _tagView = [[UIImageView alloc]init];
        _tagView.backgroundColor = [UIColor clearColor];
        _tagView.layer.masksToBounds = YES;
        _tagView.layer.cornerRadius = 4;
        [_contentView addSubview:_tagView];
        [_tagView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_textLabel.mas_bottom).offset(10);
            make.centerX.equalTo(_textLabel);
            make.size.mas_equalTo(CGSizeMake(8, 8));
        }];
    }
    return self;
}

- (void)layoutSubviews {
    CGSize frameSize = self.frame.size;
    CGSize dateTitleSize = [self.textLabel sizeThatFits:CGSizeMake(frameSize.width, frameSize.height)];
    
    self.backgroundView.frame = self.bounds;
    self.contentView.frame = self.bounds;
    self.textLabel.frame = CGRectMake(roundf(frameSize.width / 2 - dateTitleSize.width / 2),
                                           roundf(frameSize.height / 2 - dateTitleSize.height / 2),
                                           dateTitleSize.width, dateTitleSize.height);
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
                weakSelf.backgroundView.layer.borderColor = [UIColor blueColor].CGColor;
            } else {
                weakSelf.backgroundView.alpha = 1.0f;
            }

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
                weakSelf.backgroundView.layer.borderColor = [UIColor blueColor].CGColor;
            } else {
                weakSelf.backgroundView.alpha = 1.0f;
            }
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
- (void)setDayInfoWithDayId:(NSInteger)dayId
{
    dispatch_async(kBgQueue, ^{
        _todoArray = [DBManager getDayInfoFromDateList:dayId];
        dispatch_async(kMainQueue, ^{
            if (_todoArray.count) {
                [self addCellTodoListWithTodoListCount:_todoArray.count];
            }
        });
    });
}

#pragma mark 根据数量创建label
- (void)addCellTodoListWithTodoListCount:(NSInteger)count
{
    CGFloat x = 2;
    CGFloat y = 5;
    CGFloat width = self.frame.size.width - 4;
    CGFloat height = 6;
    _labels = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i < count ; i++)
    {
        FMTodoModel *todo = _todoArray[i];
        FMProject *type = todo.project;
        UILabelZoomable *todoLabel = [[UILabelZoomable alloc]initWithFrame:CGRectMake(x, y, width, height)];
        todoLabel.numberOfLines = 0;
        todoLabel.alpha = 0;
        todoLabel.textColor = [UIColor blackColor];
        todoLabel.font = [UIFont systemFontOfSize:5];
        todoLabel.textAlignment = NSTextAlignmentCenter;
        todoLabel.text = [NSString stringWithFormat:@" %@",todo.thingStr];
        todoLabel.backgroundColor = RGBA(type.red, type.green, type.blue, 1.0);
        todoLabel.layer.masksToBounds = YES;
        todoLabel.layer.cornerRadius = 1.5f;
        CATiledLayer *todoLabelLayer = (CATiledLayer *)todoLabel.layer;
        todoLabelLayer.levelsOfDetail = 2;
        todoLabelLayer.levelsOfDetailBias = 2;
        [_contentView addSubview:todoLabel];
        y = y + height + 2;
        
        [_labels addObject:todoLabel];
    }
    FMTodoModel *first = _todoArray[0];
    _tagView.backgroundColor = RGBA(first.project.red, first.project.green, first.project.blue, 1.0);
    
}

#pragma mark 设置透明度
-(void)setScaleAlpha:(CGFloat)scaleAlpha
{
    self.textLabel.alpha = 1 - scaleAlpha;
    if (scaleAlpha == 0) {
        _tagView.alpha = 1;
    }else{
        _tagView.alpha = 0;
    }
    for (UILabelZoomable *todoListLabel in _labels) {
        todoListLabel.alpha = scaleAlpha;
    }
}

@end
