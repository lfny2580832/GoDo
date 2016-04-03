//
//  LoginView.h
//  GoDo
//
//  Created by 牛严 on 16/3/30.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginView : UIView

@property (nonatomic, strong) UITextField *mailTextField;
@property (nonatomic, strong) UITextField *passwordTextField;

- (instancetype)initWithTarget:(id)target frame:(CGRect)frame;

@end
