//
//  RegistAPI.h
//  GoDo
//
//  Created by 牛严 on 16/3/30.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>

@interface RegistAPI : YTKRequest

- (id)initWithName:(NSString *)name password:(NSString *)password mail:(NSString *)mail verifyCode:(NSString *)verifyCode;

@end
