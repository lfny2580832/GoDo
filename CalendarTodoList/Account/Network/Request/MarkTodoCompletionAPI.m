//
//  MarkTodoCompletionAPI.m
//  GoDo
//
//  Created by 牛严 on 16/4/28.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import "MarkTodoCompletionAPI.h"

@implementation MarkTodoCompletionAPI
{
    NSString *_todoId;
}

- (id)initWithTodoId:(NSString *)todoId
{
    self = [super init];
    if (self) {
        _todoId = todoId;
    }
    return self;
}

//- (void)startWithSuccessBlock:(successBlock)success failure:(failureBlock)failure
//{
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    manager.requestSerializer=[AFJSONRequestSerializer serializer];
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
//    [manager.requestSerializer setValue:[UserDefaultManager token] forHTTPHeaderField:@"Authorization"];
//    NSString *url = [NSString stringWithFormat:@"%@/users/personalInfo",baseAPIURL];
//    NSMutableDictionary *dict = [NSMutableDictionary new];
//    [dict setObject:_name forKey:@"name"];
//    [dict setObject:_avatar forKey:@"avatar"];
//    [manager PUT:url parameters:dict success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
//        
//        success();
//        
//    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
//        
//        failure();
//        
//    }];
//    
//}

@end
