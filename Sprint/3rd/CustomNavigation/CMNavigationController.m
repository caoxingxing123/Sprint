//  Created by apple on 13-12-23.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import "CMNavigationController.h"
#import "SPTMainViewController.h"
@implementation CMNavigationController

#pragma mark 一个类只会调用一次
+ (void)initialize {
    // 1.取出设置主题的对象
    UINavigationBar *navBar = [UINavigationBar appearance];
    
    // 2.设置导航栏的背景图片
    UIImage *navBarBgImg = nil;
    if (isIOS7) { // iOS7
        navBarBgImg = [Common drawImageSize:Size(Screen_Width, 64) Color:[Common colorFromHexRGB:@"2b2f3e"]];
        navBar.tintColor = [UIColor whiteColor];
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    } else { // 非iOS7
        navBarBgImg = [Common drawImageSize:Size(Screen_Width, 44) Color:[Common colorFromHexRGB:@"2b2f3e"]];
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    }
    [navBar setBackgroundImage:navBarBgImg
                 forBarMetrics:UIBarMetricsDefault];
   
    
    // 3.标题
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [Common colorFromHexRGB:@"000000"];
    shadow.shadowOffset = Size(0.5, 0.5);
    NSDictionary *attributesDic = @{NSForegroundColorAttributeName : [Common colorFromHexRGB:@"FCFFFE"],
                                    NSShadowAttributeName : shadow,
                                    NSFontAttributeName : [UIFont boldSystemFontOfSize:18.0]};
    [navBar setTitleTextAttributes:attributesDic];
}

#pragma mark 控制状态栏的样式
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma -mark
#pragma -mark iOS 连续跳转会奔溃的问题
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if ([self.topViewController isKindOfClass:[SPTMainViewController class]]) {
        SPTMainViewController *topVC = (SPTMainViewController *)self.topViewController;
        if (topVC.animating) {
            return;
        }
        topVC.animating = animated;
    }
    if ([viewController isKindOfClass:[SPTMainViewController class]]) {
        SPTMainViewController *pushVC = (SPTMainViewController *)viewController;
        pushVC.animating = animated;
    }
    [super pushViewController:viewController animated:animated];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
    if ([self.topViewController isKindOfClass:[SPTMainViewController class]]) {
        SPTMainViewController *topVC = (SPTMainViewController *)self.topViewController;
        if (topVC.animating) {
            return nil;
        }
        topVC.animating = animated;
    }
    return [super popViewControllerAnimated:animated];
}

@end