//
//  WeekCollectionView.m
//  CalendarTodoList
//
//  Created by 牛严 on 16/1/11.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import "WeekCollectionView.h"
#import "WeekCollectionViewCell.h"
#import "NSObject+NYExtends.h"

@implementation WeekCollectionView

static NSString * const reuseIdentifier = @"Cell";

#pragma mark 初始化方法
- (instancetype)initWithFrame:(CGRect)frame
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setItemSize:CGSizeMake(SCREEN_WIDTH/7, SCREEN_WIDTH/7)];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    [flowLayout setMinimumLineSpacing:0];
    self = [super initWithFrame:frame collectionViewLayout:flowLayout];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)initView
{
    self.delegate = self;
    self.dataSource = self;
    self.showsHorizontalScrollIndicator = NO;
    self.backgroundColor = [UIColor whiteColor];
    self.pagingEnabled = YES;
    [self registerClass:[WeekCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

#pragma mark CollectionView返回三个月天数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [NSObject numberOfDaysOfThreeMonths];
}

#pragma mark 生成CollectionView的Item
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    WeekCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [NSObject randomColor];
    return cell;
}

@end
