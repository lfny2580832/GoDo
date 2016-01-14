//
//  TodoCollectionView.h
//  CalendarTodoList
//
//  Created by 牛严 on 16/1/8.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TodoCollectionViewDelegate <NSObject>

- (void)selectedTodoCellWithIndexRow:(NSInteger)indexRow;

- (void)cellSelectedByChosenDateWithIndexRow:(NSInteger)indexRow;

@end

@interface TodoCollectionView : UICollectionView<UICollectionViewDataSource,UICollectionViewDelegate,UIScrollViewDelegate>

@property (nonatomic, weak) id<TodoCollectionViewDelegate> mdelegate;

- (void)getIndexPageTodoCellWithChosenDate:(NSDate *)chosenDate;

- (void)setSelectedDayTodoCellWithIndexRow:(NSInteger)indexRow;

@end
