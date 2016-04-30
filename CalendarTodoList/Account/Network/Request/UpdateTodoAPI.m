//
//  UpdateTodoAPI.m
//  GoDo
//
//  Created by 牛严 on 16/4/7.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import "UpdateTodoAPI.h"
#import "TodoModel.h"

@implementation UpdateTodoAPI
{
    TodoModel *_todo;
    NSArray *_pictures;
}

- (id)initWithTodo:(TodoModel *)todo pictures:(NSArray *)pictures
{
    self = [super init];
    if (self) {
        _todo = todo;
        _pictures = pictures;
    }
    return self;
}

- (void)startWithSuccessBlock:(successBlock)success failure:(failureBlock)failure
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [manager.requestSerializer setValue:[UserDefaultManager token] forHTTPHeaderField:@"Authorization"];
    NSString *url = [NSString stringWithFormat:@"%@/todos/%@",baseAPIURL,_todo.id];
    NSDictionary *dict = [NSDictionary new];
    
    if (_todo.missionId.length > 0 ) {
        dict = @{
                 @"startTime": @(_todo.startTime),
                 @"repeat": @(_todo.repeat),
                 @"repeatMode":@(_todo.repeatMode),
                 @"allDay":@(_todo.allDay),
                 @"desc":_todo.desc,
                 @"missionId":_todo.missionId,
                 @"pictures":_pictures,
                 };
    }else{
        dict = @{
                 @"startTime": @(_todo.startTime),
                 @"repeat": @(_todo.repeat),
                 @"repeatMode":@(_todo.repeatMode),
                 @"allDay":@(_todo.allDay),
                 @"desc":_todo.desc,
                 @"pictures":_pictures,
                 };
    }
    
    [manager PUT:url parameters:dict success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        success();
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NSLog(@"fuck%@",error);
        failure();
    }];
}

//- (NSString *)requestUrl {
//    NSString *url = [NSString stringWithFormat:@"/todos/%@",_todo.id];
//    return url;
//}
//
//- (YTKRequestMethod)requestMethod {
//    return YTKRequestMethodPut;
//}
//
//
//- (NSDictionary *)requestHeaderFieldValueDictionary
//{
//    return @{
//             @"Authorization": [UserDefaultManager token],
////             @"Content-Type":@"application/json;charset=UTF-8",
//             };
//}
//
//- (id)requestArgument {
//    NSDictionary *dic;
//    if (_todo.missionId.length > 0 ) {
//        dic = @{
//                @"startTime": @(_todo.startTime),
//                @"repeat": @(_todo.repeat),
//                @"repeatMode":@(_todo.repeatMode),
//                @"allDay":@(_todo.allDay),
//                @"desc":_todo.desc,
//                @"missionId":_todo.missionId,
//                @"pictures":_pictures,
//                };
//    }else{
//        dic = @{
//                @"startTime": @(_todo.startTime),
//                @"repeat": @(_todo.repeat),
//                @"repeatMode":@(_todo.repeatMode),
//                @"allDay":@(_todo.allDay),
//                @"desc":_todo.desc,
//                @"pictures":_pictures,
//                };
//    }
////    NSLog(@"fuck %@",dic);
//    return dic;
//}

@end
