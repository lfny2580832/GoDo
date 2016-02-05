//
//  ChooseTypeColorVC.m
//  CalendarTodoList
//
//  Created by 牛严 on 16/2/5.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import "ChooseTypeColorVC.h"
#import "TypeColor.h"

#import "NSObject+NYExtends.h"

@interface ChooseTypeColorVC ()<UICollectionViewDataSource,UICollectionViewDelegate>

@end

@implementation ChooseTypeColorVC
{
    UICollectionView *_collectionView;
    
    NSArray *_colors;
}

#pragma mark UICollectionView Delegate Datsource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 10;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    UIView *colorView = [[UIView alloc]init];
    colorView.layer.cornerRadius = 20.f;
    TypeColor *color = _colors[indexPath.row];
    colorView.backgroundColor = RGBA(color.red, color.green, color.blue, 1.0);
    [cell.contentView addSubview:colorView];
    [colorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(cell.contentView);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.delegate returnTypeColorWithTypeColor:_colors[indexPath.row]];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 初始化
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.view.backgroundColor = [UIColor whiteColor];
        [self initColorData];
        [self initViews];
    }
    return self;
}

- (void)initColorData
{
    TypeColor *color1 = [[TypeColor alloc]initWithRed:149 green:239 blue:99];
    TypeColor *color2 = [[TypeColor alloc]initWithRed:255 green:133 blue:129];
    TypeColor *color3 = [[TypeColor alloc]initWithRed:255 green:196 blue:113];
    TypeColor *color4 = [[TypeColor alloc]initWithRed:249 green:236 blue:117];
    TypeColor *color5 = [[TypeColor alloc]initWithRed:168 green:200 blue:228];
    TypeColor *color6 = [[TypeColor alloc]initWithRed:227 green:171 blue:229];
    TypeColor *color7 = [[TypeColor alloc]initWithRed:210 green:184 blue:163];
    TypeColor *color8 = [[TypeColor alloc]initWithRed:251 green:136 blue:110];
    TypeColor *color9 = [[TypeColor alloc]initWithRed:225 green:204 blue:0];
    TypeColor *color10 = [[TypeColor alloc]initWithRed:116 green:232 blue:211];
    TypeColor *color11 = [[TypeColor alloc]initWithRed:59 green:213 blue:251];

    _colors = [NSArray arrayWithObjects:color1,color2,color3,color4,color5,color6,color7,color8,color9,color10,color11, nil];
}

- (void)initViews
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setItemSize:CGSizeMake(SCREEN_WIDTH/7, SCREEN_WIDTH/7)];
    [flowLayout setMinimumLineSpacing:0];
    [flowLayout setMinimumInteritemSpacing:0];
    _collectionView = [[UICollectionView alloc]initWithFrame:self.view.frame collectionViewLayout:flowLayout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor whiteColor];
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [self.view addSubview:_collectionView];
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(10);
        make.left.equalTo(self.view).offset(10);
        make.right.equalTo(self.view).offset(-10);
        make.height.mas_equalTo(SCREEN_WIDTH - 74);
    }];
}

@end
