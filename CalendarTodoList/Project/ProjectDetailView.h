//
//  ProjectDetailView.h
//  GoDo
//
//  Created by 牛严 on 16/4/12.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ProjectModel;

@protocol ProjectDetailViewDelegate <NSObject>

- (void)didSelectCellAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface ProjectDetailView : UIView

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) ProjectModel *project;

@property (nonatomic, strong) NSArray *missions;

@property (nonatomic, weak) id <ProjectDetailViewDelegate> delegate;

- (instancetype)initWithTarget:(id)target;

@end
