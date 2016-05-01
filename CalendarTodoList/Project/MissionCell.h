//
//  MissionCell.h
//  GoDo
//
//  Created by 牛严 on 16/4/13.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MissionModel;
@class TodoDetailVC;

@protocol MissionCellDelegate <NSObject>

- (void)acceptMissionWithVC:(TodoDetailVC *)vc;

@end

@interface MissionCell : UITableViewCell

@property (nonatomic, strong) MissionModel *mission;

@property (nonatomic, weak) id<MissionCellDelegate> delegate;

@property (nonatomic, strong) NSMutableArray *images;

@end
