//
//  MissionCell.h
//  GoDo
//
//  Created by 牛严 on 16/4/13.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MissionModel;

@interface MissionCell : UITableViewCell

- (void)loadDataWithMission:(MissionModel *)mission;

@end
