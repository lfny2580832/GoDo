//
//  VerifyCodeButton.h
//  GoDo
//
//  Created by 牛严 on 16/4/3.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VerifyCodeButton : UIButton

@property (nonatomic, copy) NSString *mail;

- (void)sendVerifyCodeWithMail:(NSString *)mail use:(NSString *)use;

@end
