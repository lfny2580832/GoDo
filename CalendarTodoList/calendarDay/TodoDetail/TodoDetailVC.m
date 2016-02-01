//
//  TodoDetailVC.m
//  CalendarTodoList
//
//  Created by 牛严 on 16/1/31.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import "TodoDetailVC.h"
#import "TodoList.h"

#import "TodoContentView.h"

@interface TodoDetailVC ()<TodoContentViewDelegate>

@end

@implementation TodoDetailVC
{
    UIScrollView *_scrollView;
    TodoContentView *_todoContentView;
    
    NSString *_todoContentStr;
}

#pragma mark Set Methods
- (void)setTodoList:(TodoList *)todoList
{
    _todoList = todoList;
    _todoContentView.todoContentField.text = _todoList.thing.thingStr;
    //
}

#pragma mark 获取TodoContent
- (void)getTodoContentWith:(NSString *)todoContentStr
{
    if ([_todoContentStr isEqualToString:@""]) {
        //不能提交
        
        return;
    }
    _todoContentStr = todoContentStr;
}

#pragma mark 初始化
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initViews];
    }
    return self;
}

- (void)initViews
{
    _scrollView = [[UIScrollView alloc]init];
    _scrollView.backgroundColor = RGBA(247, 247, 247, 1.0);
    _scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_scrollView];
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.equalTo(self.view);
    }];
    
    _todoContentView = [[TodoContentView alloc]init];
    _todoContentView.delegate = self;
    [_scrollView addSubview:_todoContentView];
    [_todoContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(_scrollView);
        make.height.mas_equalTo(@75);
        make.width.mas_equalTo(SCREEN_WIDTH);
    }];
    
    [_scrollView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(_todoContentView).offset(50);
    }];
}

@end
