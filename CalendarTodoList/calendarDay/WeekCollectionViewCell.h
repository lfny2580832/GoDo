//
//  WeekCollectionViewCell.h
//  CalendarTodoList
//
//  Created by 牛严 on 16/1/11.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface WeekCollectionViewCell : UICollectionViewCell

@property (nonatomic, copy) NSString *index;

@property (nonatomic, strong) NSDate *date;

@end

