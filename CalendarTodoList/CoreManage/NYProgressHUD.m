//
//  NYProgressHUD.m
//  GoDo
//
//  Created by 牛严 on 16/4/2.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import "NYProgressHUD.h"

@interface NYProgressHUD ()<MBProgressHUDDelegate>

@property (strong, nonatomic) MBProgressHUD *HUD;

@end

@implementation NYProgressHUD

+ (void)showToastText:(NSString *)text
{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    MBProgressHUD *HUD = [[MBProgressHUD alloc]initWithWindow:keyWindow];
    [keyWindow addSubview:HUD];
    HUD.labelText = text;
    HUD.mode = MBProgressHUDModeText;
    
    int sec = text.length > 6? 2:1;

    [HUD showAnimated:YES whileExecutingBlock:^{
        sleep(sec);
    } completionBlock:^{
        [HUD removeFromSuperview];
    }];
}

+ (void)showToastText:(NSString *)text completion:(void(^)())completionBlock
{
    [self showToastText:text];
    int sec = text.length > 6? 2:1;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(sec * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        completionBlock();
    });
}






- (void)showAnimationWithText:(NSString *)text
{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    _HUD = [[MBProgressHUD alloc]initWithWindow:keyWindow];
    
    [keyWindow addSubview:_HUD];
    _HUD.labelText = text;
    _HUD.delegate = self;//添加代理
    
    [_HUD show:YES];
}

-(void)hide
{
    [_HUD hide:YES];
}

#pragma mark MBProgressHUD代理方法
-(void)hudWasHidden:(MBProgressHUD *)hud
{
    [_HUD removeFromSuperview];
    if (_HUD != nil) {
        _HUD = nil;
    }
}
@end
