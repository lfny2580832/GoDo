//
//  NSString+ZZExtends.h
//  HouseTransaction
//
//  Created by Jinsongzhuang on 4/1/15.
//  Copyright (c) 2015 chisalsoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMTodoModel.h"

@interface NSString (ZZExtends)

// md5计算
+ (NSString *)md5String:(NSString *)source;

// app版本号
+ (NSString *)appVersionString;

// 时间戳转换为时分字符串
+ (NSString *) getHourMinuteDateFromTimeInterval:(long long)dateTime;

//判断邮箱格式是否正确
- (BOOL)emailFormatCheck;

//判断手机号码格式是否正确
- (BOOL)phoneFormatCheck;

//pragma mark 判断是否包含非法字符
+ (BOOL)checkContainsEmoji:(NSString *)string;

+ (NSString *)getRepeatStrWithMode:(RepeatMode)repeatMode;

#pragma mark 根据DoneType返回字符串
+ (NSString *)getDoneStrWithType:(DoneType)doneType startTime:(long long)startTime;

#pragma mark 根据RemindMode返回字符串
+ (NSString *)getRemindStrWithMode:(RemindMode)remindMode;
@end
