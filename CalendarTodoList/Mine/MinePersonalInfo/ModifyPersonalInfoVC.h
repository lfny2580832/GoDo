//
//  ModifyPersonalInfoVC.h
//  GoDo
//
//  Created by 牛严 on 16/4/26.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol ModifyPersonalInfoVCDelegate <NSObject>

- (void)modidfyNameWith:(NSString *)name;

@end

@interface ModifyPersonalInfoVC : UIViewController

@property (nonatomic, weak) id<ModifyPersonalInfoVCDelegate> delegate;

@end
