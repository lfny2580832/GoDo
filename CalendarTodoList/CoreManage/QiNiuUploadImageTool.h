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


///上传todo、mission多张图片
- (void)uploadImages:(NSArray *)images todoId:(NSString *)todoId completed:(completedBlock)completed;


///上传头像图片
- (void)uploadHeadImage:(UIImage *)image completed:(completedBlock)completed;


@end
