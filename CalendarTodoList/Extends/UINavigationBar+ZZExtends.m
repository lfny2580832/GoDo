//
//  UINavigationBar+ZZExtends.m
//  HouseTransaction
//
//  Created by Jinsongzhuang on 3/26/15.
//  Copyright (c) 2015 chisalsoft. All rights reserved.
//

#import "UINavigationBar+ZZExtends.h"
#import "UIImage+ZZExtends.h"

@implementation UINavigationBar (ZZExtends)

- (void) configureNavigationBarBackgroundColor:(UIColor *)color {
    [self setBackgroundImage:[UIImage imageWithColor:color cornerRadius:0]
               forBarMetrics:UIBarMetricsDefault & UIBarMetricsCompact];
    
    NSMutableDictionary *titleTextAttributes = [[self titleTextAttributes] mutableCopy];
    if (!titleTextAttributes) {
        titleTextAttributes = [NSMutableDictionary dictionary];
    }
    
    NSShadow *shadow = [[NSShadow alloc] init];
    [shadow setShadowOffset:CGSizeZero];
    [shadow setShadowColor:[UIColor clearColor]];
    [titleTextAttributes setObject:shadow forKey:NSShadowAttributeName];
    
    [self setTitleTextAttributes:titleTextAttributes];
    if ([self respondsToSelector:@selector(setShadowImage:)]) {
        [self setShadowImage:[UIImage imageWithColor:[UIColor clearColor] cornerRadius:0]];
    }
}



@end
