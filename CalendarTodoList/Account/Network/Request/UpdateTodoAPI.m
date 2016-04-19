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
    NSArray *_pictures;
}

- (id)initWithTodo:(TodoModel *)todo pictures:(NSArray *)pictures
{
    self = [super init];
    if (self) {
        _todo = todo;
        _pictures = pictures;
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
    NSDictionary *dic;
    if (_todo.missionId.length > 0 ) {
        dic = @{
                @"startTime": @(_todo.startTime),
                @"repeat": @(_todo.repeat),
                @"repeatMode":@(_todo.repeatMode),
                @"allDay":@(_todo.allDay),
                @"desc":_todo.desc,
                @"missionId":_todo.missionId,
                @"pictures":_pictures,
                };
    }else{
        dic = @{
                @"startTime": @(_todo.startTime),
                @"repeat": @(_todo.repeat),
                @"repeatMode":@(_todo.repeatMode),
                @"allDay":@(_todo.allDay),
                @"desc":_todo.desc,
                @"pictures":_pictures,
                };
    }
    NSLog(@"fuck %@",dic);
    return dic;
}

@end
