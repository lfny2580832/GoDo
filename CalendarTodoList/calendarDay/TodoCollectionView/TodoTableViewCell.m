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
//    _textLabel.text = @"拉伸的开发及阿里山的开发及阿里山的开发了阿萨德两分开就阿里山的疯狂就阿里是对方空间";
}

#pragma mark 初始化
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier                                                                             
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.clipsToBounds = YES;
        self.backgroundColor = [UIColor clearColor];
        [self initView];
    }
    return self;
}

- (void)initView
{
    _textLabel = [[UILabel alloc]init];
    _textLabel.textColor = [UIColor whiteColor];
    _textLabel.numberOfLines = 0;
    [self.contentView addSubview:_textLabel];
    [_textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(15);
        make.bottom.equalTo(self.contentView).offset(-15);
        make.left.equalTo(self.contentView).offset(15);
        make.width.mas_equalTo(@300);
    }];
}

@end
