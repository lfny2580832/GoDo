//
//  TodoCollectionViewCell.m
//  CalendarTodoList
//
//  Created by 牛严 on 16/1/8.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import "TodoCollectionViewCell.h"

@implementation TodoCollectionViewCell
{
    UILabel *_testLabel;
    UILabel *_dateLabel;
}

- (void)setDate:(NSDate *)date
{
    _dateLabel.text = [NSString stringWithFormat:@"%@",date];
}

- (void)setIndex:(NSString *)index
{
    _testLabel.text = index;
}
#pragma mark 初始化
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)initView
{
    _testLabel = [[UILabel alloc]init];
    _testLabel.font = [UIFont systemFontOfSize:30];
    _testLabel.textColor = [UIColor whiteColor];
    [self addSubview:_testLabel];
    [_testLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];
    
    _dateLabel = [[UILabel alloc]init];
    _dateLabel.numberOfLines = 0;
    _dateLabel.font = [UIFont systemFontOfSize:30];
    _dateLabel.textColor = [UIColor whiteColor];
    [self addSubview:_dateLabel];
    [_dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
    }];
}

@end
