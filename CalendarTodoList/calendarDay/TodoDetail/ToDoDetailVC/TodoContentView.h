//
//  TodoContentView.h
//  CalendarTodoList
//
//  Created by 牛严 on 16/2/2.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TodoContentViewDelegate <NSObject>

- (void)getTodoContentWith:(NSString *)todoContentStr;

- (void)pickImageWithCurrentImages:(NSArray *)images;

@end

@interface TodoContentView : UIView<UITextFieldDelegate>

@property (nonatomic, strong) UITextField *todoContentField;

@property (nonatomic, strong) NSMutableArray *modifyImages;

@property (nonatomic, weak) id<TodoContentViewDelegate> delegate;

- (void)updateContentViewWithImageArray:(NSMutableArray *)images;

@end
