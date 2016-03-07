//
//  JFRootViewController.h
//  JFLite
//
//  Created by xxcao on 14-7-30.
//  Copyright (c) 2014年 joindoo. All rights reserved.
//

#import "SPTMainViewController.h"
//release
typedef enum : NSUInteger {
    EJFTeam = 0,
    EJFFriends,
    EJFMessage,
    EJFSuggestion,
    EJFSetting,
} EJobFreeNavigationType;

typedef enum : NSUInteger {
    ETransStatusNormal = 0,
    ETransStatusSame,
    ETransStatusAnimating,
    ETransStatusBeyondIndex,
} ETransitionStatus;

@interface SPTContentViewController : SPTMainViewController

Strong UIViewController *currentViewController;
Assign NSInteger curIdx;

+ (id)sharedInstance;

- (ETransitionStatus)transitionViewControllerToIndex:(NSInteger)viewControllerIdx;

@end
