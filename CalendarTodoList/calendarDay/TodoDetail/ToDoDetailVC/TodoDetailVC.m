//
//  TodoDetailVC.m
//  CalendarTodoList
//
//  Created by 牛严 on 16/1/31.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import "TodoDetailVC.h"
#import "Todo.h"
#import "RLMTodo.h"
#import "RLMThingType.h"

#import "TZImagePickerController.h"
#import "TodoContentView.h"
#import "TodoProjectView.h"
#import "ChooseProjectVC.h"
#import "DatePickerCell.h"
#import "ChooseModeCell.h"
#import "DeleteTodoCell.h"

#import "RealmManage.h"
#import "NSString+ZZExtends.h"
#import "NSObject+NYExtends.h"

@interface TodoDetailVC ()<UITableViewDataSource,UITableViewDelegate,TodoContentViewDelegate,TodoProjectViewDelegate,ChooseProjectVCDelegate,ChooseModeCellDelegate,DatePickerCellDelegate,TZImagePickerControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

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
    DatePickerCell *_endCell;
    
    NSString *_todoContentStr;
    ThingType *_todoThingType;
    NSInteger _tableId;
    NSDate *_startDate;
    NSDate *_endDate;
    NSMutableArray *_chosenImages;
}

static CGFloat cellHeight = 50.f;
static CGFloat datePickerCellHeight = 240.f;

#pragma mark 添加图片
- (void)pickImageWithCurrentImageCount:(NSInteger)count
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
                                                      [self chosenImageFromAlbumWithLeftCount:4-count];
                                                  }]];
    [self presentViewController:imageSheet animated:YES completion:nil];

}

#pragma mark 从相册选择照片
- (void)chosenImageFromAlbumWithLeftCount:(NSInteger)count
{
    _imagePickerVC = [[TZImagePickerController alloc] initWithMaxImagesCount:count delegate:self];
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
                                                    [self deleteTodoFromRealm];
                                                }]];
    [self presentViewController:deleteSheet animated:YES completion:nil];
}

- (void)deleteTodoFromRealm
{
    [RealmManager deleteTodoWithTableId:_tableId];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"ReloadTodoTableView" object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark Set Methods
- (void)setTodo:(Todo *)todo
{
    if(!todo)
    {
        ThingType *defaultType = [[RealmManager getThingTypeArray] firstObject];
        _todoThingType = defaultType;
        _todoProjectView.thingType = _todoThingType;
        _todoContentView.todoContentField.text = @"";
        
        //当天八点
        NSDate *tempDate = [NSDate dateWithTimeInterval:0 sinceDate:_initialDate];
        if ([[NSDate date] timeIntervalSinceDate:tempDate] > 0)
            _startDate = [NSDate dateWithTimeInterval:60*10 sinceDate:[NSDate date]];
        else
            _startDate = tempDate;
        
        _endDate = [NSDate dateWithTimeInterval:60*60 sinceDate:_startDate];
        return;
    }
    _todo = todo;
    _tableId = _todo.tableId;
    _todoContentStr =  _todo.thing.thingStr;
    _todoContentView.todoContentField.text = _todoContentStr;
    _todoThingType = [RealmManager getThingTypeWithThingTypeId:_todo.thing.thingType.typeId];
    _todoProjectView.thingType = _todoThingType;
    _startDate = [NSDate dateWithTimeIntervalSinceReferenceDate:_todo.startTime];
    _endDate = [NSDate dateWithTimeIntervalSinceReferenceDate:_todo.endTime];
    _chosenImages = (NSMutableArray *)_todo.thing.images;
    if (_chosenImages.count) {
        [_todoContentView updateContentViewWithImageArray:_chosenImages];
    }
}

#pragma mark 返回全天或时段
- (void)datePickerModeValueChanged:(BOOL)value
{
    if (value)  _datePickerMode = UIDatePickerModeDate;
    else _datePickerMode = UIDatePickerModeDateAndTime;
    
    [_startCell setDatePickerMode:_datePickerMode date:_startDate];
    [_endCell setDatePickerMode:_datePickerMode date:_endDate];
}

#pragma mark 返回开始日期
- (void)returnStartDate:(NSDate *)startDate endDate:(NSDate *)endDate
{
    if (startDate)  _startDate = startDate;
    else _endDate = endDate;
    
    if ([_startDate timeIntervalSinceDate:_endDate] >= 0.0)
        _endCell.dateLabel.textColor = [UIColor redColor];
    else
        _endCell.dateLabel.textColor = [UIColor blackColor];
}

#pragma mark ChooseProjectVC Delegate 获取返回的type类型
- (void)returnProjectWithThingType:(ThingType *)type
{
    _todoThingType = type;
    _todoProjectView.thingType = _todoThingType;
}

#pragma mark 获取TodoContent
- (void)getTodoContentWith:(NSString *)todoContentStr
{
    _todoContentStr = todoContentStr;
}

#pragma mark 点击保存
- (void)rightbarButtonItemOnclick:(id)sender
{
    if (_todoContentStr.length <= 0) {
        NSLog(@"请输入内容");
        return;
    }
    if ([_endDate isKindOfClass:[NSNull class]]) {
        NSLog(@"请选择正确日期");
        return;
    }
    
    [RealmManager createTodoWithThingType:_todoThingType contentStr:_todoContentStr contentImages:_chosenImages startDate:_startDate endDate:_endDate tableId:_tableId];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"ReloadTodoTableView" object:nil];
    [self.navigationController popViewControllerAnimated:YES];
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
    return section == 0 ? 3:1;
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
        _endCell = [[DatePickerCell alloc]init];
        _endCell.delegate = self;
        [_endCell setDatePickerMode:_datePickerMode date:_endDate];
        _endCell.titleLabel.text = @"结束";
        return _endCell;
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
    if (indexPath.section == 0 && (indexPath.row == 1||indexPath.row == 2))
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
    }else if (indexPath.section == 1 && indexPath.row == 0)
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
        [self setRightBackButtontile:@"保存"];
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
