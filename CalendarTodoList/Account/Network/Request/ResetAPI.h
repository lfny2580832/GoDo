//
//  ResetAPI.h
//  GoDo
//
//  Created by 牛严 on 16/4/4.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>

@interface ResetAPI : YTKRequest

- (id)initWithMail:(NSString *)mail password:(NSString *)password verifyCode:(NSString *)verifyCode;

@end
