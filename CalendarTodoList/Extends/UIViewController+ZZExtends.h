//
//  UIViewController+ZZExtends.h
//  HouseTransaction
//
//  Created by Jinsongzhuang on 3/24/15.
//  Copyright (c) 2015 chisalsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (ZZExtends)

void ZZLog(NSString *format, ...);

// 设置导航栏标题
- (void)setCustomTitle:(NSString *)customTittle;
- (void)setCustomTitle:(NSString *)customTittle color:(UIColor *)color;
- (void)setCustomTitle:(NSString *)customTittle color:(UIColor *)color font:(UIFont *)font;
- (void)setCustomTitleImage:(UIImage *)image;

// 设置导航栏左按钮
- (void)setLeftBackButtontitle:(NSString *)title;
- (void)setLeftBackButtontitle:(NSString *)customTittle color:(UIColor *)color;
- (void)setLeftBackButtontitle:(NSString *)customTittle color:(UIColor *)color font:(UIFont *)font;
- (void)setLeftBackButtonImage:(UIImage *)image;

// 设置导航栏右按钮
- (void)setRightBackButtontile:(NSString *)title;
- (void)setRightBackButtontile:(NSString *)customTittle color:(UIColor *)color;
- (void)setRightBackButtontile:(NSString *)customTittle color:(UIColor *)color font:(UIFont *)font;
- (void)setRightBackButtonImage:(UIImage *)image;
- (void)rightbarButtonItemOnclick:(id)sender;
- (void)leftbarButtonItemOnclick:(id)sender;

// 取消页面编辑状态
- (void)endAllEdittings;

//设置tabbar 是否隐藏;
- (void)setTabBarHidden:(BOOL)hidden;
@end
