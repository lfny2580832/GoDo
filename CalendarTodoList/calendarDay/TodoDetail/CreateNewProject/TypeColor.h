//
//  TypeColor.h
//  CalendarTodoList
//
//  Created by 牛严 on 16/2/5.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TypeColor : NSObject

@property (nonatomic, assign)NSInteger red;
@property (nonatomic, assign)NSInteger green;
@property (nonatomic, assign)NSInteger blue;

- (instancetype)initWithRed:(NSInteger)red green:(NSInteger)green blue:(NSInteger)blue;

@end
