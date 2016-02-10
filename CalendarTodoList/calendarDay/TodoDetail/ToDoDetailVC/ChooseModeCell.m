//
//  ChooseModeCell.m
//  CalendarTodoList
//
//  Created by 牛严 on 16/2/10.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import "ChooseModeCell.h"

@implementation ChooseModeCell
{
    UILabel *_dateLabel;
}

- (void)swithcButtonValueChanged:(UISwitch *)switchButton
{
    BOOL isButtonOn = [switchButton isOn];
    [self.delegate datePickerModeValueChanged:isButtonOn];
}

#pragma mark 初始化
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.clipsToBounds = YES;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initView];
    }
    return self;
}

- (void)initView
{
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.text = @"全天";
    titleLabel.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(18);
        make.top.equalTo(self.contentView).offset(15);
        make.width.mas_equalTo(@60);
    }];
    
    _switchButton = [[UISwitch alloc]init];
    [_switchButton setOn:NO];
    [_switchButton addTarget:self action:@selector(swithcButtonValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.contentView addSubview:_switchButton];
    [_switchButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(titleLabel);
        make.right.equalTo(self.contentView).offset(-18);
    }];
}
@end
