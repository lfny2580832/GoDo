//
//  TypeColor.m
//  CalendarTodoList
//
//  Created by 牛严 on 16/2/5.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import "TypeColor.h"

@implementation TypeColor

- (instancetype)initWithRed:(NSInteger)red green:(NSInteger)green blue:(NSInteger)blue
{
    self = [super init];
    if (self) {
        _red = red;
        _green = green;
        _blue = blue;
    }
    return self;
}

@end
