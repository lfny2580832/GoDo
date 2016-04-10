//
//  BaseModel.h
//  GoDo
//
//  Created by 牛严 on 16/4/10.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface BaseModel : JSONModel

@property (nonatomic, assign) NSInteger code;

@property (nonatomic, copy) NSString<Optional> *msg;

@end
