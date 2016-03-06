//
//  RLMDayList.h
//  CalendarTodoList
//
//  Created by 牛严 on 16/3/7.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import <Realm/Realm.h>
#import "RLMTodoTableID.h"

@interface RLMDayList : RLMObject

@property  NSInteger dayID;

@property  RLMArray <RLMTodoTableID> *todoIDs;

@end


