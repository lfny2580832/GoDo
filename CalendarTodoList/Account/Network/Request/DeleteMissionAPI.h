//
//  DeleteMissionAPI.h
//  GoDo
//
//  Created by 牛严 on 16/4/21.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import <YTKRequest.h>

@interface DeleteMissionAPI : YTKRequest

- (id)initWithMissionId:(NSString *)missionId;

@end
