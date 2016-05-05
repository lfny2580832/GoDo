//
//  CreateMissionVC.m
//  GoDo
//
//  Created by 牛严 on 16/4/15.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import "CreateMissionVC.h"
#import "TZImagePickerController.h"
#import "TodoContentView.h"
#import "DatePickerCell.h"
#import "DeleteTodoCell.h"
#import "ChooseMemberCell.h"
#import "ChooseMemberVC.h"

#import "CreateMissionAPI.h"
#import "CreateMissionModel.h"
#import "MissionModel.h"
#import "UpdateMissionImageAPI.h"
#import "DeleteMissionAPI.h"
#import "ProjectModel.h"
#import "ProjectMemberModel.h"

#import "QiNiuUploadImageTool.h"

#import "NSString+ZZExtends.h"
#import "NSObject+NYExtends.h"

@interface CreateMissionVC ()<TZImagePickerControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,DatePickerCellDelegate,TodoContentViewDelegate,UITableViewDataSource,UITableViewDelegate,ChooseMemberVCDelegate>

@end

@implementation CreateMissionVC
{
    TodoContentView *_missionContentView;
    UITableView *_tableView;
    
    NSDate *_initialDate;                  //选择当天的日期
    
    NSMutableDictionary *_selectedIndexes; //所有cell高度的数组
    NSIndexPath *_selectedIndexPath; //当前选择的可变高度cell的index
    
    UIDatePickerMode _datePickerMode; //全天 or 时段
    
    TZImagePickerController *_imagePickerVC;
    DatePickerCell *_deadlineCell;
    
    NSString *_projectId;
    NSString *_missionContentStr;
    NSString *_missionId;
    NSDate *_deadlineDate;
    NSArray *_members;
    
    NSArray *_receiverIds;
    NSMutableArray *_chosenImages;
}

static CGFloat cellHeight = 50.f;
static CGFloat datePickerCellHeight = 240.f;

#pragma mark 指定任务执行者
- (void)getSelectedMembersWith:(NSArray *)selectedMemberIds
{
    _receiverIds = selectedMemberIds;
}

#pragma mark 添加图片
- (void)pickImageWithCurrentImages:(NSArray *)images
{
    [self.view endEditing:YES];
    UIAlertController *imageSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [imageSheet addAction:[UIAlertAction actionWithTitle:@"取消"
                                                   style:UIAlertActionStyleCancel
                                                 handler:nil]];
    [imageSheet addAction:[UIAlertAction actionWithTitle:@"拍照"
                                                   style:UIAlertActionStyleDefault
                                                 handler:^(UIAlertAction *action) {
                                                     [self takePhoto];
                                                 }]];
    [imageSheet addAction:[UIAlertAction actionWithTitle:@"从相册中选取"
                                                   style:UIAlertActionStyleDefault
                                                 handler:^(UIAlertAction *action) {
                                                     [self chosenImageFromAlbumWithImages:images];
                                                 }]];
    [self presentViewController:imageSheet animated:YES completion:nil];
    
}

#pragma mark 从相册选择照片
- (void)chosenImageFromAlbumWithImages:(NSArray *)images
{
    _chosenImages = [NSMutableArray arrayWithArray:images];
    _imagePickerVC = [[TZImagePickerController alloc] initWithMaxImagesCount:4 - images.count delegate:self];
    _imagePickerVC.navigationBar.barTintColor = KNaviColor;
    _imagePickerVC.allowPickingVideo = NO;
    _imagePickerVC.allowPickingOriginalPhoto = YES;
    
    [self presentViewController:_imagePickerVC animated:YES completion:nil];
}

//选择照片回调
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets
{
    for (int i = 0 ; i < photos.count; i ++)
    {
        UIImage *image = [NSObject imageCompressForWidth:photos[i] targetWidth:SCREEN_WIDTH * 1.5];
        NSData * imageData = UIImageJPEGRepresentation(image,0.5);
        NSInteger length = [imageData length]/1024;
        NSLog(@"图片大小 %ldkb",(long)length);
        [_chosenImages addObject:image];
    }
    [_missionContentView updateContentViewWithImageArray:_chosenImages];
}

#pragma mark 拍照
- (void)takePhoto
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    picker.allowsEditing = NO;
    picker.delegate = self;
    [self presentViewController:picker animated:YES completion:nil];
}

//拍照回调
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage* original = [info objectForKey:UIImagePickerControllerOriginalImage];
    UIImage *image = [NSObject imageCompressForWidth:original targetWidth:SCREEN_WIDTH * 1.5];

    [_chosenImages addObject:image];
    [_missionContentView updateContentViewWithImageArray:_chosenImages];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark 删除任务
