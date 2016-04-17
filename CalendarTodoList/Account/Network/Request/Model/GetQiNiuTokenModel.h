//
//  GetQiNiuTokenModel.h
//  GoDo
//
//  Created by 牛严 on 16/4/17.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import "BaseModel.h"

@interface GetQiNiuTokenModel : BaseModel

@property (nonatomic, copy) NSString *uploadToken;

@property (nonatomic, assign) NSInteger expire;

@end
