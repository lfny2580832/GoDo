//
//  UpdatePersonalInfoAPI.h
//  GoDo
//
//  Created by 牛严 on 16/4/25.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>


typedef void (^successBlock)();
typedef void (^failureBlock)();

@interface UpdatePersonalInfoAPI : YTKRequest

- (id)initWithName:(NSString *)name avatarName:(NSString *)avatarName;

- (void)startWithSuccessBlock:(successBlock)success failure:(failureBlock)failure;

@end
