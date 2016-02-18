//
//  UserDefaultManage.h
//  CalendarTodoList
//
//  Created by 牛严 on 16/2/17.
//  Copyright © 2016年 牛严. All rights reserved.

//该类中存储需设置的对象

//

#import <Foundation/Foundation.h>

#define UserDefaultManager [UserDefaultManage sharedInstance]

@interface UserDefaultManage : NSObject

//todo的tableId，标示唯一性，需自增处理
@property (nonatomic, assign) NSInteger todoMaxId;

+ (id)sharedInstance;

@end
