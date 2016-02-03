//
//  RLMThingType.h
//  CalendarTodoList
//
//  Created by 牛严 on 16/2/4.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import <Realm/Realm.h>

@interface RLMThingType : RLMObject
///事件类型ID 主键
@property (nonatomic, assign) NSInteger typeId;
///事件类型字符串
@property (nonatomic, copy) NSString *typeStr;
///事件类型标记颜色
@property (nonatomic, assign) NSInteger red;
@property (nonatomic, assign) NSInteger green;
@property (nonatomic, assign) NSInteger blue;

@end


