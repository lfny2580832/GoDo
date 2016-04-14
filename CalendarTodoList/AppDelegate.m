//
//  AppDelegate.m
//  CalendarTodoList
//
//  Created by 牛严 on 15/12/24.
//  Copyright © 2015年 牛严. All rights reserved.
//

#import "AppDelegate.h"
#import "MainTabBarVC.h"
#import "BaseNavigationController.h"
#import "CalendarVC.h"

#import <IQKeyboardManager/IQKeyboardManager.h>

#import <YTKNetwork/YTKNetworkConfig.h>

@interface AppDelegate ()

@end

@implementation AppDelegate
{
//    BaseNavigationController *_calendarNavVC;
    MainTabBarVC *_mainTabbarVC;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    [self registRemoteNotification];
    [self registLocalNotification];
    [self setNetworkConfig];
    [[IQKeyboardManager sharedManager] setEnable:YES];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    _mainTabbarVC = [[MainTabBarVC alloc]init];

    [self.window setRootViewController:_mainTabbarVC];
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)setNetworkConfig
{
    YTKNetworkConfig *config = [YTKNetworkConfig sharedInstance];
    config.baseUrl = @"https://api.samaritan.tech";
//    config.baseUrl = @"http://127.0.0.1:8080";

}

//注册本地通知
- (void)registLocalNotification
{
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)])
    {
        UIUserNotificationType type =  UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:type
                                                                                 categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }
}

//注册远程通知
- (void)registRemoteNotification
{
    UIUserNotificationSettings *notiSettings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeBadge | UIUserNotificationTypeAlert | UIUserNotificationTypeSound) categories:nil];
    
    [[UIApplication sharedApplication] registerUserNotificationSettings:notiSettings];
    [[UIApplication sharedApplication] registerForRemoteNotifications];

}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    NSString *message = [notification.userInfo objectForKey:@"todoStr"];
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"您有新任务"
                                                                     message:message
                                                              preferredStyle:UIAlertControllerStyleAlert];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
    
    [_mainTabbarVC presentViewController:alertVC animated:YES completion:nil];
    
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet: [NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    [UserDefaultManager setDeviceToken:token];
    NSLog(@"content---%@", token);
    
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    
    NSLog(@"userInfo == %@",userInfo);
    NSString *message = [[userInfo objectForKey:@"aps"]objectForKey:@"alert"];
    NSLog(@"message:%@",message);
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    
    NSLog(@"Regist fail%@",error);
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
