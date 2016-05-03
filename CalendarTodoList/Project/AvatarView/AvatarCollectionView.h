//
//  AvatarCollectionView.h
//  GoDo
//
//  Created by 牛严 on 16/5/1.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ProjectModel;

@protocol AvatarCollectionViewDelegate <NSObject>

- (void)didSelectAvatarViewWith:(ProjectModel *)project;

- (void)didSelectAvatarViewToAddMember;

@end

@interface AvatarCollectionView : UICollectionView

@property (nonatomic, strong) ProjectModel *project;

@property (nonatomic, weak) id<AvatarCollectionViewDelegate> mdelegate;

@end

@interface NYAvatarCollectionViewFlowLayout : UICollectionViewFlowLayout


@end