//
//  GradientView.m
//  CalendarTodoList
//
//  Created by 牛严 on 16/1/4.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import "GradientView.h"

@implementation GradientView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self insertTransparentGradient];
    }
    return self;
}

- (void) insertTransparentGradient {
    UIColor *colorOne = RGBA(255, 255, 255, 1);
    UIColor *colorTwo = RGBA(255, 255, 255, 0);
    NSArray *colors = [NSArray arrayWithObjects:(id)colorOne.CGColor, colorTwo.CGColor, nil];
    NSNumber *stopOne = [NSNumber numberWithFloat:0.0];
    NSNumber *stopTwo = [NSNumber numberWithFloat:1.0];
    NSArray *locations = [NSArray arrayWithObjects:stopOne, stopTwo, nil];
    
    //crate gradient layer
    CAGradientLayer *headerLayer = [CAGradientLayer layer];
    
    headerLayer.colors = colors;
    headerLayer.locations = locations;
    headerLayer.frame = self.bounds;
    
    [self.layer insertSublayer:headerLayer atIndex:0];
}

@end
