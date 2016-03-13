//
//  TodoCollectionView.h
//  CalendarTodoList
//
//  Created by 牛严 on 16/1/8.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TodoCollectionViewCell.h"

@class FMTodoModel;

@protocol TodoCollectionViewDelegate <NSObject>

- (void)selectedTodoCellWithIndexItem:(NSInteger)indexItem;

- (void)cellSelectedByChosenDateWithIndexRow:(NSInteger)indexRow;

- (void)didSelectedTodoTableViewCellWithTodo:(FMTodoModel *)todo;

- (void)returnChosenDate:(NSDate *)chosenDate;
@end

@interface TodoCollectionView : UICollectionView<UICollectionViewDataSource,UICollectionViewDelegate,UIScrollViewDelegate,TodoCollectionCellDelegate>

@property (nonatomic, weak) id<TodoCollectionViewDelegate> mdelegate;

- (void)getIndexPageTodoCellWithChosenDate:(NSDate *)chosenDate;

- (void)setSelectedDayTodoCellWithIndexRow:(NSInteger)indexRow;

@end
