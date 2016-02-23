//
//  ZoomImage.h
//  CalendarTodoList
//
//  Created by 牛严 on 16/2/24.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZoomImageView : UIScrollView<UIScrollViewDelegate>

#pragma mark 放大缩小图片
- (instancetype)initWithImageView:(UIImageView *)smallImageView;

-(void)showBigImageView;

@end
