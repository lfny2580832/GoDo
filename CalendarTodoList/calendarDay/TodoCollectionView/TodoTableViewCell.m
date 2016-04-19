//
//  TodoTableViewCell.m
//  CalendarTodoList
//
//  Created by 牛严 on 16/1/19.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import "TodoTableViewCell.h"
#import "PopoverView.h"

#import "DBManage.h"

#import "NSObject+NYExtends.h"
#import "NSString+ZZExtends.h"
#import "ZoomImageView.h"

@implementation TodoTableViewCell
{
    UILabel *_textLabel;
    UILabel *_timeLabel;
    UILabel *_projectLabel;
    UILabel *_repeatLabel;
    UILabel *_statusLabel;
    UIView *_sideColorView;
    UIView *_backView;
    UIView *_shadowView;
    FMTodoModel *_todo;
}

- (void)loadTodo:(FMTodoModel *)todo
{
    _todo = todo;
    _textLabel.text = todo.thingStr;
    NSString *timeStr;
    if (todo.isAllDay) {
        timeStr = @"全天";
    }else{
        timeStr = [NSString getHourMinuteDateFromTimeInterval:todo.startTime];
    }
    _timeLabel.text = timeStr;

    NSInteger R = todo.project.red;
    NSInteger G = todo.project.green;
    NSInteger B = todo.project.blue;
    _sideColorView.backgroundColor = RGBA(R, G, B, 1.0);
    _projectLabel.text = todo.project.projectStr;
    _repeatLabel.text = [NSString getRepeatStrWithMode:todo.repeatMode];
    _statusLabel.text = [NSString getDoneStrWithType:todo.doneType startTime:todo.startTime];
    
    todo.doneType == Done?          _statusLabel.text = @"已完成":@"未完成";
    if (todo.images.count) {
        NSInteger imageCount = todo.images.count;
        NSInteger imageEdge = 10;
        [_textLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.contentView).offset(-110);
        }];
        //创建imageView
        for (int i = 0; i < 4; i ++) {
            UIImageView *todoImageView = [_imageViews objectAtIndex:i];
            if (i < imageCount) {
                todoImageView.userInteractionEnabled = YES;
                todoImageView.contentMode= UIViewContentModeScaleAspectFill;
                todoImageView.clipsToBounds = YES;
//                todoImageView.tag = todo.tableId *4 + i;
                todoImageView.image = todo.images[i];
                UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(enlargeImageWithImageView:)];
                [todoImageView addGestureRecognizer:recognizer];
            }else{
                todoImageView.image = nil;
            }
            
            [self.contentView addSubview:todoImageView];
            [todoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.contentView).offset(98 + i*(50+imageEdge));
                make.size.mas_equalTo(CGSizeMake(50, 50));
                make.top.equalTo(_textLabel.mas_bottom).offset(15);
            }];
            [_imageViews addObject:todoImageView];
        }
    }else{
//        for(UIImageView *imageView in _imageViews)
//        {
//            imageView.image = nil;
//            [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.height.mas_equalTo(@0);
//            }];
//        }
        [_textLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(_backView).offset(-55);
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


#pragma mark 选择完成状态
- (void)showPopoverViewOfDoneType:(id)sender
{
    UIButton *btn = sender;
    PopoverView *popoverView = [[PopoverView alloc]init];
    popoverView.menuTitles   = @[@"未完成",@"已完成"];

    [popoverView showFromView:btn selected:^(NSInteger index) {
        _statusLabel.text = popoverView.menuTitles[index];
        //选择完成未完成状态
        DoneType doneType;
        if (index == 1) {
            if (_todo.repeatMode != Never) {
                [NYProgressHUD showToastText:@"重复任务不能标记已完成"];
                [popoverView hide];
                return;
            }
            doneType = Done;
        }else
            doneType = NotDone;
        dispatch_async(kBgQueue, ^{
            [DBManager changeTodoDoneTypeWithTableId:_todo.tableId doneType:doneType];
        });
    }];
}

- (void)layoutSubviews
{
    _shadowView.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:_shadowView.bounds cornerRadius:5].CGPath;
    _shadowView.layer.shadowOffset = CGSizeMake(2, 2);
    _shadowView.layer.shadowRadius = 1;
    _shadowView.layer.shadowOpacity = 0.2;
    _shadowView.layer.cornerRadius = 5;
}

#pragma mark 初始化
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier                                                                             
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.clipsToBounds = YES;
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _imageViews = [NSMutableArray arrayWithCapacity:4];
        for(int i = 0 ;i < 4 ; i ++)
        {
            UIImageView *imageView = [[UIImageView alloc]init];
            [_imageViews addObject:imageView];
        }
        [self initView];
        
    }
    return self;
}

