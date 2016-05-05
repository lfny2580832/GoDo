//
//  MainTabBarVC.h
//  CalendarTodoList
//
//  Created by 牛严 on 15/12/25.
//  Copyright © 2015年 牛严. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BaseNavigationController;

@interface MainTabBarVC : UITabBarController

@property (nonatomic, strong)BaseNavigationController *calendarNavVC;

@property (nonatomic, strong)BaseNavigationController *projectNavVC;

@property (nonatomic, strong)BaseNavigationController *mineNavVC;

@end
