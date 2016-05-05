//
//  CreateMissionAPI.h
//  GoDo
//
//  Created by 牛严 on 16/4/14.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>

@class MissionModel;

typedef void (^successBackBlock)(id responseObject);
typedef void (^failureBlock)();

@interface CreateMissionAPI : YTKRequest

- (id)initWithMissionName:(NSString *)name deadline:(NSDate *)deadline projectId:(NSString *)projectId receiversId:(NSArray *)receiversId;

- (void)startWithSuccessBlock:(successBackBlock)success failure:(failureBlock)failure;

@end
