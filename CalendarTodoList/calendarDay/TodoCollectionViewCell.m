//
//  TodoCollectionViewCell.m
//  CalendarTodoList
//
//  Created by 牛严 on 16/1/8.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import "TodoCollectionViewCell.h"
#import "RLMTodoList.h"
#import <Realm/Realm.h>
#import "NSString+ZZExtends.h"

@implementation TodoCollectionViewCell
{
    UILabel *_testLabel;
    UILabel *_dateLabel;
    UILabel *_todoListLabel;
    NSString *_todoList;
}

- (void)setDate:(NSDate *)date
{
    _dateLabel.text = [NSString stringWithFormat:@"%@",date];
}

- (void)setIndex:(NSString *)index
{
    _testLabel.text = index;
}

- (void)setDayId:(NSInteger)dayId
{
    dispatch_async(kBgQueue, ^{
        _todoList = [self getDayInfoFromRealmWithDayId:dayId];
        dispatch_async(kMainQueue, ^{
            _todoListLabel.text = _todoList;
        });
    });
}

#pragma mark 获取数据库信息
- (NSString *)getDayInfoFromRealmWithDayId:(NSInteger)dayId
{
    RLMResults *result = [RLMTodoList objectsWhere:@"dayId = %ld",dayId];
    RLMTodoList *todolist = [result firstObject];
    NSString *todoListStr;
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
        todoListStr = [NSString stringWithFormat:@"%@%@",timeStr,todolist.thing.thingStr];
    }
    return todoListStr;
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
    _dateLabel = [[UILabel alloc]init];
    _dateLabel.numberOfLines = 0;
    _dateLabel.font = [UIFont systemFontOfSize:30];
    _dateLabel.textColor = [UIColor whiteColor];
    [self addSubview:_dateLabel];
    [_dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
    }];
    
    _testLabel = [[UILabel alloc]init];
    _testLabel.font = [UIFont systemFontOfSize:30];
    _testLabel.textColor = [UIColor whiteColor];
    [self addSubview:_testLabel];
    [_testLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_dateLabel.mas_bottom);
    }];
    
    _todoListLabel = [[UILabel alloc]init];
    _todoListLabel.font = [UIFont systemFontOfSize:30];
    _todoListLabel.textColor = [UIColor whiteColor];
    [self addSubview:_todoListLabel];
    [_todoListLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_testLabel.mas_bottom);
    }];
}

@end