- (void)initView
{
    _shadowView = [[UIView alloc]init];
    _shadowView.backgroundColor = RGBA(232, 232, 232, 1.0);
    _shadowView.layer.cornerRadius = 5;
    [self.contentView addSubview:_shadowView];
    [_shadowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(5);
        make.bottom.equalTo(self.contentView).offset(-6);
        make.left.equalTo(self.contentView).offset(10);
        make.right.equalTo(self.contentView).offset(-10);
    }];

    _backView = [[UIView alloc]init];
    _backView.backgroundColor = [UIColor whiteColor];
    _backView.layer.cornerRadius = 5;
    _backView.layer.masksToBounds = YES;
    [self.contentView addSubview:_backView];
    [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.equalTo(_shadowView);
    }];
    
    _sideColorView = [[UIView alloc]init];
    [_backView addSubview:_sideColorView];
    [_sideColorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(_backView);
        make.left.equalTo(_backView);
        make.width.mas_equalTo(@4);
    }];
    
    _timeLabel = [[UILabel alloc]init];
    _timeLabel.textColor = [UIColor blackColor];
    _timeLabel.font = [UIFont systemFontOfSize:18];
    [_backView addSubview:_timeLabel];
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_backView).offset(15);
        make.centerY.equalTo(_backView);
        make.width.mas_equalTo(@50);
    }];
    
    UIView *seperateLine = [[UIView alloc]init];
    seperateLine.backgroundColor = [UIColor grayColor];
    [_backView addSubview:seperateLine];
    [seperateLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_backView).offset(8);
        make.bottom.equalTo(_backView).offset(-8);
        make.width.mas_equalTo(@1);
        make.left.equalTo(_timeLabel.mas_right).offset(10);
    }];
    
    _textLabel = [[UILabel alloc]init];
    _textLabel.textColor = [UIColor blackColor];
    _textLabel.font = [UIFont systemFontOfSize:18];
    _textLabel.textAlignment = NSTextAlignmentCenter;
    _textLabel.numberOfLines = 0;
    [_backView addSubview:_textLabel];
    [_textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_backView).offset(12);
        make.bottom.equalTo(_backView).offset(-55);
        make.left.equalTo(seperateLine.mas_right).offset(10);
        make.right.equalTo(_backView).offset(-10);
    }];
    
    UIView *textLine = [[UIView alloc]init];
    textLine.backgroundColor = RGBA(232, 232, 232, 1.0);
    [_backView addSubview:textLine];
    [textLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_textLabel.mas_bottom).offset(8);
        make.width.equalTo(_textLabel);
        make.left.equalTo(_textLabel);
        make.height.mas_equalTo(@1);
    }];
    
    UILabel *projectNameLabel = [[UILabel alloc]init];
    projectNameLabel.text = @"所属项目";
    projectNameLabel.textColor = [UIColor grayColor];
    projectNameLabel.font = [UIFont systemFontOfSize:12];
    [_backView addSubview:projectNameLabel];
    [projectNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_backView).offset(-20);
        make.left.equalTo(seperateLine).offset(10);
    }];
    
    _projectLabel = [[UILabel alloc]init];
    _projectLabel.text = @"学生会";
    _projectLabel.textAlignment = NSTextAlignmentCenter;
    _projectLabel.font = [UIFont systemFontOfSize:12];
    [_backView addSubview:_projectLabel];
    [_projectLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(projectNameLabel.mas_bottom).offset(3);
        make.centerX.equalTo(projectNameLabel);
        make.width.mas_equalTo(@50);
    }];
    
    UILabel *repeatNameLabel = [[UILabel alloc]init];
    repeatNameLabel.text = @"重复模式";
    repeatNameLabel.textColor = [UIColor grayColor];
    repeatNameLabel.font = [UIFont systemFontOfSize:12];
    [_backView addSubview:repeatNameLabel];
    [repeatNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_textLabel);
        make.top.equalTo(projectNameLabel);
    }];
    
    _repeatLabel = [[UILabel alloc]init];
    _repeatLabel.text = @"每周";
    _repeatLabel.font = [UIFont systemFontOfSize:12];
    [_backView addSubview:_repeatLabel];
    [_repeatLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(repeatNameLabel);
        make.top.equalTo(_projectLabel);
    }];
    
    UILabel *statusNameLabel = [[UILabel alloc]init];
    statusNameLabel.text = @"完成状态▼";
    statusNameLabel.textColor = [UIColor grayColor];
    statusNameLabel.font = [UIFont systemFontOfSize:12];
    [_backView addSubview:statusNameLabel];
    [statusNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(projectNameLabel);
        make.right.equalTo(_backView.mas_right).offset(-10);
    }];
    
    _statusLabel = [[UILabel alloc]init];
    _statusLabel.text = @"未开始";
    _statusLabel.font = [UIFont systemFontOfSize:12];
    [_backView addSubview:_statusLabel];
    [_statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_projectLabel);
        make.centerX.equalTo(statusNameLabel).offset(-2);
    }];
    
    UIButton *switchDoneButton = [[UIButton alloc]init];
    switchDoneButton.backgroundColor = [UIColor clearColor];
    [switchDoneButton addTarget:self action:@selector(showPopoverViewOfDoneType:) forControlEvents:UIControlEventTouchUpInside];
    [_backView addSubview:switchDoneButton];
    [switchDoneButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(statusNameLabel).offset(-5);
        make.left.equalTo(statusNameLabel).offset(-10);
        make.right.equalTo(_backView).offset(3);
        make.bottom.equalTo(_backView).offset(1);
    }];

}

@end
