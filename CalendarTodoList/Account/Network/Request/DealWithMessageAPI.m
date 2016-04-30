//
//  DealWithMessage.m
//  GoDo
//
//  Created by 牛严 on 16/4/29.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import "DealWithMessageAPI.h"

@implementation DealWithMessageAPI
{
    NSString *_messageId;
    BOOL _dealt;
}

- (id)initWithMessageId:(NSString *)messageId Dealt:(BOOL)dealt
{
    self = [super init];
    if (self) {
        _messageId = messageId;
        _dealt = dealt;
    }
    return self;
}

- (void)startWithSuccessBlock:(successBlock)success failure:(failureBlock)failure
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [manager.requestSerializer setValue:[UserDefaultManager token] forHTTPHeaderField:@"Authorization"];
    NSString *url = [NSString stringWithFormat:@"%@/chats/status/%@",baseAPIURL,_messageId];
    NSMutableDictionary *dict = [NSMutableDictionary new];
    [dict setValue:@(_dealt) forKey:@"dealt"];
    [manager PUT:url parameters:dict success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        success();
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        failure();
    }];
}

@end
