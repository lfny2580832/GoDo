//
//  TodoListModel.h
//  CalendarTodoList
//
//  Created by 牛严 on 16/1/5.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import <Realm/Realm.h>
#import "RLMThing.h"

@interface RLMTodoList : RLMObject

///tableId 为年月日，如 20160106
@property (nonatomic, assign) NSInteger tableId;

///当天时间 如 2311
@property (nonatomic, assign) NSInteger timeStamp;

///对应事件;
@property (nonatomic, strong) RLMThing *thing;

@end
