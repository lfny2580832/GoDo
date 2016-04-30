//
//  JoinProjectAPI.m
//  GoDo
//
//  Created by 牛严 on 16/4/29.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import "JoinProjectAPI.h"

@implementation JoinProjectAPI

{
    NSString *_projectId;
}

- (id)initWithProjectId:(NSString *)projectId
{
    self = [super init];
    if (self) {
        _projectId = projectId;
    }
    return self;
}

- (void)startWithSuccessBlock:(successBlock)success failure:(failureBlock)failure
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [manager.requestSerializer setValue:[UserDefaultManager token] forHTTPHeaderField:@"Authorization"];
    NSString *url = [NSString stringWithFormat:@"%@/projects/joined/%@",baseAPIURL,_projectId];
    [manager PUT:url parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        success();
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        failure();
    }];
}

@end
