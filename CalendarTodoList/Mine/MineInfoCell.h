//
//  InfoCell.h
//  GoDo
//
//  Created by 牛严 on 16/4/25.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MineInfoCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLabel;

- (void)loadHeadImageWithUrl:(NSString *)imageUrl;

@end
