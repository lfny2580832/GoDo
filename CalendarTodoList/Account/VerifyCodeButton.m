//
//  VerifyCodeButton.m
//  GoDo
//
//  Created by 牛严 on 16/4/3.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import "VerifyCodeButton.h"
#import "SendVerifyCodeAPI.h"

#import "BaseModel.h"

@implementation VerifyCodeButton
{
    NSInteger _resendSecond;
    NSTimer *_resendTimer;
}

- (void)resendTimerChange
{
    _resendSecond--;
    [self setTitle:[NSString stringWithFormat:@"%ld",(long)_resendSecond] forState:UIControlStateDisabled];
    if(_resendSecond <= 0)
    {
        self.enabled = YES;
        [self setTitle:@"重新获取" forState:UIControlStateNormal];
        [self setTitle:@"重新获取" forState:UIControlStateDisabled];
        [_resendTimer invalidate];
    }
}

#pragma mark 发送验证码
- (void)sendVerifyCodeWithMail:(NSString *)mail use:(NSString *)use
{
    _resendSecond = 59;
    self.enabled = NO;

    SendVerifyCodeAPI *api = [[SendVerifyCodeAPI alloc]initWithTo:mail use:use];
    NYProgressHUD *hud = [NYProgressHUD new];
    [hud showAnimationWithText:@"验证码发送中"];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        [hud hide];
        BaseModel *model = [BaseModel yy_modelWithJSON:request.responseString];
        if (model.code == 0) {
            [NYProgressHUD showToastText:@"验证码发送成功"];
            _resendTimer = [NSTimer scheduledTimerWithTimeInterval:1.f target:self selector:@selector(resendTimerChange) userInfo:nil repeats:YES];
        }else
        {
            [NYProgressHUD showToastText:model.msg];
        }


    } failure:^(__kindof YTKBaseRequest *request) {
        [hud hide];
        [NYProgressHUD showToastText:@"验证码发送失败"];
        self.enabled = YES;
    }];
}

#pragma makr 初始化
- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = KNaviColor;
        self.titleLabel.font = [UIFont systemFontOfSize:13];
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 2;
        [self setTitle:@"发送验证码" forState:UIControlStateNormal];
    }
    return self;
}


@end
