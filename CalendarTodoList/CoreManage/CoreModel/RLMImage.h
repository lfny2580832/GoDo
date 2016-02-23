//
//  RLMImage.h
//  CalendarTodoList
//
//  Created by 牛严 on 16/2/23.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import <Realm/Realm.h>

@interface RLMImage : RLMObject

@property NSData *imageData;

@end

RLM_ARRAY_TYPE(RLMImage)

