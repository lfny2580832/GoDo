//
//  NSString+ZZExtends.m
//  HouseTransaction
//
//  Created by Jinsongzhuang on 4/1/15.
//  Copyright (c) 2015 chisalsoft. All rights reserved.
//

#import "NSString+ZZExtends.h"
#import <CommonCrypto/CommonDigest.h>

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

#pragma mark 获取时间戳
+ (NSString *)timeIntervalSince1970
{
    return [NSString stringWithFormat:@"%lld", (long long)[[NSDate date] timeIntervalSince1970]];
}

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
    NSDate *lastDate = [NSDate dateWithTimeIntervalSinceReferenceDate:dateTime];
    [dateFormatter setDateFormat:@"HH:mm"];
    newTime = [dateFormatter stringFromDate:lastDate];
    
    return newTime;
}

@end
