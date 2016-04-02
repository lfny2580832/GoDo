//
//  LogInAPI.h
//  GoDo
//
//  Created by 牛严 on 16/4/2.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>

@interface LogInAPI : YTKRequest

- (id)initWithmail:(NSString *)mail password:(NSString *)password;

@end
