//
//  ChoosePrivateTypeVC.h
//  GoDo
//
//  Created by 牛严 on 16/4/11.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ChoosePrivateTypeVCDelegate <NSObject>

- (void)getPrivateTypeWith:(NSString *)name;

@end

@interface ChoosePrivateTypeVC : UIViewController

@property (nonatomic, weak) id <ChoosePrivateTypeVCDelegate> delegate;

@end

@interface PrivateTypeCell : UITableViewCell

@property (nonatomic, copy) NSString *privateStr;

- (instancetype)initWithPrivteType;

- (instancetype)initWithPublicType;

@end