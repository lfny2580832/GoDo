//
//  TodoTableViewCell.m
//  CalendarTodoList
//
//  Created by 牛严 on 16/1/19.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import "TodoTableViewCell.h"

#import "NSObject+NYExtends.h"
#import "NSString+ZZExtends.h"
#import "ZoomImageView.h"

@implementation TodoTableViewCell
{
    UILabel *_textLabel;
    UILabel *_timeLabel;
    
    UIView *_topLine;
    UIView *_cicleView;
    UIView *_bottomLine;
}

static NSInteger CircleRadius = 9;
static NSInteger LineWidth = 2;

#pragma mark Set方法
- (void)setTodo:(Todo *)todo
{
    _todo = todo;
    _textLabel.text = todo.thingStr;
    NSString *timeStr = [NSString getHourMinuteDateFromTimeInterval:todo.startTime];
    _timeLabel.text = timeStr;
    
    NSInteger R = todo.project.red;
    NSInteger G = todo.project.green;
    NSInteger B = todo.project.blue;
    _cicleView.backgroundColor = RGBA(R, G, B, 1.0);
    
    if (_todo.images.count) {
        NSInteger imageCount = _todo.images.count;
        NSArray *images = _todo.images;
        NSInteger imageEdge = 10;
        [_textLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.contentView).offset(-65);
        }];
        //创建imageView
        for (int i = 0; i < imageCount; i ++) {
            UIImageView *todoImageView = [[UIImageView alloc]initWithImage:images[i]];
            todoImageView.userInteractionEnabled = YES;
            todoImageView.contentMode= UIViewContentModeScaleAspectFill;
            todoImageView.clipsToBounds = YES;
            UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(enlargeImageWithImageView:)];
            [todoImageView addGestureRecognizer:recognizer];
            [self addSubview:todoImageView];
            [todoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.contentView).offset(90 + i*(50+imageEdge));
                make.size.mas_equalTo(CGSizeMake(50, 50));
                make.top.equalTo(_textLabel.mas_bottom).offset(10);
            }];
        }
    }else{
        [_textLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.contentView).offset(-15);
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
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier                                                                             
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.clipsToBounds = YES;
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initView];
    }
    return self;
}

- (void)initView
{
    _textLabel = [[UILabel alloc]init];
    _textLabel.textColor = [UIColor whiteColor];
    _textLabel.textAlignment = NSTextAlignmentLeft;
    _textLabel.numberOfLines = 0;
    [self.contentView addSubview:_textLabel];
    [_textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(15);
        make.bottom.equalTo(self.contentView).offset(-15);
        make.left.equalTo(self.contentView).offset(90);
        make.right.equalTo(self.contentView).offset(-15);
    }];
    
    _timeLabel = [[UILabel alloc]init];
    _timeLabel.textColor = [UIColor whiteColor];
    [self.contentView addSubview:_timeLabel];
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(10);
        make.top.equalTo(self.contentView).offset(15);
        make.width.mas_equalTo(@50);
    }];
    
    _topLine = [[UIView alloc]init];
    _topLine.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:_topLine];
    [_topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(70);
        make.size.mas_equalTo(CGSizeMake(LineWidth, 22));
    }];
    
    _bottomLine = [[UIView alloc]init];
    _bottomLine.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:_bottomLine];
    [_bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(25);
        make.centerX.equalTo(_topLine);
        make.width.mas_equalTo(LineWidth);
        make.bottom.equalTo(self.contentView);
    }];
    
    _cicleView = [[UIView alloc]init];
    _cicleView.layer.masksToBounds = YES;
    _cicleView.layer.cornerRadius = CircleRadius;
    _cicleView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:_cicleView];
    [_cicleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_timeLabel);
        make.centerX.equalTo(_topLine);
        make.size.mas_equalTo(CGSizeMake(CircleRadius*2, CircleRadius*2));
    }];
    
}

@end
