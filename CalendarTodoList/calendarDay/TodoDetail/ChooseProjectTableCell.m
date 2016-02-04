//
//  ChooseProjectTableCell.m
//  CalendarTodoList
//
//  Created by 牛严 on 16/2/4.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import "ChooseProjectTableCell.h"
#import "ThingType.h"

@implementation ChooseProjectTableCell
{
    UIView *_colorView;
    UILabel *_projectLabel;
}

#pragma mark Set Methods
- (void)setType:(ThingType *)type
{
    _type = type;
    _projectLabel.text = type.typeStr;
    
    UIColor *typeColor = RGBA(type.red, type.green, type.blue, 1.0);
    _colorView.backgroundColor = typeColor;
}

#pragma mark 初始化
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)initView
{
    _colorView = [[UIView alloc]init];
    _colorView.layer.masksToBounds = YES;
    _colorView.layer.cornerRadius = 10;
    [self.contentView addSubview:_colorView];
    [_colorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(20, 20));
        make.left.equalTo(self.contentView).offset(20);
    }];
    
    _projectLabel = [[UILabel alloc]init];
    _projectLabel.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:_projectLabel];
    [_projectLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_colorView.mas_right).offset(10);
        make.centerY.equalTo(_colorView);
        make.width.mas_equalTo(@(SCREEN_HEIGHT - 80));
    }];
    
}

@end
