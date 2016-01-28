//
//  RLMThing.h
//  CalendarTodoList
//
//  Created by 牛严 on 16/1/6.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import <Realm/Realm.h>

///事件类型枚举
typedef NS_ENUM(NSInteger, ThingType)
{
    Study = 0,          //学习
    Entertainment,      //娱乐
    Sport,              //体育
    Corporation,        //社团
    Organization,       //组织
};

@interface RLMThing : RLMObject

///事件类型
@property ThingType thingType;
///事件字符串
@property NSString *thingStr;

@end

