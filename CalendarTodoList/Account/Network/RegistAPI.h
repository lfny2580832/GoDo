//
//  RegistAPI.h
//  GoDo
//
//  Created by 牛严 on 16/3/30.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>

@interface RegistAPI : YTKRequest

- (id)initWithName:(NSString *)name password:(NSString *)password phone:(NSString *)phone email:(NSString *)email type:(NSString *)type verifyCode:(NSString *)verifyCode;

@end
