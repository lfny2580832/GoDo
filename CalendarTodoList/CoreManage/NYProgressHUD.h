//
//  NYProgressHUD.h
//  GoDo
//
//  Created by 牛严 on 16/4/2.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MBProgressHUD.h>

@interface NYProgressHUD : NSObject

+ (void)showToastText:(NSString *)text;

+ (void)showToastText:(NSString *)text completion:(void(^)())completionBlock;

- (void)showAnimationWithText:(NSString *)text;

- (void)hide;

@end
