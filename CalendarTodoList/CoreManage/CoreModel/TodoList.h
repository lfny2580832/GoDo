//
//  TodoList.h
//  CalendarTodoList
//
//  Created by 牛严 on 16/1/28.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Thing.h"

@interface TodoList : NSObject

///dayId 为年月日，如 20160106
@property (nonatomic, assign) NSInteger dayId;

///开始时间戳 精确到秒
@property (nonatomic, assign) long long startTime;
///结束时间
@property (nonatomic, assign) long long endTime;
///对应事件;
@property (nonatomic, strong) Thing *thing;
///事件概述（RLM模型中没有）
@property (nonatomic, strong) NSString *briefStr;

@end
