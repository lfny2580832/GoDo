//
//  DeleteTodoCell.m
//  CalendarTodoList
//
//  Created by 牛严 on 16/2/15.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import "DeleteTodoCell.h"

@implementation DeleteTodoCell

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initView];
    }
    return self;
}

- (void)initView
{
    UILabel *deleteLabel = [[UILabel alloc]init];
    deleteLabel.textColor = [UIColor redColor];
    deleteLabel.text = @"删除任务";
    deleteLabel.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:deleteLabel];
    [deleteLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.contentView);
    }];
}

@end
