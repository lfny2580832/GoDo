//
//  UpdateTodoAPI.m
//  GoDo
//
//  Created by 牛严 on 16/4/7.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import "UpdateTodoAPI.h"
#import "TodoModel.h"

@implementation UpdateTodoAPI
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
    NSString *url = [NSString stringWithFormat:@"/todos/%@",_todo.id];
    return url;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPut;
}


- (NSDictionary *)requestHeaderFieldValueDictionary
{
    return @{
             @"Authorization": [UserDefaultManager token],
             };
}

- (id)requestArgument {
    return @{
             @"startTime": @(_todo.startTime),
             @"repeat": @(_todo.repeat),
             @"repeatMode":@(_todo.repeatMode),
             @"allDay":@(_todo.allDay),
             @"desc":_todo.desc,
             @"missionId":_todo.missionId

             };
}

@end
