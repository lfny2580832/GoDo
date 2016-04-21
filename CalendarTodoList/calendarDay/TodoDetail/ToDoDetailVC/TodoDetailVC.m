//
//  TodoDetailVC.m
//  CalendarTodoList
//
//  Created by 牛严 on 16/1/31.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import "TodoDetailVC.h"

#import "TZImagePickerController.h"
#import "TodoContentView.h"
#import "TodoProjectView.h"
#import "ChooseProjectVC.h"
#import "DatePickerCell.h"
#import "ChooseModeCell.h"
#import "DeleteTodoCell.h"
#import "RepeatModeCell.h"
#import "RepeateModeChooseVC.h"
#import "RemindModeCell.h"
#import "RemindModeChooseVC.h"

#import "FMTodoModel.h"
#import "DBManage.h"

#import "CreateTodoAPI.h"
#import "CreateTodoModel.h"
#import "UpdateTodoAPI.h"
#import "deleteTodoAPI.h"

#import "QiNiuUploadImageTool.h"

#import "NSString+ZZExtends.h"
#import "NSObject+NYExtends.h"

@interface TodoDetailVC ()<UITableViewDataSource,UITableViewDelegate,TodoContentViewDelegate,TodoProjectViewDelegate,ChooseProjectVCDelegate,ChooseModeCellDelegate,DatePickerCellDelegate,TZImagePickerControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,RepeatModeChooseVCDelegate,RemindModeChooseVCDelegate>

@end

@implementation TodoDetailVC
{
    TodoContentView *_todoContentView;
    TodoProjectView *_todoProjectView;
    UITableView *_tableView;
    
    NSDate *_initialDate;                  //选择当天的日期
    
    NSMutableDictionary *_selectedIndexes; //所有cell高度的数组
    NSIndexPath *_selectedIndexPath; //当前选择的可变高度cell的index
    
    UIDatePickerMode _datePickerMode; //全天 or 时段
    
    TZImagePickerController *_imagePickerVC;
    DatePickerCell *_startCell;
//    DatePickerCell *_endCell;
    RepeatModeCell *_repeatCell;
    RemindModeCell *_remindCell;
    
    NSString *_todoContentStr;
    FMProject *_project;
    NSString *_tableId;
    NSDate *_startDate;
    NSDate *_OldStartDate;
//    NSDate *_endDate;
    RepeatMode _repeatMode;
    RemindMode _remindMode;
    NSMutableArray *_chosenImages;
    BOOL _isAllDay;
    BOOL _canChange;
}

static CGFloat cellHeight = 50.f;
static CGFloat datePickerCellHeight = 240.f;

#pragma mark 选择重复模式
- (void)returnRepeatModeWith:(RepeatMode)repeatMode modeName:(NSString *)modeName
{
    _repeatMode = repeatMode;
    _repeatCell.modeLabel.text = modeName;
}

#pragma mark 选择提醒模式
- (void)returnRemindModeWith:(RemindMode)remindMode modeName:(NSString *)modeName
{
    _remindMode = remindMode;
    _remindCell.modeLabel.text = modeName;
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
    [_todoContentView updateContentViewWithImageArray:_chosenImages];
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
    NSData * imageData = UIImageJPEGRepresentation(image,0.5);
    NSInteger length = [imageData length]/1024;
    NSLog(@"图片大小 %ldkb",(long)length);
    [_chosenImages addObject:image];
    [_todoContentView updateContentViewWithImageArray:_chosenImages];
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
                                                    [self requestToDeleteTodo];
                                                }]];
    [self presentViewController:deleteSheet animated:YES completion:nil];
}

- (void)requestToDeleteTodo
{
    NYProgressHUD *hud = [NYProgressHUD new];
    [hud showAnimationWithText:@"删除任务中"];
    DeleteTodoAPI *api = [[DeleteTodoAPI alloc]initWithTodoId:_tableId];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        BaseModel *model = [BaseModel yy_modelWithJSON:request.responseString];
        if (model.code == 0) {
            [self deleteTodoFromDateBaseWithHud:hud];
        }else{
            [hud hide];
            [NYProgressHUD showToastText:model.msg];
        }
        
    } failure:^(__kindof YTKBaseRequest *request) {
        [hud hide];
        [NYProgressHUD showToastText:@"删除失败，请检查网络环境"];
    }];
}

- (void)deleteTodoFromDateBaseWithHud:(NYProgressHUD *)hud
{
    dispatch_async(kBgQueue, ^{
        [DBManager deleteTodoWithTableId:_tableId];
        dispatch_async(kMainQueue, ^{
            [hud hide];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"ReloadTodoTableView" object:nil];
            [self.navigationController popViewControllerAnimated:YES];
        });
    });

}

#pragma mark 返回全天或时段
- (void)datePickerModeValueChanged:(BOOL)value
{
    if (value)
    {
        _datePickerMode = UIDatePickerModeDate;
        _isAllDay = YES;
    }
    else
    {
        _datePickerMode = UIDatePickerModeDateAndTime;
        _isAllDay = NO;
    }
    [_startCell setDatePickerMode:_datePickerMode date:_startDate];
    //    [_endCell setDatePickerMode:_datePickerMode date:_endDate];
}

