//
//  ProjectDetailVC.h
//  GoDo
//
//  Created by 牛严 on 16/4/12.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ProjectModel;

@interface ProjectDetailVC : UIViewController

- (instancetype)initWithProject:(ProjectModel *)project;

- (instancetype)initWithProjectId:(NSString *)projectId;

@end
