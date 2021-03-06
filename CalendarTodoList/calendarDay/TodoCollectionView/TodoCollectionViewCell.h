//
//  TodoCollectionViewCell.h
//  CalendarTodoList
//
//  Created by 牛严 on 16/1/8.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FMTodoModel;

@protocol TodoCollectionCellDelegate <NSObject>

- (void)didSelectedTodoTableCellWithTodo:(FMTodoModel *)todo;

@end

@interface TodoCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) NSDate *date;
@property (nonatomic, assign) NSInteger dayId;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, weak) id<TodoCollectionCellDelegate> delegate;


@end
