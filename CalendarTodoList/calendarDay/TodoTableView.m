//
//  TodoTableView.m
//  CalendarTodoList
//
//  Created by 牛严 on 16/1/19.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import "TodoTableView.h"

@implementation TodoTableView


#pragma mark UITableViewDelegate DataSource
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    
//}

#pragma mark 初始化
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)initView
{
    self.delegate = self;
    self.dataSource = self;
    self.showsVerticalScrollIndicator = NO;

}

@end
