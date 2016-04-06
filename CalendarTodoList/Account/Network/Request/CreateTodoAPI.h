//
//  CreateTodo.h
//  GoDo
//
//  Created by 牛严 on 16/4/7.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>

@class TodoModel;

@interface CreateTodoAPI : YTKRequest

- (id)initWithTodo:(TodoModel *)todo;

@end
