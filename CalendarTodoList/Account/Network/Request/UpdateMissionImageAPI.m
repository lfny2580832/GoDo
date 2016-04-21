
//
//  UpdateMissionImageAPI.m
//  GoDo
//
//  Created by 牛严 on 16/4/20.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import "UpdateMissionImageAPI.h"

@implementation UpdateMissionImageAPI
{
    NSString *_missionId;
    NSArray *_pictures;
}

- (id)initWithMissionId:(NSString *)missionId pictures:(NSArray *)pictures
{
    self = [super init];
    if (self) {
        _missionId = missionId;
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
    NSString *url = [NSString stringWithFormat:@"%@/missions/pictures/%@",baseAPIURL,_missionId];
    NSMutableDictionary *dict = [NSMutableDictionary new];
    [dict setObject:_pictures forKey:@"pictures"];
    [manager PUT:url parameters:dict success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        success();

    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
        failure();

    }];

}

- (void)request{
   
}

//- (NSString *)requestUrl {
//    NSString *url = [NSString stringWithFormat:@"/missions/pictures/%@",_missionId];
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
//             @"Content-Type":@"application/json",
//             @"Authorization": [UserDefaultManager token],
//             };
//}
//
//- (id)requestArgument {
//
//    NSDictionary *dic = @{
//                          @"pictures":_pictures
//                          };
//    NSLog(@"----%@",dic);
//    return dic;
//}

@end
