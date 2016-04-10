//
//  SearchUserModel.h
//  GoDo
//
//  Created by 牛严 on 16/4/11.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import "BaseModel.h"

@interface SearchUserModel : BaseModel

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString<Optional> *avatar; //头像url

@end
