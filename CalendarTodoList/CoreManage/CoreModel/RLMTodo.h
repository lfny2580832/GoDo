//
//  TodoListModel.h
//  CalendarTodoList
//
//  Created by 牛严 on 16/1/5.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import <Realm/Realm.h>
#import "RLMThing.h"

//月界面只显示未开始、进行中和过期 （可设置）
typedef NS_ENUM(NSInteger, DoneType)
{
    NotStart = 0,       //未开始
    Doing,              //进行中
    OutOfDate,          //过期
    Done                //已完成
};

@interface RLMTodo : RLMObject

@property (nonatomic, assign) NSInteger tableId;
///dayId 为年月日，如 20160106
@property (nonatomic, assign) NSInteger dayId;

///开始时间戳 精确到秒
@property (nonatomic, assign) long long startTime;
///结束时间
@property (nonatomic, assign) long long endTime;
///对应事件;
@property (nonatomic, strong) RLMThing *thing;


@property (nonatomic, assign) DoneType doneType;

@end
