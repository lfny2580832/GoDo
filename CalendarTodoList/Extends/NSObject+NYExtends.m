//
//  NSObject+NYExtends.m
//  CalendarTodoList
//
//  Created by 牛严 on 16/1/11.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import "NSObject+NYExtends.h"

@implementation NSObject (NYExtends)

#pragma mark 获取当前三个月天数
+ (NSInteger)numberOfDaysOfThreeMonths {
    NSCalendar *currentCalendar = [NSCalendar autoupdatingCurrentCalendar];
    NSDateComponents *currentComponents = [currentCalendar components:NSCalendarUnitYear|
                                           NSCalendarUnitMonth|
                                           NSCalendarUnitDay|
                                           NSCalendarUnitWeekday|
                                           NSCalendarUnitCalendar
                                                             fromDate:[NSDate date]];
    //用来加一个月的component
    NSDateComponents *inc = [[NSDateComponents alloc] init];
    inc.month = 1;
    //第一个月的日期和天数
    NSInteger firstMonthDays = [currentCalendar rangeOfUnit:NSCalendarUnitDay
                                                     inUnit:NSCalendarUnitMonth
                                                    forDate:[NSDate date]].length;
    
    NSDate *currentDate = [currentCalendar dateFromComponents:currentComponents];
    //第二个月的日期和天数
    NSDate *secondDate = [currentCalendar dateByAddingComponents:inc toDate:currentDate options:0];
    NSInteger secondMonthDays = [currentCalendar rangeOfUnit:NSCalendarUnitDay
                                                      inUnit:NSCalendarUnitMonth
                                                     forDate:secondDate].length;
    //第三个月的日期和天数
    NSDate *thirdDate = [currentCalendar dateByAddingComponents:inc toDate:secondDate options:0];
    NSInteger thirdMonthDays = [currentCalendar rangeOfUnit:NSCalendarUnitDay
                                                     inUnit:NSCalendarUnitMonth
                                                    forDate:thirdDate].length;
    
    return firstMonthDays + secondMonthDays + thirdMonthDays;
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

#pragma mark 放大缩小图片
static CGRect oldframe;

-(void)showImage:(UIImageView *)avatarImageView{
    UIImage *image=avatarImageView.image;
    UIWindow *window=[UIApplication sharedApplication].keyWindow;
    UIView *backgroundView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    oldframe=[avatarImageView convertRect:avatarImageView.bounds toView:window];
    backgroundView.backgroundColor=[UIColor blackColor];
    backgroundView.alpha=0;
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:oldframe];
    imageView.image=image;
    imageView.tag=1;
    [backgroundView addSubview:imageView];
    [window addSubview:backgroundView];
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideImage:)];
    [backgroundView addGestureRecognizer: tap];
    
    [UIView animateWithDuration:0.3 animations:^{
        imageView.frame=CGRectMake(0,([UIScreen mainScreen].bounds.size.height-image.size.height*[UIScreen mainScreen].bounds.size.width/image.size.width)/2, [UIScreen mainScreen].bounds.size.width, image.size.height*[UIScreen mainScreen].bounds.size.width/image.size.width);
        backgroundView.alpha=1;
    } completion:^(BOOL finished) {
        
    }];
}

-(void)hideImage:(UITapGestureRecognizer*)tap{
    UIView *backgroundView=tap.view;
    UIImageView *imageView=(UIImageView*)[tap.view viewWithTag:1];
    [UIView animateWithDuration:0.3 animations:^{
        imageView.frame=oldframe;
        backgroundView.alpha=0;
    } completion:^(BOOL finished) {
        [backgroundView removeFromSuperview];
    }];
}

@end
