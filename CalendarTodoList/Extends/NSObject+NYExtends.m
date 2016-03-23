//
//  NSObject+NYExtends.m
//  CalendarTodoList
//
//  Created by 牛严 on 16/1/11.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import "NSObject+NYExtends.h"
#import <objc/runtime.h>

@implementation NSObject (NYExtends)
//@dynamic testStr;


const char testStringkey;

- (NSString *)testStr
{
    NSString * associatedObject = (NSString *)objc_getAssociatedObject(self, &testStringkey);
    return associatedObject;
}

- (void)setTestStr:(NSString *)testStr
{
    objc_setAssociatedObject(self, &testStringkey, testStr, OBJC_ASSOCIATION_RETAIN);
}

- (void)removeTestStr
{
    objc_setAssociatedObject(self, &testStringkey, nil, OBJC_ASSOCIATION_RETAIN);
}

#pragma mark 获取现在开始一年的天数
+ (NSInteger)numberOfDaysInThisYear
{
    NSCalendar *currentCalendar = [NSCalendar autoupdatingCurrentCalendar];
    NSDateComponents *inc = [[NSDateComponents alloc] init];
    inc.month = 1;

    NSDate *thisDate = [NSDate date];
    NSInteger sumDays = 0;
    for (int i = 0; i < 13; i ++) {
        NSInteger days = [currentCalendar rangeOfUnit:NSCalendarUnitDay
                                               inUnit:NSCalendarUnitMonth
                                              forDate:thisDate].length;
        NSDate *nextDate = [currentCalendar dateByAddingComponents:inc toDate:thisDate options:0];
        thisDate = nextDate;
        sumDays = sumDays + days;
    }
    return sumDays;
}

#pragma mark 获取上个月的天数
+ (NSInteger)numberOfDaysInLastMonth
{
    NSCalendar *currentCalendar = [NSCalendar autoupdatingCurrentCalendar];
    NSDateComponents *inc = [[NSDateComponents alloc] init];
    inc.month = -1;
    NSDate *lastDate = [currentCalendar dateByAddingComponents:inc toDate:[NSDate date] options:0];
    NSInteger days = [currentCalendar rangeOfUnit:NSCalendarUnitDay
                                           inUnit:NSCalendarUnitMonth
                                          forDate:lastDate].length;
    return days;
}

#pragma mark 获取随机颜色
+ (UIColor *)randomColor
{
    CGFloat hue = ( arc4random() % 256 / 256.0 ); //0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5; // 0.5 to 1.0,away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5; //0.5 to 1.0,away from black
    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
}

#pragma mark 根据时间戳返回dayId
- (NSInteger)getDayIdWithDateStamp:(long long)startDateStamp
{
    static NSDateFormatter *dateFormatter = nil;
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
    }
    [dateFormatter setDateFormat:@"yyyyMMdd"];
    NSDate *startDate = [NSDate dateWithTimeIntervalSinceReferenceDate:startDateStamp];
    NSString *dateStr = [dateFormatter stringFromDate:startDate];
    return [dateStr integerValue];
}

#pragma mark 根据日期返回dayId
- (NSInteger)getDayIdWithDate:(NSDate *)date
{
    static NSDateFormatter *dateFormatter = nil;
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
    }
    [dateFormatter setDateFormat:@"yyyyMMdd"];
    NSString *dateStr = [dateFormatter stringFromDate:date];
    return [dateStr integerValue];
}

-(UIImage *) imageCompressForWidth:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth
{
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = defineWidth;
    CGFloat targetHeight = (targetWidth / width) * height;
    UIGraphicsBeginImageContext(CGSizeMake(targetWidth, targetHeight));
    [sourceImage drawInRect:CGRectMake(0,0,targetWidth,  targetHeight)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end
