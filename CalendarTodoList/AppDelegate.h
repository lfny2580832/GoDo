//
//  AppDelegate.h
//  CalendarTodoList
//
//  Created by 牛严 on 15/12/24.
//  Copyright © 2015年 牛严. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MainTabBarVC;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, strong) MainTabBarVC *mainTabbarVC;

@end

