//
//  MemberCell.h
//  GoDo
//
//  Created by 牛严 on 16/5/1.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ProjectMemberModel;

@interface MemberCell : UITableViewCell

@property (nonatomic, strong ) ProjectMemberModel *member;
@end
