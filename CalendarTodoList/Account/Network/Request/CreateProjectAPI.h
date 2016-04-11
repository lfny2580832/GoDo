//
//  CreateProjectAPI.h
//  GoDo
//
//  Created by 牛严 on 16/4/11.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>
#import "BaseModel.h"
@interface CreateProjectAPI : YTKRequest

- (id)initWithName:(NSString *)name private:(BOOL)pri;

@end