#pragma mark 返回开始日期
- (void)returnStartDate:(NSDate *)startDate
{
    if (startDate)  _startDate = startDate;
    //    else _endDate = endDate;
    
    //    if ([_startDate timeIntervalSinceDate:_endDate] >= 0.0)
    //        _endCell.dateLabel.textColor = [UIColor redColor];
    //    else
    //        _endCell.dateLabel.textColor = [UIColor blackColor];
}

#pragma mark ChooseProjectVC Delegate 获取返回的project
- (void)returnProject:(FMProject *)project
{
    _project = project;
    _todoProjectView.project = _project;
}

#pragma mark 获取TodoContent
- (void)getTodoContentWith:(NSString *)todoContentStr
{
    _todoContentStr = todoContentStr;
}

#pragma mark Set Methods
- (void)setTodo:(FMTodoModel *)todo
{
    //创建新项目
    if(!todo)
    {
        _canChange = YES;
        FMProject *defaultProject = [[DBManager getProjectArray] firstObject];
        _project = defaultProject;
        _todoProjectView.project = _project;
        _todoContentView.todoContentField.text = @"";
        _repeatMode = Never;
        _remindMode = NoRemind;
        //当天八点
        NSDate *tempDate = [NSDate dateWithTimeInterval:0 sinceDate:_initialDate];
        if ([[NSDate date] timeIntervalSinceDate:tempDate] > 0)
            _startDate = [NSDate dateWithTimeInterval:60*10 sinceDate:[NSDate date]];
        else
            _startDate = tempDate;
        _isAllDay = NO;
        return;
    }
    
    //修改项目
    _todo = todo;
    _repeatMode = todo.repeatMode;
    if (todo.repeatMode != Never) {
        _canChange = NO;
    }
    _repeatCell.modeLabel.text = [NSString getRepeatStrWithMode:todo.repeatMode];
    
    _remindMode = todo.remindMode;
    _remindCell.modeLabel.text = [NSString getRemindStrWithMode:todo.remindMode];
    
    _tableId = _todo.tableId;
    _todoContentStr = _todo.thingStr;
    _todoContentView.todoContentField.text = _todoContentStr;
    _project = [DBManager getProjectWithId:_todo.project.projectId];
    _todoProjectView.project = _project;
    _startDate = [NSDate dateWithTimeIntervalSince1970:_todo.startTime];
    _isAllDay = todo.isAllDay;
    _datePickerMode = (_isAllDay)? UIDatePickerModeDate:UIDatePickerModeDateAndTime;
    [_startCell setDatePickerMode:_datePickerMode date:_startDate];

    _OldStartDate = _startDate;
    _chosenImages = [NSMutableArray arrayWithArray:todo.images];
    if (_chosenImages.count) {
        [_todoContentView updateContentViewWithImageArray:_chosenImages];
    }
}

#pragma mark 创建ToDo网络请求
- (void)requestToCreateOrUpdateTodo
{
    TodoModel *todo = [[TodoModel alloc]init];
    todo.desc = _todoContentStr;
    todo.startTime = [_startDate timeIntervalSince1970];
    todo.repeatMode = _repeatMode;
    todo.repeat = (_repeatMode == 0)? NO:YES;
    todo.allDay = _isAllDay;
    
    NYProgressHUD *hud = [NYProgressHUD new];
    [hud showAnimationWithText:@"创建任务中"];
    CreateTodoAPI *api = [[CreateTodoAPI alloc]initWithTodo:todo];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        CreateTodoModel *model = [CreateTodoModel yy_modelWithJSON:request.responseString];
        todo.id = model.id;
        _tableId = todo.id;
        NSLog(@"int----%ld",(long)_tableId);
        if (model.code == 0) {
            NSLog(@"创建任务网络请求完成（不包含图片）");

            _chosenImages = _todoContentView.modifyImages;
            if(_chosenImages.count)
            {
                QiNiuUploadImageTool *tool = [[QiNiuUploadImageTool alloc]init];
                [tool uploadImages:_chosenImages todoId:todo.id completed:^(NSArray *keys) {
                    
                    [self requestToSaveTodoImageWith:keys todoModel:todo completion:^{
                        
                        [self saveTodoToDataBaseWithHud:hud];
                        
                    }];
                }];
            }
            else
            {
                [self saveTodoToDataBaseWithHud:hud];
            }
        }else{
            [hud hide];
            [NYProgressHUD showToastText:model.msg];
        }
    } failure:^(__kindof YTKBaseRequest *request) {
        [hud hide];
        [NYProgressHUD showToastText:@"创建任务失败，请检查网络环境"];
    }];
}

