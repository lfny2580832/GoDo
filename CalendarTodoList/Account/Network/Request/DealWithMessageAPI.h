//
//  DealWithMessage.h
//  GoDo
//
//  Created by 牛严 on 16/4/29.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>

typedef void (^successBlock)();
typedef void (^failureBlock)();

@interface DealWithMessageAPI : YTKRequest

- (id)initWithMessageId:(NSString *)messageId Dealt:(BOOL)dealt;

- (void)startWithSuccessBlock:(successBlock)success failure:(failureBlock)failure;

@end
