//
//  BaseNavigationController.m
//  UsedCar
//
//  Created by shi_mhua on 15/10/1.
//  Copyright © 2015年 chisalsoft. All rights reserved.
//

#import "BaseNavigationController.h"
#import "UINavigationBar+ZZExtends.h"

@interface BaseNavigationController ()

@end

@implementation BaseNavigationController

-(instancetype) initWithRootViewController:(UIViewController *)rootViewController
{
    self = [super initWithRootViewController:rootViewController];
    if (self)
    {
        [self.navigationBar configureNavigationBarBackgroundColor:KNaviColor];
    }
    return self;
}

- (void) pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.viewControllers.count)
    {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}

@end
