//
//  CreateMissionAPI.m
//  GoDo
//
//  Created by 牛严 on 16/4/14.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import "CreateMissionAPI.h"
#import "MissionModel.h"

@implementation CreateMissionAPI

{
    NSString *_name;
    NSString *_desc;
    NSString *_projectId;
    NSArray *_receiversId;
    long long _deadline;
    
}

- (id)initWithMissionName:(NSString *)name deadline:(NSDate *)deadline projectId:(NSString *)projectId receiversId:(NSArray *)receiversId
{
    self = [super init];
    if (self) {
        _name = name;
        _desc = @"无";
        _projectId = projectId;
        _deadline = [deadline timeIntervalSince1970];
        _receiversId = receiversId;
    }
    return self;
}


- (void)startWithSuccessBlock:(successBackBlock)success failure:(failureBlock)failure
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [manager.requestSerializer setValue:[UserDefaultManager token] forHTTPHeaderField:@"Authorization"];
    NSString *url = [NSString stringWithFormat:@"%@/missions",baseAPIURL];
    NSDictionary *dic = @{
                          @"name": _name,
                          @"desc": _desc,
                          @"projectId":_projectId,
                          @"receiversId":_receiversId,
                          @"deadline":@(_deadline)
                          };
    [manager POST:url parameters:dic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        success(responseObject);
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        failure();
    }];
}

- (NSString *)requestUrl {
    return @"/missions";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPost;
}


- (NSDictionary *)requestHeaderFieldValueDictionary
{
    return @{
             @"Authorization": [UserDefaultManager token],
             };
}

- (id)requestArgument {
    NSDictionary *dic =@{
                         @"name": _name,
                         @"desc": _desc,
                         @"projectId":_projectId,
                         @"receiversId":_receiversId,
                         @"deadline":@(_deadline)
                         };
    NSLog(@"---%@",dic);
    return dic;
}

@end
