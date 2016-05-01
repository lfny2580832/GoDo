//
//  CreateMissionVC.h
//  GoDo
//
//  Created by 牛严 on 16/4/15.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MissionModel;
@class ProjectModel;

@interface CreateMissionVC : UIViewController

@property (nonatomic, strong) MissionModel *mission;

- (instancetype)initWithProject:(ProjectModel *)project;

@end
