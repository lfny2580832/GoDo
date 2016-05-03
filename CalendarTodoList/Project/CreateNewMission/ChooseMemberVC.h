//
//  ChooseMemberVC.h
//  GoDo
//
//  Created by 牛严 on 16/5/1.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ChooseMemberVCDelegate <NSObject>

- (void)getSelectedMembersWith:(NSArray *)selectedMemberIds;


@end

@interface ChooseMemberVC : UIViewController

@property (nonatomic, strong) NSArray *receivers;

@property (nonatomic, weak) id <ChooseMemberVCDelegate> delegate;

- (instancetype)initWithMembers:(NSArray *)members;

@end
