//
//  ZoomImage.m
//  CalendarTodoList
//
//  Created by 牛严 on 16/2/24.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import "ZoomImageView.h"

@implementation ZoomImageView
{
    CGRect _oldFrame;
    
    UIImageView *_smallImageView;
    UIImageView *_bigImageView;
    
    UIView *_returnView;
}
#pragma mark 放大缩小图片

- (instancetype)initWithImageView:(UIImageView *)smallImageView
{
    self = [super initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    if (self) {
        _smallImageView = smallImageView;
        self.backgroundColor = [UIColor blackColor];
        self.alpha = 0;
        self.delegate = self;
        self.bouncesZoom = YES;
        self.bounces = YES;
        self.scrollEnabled = YES;
        self.minimumZoomScale = 1.0f;
        self.maximumZoomScale = 2.0f;
        self.zoomScale = self.minimumZoomScale;
        self.contentSize = self.frame.size;
    }
    return self;
}

-(void)showBigImageView
{
    UIImage *image = _smallImageView.image;
  
    //转换坐标系
    _oldFrame = [_smallImageView convertRect:_smallImageView.bounds toView:KeyWindow];
    _bigImageView = [[UIImageView alloc]initWithFrame:_oldFrame];
    _bigImageView.image = image;
    _bigImageView.tag = 1;
    _returnView = [[UIView alloc]initWithFrame:self.frame];
    [_returnView addSubview:_bigImageView];
    
    [self addSubview:_returnView];
    [KeyWindow addSubview:self];
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideImage:)];
    [self addGestureRecognizer: tap];
    
    [UIView animateWithDuration:0.3 animations:^{
        _bigImageView.frame = CGRectMake(0,(SCREEN_HEIGHT - image.size.height * SCREEN_WIDTH/image.size.width)/2, SCREEN_WIDTH, image.size.height * SCREEN_WIDTH/image.size.width);
        self.alpha = 1;
    } completion:nil];
}

#pragma mark 返回要缩放的View
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _returnView;
}

#pragma mark 缩小
-(void)hideImage:(UITapGestureRecognizer*)tap
{
    UIImageView *imageView = (UIImageView*)[tap.view viewWithTag:1];
    [UIView animateWithDuration:0.3 animations:^{
        imageView.frame = _oldFrame;
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
