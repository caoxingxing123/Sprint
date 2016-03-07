//
//  JFRootViewController.m
//  JFLite
//
//  Created by xxcao on 14-7-30.
//  Copyright (c) 2014年 joindoo. All rights reserved.
//

#import "SPTContentViewController.h"
#import "CMNavigationController.h"
#import "SPTBoardViewController.h"
#import "SPTSettingViewController.h"

@interface SPTContentViewController ()

Assign BOOL transiting;

@end

@implementation SPTContentViewController

static SPTContentViewController *singleton = nil;
+ (id)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singleton = [[SPTContentViewController alloc] initWithNibName:@"SPTContentViewController" bundle:nil];
        [singleton composeViewControllers];
    });
    return singleton;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

#pragma -mark
#pragma -mark Custom Methods
- (void)composeViewControllers {
    
    SPTBoardViewController *boardVC = [[SPTBoardViewController alloc] initWithNibName:@"SPTBoardViewController" bundle:nil];
    
    SPTSettingViewController *settingVC = [[SPTSettingViewController alloc] initWithNibName:@"SPTSettingViewController" bundle:nil];
    
    NSArray *vcArray = @[boardVC,settingVC];
    WeakSelf;
    [vcArray enumerateObjectsUsingBlock:^(UIViewController *objVC, NSUInteger idx, BOOL *stop) {
        [wself addMyChildViewController:objVC];
    }];
    [self.view addSubview:[self.childViewControllers[0] view]];
    [self.childViewControllers[0] didMoveToParentViewController:self];
    self.currentViewController = self.childViewControllers[0];
    self.curIdx = 0;
}

- (ETransitionStatus)transitionViewControllerToIndex:(NSInteger)viewControllerIdx {
    if (viewControllerIdx >= self.childViewControllers.count) {
        return ETransStatusBeyondIndex;
    }
    if (viewControllerIdx == self.curIdx) {
        //同一个已经展开的
        return ETransStatusSame;
    }
    if (self.transiting) {
        return ETransStatusAnimating;
    }
    self.transiting = YES;
    WeakSelf;
    [self transitionFromViewController:self.currentViewController
                      toViewController:self.childViewControllers[viewControllerIdx]
                              duration:0.0
                               options:UIViewAnimationOptionTransitionNone
                            animations:^{}
                            completion:^(BOOL finished) {
                                wself.transiting = NO;
                            }];
    self.currentViewController = self.childViewControllers[viewControllerIdx];
    self.curIdx = viewControllerIdx;
    return ETransStatusNormal;
}

- (void)addMyChildViewController:(UIViewController *)viewController {
    CMNavigationController *nav = [[CMNavigationController alloc] initWithRootViewController:viewController];
    [self addChildViewController:nav];
}

@end
