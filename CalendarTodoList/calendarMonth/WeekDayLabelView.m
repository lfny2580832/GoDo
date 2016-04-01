//
//  WeekDayLabel.m
//  GoDo
//
//  Created by 牛严 on 16/3/29.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import "WeekDayLabelView.h"
#import "UILabelZoomable.h"

@implementation WeekDayLabelView


- (void)setTransform:(CGAffineTransform)newValue
{
    CGAffineTransform constrainedTransform = CGAffineTransformIdentity;
    constrainedTransform.a = newValue.a;
    [super setTransform:constrainedTransform];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = KNaviColor;
        [self initView];
    }
    return self;
}


- (void)initView
{
    NSArray *weekDays = [NSArray arrayWithObjects:@"周日",@"周一",@"周二",@"周三",@"周四",@"周五",@"周六", nil];
    for (int i = 0; i < 7; i ++) {
        UILabelZoomable *weekDayLabel = [[UILabelZoomable alloc] init];
        weekDayLabel.font = [UIFont systemFontOfSize:14];
        weekDayLabel.textColor = [UIColor whiteColor];
        weekDayLabel.backgroundColor = KNaviColor;
        weekDayLabel.textAlignment = NSTextAlignmentCenter;
        weekDayLabel.text = weekDays[i];
        CATiledLayer *listLabelLayer = (CATiledLayer *)weekDayLabel.layer;
        listLabelLayer.levelsOfDetail = 2;
        listLabelLayer.levelsOfDetailBias = 2;
        [self addSubview:weekDayLabel];
        CGFloat left = i * (SCREEN_WIDTH/7);
        [weekDayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self);
            make.width.mas_equalTo(SCREEN_WIDTH/7);
            make.left.equalTo(self).offset(left);
        }];
    }
}

@end
