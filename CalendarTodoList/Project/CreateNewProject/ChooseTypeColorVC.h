//
//  ChooseTypeColorVC.h
//  CalendarTodoList
//
//  Created by 牛严 on 16/2/5.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TypeColor;

@protocol ChooseTypeColorDelegate <NSObject>

- (void)returnTypeColorWithTypeColor:(TypeColor *)color;

@end

@interface ChooseTypeColorVC : UIViewController

@property (nonatomic, weak) id<ChooseTypeColorDelegate> delegate;

@end
