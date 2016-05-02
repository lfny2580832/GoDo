//
//  GetProjectInfoAPI.h
//  GoDo
//
//  Created by 牛严 on 16/5/2.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>

@interface GetProjectInfoAPI : YTKRequest

- (id)initWithProjectId:(NSString *)projectId;

@end