- (void)requestToSaveTodoImageWith:(NSArray *)pictures todoModel:(TodoModel *)todo completion:(void(^)())finishiBlock
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [manager.requestSerializer setValue:[UserDefaultManager token] forHTTPHeaderField:@"Authorization"];
    NSString *url = [NSString stringWithFormat:@"%@/todos/%@",baseAPIURL,todo.id];
    NSDictionary *dict = [NSDictionary new];
    
    if (todo.missionId.length > 0 ) {
        dict = @{
                @"startTime": @(todo.startTime),
                @"repeat": @(todo.repeat),
                @"repeatMode":@(todo.repeatMode),
                @"allDay":@(todo.allDay),
                @"desc":todo.desc,
                @"missionId":todo.missionId,
                @"pictures":pictures,
                };
    }else{
        dict = @{
                @"startTime": @(todo.startTime),
                @"repeat": @(todo.repeat),
                @"repeatMode":@(todo.repeatMode),
                @"allDay":@(todo.allDay),
                @"desc":todo.desc,
                @"pictures":pictures,
                };
    }
    
    [manager PUT:url parameters:dict success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        finishiBlock();

    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        [NYProgressHUD showToastText:@"上传图片失败"];
    }];
    
}

- (void)saveTodoToDataBaseWithHud:(NYProgressHUD *)hud
{
    dispatch_async(kBgQueue, ^{
        [DBManager createTodoWithProject:_project contentStr:_todoContentStr contentImages:_chosenImages startDate:_startDate oldStartDate:_OldStartDate isAllDay:_isAllDay tableId:_tableId repeatMode:_repeatMode remindMode:_remindMode];
        dispatch_async(kMainQueue, ^{
            NSLog(@"任务已保存到本地数据库");
            [hud hide];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"ReloadTodoTableView" object:nil];
            [self.navigationController popViewControllerAnimated:YES];
        });
    });
}

#pragma mark 点击保存
- (void)rightbarButtonItemOnclick:(id)sender
{
    [self.view endEditing:YES];
    if (_todoContentStr.length <= 0) {
        [NYProgressHUD showToastText:@"请输入任务内容"];
        return;
    }
    
    [self requestToCreateOrUpdateTodo];
    
}

#pragma mark 选择todo所属项目
- (void)chooseTodoProject
{
    ChooseProjectVC *vc = [[ChooseProjectVC alloc]init];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark TableView DataSource Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _tableId > 0? 2:1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return section == 0 ? 4:1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0)
    {
        ChooseModeCell *cell = [[ChooseModeCell alloc]init];
        if (_datePickerMode == UIDatePickerModeDateAndTime) {
            [cell.switchButton setOn:NO];
        }else{
            [cell.switchButton setOn:YES];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        return cell;
    }
    else if (indexPath.section == 0 && indexPath.row == 1)
    {
        _startCell = [[DatePickerCell alloc]init];
        _startCell.delegate = self;
        [_startCell setDatePickerMode:_datePickerMode date:_startDate];
        _startCell.titleLabel.text = @"开始";
        return _startCell;
    }
    else if (indexPath.section == 0 && indexPath.row == 2)
    {
        return _repeatCell;
    }
    else if (indexPath.section == 0 && indexPath.row == 3)
    {
        return _remindCell;
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
    if (_todo.doneType == Done) {
        if (indexPath.section == 1 && indexPath.row == 0) {
            
        }else
        {
            [NYProgressHUD showToastText:@"已完成任务不能进行修改"];
            return;
        }
    }
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
    else if (indexPath.section == 0 && indexPath.row == 2)
    {
        if (!_canChange) {
            [NYProgressHUD showToastText:@"重复任务不能再次选择重复模式"];
            return;
        }
        if (_remindMode != NoRemind) {
            [NYProgressHUD showToastText:@"重复任务不能选择提醒"];
            return;
        }
        RepeateModeChooseVC *vc = [[RepeateModeChooseVC alloc]init];
        vc.delegate = self;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (indexPath.section == 0 && indexPath.row == 3)
    {
        if (_repeatMode != Never) {
            [NYProgressHUD showToastText:@"重复任务不能选择提醒"];
            return;
        }
        RemindModeChooseVC *vc = [[RemindModeChooseVC alloc]init];
        vc.delegate = self;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (indexPath.section == 1 && indexPath.row == 0)
        [self deleteTodo];
    
    [tableView deselectRowAtIndexPath:indexPath animated:TRUE];
}

- (BOOL)cellIsSelected:(NSIndexPath *)indexPath
{
    NSNumber *selectedIndex = [_selectedIndexes objectForKey:indexPath];
    return selectedIndex == nil ? FALSE : [selectedIndex boolValue];
}

#pragma mark 初始化
- (instancetype)initWithDate:(NSDate *)date
{
    self = [super init];
    if (self) {

        _initialDate = date;
        _datePickerMode = UIDatePickerModeDateAndTime;
        _chosenImages = [[NSMutableArray alloc]initWithCapacity:0];
        _canChange = YES;
        _remindCell = [[RemindModeCell alloc]init];
        _repeatCell = [[RepeatModeCell alloc]init];

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

    UIView *headView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 195)];
    
    _todoContentView = [[TodoContentView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 145)];
    _todoContentView.delegate = self;
    [headView addSubview:_todoContentView];
    
    _todoProjectView = [[TodoProjectView alloc]initWithFrame:CGRectMake(0, 145, SCREEN_WIDTH, 50)];
    _todoProjectView.delegate = self;
    [headView addSubview:_todoProjectView];
    
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
