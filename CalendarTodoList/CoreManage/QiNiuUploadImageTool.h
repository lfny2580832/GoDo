//
//  QiNiuUploadImageTool.h
//  GoDo
//
//  Created by 牛严 on 16/4/17.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^completedBlock)(NSArray *keys);

@interface QiNiuUploadImageTool : NSObject

- (void)uploadImages:(NSArray *)images todoId:(NSString *)todoId completed:(completedBlock)completed;

@end