- (void)deleteTodo
{
    UIAlertController *deleteSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [deleteSheet addAction:[UIAlertAction actionWithTitle:@"取消"
                                                    style:UIAlertActionStyleCancel
                                                  handler:nil]];
    [deleteSheet addAction:[UIAlertAction actionWithTitle:@"删除任务"
                                                    style:UIAlertActionStyleDefault
                                                  handler:^(UIAlertAction *action) {

                                                  
                                                      [self requestToDeleteMission];
                                                      //删除mission操作
                                                      
                                                  }]];
    [self presentViewController:deleteSheet animated:YES completion:nil];
}

- (void)requestToDeleteMission
{
    NYProgressHUD *hud = [NYProgressHUD new];
    [hud showAnimationWithText:@"删除任务中"];
    DeleteMissionAPI *api = [[DeleteMissionAPI alloc]initWithMissionId:_missionId];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        [hud hide];
        BaseModel *model = [BaseModel yy_modelWithJSON:request.responseString];
        if (model.code == 0) {
            [NYProgressHUD showToastText:@"删除成功" completion:^{
                [self.navigationController popViewControllerAnimated:YES];
            }];
        }else{
            [NYProgressHUD showToastText:model.msg];
        }

    } failure:^(__kindof YTKBaseRequest *request) {
        [hud hide];
        
    }];
}

#pragma mark Set Methods
- (void)setMission:(MissionModel *)mission
{
    //创建新项目
    if(!mission)
    {
        _missionContentView.todoContentField.text = @"";
        _deadlineDate = [NSDate dateWithTimeInterval:60*10 sinceDate:[NSDate date]];
        [_deadlineCell setDatePickerMode:_datePickerMode date:_deadlineDate];
        return;
    }
    
//    //修改项目
    _mission = mission;
    _missionId = mission.id;
    _missionContentStr = mission.name;
    _missionContentView.todoContentField.text = _missionContentStr;
    _deadlineDate = [NSDate dateWithTimeIntervalSince1970:mission.createTime];
    [_deadlineCell setDatePickerMode:_datePickerMode date:_deadlineDate];
//    _chosenImages = [NSMutableArray arrayWithArray:mission.pictures];
    if (_chosenImages.count) {
        [_missionContentView updateContentViewWithImageArray:_chosenImages];
    }
}

#pragma mark 返回日期
- (void)returnStartDate:(NSDate *)deadLineDate
{
    if (deadLineDate)  _deadlineDate = deadLineDate;
}

#pragma mark 获取TodoContent
- (void)getTodoContentWith:(NSString *)todoContentStr
{
    _missionContentStr = todoContentStr;
    
}

#pragma mark 点击保存
- (void)rightbarButtonItemOnclick:(id)sender
{
    if (_missionContentStr.length <= 0) {
        [NYProgressHUD showToastText:@"请输入任务内容"];
        return;
    }
    _chosenImages = _missionContentView.modifyImages;
    [self createMission];
}

