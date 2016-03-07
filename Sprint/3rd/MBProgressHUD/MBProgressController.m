//
//  ThirdViewController.m
//  RealToolPicker
//
//  Created by xxcao on 13-1-8.
//  Copyright (c) 2013年 dream. All rights reserved.
//

#import "MBProgressController.h"
#import "MacroDef.h"
@interface MBProgressController ()

@end

@implementation MBProgressController

static MBProgressController *progressController = nil;

+ (MBProgressController *)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        progressController = [[MBProgressController alloc] init];
    });
    return progressController;
}

- (id)init{
    if (self = [super init]) {
        //自定义的imgView
        self.customV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 74, 37)];
        [self.customV setImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
        self.customV.contentMode = UIViewContentModeCenter;
    }
    return self;
}

#pragma mark -Customed MBProgress methods

- (void)showWithText:(NSString *)tipsStr {
    [self allocNewMBprogressHUDwithType: MBProgressHUDModeIndeterminate];
    if (tipsStr && tipsStr.length != 0) {
        if (tipsStr.length < 20) {
            self.hud.labelText = tipsStr;
        } else {
            self.hud.detailsLabelText = tipsStr;
        }
    }
    [self.hud show:YES];
}

- (void)hide {
    if (self.hud) {
        self.hud.removeFromSuperViewOnHide = YES;
        [self.hud hide:YES];
    }
    
    //again
    WeakSelf;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        MBProgressHUD *hudView = [window viewWithTag:2016 + 2046];
        if (hudView) {
            if (wself.hud) {
                wself.hud.removeFromSuperViewOnHide = YES;
                [wself.hud hide:YES];
            }
        }
    });
}

- (void)showTipsLoadingWithText:(NSString *)tipsStr AndDelay:(NSTimeInterval)delay {
    [self allocNewMBprogressHUDwithType:MBProgressHUDModeIndeterminate];
    if (tipsStr && tipsStr.length != 0) {
        if (tipsStr.length < 20) {
            self.hud.labelText = tipsStr;
        } else {
            self.hud.detailsLabelText = tipsStr;
        }
    }
    WeakSelf;
    [self.hud showAnimated:YES
       whileExecutingBlock:^(){
           [wself mbprogressDelaySet:delay];
       }completionBlock:^(){
           [wself.hud removeFromSuperview];
           wself.hud = nil;
       }];
}

- (void)showTipsLoadingWithText:(NSString *)tipsStr WithResult:(BOOL)isSuccess AndDelay:(NSTimeInterval)delay {
    [self allocNewMBprogressHUDwithType:MBProgressHUDModeIndeterminate];
    if (tipsStr && tipsStr.length != 0) {
        if (tipsStr.length < 20) {
            self.hud.labelText = tipsStr;
        } else {
            self.hud.detailsLabelText = tipsStr;
        }
    }
    WeakSelf;
    [self.hud showAnimated:YES
       whileExecutingBlock:^(){
           wself.isTrue = isSuccess;
           [wself mbprogressDelayWithResultSet:delay];
       }completionBlock:^(){
           [wself.hud removeFromSuperview];
           wself.hud = nil;
       }];
}

- (void)showTipsOnlyText:(NSString *)tipsStr AndDelay:(NSTimeInterval)delay {
    if (!tipsStr || tipsStr.length == 0) {
        return;
    }
    [self allocNewMBprogressHUDwithType:MBProgressHUDModeText];
    if (tipsStr.length < 20) {
        self.hud.labelText = tipsStr;
    } else {
        self.hud.detailsLabelText = tipsStr;
    }
    self.hud.margin = 10;
    //self.hud.yOffset = 150;
    self.hud.removeFromSuperViewOnHide = YES;
    WeakSelf;
    [self.hud showAnimated:YES
       whileExecutingBlock:^(){
           [wself mbprogressDelaySet:delay];
       }
           completionBlock:^(){
           [wself.hud removeFromSuperview];
           wself.hud = nil;
       }];
}

- (void)showTipsOnlyCustomViewWith:(NSString *)tipsStr AndDelay:(NSTimeInterval)delay{
    [self allocNewMBprogressHUDwithType:MBProgressHUDModeCustomView];
    if (tipsStr && tipsStr.length != 0) {
        if (tipsStr.length < 20) {
            self.hud.labelText = tipsStr;
        } else {
            self.hud.detailsLabelText = tipsStr;
        }
    }
    WeakSelf;
    [self.hud showAnimated:YES
       whileExecutingBlock:^(){
           [wself mbprogressDelaySet:delay];
       }completionBlock:^(){
           [wself.hud removeFromSuperview];
           wself.hud = nil;
       }];
}

#pragma mark -Init MBprogressHUD methods
- (void)allocNewMBprogressHUDwithType:(MBProgressHUDMode)type {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    self.hud = [[MBProgressHUD alloc] initWithWindow:window];
    self.hud.mode = type;
    if (type == MBProgressHUDModeCustomView) {
        self.hud.customView = self.customV;
    }
    self.hud.tag = 2016 + 2046;
    [window addSubview:self.hud];
}

#pragma mark -Delay methods
- (void)mbprogressDelaySet:(NSTimeInterval)delay{
    sleep(delay);
    
}

-(void)mbprogressDelayWithResultSet:(NSTimeInterval)delay{
    sleep(delay);
    if (self.isTrue) {
        self.hud.mode = MBProgressHUDModeCustomView;
        self.hud.customView = self.customV;
        self.hud.labelText = @"成 功";
    } else {
        self.hud.mode = MBProgressHUDModeText;
        self.hud.labelText = @"失 败";
        self.hud.margin = 10.0;
        self.hud.yOffset = 150.0;
        self.hud.removeFromSuperViewOnHide = YES;
    }
    sleep(2.0);
}

@end
