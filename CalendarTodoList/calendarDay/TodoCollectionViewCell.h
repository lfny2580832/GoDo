//
//  TodoCollectionViewCell.h
//  CalendarTodoList
//
//  Created by 牛严 on 16/1/8.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TodoCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) NSDate *date;
@property (nonatomic, copy) NSString *index;
@property (nonatomic, assign) NSInteger dayId;

- (void)refreshTableViewBeforQueryData;

@end
