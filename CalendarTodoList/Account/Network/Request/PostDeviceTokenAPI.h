//
//  PostDeviceToken.h
//  GoDo
//
//  Created by 牛严 on 16/4/15.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>

@interface PostDeviceTokenAPI : YTKRequest

- (id)initWithDeviceToken:(NSString *)deviceToken;

@end
