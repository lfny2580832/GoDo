//
//  TodoContentView.m
//  CalendarTodoList
//
//  Created by 牛严 on 16/2/2.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import "TodoContentView.h"

#import "ZoomImageView.h"

@implementation TodoContentView
{
    UIImageView *_addImageView;
    
    NSInteger _imageCount;
    NSArray *_images;
}

#pragma mark KVO Texfield
- (void)textFieldChanged:(UITextField *)textField
{
    [self.delegate getTodoContentWith:textField.text];
}

#pragma mark 点击添加图片
- (void)addImageViewClicked
{
    [self.delegate pickImageWithCurrentImageCount:_imageCount];
}

#pragma mark 加载图片
- (void)updateContentViewWithImageArray:(NSMutableArray *)images
{
    NSInteger imageEdge = 10;
    _images = images;
    _imageCount = images.count;
    //改变添加按钮的左边距
    if (_imageCount < 4) {
        [_addImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(25 + _imageCount * (60 + imageEdge));
        }];
    }else if (_imageCount == 4){
        _addImageView.hidden = YES;
    }
    
    //创建iamgeView
    for (int i = 0; i < _imageCount; i ++) {
        UIImageView *todoImageView = [[UIImageView alloc]initWithImage:images[i]];
        todoImageView.userInteractionEnabled = YES;
        todoImageView.contentMode= UIViewContentModeScaleAspectFill;
        todoImageView.clipsToBounds = YES;
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(enlargeImageWithImageView:)];
        [todoImageView addGestureRecognizer:recognizer];
        [self addSubview:todoImageView];
        [todoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_todoContentField.mas_bottom).offset(20);
            make.left.equalTo(self).offset(25 + i * (60 + imageEdge));
            make.size.mas_equalTo(CGSizeMake(60, 60));
        }];
    }
}

#pragma mark 放大ImageView中的图片
- (void)enlargeImageWithImageView:(id)sender
{
    UITapGestureRecognizer * singleTap = (UITapGestureRecognizer *)sender;
    ZoomImageView *zoomImageView = [[ZoomImageView alloc]initWithImageView:(UIImageView *)[singleTap view]];
    [zoomImageView showBigImageView];
}

#pragma mark 初始化
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self initViews];
    }
    return self;
}

- (void)initViews
{
    UIView *lineView1 = [[UIView alloc]init];
    lineView1.backgroundColor = RGBA(220, 219, 224, 1.0);
    [self addSubview:lineView1];
    [lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.mas_equalTo(@1);
    }];
    
    _todoContentField = [[UITextField alloc]init];
    _todoContentField.placeholder = @"内容";
    _todoContentField.delegate = self;
    [_todoContentField addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    _todoContentField.font = [UIFont systemFontOfSize:18];
    [self addSubview:_todoContentField];
    [_todoContentField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(27);
        make.bottom.equalTo(self).offset(-96);
        make.left.equalTo(self).offset(25);
        make.right.equalTo(self).offset(-25);
    }];
    
    _addImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"AlbumAddBtn.png"]];
    _addImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *addImageRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addImageViewClicked)];
    [_addImageView addGestureRecognizer:addImageRecognizer];
    [self addSubview:_addImageView];
    [_addImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_todoContentField.mas_bottom).offset(20);
        make.left.equalTo(self).offset(25);
        make.size.mas_equalTo(CGSizeMake(60, 60));
    }];
    
    UIView *lineView2 = [[UIView alloc]init];
    lineView2.backgroundColor = RGBA(220, 219, 224, 1.0);
    [self addSubview:lineView2];
    [lineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self);
        make.height.mas_equalTo(@1);
    }];
}

@end
