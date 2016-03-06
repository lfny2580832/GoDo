//
//  RLMTodoTableID.h
//  CalendarTodoList
//
//  Created by 牛严 on 16/3/7.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import <Realm/Realm.h>

@interface RLMTodoTableID : RLMObject

@property NSInteger todoTableID;

@end


RLM_ARRAY_TYPE(RLMTodoTableID)
