//
//  WeekCollectionView.h
//  CalendarTodoList
//
//  Created by 牛严 on 16/1/11.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol WeekCellDelegate <NSObject>

- (void)weekCellClickedWithIndexRow:(NSInteger)indexRow;

@end


@interface WeekCollectionView : UICollectionView<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, weak) id<WeekCellDelegate> mdelegate;

- (void)setWeekCellSelectedWithIndexItem:(NSInteger)indexItem;

- (void)setWeekPageWithIndexItem:(NSInteger)indexItem animated:(BOOL)animated;

@end
