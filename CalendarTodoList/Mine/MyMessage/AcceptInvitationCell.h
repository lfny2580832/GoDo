//
//  AcceptInvitationCell.h
//  GoDo
//
//  Created by 牛严 on 16/4/28.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UserMessageModel;

@protocol AcceptInvitationCellDelegate <NSObject>

- (void)joinProjectWithId:(NSString *)projectId messageId:(NSString *)messageId;

- (void)jumpToProjectInfoVCWithId:(NSString *)projectId;

@end

@interface AcceptInvitationCell : UITableViewCell

@property (nonatomic, strong) UserMessageModel *message;

@property (nonatomic, weak) id<AcceptInvitationCellDelegate> delegate;

@end
