//
//  SearchUserAPI.h
//  GoDo
//
//  Created by 牛严 on 16/4/10.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>
#import "BaseModel.h"

@interface SearchUserAPI : YTKRequest

- (id)initWithMail:(NSString *)mail;

@end

