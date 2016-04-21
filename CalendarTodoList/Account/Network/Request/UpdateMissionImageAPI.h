//
//  UpdateMissionImageAPI.h
//  GoDo
//
//  Created by 牛严 on 16/4/20.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import <AFNetworking.h>

typedef void (^successBlock)();
typedef void (^failureBlock)();

@interface UpdateMissionImageAPI : AFHTTPRequestOperationManager

- (id)initWithMissionId:(NSString *)missionId pictures:(NSArray *)pictures;

- (void)startWithSuccessBlock:(successBlock)success failure:(failureBlock)failure;
@end
