//
//  CreateTodo.m
//  GoDo
//
//  Created by 牛严 on 16/4/7.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import "CreateTodoAPI.h"
#import "TodoModel.h"

@implementation CreateTodoAPI
{
    TodoModel *_todo;
}

- (id)initWithTodo:(TodoModel *)todo
{
    self = [super init];
    if (self) {
        _todo = todo;
    }
    return self;
}

- (NSString *)requestUrl {
    return @"/todos";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPost;
}


- (NSDictionary *)requestHeaderFieldValueDictionary
{
    return @{
             @"Authorization": [UserDefaultManager token],
             };
}

- (id)requestArgument {
    NSDictionary *dic;
    if (_todo.missionId.length > 0) {
        dic =  @{
                 @"startTime": @(_todo.startTime),
                 @"repeat": @(_todo.repeat),
                 @"repeatMode":@(_todo.repeatMode),
                 @"allDay":@(_todo.allDay),
                 @"desc":_todo.desc,
                 @"missionId":_todo.missionId
                 };
    }else
    {
        dic = @{
                @"startTime": @(_todo.startTime),
                @"repeat": @(_todo.repeat),
                @"repeatMode":@(_todo.repeatMode),
                @"allDay":@(_todo.allDay),
                @"desc":_todo.desc,
                };
    }
    NSLog(@"--%@",dic);
    return dic;
}

@end
