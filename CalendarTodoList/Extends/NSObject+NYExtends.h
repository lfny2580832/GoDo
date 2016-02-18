//
//  NSObject+NYExtends.h
//  CalendarTodoList
//
//  Created by 牛严 on 16/1/11.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (NYExtends)

#pragma mark 获取当前三个月天数
+ (NSInteger)numberOfDaysOfThreeMonths;

#pragma mark 获取随机颜色
+ (UIColor *)randomColor;

#pragma mark 根据日期返回dayId
- (NSInteger)getDayIdWithDateStamp:(long long)startDateStamp;

#pragma mark 根据日期返回dayId
- (NSInteger)getDayIdWithDate:(NSDate *)date;
@end
