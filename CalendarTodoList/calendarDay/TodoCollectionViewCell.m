//
//  TodoCollectionViewCell.m
//  CalendarTodoList
//
//  Created by 牛严 on 16/1/8.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import "TodoCollectionViewCell.h"
#import "TodoList.h"
#import "Thing.h"
#import <Realm/Realm.h>
#import "NSString+ZZExtends.h"
#import "RealmManage.h"

@implementation TodoCollectionViewCell
{
    UILabel *_todoListLabel;
    NSArray <TodoList *> *_todoListArray;
    NSString *_todoList;
}

- (void)setDayId:(NSInteger)dayId
{
    _dayId = dayId;
    dispatch_async(kBgQueue, ^{
        _todoListArray = [RealmManager getDayInfoBriefFromRealmWithDayId:dayId];
        if (_todoListArray) {
            NSLog(@"--- %@",_todoListArray[0].thing.thingStr);
        }
        dispatch_async(kMainQueue, ^{
            if (_todoListArray) {
                NSLog(@"+++ %@",_todoListArray[0].thing.thingStr);
            }
        });
    });
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
    _todoListLabel = [[UILabel alloc]init];
    _todoListLabel.font = [UIFont systemFontOfSize:30];
    _todoListLabel.textColor = [UIColor whiteColor];
    [self addSubview:_todoListLabel];
    [_todoListLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
    }];
}

@end
