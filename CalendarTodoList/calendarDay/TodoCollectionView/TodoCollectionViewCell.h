//
//  TodoCollectionViewCell.h
//  CalendarTodoList
//
//  Created by 牛严 on 16/1/8.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TodoList;

@protocol TodoCollectionCellDelegate <NSObject>

- (void)didSelectedTodoTableCellWithTodoList:(TodoList *)todoList;

@end

@interface TodoCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) NSDate *date;
@property (nonatomic, copy) NSString *index;
@property (nonatomic, assign) NSInteger dayId;
@property (nonatomic, weak) id<TodoCollectionCellDelegate> delegate;

- (void)refreshTableViewBeforQueryData;

@end
