//
//  YRSideViewController.h
//  YRSnippets
//
//  Created by 王晓宇 on 14-5-10.
//  Copyright (c) 2014年 王晓宇. All rights reserved.
//

/*!
 *	@class	侧边栏控制器,5.0以上系统使用
 */
#import <UIKit/UIKit.h>
#import "SPTMainViewController.h"

typedef void(^RootViewMoveBlock)(UIView *rootView,CGRect orginFrame,CGFloat xoffset);


@interface YRSideViewController : SPTMainViewController

@property (retain,nonatomic) UIViewController *rootViewController;
@property (retain,nonatomic) UIViewController *leftViewController NS_AVAILABLE_IOS(5_0);
@property (retain,nonatomic) UIViewController *rightViewController NS_AVAILABLE_IOS(5_0);

@property (assign,nonatomic) CGFloat leftViewShowWidth;//左侧栏的展示大小
@property (assign,nonatomic) CGFloat rightViewShowWidth;//右侧栏的展示大小

@property (assign,nonatomic) NSTimeInterval animationDuration;//动画时长
@property (assign,nonatomic) BOOL showBoundsShadow;//是否显示边框阴影

@property (copy,nonatomic) RootViewMoveBlock rootViewMoveBlock;//可在此block中重做动画效果

@property (assign,nonatomic) BOOL isShowLeftViewController;//是否已经显示左侧菜单
@property (assign,nonatomic) BOOL isShowRightViewController;//是否已经显示右侧菜单

@property (assign,nonatomic) BOOL needLeftSide;//是否开启左滑手势菜单
@property (assign,nonatomic) BOOL needRightSide;//是否开启左滑手势菜单

- (void)setRootViewMoveBlock:(RootViewMoveBlock)rootViewMoveBlock;

- (void)showLeftViewController:(BOOL)animated;//展示左边栏
- (void)showRightViewController:(BOOL)animated;//展示右边栏
- (void)hideSideViewController:(BOOL)animated;//恢复正常位置

- (void)setSwipeShowMenuLeft:(BOOL)needLeftSwipe Right:(BOOL)needRightSwipe;

@end
