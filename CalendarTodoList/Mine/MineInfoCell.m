//
//  InfoCell.m
//  GoDo
//
//  Created by 牛严 on 16/4/25.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import "MineInfoCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation MineInfoCell
{
    UIImageView *_imageView;
}

- (void)loadHeadImage
{
    UIImage *headImage = [UserDefaultManager headImage];
    _imageView.image = headImage;
    _titleLabel.text = [UserDefaultManager nickName];

}


- (void)loadHeadImageWithUrl:(NSString *)imageUrl
{
    NSLog(@"-----%@",imageUrl);
    [_imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"default.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        [UserDefaultManager setHeadImage:image];
    }];
    _titleLabel.text = [UserDefaultManager nickName];
}

#pragma mark 初始化
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initView];
        [self loadHeadImage];
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return self;
}

- (void)initView
{
    _imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"default.png"]];
    [self.contentView addSubview:_imageView];
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(5);
        make.bottom.equalTo(self.contentView).offset(-5);
        make.left.equalTo(self.contentView).offset(18);
        make.size.mas_equalTo(CGSizeMake(70, 70));
    }];
    
    _titleLabel = [[UILabel alloc]init];
    [self.contentView addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_imageView.mas_right).offset(18);
        make.centerY.equalTo(_imageView);
    }];
}

@end
