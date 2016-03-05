//
//  RLMTodoID.h
//  CalendarTodoList
//
//  Created by 牛严 on 16/3/6.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import <Realm/Realm.h>

@interface RLMTodoID : RLMObject

@property (nonatomic, strong) NSNumber <RLMInt> *tableId;

@end

// This protocol enables typed collections. i.e.:
// RLMArray<RLMTodoID>
RLM_ARRAY_TYPE(RLMTodoID)
