//
//  QiNiuUploadImageTool.m
//  GoDo
//
//  Created by 牛严 on 16/4/17.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import "QiNiuUploadImageTool.h"
#import <QiniuSDK.h>
#import "GetQiNiuTokenAPI.h"

@implementation QiNiuUploadImageTool

#pragma mark 根据任务id对图片进行命名
- (void)uploadImages:(NSArray *)images todoId:(NSString *)todoId
{
    GetQiNiuTokenAPI *api = [[GetQiNiuTokenAPI alloc]init];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        GetQiNiuTokenModel *model = [GetQiNiuTokenModel yy_modelWithJSON:request.responseString];
        [UserDefaultManager setQiNiuToken:model.uploadToken];
        QNUploadManager *uploadManager = [QNUploadManager sharedInstanceWithConfiguration:nil];
        NSMutableArray *keys = [[NSMutableArray alloc]initWithCapacity:images.count];
        [self uploadImages:images atIndex:0 uploadManager:uploadManager keys:keys todoId:todoId];
    } failure:nil];
}

-(void)uploadImages:(NSArray *)images atIndex:(NSInteger)index uploadManager:(QNUploadManager *)uploadManager keys:(NSMutableArray *)keys todoId:(NSString *)todoId
{
    UIImage *image = images[index];
    __block NSInteger imageIndex = index;
    NSData *data = UIImageJPEGRepresentation(image, 1);
    NSString *filename = [NSString stringWithFormat:@"%@_%ld.%@",todoId,index,@"jpg"];
    [uploadManager putData:data key:filename token:[UserDefaultManager qiNiuToken]
                  complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp)
    {
        if (info.isOK)
        {
            [keys addObject:key];
            NSLog(@"第 %ld 张上传完成",index + 1);
            imageIndex++;
            if (imageIndex >= images.count)
            {
                NSLog(@"图片全部上传完成");
                for (NSString *imgKey in keys)
                {
                    NSLog(@"%@",imgKey);
                }
                return ;
            }
            [self uploadImages:images atIndex:imageIndex uploadManager:uploadManager keys:keys todoId:todoId];
        }
        else
        {
            NSLog(@"error:%@",info.error);
        }
    } option:nil];
}

@end
