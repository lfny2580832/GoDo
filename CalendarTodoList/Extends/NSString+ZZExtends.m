//
//  NSString+ZZExtends.m
//  HouseTransaction
//
//  Created by Jinsongzhuang on 4/1/15.
//  Copyright (c) 2015 chisalsoft. All rights reserved.
//

#import "NSString+ZZExtends.h"
#import <CommonCrypto/CommonDigest.h>
#import "FMTodoModel.h"


@implementation NSString (ZZExtends)

#pragma mark - MD5加密
+ (NSString *)md5String:(NSString *)string {
    if(string == nil || [string length] == 0)
        return nil;
    
    const char *value = [string UTF8String];
    
    unsigned char outputBuffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5(value, (CC_LONG)strlen(value), outputBuffer);
    
    NSMutableString *outputString = [[NSMutableString alloc] initWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(NSInteger count = 0; count < CC_MD5_DIGEST_LENGTH; count++){
        [outputString appendFormat:@"%02X",outputBuffer[count]];
    }
    
    return outputString;
}

#pragma mark 获取系统版本号
+ (NSString *)appVersionString {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}
//
//#pragma mark 获取时间戳
//+ (NSString *)timeIntervalSince1970
//{
//    return [NSString stringWithFormat:@"%lld", (long long)[[NSDate date] timeIntervalSince1970]];
//}

#pragma mark 判断邮箱格式是否正确
- (BOOL)emailFormatCheck
{
    NSString *emailRegex = @"[A-Za-z0-9_]+([-+.][A-Za-z0-9_]+)*@[A-Za-z0-9_]+([-.][A-Za-z0-9_]+)*\\.[A-Za-z0-9_]+([-.][A-Za-z0-9_]+)*";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",emailRegex];
    
    return [emailTest evaluateWithObject:self];
}

#pragma mark 判断手机号码格式是否正确
- (BOOL)phoneFormatCheck
{
    NSString *phoneNumberRegex = @"^[1][123456789][0-9]{9}$";
    NSPredicate *phoneNumberPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneNumberRegex];
    return [phoneNumberPredicate evaluateWithObject:self];
}

#pragma mark 判断是否包含Emoji表情
+ (BOOL)checkContainsEmoji:(NSString *)string
{    
    __block BOOL returnValue = NO;
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:
     ^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
         
         const unichar hs = [substring characterAtIndex:0];
         // surrogate pair
         if (0xd800 <= hs && hs <= 0xdbff) {
             if (substring.length > 1) {
                 const unichar ls = [substring characterAtIndex:1];
                 const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                 if (0x1d000 <= uc && uc <= 0x1f77f) {
                     returnValue = YES;
                 }
             }
         } else if (substring.length > 1) {
             const unichar ls = [substring characterAtIndex:1];
             if (ls == 0x20e3) {
                 returnValue = YES;
             }
             
         } else {
             // non surrogate
             if (0x2100 <= hs && hs <= 0x27ff) {
                 returnValue = YES;
             } else if (0x2B05 <= hs && hs <= 0x2b07) {
                 returnValue = YES;
             } else if (0x2934 <= hs && hs <= 0x2935) {
                 returnValue = YES;
             } else if (0x3297 <= hs && hs <= 0x3299) {
                 returnValue = YES;
             } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                 returnValue = YES;
             }
         }
     }];
    
    return returnValue;
}

#pragma mark 时间戳转换为时分字符串
+ (NSString *) getHourMinuteDateFromTimeInterval:(long long)dateTime
{
    NSString *newTime;
    static NSDateFormatter *dateFormatter = nil;
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
    }
    NSDate *lastDate = [NSDate dateWithTimeIntervalSince1970:dateTime];
    [dateFormatter setDateFormat:@"HH:mm"];
    newTime = [dateFormatter stringFromDate:lastDate];
    
    return newTime;
}

#pragma mark 根据RepeatMode返回字符串
+ (NSString *)getRepeatStrWithMode:(RepeatMode)repeatMode
{
    NSString *str;
    switch (repeatMode) {
        case 0:
            str = @"不重复";
            break;
        case 1:
            str = @"每天";
            break;
        case 2:
            str = @"每周";
            break;
        case 3:
            str = @"每月";
            break;
        case 4:
            str = @"工作日";
            break;
        default:
            break;
    }
    return str;
}

#pragma mark 根据DoneType返回字符串
+ (NSString *)getDoneStrWithType:(DoneType)doneType startTime:(long long)startTime
{
    NSString *str;
    switch (doneType) {
        case NotDone:
        {
            long long now = [[NSDate date] timeIntervalSince1970];
            str = (now > startTime)? @"未完成":@"未开始";
        }
            break;
        case Done:
            str = @"已完成";
            break;
        default:
            break;
    }
    return str;
}

#pragma mark 根据RemindMode返回字符串
+ (NSString *)getRemindStrWithMode:(RemindMode)remindMode
{
    NSString *str;
    switch (remindMode) {
        case 0:
            str = @"不提醒";
            break;
        case 1:
            str = @"准时提醒";
            break;
        case 2:
            str = @"提前5分钟";
            break;
        case 3:
            str = @"提前10分钟";
            break;
        case 4:
            str = @"提前15分钟";
            break;
        case 5:
            str = @"提前半小时";
            break;
        default:
            break;
    }
    return str;
}

#pragma mark 时间戳转换为 x月x日、x时x分
+ (NSDictionary *)dateStringsWithTimeStamp:(long long)timeStamp
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeStamp];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"MM月dd日"];
    NSString *dateStr = [dateFormatter stringFromDate:date];
    [dateFormatter setDateFormat:@"hh:mm"];
    NSString *timeStr = [dateFormatter stringFromDate:date];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:2];
    [dic setObject:dateStr forKey:@"date"];
    [dic setObject:timeStr forKey:@"time"];
    return dic;
}

#pragma mark 时间戳转换为 x月x日
+ (NSString *)monthDayDateStringWithTimeStamp:(long long)timeStamp
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeStamp];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"MM月dd日"];
    NSString *dateStr = [dateFormatter stringFromDate:date];
    return dateStr;
}

@end
