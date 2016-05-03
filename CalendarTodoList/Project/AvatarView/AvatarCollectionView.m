//
//  AvatarCollectionView.m
//  GoDo
//
//  Created by 牛严 on 16/5/1.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import "AvatarCollectionView.h"
#import "AvatarCollectionViewCell.h"

#import "ProjectModel.h"

@interface AvatarCollectionView ()<UICollectionViewDataSource,UICollectionViewDelegate>

@end

@implementation AvatarCollectionView
{
    NSArray *_members;
}

static NSString *reuseIdentifier = @"avatarCollectionViewCell";

- (void)setProject:(ProjectModel *)project
{
    _project = project;
    _members = project.members;
    
    [self reloadData];
}

#pragma mark 初始化方法
- (instancetype)initWithFrame:(CGRect)frame
{
    NYAvatarCollectionViewFlowLayout *flowLayout = [[NYAvatarCollectionViewFlowLayout alloc] init];
    [flowLayout setItemSize:CGSizeMake(28, 28)];
    [flowLayout setMinimumInteritemSpacing:10];
    [flowLayout setMinimumLineSpacing:4];
    self = [super initWithFrame:frame collectionViewLayout:flowLayout];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
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
    [self registerClass:[AvatarCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _members.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    AvatarCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    if (indexPath.item == _members.count) {
        [cell loadAddMemberImage];
    }else{
        [cell loadMemberImagesWithMember:_members[indexPath.row]];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    if (indexPath.item != _members.count) {
        [self.mdelegate didSelectAvatarViewWith:_project];
    }else{
        [self.mdelegate didSelectAvatarViewToAddMember];
    }
}

@end

@implementation NYAvatarCollectionViewFlowLayout

//重写FlowLayout方法，使item 间距固定，并且items整体居中
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSArray *itemsLayout = [super layoutAttributesForElementsInRect:rect];
    
    UICollectionViewLayoutAttributes *itemAttribute = itemsLayout.count? itemsLayout[0] :nil;
    
    CGFloat viewWidth = rect.size.width;
    CGFloat itemWidth = itemAttribute.frame.size.width;
    //item之间的固定间隔
    NSInteger staticSpacing = 10;
    //每行最多多少个item
    NSInteger maxItemCountALine = floor((viewWidth + staticSpacing)/(itemWidth + staticSpacing));
    //最后一行第一排是第几个item
    NSInteger lastLineFirstItemIndex = itemsLayout.count -  itemsLayout.count % maxItemCountALine;
    //满行的第一个item的x坐标
    CGFloat fullLineFirstX = (viewWidth - maxItemCountALine * itemWidth - (maxItemCountALine - 1) * staticSpacing)/2;
    
    if (itemsLayout.count == 1)
    {
        UICollectionViewLayoutAttributes *onlyItemAttributes = itemsLayout[0];
        CGFloat oneItemLineFirstX = (viewWidth - itemWidth)/2;
        CGRect frame = onlyItemAttributes.frame;
        frame.origin.x = oneItemLineFirstX;
        onlyItemAttributes.frame = frame;
    }
    
    for(int i = 1; i < [itemsLayout count]; ++i)
    {
        UICollectionViewLayoutAttributes *currentLayoutAttributes = itemsLayout[i];
        UICollectionViewLayoutAttributes *prevLayoutAttributes = itemsLayout[i - 1];
        NSInteger origin = CGRectGetMaxX(prevLayoutAttributes.frame);
        
        if ((i-1) % maxItemCountALine == 0 && (i-1) != lastLineFirstItemIndex) {
            CGRect frame = prevLayoutAttributes.frame;
            frame.origin.x = fullLineFirstX;
            prevLayoutAttributes.frame = frame;
            origin = CGRectGetMaxX(prevLayoutAttributes.frame);
        }
        else if ((i-1) == lastLineFirstItemIndex)
        {
            NSInteger itemCountInLastLine = itemsLayout.count - lastLineFirstItemIndex;
            CGFloat notFullLineFirstX = (viewWidth - itemCountInLastLine * itemWidth - (itemCountInLastLine - 1) * staticSpacing)/2;
            CGRect frame = prevLayoutAttributes.frame;
            frame.origin.x = notFullLineFirstX;
            prevLayoutAttributes.frame = frame;
            origin = CGRectGetMaxX(prevLayoutAttributes.frame);
        }
        else if (i == lastLineFirstItemIndex)
        {
            CGFloat oneItemLineFirstX = (viewWidth - itemWidth)/2;
            CGRect frame = currentLayoutAttributes.frame;
            frame.origin.x = oneItemLineFirstX;
            currentLayoutAttributes.frame = frame;
        }
        
        if(origin + staticSpacing + currentLayoutAttributes.frame.size.width < self.collectionViewContentSize.width)
        {
            CGRect frame = currentLayoutAttributes.frame;
            NSInteger origin = CGRectGetMaxX(prevLayoutAttributes.frame);
            frame.origin.x = origin + staticSpacing;
            currentLayoutAttributes.frame = frame;
        }
    }
    return itemsLayout;
}

@end

