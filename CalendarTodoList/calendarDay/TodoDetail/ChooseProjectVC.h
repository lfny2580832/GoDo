//
//  ChooseProjectVC.h
//  CalendarTodoList
//
//  Created by 牛严 on 16/2/4.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ThingType;

@protocol ChooseProjectVCDelegate <NSObject>

- (void)returnProjectWithThingType:(ThingType *)type;

@end

@interface ChooseProjectVC : UIViewController

@property (nonatomic, weak) id<ChooseProjectVCDelegate> delegate;

@end
