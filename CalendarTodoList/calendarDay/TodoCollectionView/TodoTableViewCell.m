//
//  TodoTableViewCell.m
//  CalendarTodoList
//
//  Created by 牛严 on 16/1/19.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import "TodoTableViewCell.h"

#import "NSObject+NYExtends.h"
#import "NSString+ZZExtends.h"

@implementation TodoTableViewCell
{
    UILabel *_textLabel;
    UILabel *_timeLabel;
    
    UIView *_topLine;
    UIView *_cicleView;
    UIView *_bottomLine;
}

static NSInteger CircleRadius = 9;
static NSInteger LineWidth = 2;

#pragma mark Set方法
- (void)setTodoList:(TodoList *)todoList
{
    _todoList = todoList;
    _textLabel.text = todoList.thing.thingStr;
    NSString *timeStr = [NSString getHourMinuteDateFromTimeInterval:todoList.startTime];
    _timeLabel.text = timeStr;
    
    NSInteger R = todoList.thing.thingType.red;
    NSInteger G = todoList.thing.thingType.green;
    NSInteger B = todoList.thing.thingType.blue;
    _cicleView.backgroundColor = RGBA(R, G, B, 1.0);
    
}

#pragma mark 初始化
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier                                                                             
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.clipsToBounds = YES;
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initView];
    }
    return self;
}

- (void)initView
{
    UIImageView *testView = [[UIImageView alloc]init];
    testView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:testView];
    [testView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(85);
        make.size.mas_equalTo(CGSizeMake(50, 50));
        make.bottom.equalTo(self.contentView).offset(-10);
    }];
    
    _textLabel = [[UILabel alloc]init];
    _textLabel.textColor = [UIColor whiteColor];
    _textLabel.textAlignment = NSTextAlignmentLeft;
    _textLabel.numberOfLines = 0;
    [self.contentView addSubview:_textLabel];
    [_textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(15);
        make.bottom.equalTo(testView.mas_top).offset(-15);
        make.left.equalTo(self.contentView).offset(85);
        make.right.equalTo(self.contentView).offset(-15);
    }];
    
    _timeLabel = [[UILabel alloc]init];
    _timeLabel.textColor = [UIColor whiteColor];
    [self.contentView addSubview:_timeLabel];
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(10);
        make.top.equalTo(self.contentView).offset(15);
        make.width.mas_equalTo(@50);
    }];
    
    _topLine = [[UIView alloc]init];
    _topLine.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:_topLine];
    [_topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(65);
        make.size.mas_equalTo(CGSizeMake(LineWidth, 22));
    }];
    
    _bottomLine = [[UIView alloc]init];
    _bottomLine.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:_bottomLine];
    [_bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(25);
        make.centerX.equalTo(_topLine);
        make.width.mas_equalTo(LineWidth);
        make.bottom.equalTo(self.contentView);
    }];
    
    _cicleView = [[UIView alloc]init];
    _cicleView.layer.masksToBounds = YES;
    _cicleView.layer.cornerRadius = CircleRadius;
    _cicleView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:_cicleView];
    [_cicleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_timeLabel);
        make.centerX.equalTo(_topLine);
        make.size.mas_equalTo(CGSizeMake(CircleRadius*2, CircleRadius*2));
    }];
    
}

@end
