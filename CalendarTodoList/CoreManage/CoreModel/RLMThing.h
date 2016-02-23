//
//  RLMThing.h
//  CalendarTodoList
//
//  Created by 牛严 on 16/1/6.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import <Realm/Realm.h>
#import "RLMThingType.h"
#import "RLMImage.h"

@interface RLMThing : RLMObject

///事件类型
@property RLMThingType *thingType;
///事件字符串
@property NSString *thingStr;
///图片数组
@property RLMArray <RLMImage>* imageDatas;

@end

