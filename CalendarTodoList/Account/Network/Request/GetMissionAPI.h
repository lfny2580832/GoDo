//
//  GetMissionAPI.h
//  GoDo
//
//  Created by 牛严 on 16/4/14.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>

@interface GetMissionAPI : YTKRequest

- (id)initWithMissionId:(NSString *)missionId;

@end
