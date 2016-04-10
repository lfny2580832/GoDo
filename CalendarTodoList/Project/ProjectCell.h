//
//  ProjectCell.h
//  GoDo
//
//  Created by 牛严 on 16/4/11.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ProjectModel;

@interface ProjectCell : UITableViewCell

- (void)loadDataWithProjectModel:(ProjectModel *)project;

@end
