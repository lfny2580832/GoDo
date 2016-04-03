//
//  SendVerifyCodeAPI.h
//  GoDo
//
//  Created by 牛严 on 16/4/3.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>


@interface SendVerifyCodeAPI : YTKRequest

- (id)initWithSource:(NSString *)source to:(NSString *)to use:(NSString *)use;

@end
