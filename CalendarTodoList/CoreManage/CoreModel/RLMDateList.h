//
//  RLMDateList.h
//  CalendarTodoList
//
//  Created by 牛严 on 16/3/6.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import <Realm/Realm.h>
#import "RLMTodoID.h"

@interface RLMDateList : RLMObject

@property (nonatomic, assign) NSInteger dayID;

@property (nonatomic, strong) RLMArray<RLMTodoID> *todoIDs;

@end

// This protocol enables typed collections. i.e.:
// RLMArray<RLMDateList>
RLM_ARRAY_TYPE(RLMDateList)
