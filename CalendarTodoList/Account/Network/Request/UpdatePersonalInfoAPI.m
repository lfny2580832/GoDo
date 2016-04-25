//
//  UpdatePersonalInfoAPI.m
//  GoDo
//
//  Created by 牛严 on 16/4/25.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import "UpdatePersonalInfoAPI.h"

@implementation UpdatePersonalInfoAPI

{
    NSString *_name;    //名称
    NSString *_avatar;  //头像名
}

- (id)initWithName:(NSString *)name avatarName:(NSString *)avatarName
{
    self = [super init];
    if (self) {
        _name = name? name:@"";
        _avatar = avatarName? avatarName:@"";
    }
    return self;
}

- (void)startWithSuccessBlock:(successBlock)success failure:(failureBlock)failure
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [manager.requestSerializer setValue:[UserDefaultManager token] forHTTPHeaderField:@"Authorization"];
    NSString *url = [NSString stringWithFormat:@"%@/users/personalInfo",baseAPIURL];
    NSMutableDictionary *dict = [NSMutableDictionary new];
    [dict setObject:_name forKey:@"name"];
    [dict setObject:_avatar forKey:@"avatar"];
    [manager PUT:url parameters:dict success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        success();
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
        failure();
        
    }];
    
}

//- (NSString *)requestUrl {
//    return @"/users/personalInfo";
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
////             @"Content-Type":@"application/json",
//             };
//}
//
//- (id)requestArgument {
//    
//    NSDictionary *dic = @{
//                          @"name": _name,
//                          @"avatar": _avatar,
//                          };
////    NSLog(@"fuck %@",dic);
//    return dic;
//}


@end
