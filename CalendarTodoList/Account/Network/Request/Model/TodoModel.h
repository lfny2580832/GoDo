//
//  TodoModel.h
//  GoDo
//
//  Created by 牛严 on 16/4/6.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TodoModel : NSObject

@property (nonatomic, copy) NSString *id;

@property (nonatomic, assign) long long startTime;

@property (nonatomic, assign) BOOL repeat;

@property (nonatomic, assign) BOOL allDay;

@property (nonatomic, assign) NSInteger repeatMode;

@property (nonatomic, copy) NSString *place;

@property (nonatomic, strong) NSArray<NSString *> *pictures;

@property (nonatomic, copy) NSString *desc;
///备注
@property (nonatomic, copy) NSString *remark;

@property (nonatomic, copy) NSString *ownerId;

@property (nonatomic, assign) long long finishTime;

@property (nonatomic, copy) NSString *missionId;

@end
