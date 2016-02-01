//
//  TodoTableViewCell.m
//  CalendarTodoList
//
//  Created by 牛严 on 16/1/19.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import "TodoTableViewCell.h"
#import "NSObject+NYExtends.h"

@implementation TodoTableViewCell
{
    UILabel *_textLabel;
}

#pragma mark Set方法
- (void)setTodoList:(TodoList *)todoList
{
    _todoList = todoList;
    _textLabel.text = todoList.briefStr;
}

#pragma mark 初始化
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier                                                                             
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        [self initView];
    }
    return self;
}

- (void)initView
{
    _textLabel = [[UILabel alloc]init];
    _textLabel.textColor = [UIColor whiteColor];
    [self.contentView addSubview:_textLabel];
    [_textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(15);
        make.width.mas_equalTo(@300);
    }];
}

@end
