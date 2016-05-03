//
//  ProjectAvatarCell.h
//  GoDo
//
//  Created by 牛严 on 16/5/1.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ProjectMemberModel;

@interface AvatarCollectionViewCell : UICollectionViewCell

- (void)loadAddMemberImage;

- (void)loadMemberImagesWithMember:(ProjectMemberModel *)member;

@end