#pragma mark 发布任务
- (void)createMission
{
    [self.view endEditing:YES];
    NYProgressHUD *hud = [[NYProgressHUD alloc]init];
    [hud showAnimationWithText:@"发布任务中"];
    CreateMissionAPI *api = [[CreateMissionAPI alloc]initWithMissionName:_missionContentStr deadline:_deadlineDate projectId:_projectId receiversId:_receiverIds];
    [api startWithSuccessBlock:^(id responseObject) {
        CreateMissionModel *model = [CreateMissionModel yy_modelWithDictionary:responseObject];
        _missionId = model.id;
        if(_chosenImages.count)
        {
            QiNiuUploadImageTool *tool = [[QiNiuUploadImageTool alloc]init];
            [tool uploadImages:_chosenImages todoId:_missionId completed:^(NSArray *keys) {
                
                [self requestToUpdateMissionImage:keys hud:hud];
                
            }];
        }else{
            [hud hide];
            [NYProgressHUD showToastText:@"发布任务成功" completion:^{
                [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshMission" object:nil];
                [self.navigationController popViewControllerAnimated:YES];
            }];
        }

        
    } failure:^{
        [hud hide];
        [NYProgressHUD showToastText:@"发布任务失败"];

    }];
//    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
//
//        CreateMissionModel *model = [CreateMissionModel yy_modelWithJSON:request.responseString];
//        _missionId = model.id;
//        if(_chosenImages.count)
//        {
//            QiNiuUploadImageTool *tool = [[QiNiuUploadImageTool alloc]init];
//            [tool uploadImages:_chosenImages todoId:_missionId completed:^(NSArray *keys) {
//                
//                [self requestToUpdateMissionImage:keys hud:hud];
//                
//            }];
//        }else{
//            [hud hide];
//            [NYProgressHUD showToastText:@"发布任务成功" completion:^{
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshMission" object:nil];
//                [self.navigationController popViewControllerAnimated:YES];
//            }];
//        }
//        
//    } failure:^(__kindof YTKBaseRequest *request) {
//        [hud hide];
//        [NYProgressHUD showToastText:@"发布任务失败"];
//    }];
}

- (void)requestToUpdateMissionImage:(NSArray *)images hud:(NYProgressHUD *)hud
{
    UpdateMissionImageAPI *api = [[UpdateMissionImageAPI alloc]initWithMissionId:_missionId pictures:images];
    [api startWithSuccessBlock:^{
        [hud hide];
        [NYProgressHUD showToastText:@"发布任务成功" completion:^{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshMission" object:nil];
            [self.navigationController popViewControllerAnimated:YES];
        }];
        
    } failure:^{
        [hud hide];
        [NYProgressHUD showToastText:@"上传图片失败"];
    }];
}

#pragma mark TableView DataSource Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _missionId.length > 0? 2:1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return section == 0 ? 2:1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 1)
    {
        _deadlineCell.delegate = self;
        [_deadlineCell setDatePickerMode:_datePickerMode date:_deadlineDate];
        _deadlineCell.titleLabel.text = @"截止时间";
        return _deadlineCell;
    }
    else if(indexPath.section == 0 && indexPath.row == 0)
    {
        ChooseMemberCell*cell = [[ChooseMemberCell alloc]init];
        return cell;
    }
    else
    {
        DeleteTodoCell *cell = [[DeleteTodoCell alloc]init];
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([self cellIsSelected:indexPath]) return datePickerCellHeight;
    
    return cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];

    if (indexPath.section == 0 && indexPath.row == 1)
    {
        //处理datepickercell高度逻辑
        if (_selectedIndexPath == indexPath) {
            _selectedIndexPath = nil;
            _selectedIndexes = [[NSMutableDictionary alloc] init];
            
        }else{
            _selectedIndexPath = indexPath;
            _selectedIndexes = [[NSMutableDictionary alloc] init];
            BOOL isSelected = ![self cellIsSelected:indexPath];
            NSNumber *selectedIndex = [NSNumber numberWithBool:isSelected];
            [_selectedIndexes setObject:selectedIndex forKey:indexPath];
        }
        //处理cell重新赋值逻辑
        [tableView beginUpdates];
        [tableView endUpdates];
    }
    else if(indexPath.section == 0 && indexPath.row == 0)
    {
        ChooseMemberVC *vc = [[ChooseMemberVC alloc]initWithMembers:_members];
        vc.delegate = self;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (indexPath.section == 1 && indexPath.row == 0)
    {
        [self deleteTodo];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:TRUE];
}

- (BOOL)cellIsSelected:(NSIndexPath *)indexPath
{
    NSNumber *selectedIndex = [_selectedIndexes objectForKey:indexPath];
    return selectedIndex == nil ? FALSE : [selectedIndex boolValue];
}

- (NSArray *)setReciversIdWithMembers:(NSArray *)members
{
    NSMutableArray *receiverIds = [[NSMutableArray alloc]init];
    for(ProjectMemberModel *model in members)
    {
        NSString *memberId = model.id;
        [receiverIds addObject:memberId];
    }
    return receiverIds;
}

#pragma mark 初始化
- (instancetype)initWithProject:(ProjectModel *)project
{
    self = [super init];
    if (self) {
        _members = project.members;
        _receiverIds = [self setReciversIdWithMembers:_members];
        _projectId = project.id;
        _datePickerMode = UIDatePickerModeDateAndTime;
        _chosenImages = [[NSMutableArray alloc]initWithCapacity:0];
        _deadlineCell = [[DatePickerCell alloc]init];
        [self setLeftBackButtonImage:[UIImage imageNamed:@"ico_nav_back_white.png"]];
        [self setRightBackButtontile:@"保存"];
        [self setCustomTitle:@"任务详情"];
        [self initViews];
        
    }
    return self;
}

- (void)initViews
{
    self.view.backgroundColor = RGBA(247, 247, 247, 1.0);
    
    UIView *headView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 145)];
    
    _missionContentView = [[TodoContentView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 145)];
    _missionContentView.delegate = self;
    [headView addSubview:_missionContentView];
    
    _tableView = [[UITableView alloc]init];
    _tableView.tableHeaderView = headView;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.equalTo(self.view);
    }];
}

@end
