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
- (void)uploadImages:(NSArray *)images todoId:(NSString *)todoId completed:(completedBlock)completed
{
    GetQiNiuTokenAPI *api = [[GetQiNiuTokenAPI alloc]init];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        GetQiNiuTokenModel *model = [GetQiNiuTokenModel yy_modelWithJSON:request.responseString];
        [UserDefaultManager setQiNiuToken:model.uploadToken];
        QNUploadManager *uploadManager = [QNUploadManager sharedInstanceWithConfiguration:nil];
        NSMutableArray *keys = [[NSMutableArray alloc]initWithCapacity:images.count];
        [self uploadImages:images atIndex:0 uploadManager:uploadManager keys:keys todoId:todoId completed:completed];
    } failure:nil];
}

-(void)uploadImages:(NSArray *)images atIndex:(NSInteger)index uploadManager:(QNUploadManager *)uploadManager keys:(NSMutableArray *)keys todoId:(NSString *)todoId completed:(completedBlock)completed
{
    UIImage *image = images[index];
    __block NSInteger imageIndex = index;
    NSData *data = UIImageJPEGRepresentation(image, 0.5);
    NSInteger length = [data length]/1024;
//    NSString *filename = [NSString stringWithFormat:@"%@_%ld.%@",todoId,index,@"jpg"];
    [uploadManager putData:data key:nil token:[UserDefaultManager qiNiuToken]
                  complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp)
    {
        if (info.isOK)
        {
            [keys addObject:resp[@"hash"]];
            NSLog(@"第 %ld 张上传完成，大小%ld",index + 1,(long)length);
            imageIndex++;
            if (imageIndex >= images.count)
            {
                NSLog(@"图片全部上传完成");
                completed(keys);
                return ;
            }
            [self uploadImages:images atIndex:imageIndex uploadManager:uploadManager keys:keys todoId:todoId completed:completed];
        }
        else
        {
            NSLog(@"error:%@",info.error);
        }
    } option:nil];
}

#pragma mark 上传单张图片

- (void)uploadHeadImage:(UIImage *)image completed:(completedBlock)completed
{
    GetQiNiuTokenAPI *api = [[GetQiNiuTokenAPI alloc]init];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        GetQiNiuTokenModel *model = [GetQiNiuTokenModel yy_modelWithJSON:request.responseString];
        [UserDefaultManager setQiNiuToken:model.uploadToken];
        QNUploadManager *uploadManager = [QNUploadManager sharedInstanceWithConfiguration:nil];
        [self uploadImage:image uploadManager:uploadManager id:[UserDefaultManager id] completed:completed];
    } failure:nil];
}

-(void)uploadImage:(UIImage *)image uploadManager:(QNUploadManager *)uploadManager id:(NSString *)nameId completed:(completedBlock)completed
{
    NSData *data = UIImageJPEGRepresentation(image, 0.5);
//    NSInteger length = [data length]/1024;
//    NSLog(@"图片大小 %ldkb",(long)length);
//    NSString *filename = [NSString stringWithFormat:@"%@.%@",nameId,@"jpg"];
    [uploadManager putData:data key:nil token:[UserDefaultManager qiNiuToken]
                  complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp)
     {
         if (info.isOK)
         {
             NSString *hash = resp[@"hash"];
             completed(@[hash]);
         }
         else
         {
             NSLog(@"error:%@",info.error);
         }
     } option:nil];
}


@end
