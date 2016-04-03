//
//  ResetView.h
//  GoDo
//
//  Created by 牛严 on 16/4/3.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResetView : UIView

@property (nonatomic, strong) UITextField *mailTextField;
@property (nonatomic, strong) UITextField *verifyCodeTextField;
@property (nonatomic, strong) UITextField *passwordTextField;

- (instancetype)initWithVC:(id)vc frame:(CGRect)frame;

@end
