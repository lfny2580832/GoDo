//
//  MineInfoVC.m
//  GoDo
//
//  Created by 牛严 on 16/4/25.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import "MineInfoVC.h"
#import "MineInfoAvatarCell.h"
#import "MineInfoDetailCell.h"
#import "ModifyPersonalInfoVC.h"

#import "TZImagePickerController.h"
#import "QiNiuUploadImageTool.h"

#import "UpdatePersonalInfoAPI.h"

#import "NSObject+NYExtends.h"

@interface MineInfoVC ()<UITableViewDataSource,UITableViewDelegate,TZImagePickerControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,ModifyPersonalInfoVCDelegate>

@end

@implementation MineInfoVC
{
    UITableView *_tableView;
    TZImagePickerController *_imagePickerVC;
    
    UIImage *_chosenImage;
}

#pragma mark 修改名称
- (void)modidfyNameWith:(NSString *)name
{
    NYProgressHUD *hud = [NYProgressHUD new];
    [hud showAnimationWithText:@"修改中"];
    [self updatePersonalInfoWithName:name avatar:nil success:^{
        [hud hide];
        [UserDefaultManager setNickName:name];
        [_tableView reloadData];
    } failure:^{
        [hud hide];
        [NYProgressHUD showToastText:@"修改失败"];
    }];
}

#pragma mark 添加图片
- (void)pickImage
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
                                                     [self chosenImageFromAlbum];
                                                 }]];
    [self presentViewController:imageSheet animated:YES completion:nil];
    
}

#pragma mark 从相册选择照片
- (void)chosenImageFromAlbum
{
    _imagePickerVC = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
    _imagePickerVC.navigationBar.barTintColor = KNaviColor;
    _imagePickerVC.allowPickingVideo = NO;
    _imagePickerVC.allowPickingOriginalPhoto = YES;
    
    [self presentViewController:_imagePickerVC animated:YES completion:nil];
}

//选择照片回调
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets
{
    
    UIImage *image = [NSObject imageCompressForWidth:[photos firstObject] targetWidth:SCREEN_WIDTH * 1.0];

    [self uploadHeadImageWithImage:image];

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
    UIImage *image = [NSObject imageCompressForWidth:original targetWidth:SCREEN_WIDTH * 1.0];
    [picker dismissViewControllerAnimated:YES completion:nil];

    [self uploadHeadImageWithImage:image];
}


#pragma mark 七牛上传图片
- (void)uploadHeadImageWithImage:(UIImage *)image
{
    NYProgressHUD *hud = [NYProgressHUD new];
    [hud showAnimationWithText:@"上传头像中"];
    QiNiuUploadImageTool *tool = [[QiNiuUploadImageTool alloc]init];
    [tool uploadHeadImage:image completed:^(NSArray *keys) {
        NSString *imageName = keys[0];
        [self updatePersonalInfoWithName:nil avatar:imageName success:^{
            [hud hide];
            [NYProgressHUD showToastText:@"上传头像成功"];
            [UserDefaultManager setHeadImage:image];
            [_tableView reloadData];
        } failure:^{
            [hud hide];
            [NYProgressHUD showToastText:@"上传头像失败"];
        }];
    }];
}

- (void)updatePersonalInfoWithName:(NSString *)name avatar:(NSString *)avatar success:(void(^)())successBlock failure:(void(^)())failureBlock
{
    UpdatePersonalInfoAPI *api = [[UpdatePersonalInfoAPI alloc]initWithName:name avatarName:avatar];
    [api startWithSuccessBlock:^{
        successBlock();
    } failure:^{
        failureBlock();
    }];
}

#pragma mark TableViewDelegate DataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        MineInfoAvatarCell *cell = [[MineInfoAvatarCell alloc]init];
        return cell;
    }else if(indexPath.row == 1)
    {
        MineInfoDetailCell *cell = [[MineInfoDetailCell alloc]init];
        [cell loadTitle:@"名称" content:[UserDefaultManager nickName]];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }else if(indexPath.row == 2)
    {
        MineInfoDetailCell *cell = [[MineInfoDetailCell alloc]init];
        [cell loadTitle:@"邮箱" content:[UserDefaultManager userName]];
        return cell;
    }else if(indexPath.row == 3)
    {
        MineInfoDetailCell *cell = [[MineInfoDetailCell alloc]init];
        [cell loadTitle:@"学号" content:[UserDefaultManager stuNumber]];
        return cell;
    }
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.row == 0) {
        [self pickImage];
    }else if(indexPath.row == 1){
        ModifyPersonalInfoVC *vc = [[ModifyPersonalInfoVC alloc]init];
        vc.delegate = self;
        [self.navigationController pushViewController:vc animated:YES];
        
    }
}


#pragma mark 初始化
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = RGBA(232, 232, 232, 1.0);
    [self setCustomTitle:@"个人信息"];
    [self setLeftBackButtonImage:[UIImage imageNamed:@"ico_nav_back_white.png"]];
    [self initView];

}

- (void)initView
{
    _tableView = [[UITableView alloc]init];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.tableFooterView = [UIView new];
    _tableView.estimatedRowHeight = 50.0;
    _tableView.rowHeight = UITableViewAutomaticDimension;
    _tableView.scrollEnabled = NO;
    _tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 8)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.scrollEnabled = NO;
    _tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.equalTo(self.view);
    }];

}

@end
