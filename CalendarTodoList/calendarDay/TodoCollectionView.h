//
//  TodoCollectionView.h
//  CalendarTodoList
//
//  Created by 牛严 on 16/1/8.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TodoCollectionView : UICollectionView<UICollectionViewDataSource,UICollectionViewDelegate>

- (void)setSelectedDayTodoCellWithChosenDate:(NSDate *)chosenDate;

@end
