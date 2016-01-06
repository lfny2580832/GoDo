//
//  UIViewController+ZZExtends.m
//  HouseTransaction
//
//  Created by Jinsongzhuang on 3/24/15.
//  Copyright (c) 2015 chisalsoft. All rights reserved.
//

#import "UIViewController+ZZExtends.h"

@implementation UIViewController (ZZExtends)

void ZZLog(NSString *format, ...) {
#ifdef DEBUG
    va_list argptr;
    va_start(argptr, format);
    NSLogv(format, argptr);
    va_end(argptr);
#endif
}

// 设置导航栏标题
- (void)setCustomTitle:(NSString *)customTittle
{
    [self setCustomTitle:customTittle color:[UIColor whiteColor]];
}
- (void)setCustomTitle:(NSString *)customTittle color:(UIColor *)color
{
    [self setCustomTitle:customTittle color:color font:[UIFont systemFontOfSize:18]];
}
- (void)setCustomTitle:(NSString *)customTittle color:(UIColor *)color font:(UIFont *)font
{
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 44)];
    titleLabel.text = customTittle;
    titleLabel.font = font;
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = color;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = titleLabel;
}
- (void)setCustomTitleImage:(UIImage *)image
{
    if (self.navigationItem) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 200)];
        imageView.backgroundColor = [UIColor clearColor];
        imageView.image = image;
        self.navigationItem.titleView = imageView;
    }
}

// 设置导航栏左按钮
- (void)setLeftBackButtontitle:(NSString *)title
{
    [self setLeftBackButtontitle:title color:[UIColor whiteColor]];
}
- (void)setLeftBackButtontitle:(NSString *)customTittle color:(UIColor *)color
{
    [self setLeftBackButtontitle:customTittle color:color font:[UIFont systemFontOfSize:14]];
}
- (void)setLeftBackButtontitle:(NSString *)customTittle color:(UIColor *)color font:(UIFont *)font
{
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 75, 44)];
    
    button.titleLabel.font = font;
    button.backgroundColor = [UIColor clearColor];
    [button setTitle:customTittle forState:UIControlStateNormal];
    [button setTitleColor:color forState:UIControlStateNormal];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    [button addTarget:self action:@selector(leftbarButtonItemOnclick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    
    self.navigationItem.leftBarButtonItem = barButtonItem;
}
- (void)setLeftBackButtonImage:(UIImage *)image
{
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    [button setImage:image forState:UIControlStateNormal];
    [button setImage:image forState:UIControlStateHighlighted];
    [button setImage:image forState:UIControlStateSelected];
    [button addTarget:self action:@selector(leftbarButtonItemOnclick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barbuttonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    
    self.navigationItem.leftBarButtonItem = barbuttonItem;
}


// 设置导航栏右按钮
- (void)setRightBackButtontile:(NSString *)title
{
    [self setRightBackButtontile:title color:[UIColor whiteColor]];
}
- (void)setRightBackButtontile:(NSString *)customTittle color:(UIColor *)color
{
    [self setRightBackButtontile:customTittle color:color font:[UIFont systemFontOfSize:14]];
}
- (void)setRightBackButtontile:(NSString *)customTittle color:(UIColor *)color font:(UIFont *)font
{
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 75, 44)];
    button.titleLabel.font = font;
    button.backgroundColor = [UIColor clearColor];
    //[button setTitleEdgeInsets:UIEdgeInsetsMake(10, 25, 10, 0)];
    
    [button setTitle:customTittle forState:UIControlStateNormal];
    [button setTitleColor:color forState:UIControlStateNormal];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    
    [button addTarget:self action:@selector(rightbarButtonItemOnclick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    
    self.navigationItem.rightBarButtonItem = barButtonItem;
}
- (void)setRightBackButtonImage:(UIImage *)image
{
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    [button setImage:image forState:UIControlStateNormal];
    [button setImage:image forState:UIControlStateHighlighted];
    [button setImage:image forState:UIControlStateSelected];
    [button addTarget:self action:@selector(rightbarButtonItemOnclick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barbuttonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    
    self.navigationItem.rightBarButtonItem = barbuttonItem;
}

- (void)leftbarButtonItemOnclick:(id)sender
{
    // 子类重写
}
- (void)rightbarButtonItemOnclick:(id)sender
{
    // 子类重写
}

- (void)endAllEdittings
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}
-(void)setTabBarHidden:(BOOL)hidden
{
    if (hidden == YES)
    {
        [self hideTabBar];
    }
    else
    {
        [self showTabBar];
    }

    
}
- (void)hideTabBar {
    if (self.tabBarController.tabBar.hidden == YES) {
        return;
    }
    UIView *contentView;
    if ( [[self.tabBarController.view.subviews objectAtIndex:0] isKindOfClass:[UITabBar class]] )
        contentView = [self.tabBarController.view.subviews objectAtIndex:1];
    else
        contentView = [self.tabBarController.view.subviews objectAtIndex:0];
    contentView.frame = CGRectMake(contentView.bounds.origin.x,  contentView.bounds.origin.y,  contentView.bounds.size.width, contentView.bounds.size.height + self.tabBarController.tabBar.frame.size.height);
    self.tabBarController.tabBar.hidden = YES;
    
}
- (void)showTabBar

{
    if (self.tabBarController.tabBar.hidden == NO)
    {
        return;
    }
    UIView *contentView;
    if ([[self.tabBarController.view.subviews objectAtIndex:0] isKindOfClass:[UITabBar class]])
        
        contentView = [self.tabBarController.view.subviews objectAtIndex:1];
    else
        contentView = [self.tabBarController.view.subviews objectAtIndex:0];
    contentView.frame = CGRectMake(contentView.bounds.origin.x, contentView.bounds.origin.y,  contentView.bounds.size.width, contentView.bounds.size.height - self.tabBarController.tabBar.frame.size.height);
    self.tabBarController.tabBar.hidden = NO;
    
}
@end
