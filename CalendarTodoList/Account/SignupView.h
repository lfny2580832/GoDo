//
//  SignupView.h
//  GoDo
//
//  Created by 牛严 on 16/4/3.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignupView : UIView

@property (nonatomic, strong) UITextField *schoolNumTextField;
@property (nonatomic, strong) UITextField *nameTextField;
@property (nonatomic, strong) UITextField *mailTextField;
@property (nonatomic, strong) UITextField *passwordTextField;
@property (nonatomic, strong) UITextField *verifyCodeTextField;

- (instancetype)initWithTarget:(id)target frame:(CGRect)frame;

@end
