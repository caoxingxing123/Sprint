//
//  ThirdViewController.h
//  RealToolPicker
//
//  Created by xxcao on 13-1-8.
//  Copyright (c) 2013年 dream. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface MBProgressController : UIViewController<MBProgressHUDDelegate>{
    MBProgressHUD *_hud;
    UIImageView *_customV;
    BOOL _isTure;
}

@property(nonatomic,retain)MBProgressHUD *hud;
@property(nonatomic,retain)UIImageView *customV;
@property(nonatomic,assign)BOOL isTrue;

//MBProgressController Methods
+ (MBProgressController *)sharedInstance;

- (void)showWithText:(NSString *)tipsStr;

- (void)showTipsLoadingWithText:(NSString *)tipsStr AndDelay:(NSTimeInterval)delay;

- (void)showTipsLoadingWithText:(NSString *)tipsStr WithResult:(BOOL)isSuccess AndDelay:(NSTimeInterval)delay;

- (void)showTipsOnlyText:(NSString *)tipsStr AndDelay:(NSTimeInterval)delay;

- (void)showTipsOnlyCustomViewWith:(NSString *)tipsStr AndDelay:(NSTimeInterval)delay;

- (void)hide;

@end
