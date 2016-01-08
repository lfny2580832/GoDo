//
//  UILableZoomable.m
//  CalendarTodoList
//
//  Created by 牛严 on 15/12/31.
//  Copyright © 2015年 牛严. All rights reserved.
//

#import "UILabelZoomable.h"

@implementation UILabelZoomable

//缩放时配合detail属性，不会模糊
+ (Class)layerClass
{
    return [CATiledLayer class];
}

@end
