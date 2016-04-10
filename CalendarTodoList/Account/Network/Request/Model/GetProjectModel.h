//
//  GetProjectModel.h
//  GoDo
//
//  Created by 牛严 on 16/4/11.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import "BaseModel.h"
#import "ProjectModel.h"

@interface GetProjectModel : BaseModel

@property (nonatomic, strong) NSArray<ProjectModel *> *projects;

@end
