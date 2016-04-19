//
//  deleteTodoAPI.h
//  GoDo
//
//  Created by 牛严 on 16/4/7.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>

@interface DeleteTodoAPI : YTKRequest

- (id)initWithTodoId:(NSString *)todoId;

@end
