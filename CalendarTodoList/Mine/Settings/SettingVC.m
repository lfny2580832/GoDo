//
//  SettingVC.m
//  GoDo
//
//  Created by 牛严 on 16/5/5.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import "SettingVC.h"

#import <PgySDK/PgyManager.h>
#import <PgyUpdate/PgyUpdateManager.h>
#import "AppDelegate.h"

@interface SettingVC ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation SettingVC
{
    UITableView *_tableView;
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (section == 0)?  2:1;
}

-(NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        if ([[PgyManager sharedPgyManager] isFeedbackEnabled]) {
            NSString *activeType = [[PgyManager sharedPgyManager] feedbackActiveType] == kPGYFeedbackActiveTypeShake ? @"摇一摇" : @"三指上下拖动";
            return [NSString stringWithFormat:@"请%@以激活用户反馈界面", activeType];
        } else {
            return @"";
        }
    }
    return @"";
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
    headView.backgroundColor = [UIColor whiteColor];
    return headView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0: {
                cell.textLabel.text = @"检查更新";
                break;
            }
            case 1: {
                NSString *feedbackText = [[PgyManager sharedPgyManager] isFeedbackEnabled] ? @"关闭手势用户反馈" : @"开启手势用户反馈";
                cell.textLabel.text = feedbackText;
                break;
            }
            default:
                break;
        }
    }else if (indexPath.section == 1){
        cell.textLabel.text = @"退出登录";
        cell.textLabel.textColor = [UIColor redColor];
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
     if (indexPath.section == 0) {
         switch (indexPath.row) {
                 
             case 0:
                 [self checkUpdate];
                 break;
             case 1: {
                 [self setFeedback];
             } break;
                 
             default:
                 break;
         }
     }else if (indexPath.section == 1){
         [UserDefaultManager setToken:nil];
         [UserDefaultManager setId:nil];
         [UserDefaultManager setUserName:nil];
         [UserDefaultManager setNickName:nil];
         [UserDefaultManager setStuNumber:nil];
         [UserDefaultManager setHeadImage:nil];
         [NYProgressHUD showToastText:@"退出登录成功" completion:^{
             [self.tabBarController setSelectedIndex:0];

             [self.navigationController popToRootViewControllerAnimated:YES];

         }];
         
     }
}

- (void)checkUpdate
{
    [[PgyUpdateManager sharedPgyManager] checkUpdate];
}

/**
 *  检查更新回调
 *
 *  @param response 检查更新的返回结果
 */
- (void)updateMethod:(NSDictionary *)response
{
    if (response[@"downloadURL"]) {
        
        NSString *message = response[@"releaseNote"];
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"发现新版本"
                                                                         message:message
                                                                  preferredStyle:UIAlertControllerStyleAlert];
        [alertVC addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
        
        [self presentViewController:alertVC animated:YES completion:nil];

    }
}

/**
 *  关闭或者打开用户反馈
 */
- (void)setFeedback
{
    [[PgyManager sharedPgyManager] setEnableFeedback:![[PgyManager sharedPgyManager] isFeedbackEnabled]];
    
    NSString *message = [[PgyManager sharedPgyManager] isFeedbackEnabled] ? @"手势用户反馈已开启" : @"手势用户反馈已关闭";
    

    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil
                                                                     message:message
                                                              preferredStyle:UIAlertControllerStyleAlert];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
    
    [self presentViewController:alertVC animated:YES completion:nil];
    
    
    [_tableView reloadData];
}

#pragma mark 初始化

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.view.backgroundColor = [UIColor whiteColor];
        [self setLeftBackButtonImage:[UIImage imageNamed:@"ico_nav_back_white.png"]];
        [self setCustomTitle:@"设置"];
        [self initView];
    }
    return self;
}

- (void)initView
{
    _tableView = [[UITableView alloc]init];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.tableFooterView = [UIView new];
    _tableView.scrollEnabled = NO;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.equalTo(self.view);
    }];

}

@end
