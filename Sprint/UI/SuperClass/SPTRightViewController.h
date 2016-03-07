//
//  SPTRightViewController.h
//  Sprint
//
//  Created by xxcao on 15/12/28.
//  Copyright © 2015年 xxcao. All rights reserved.
//

#import "SPTMainViewController.h"

@interface SPTRightViewController : SPTMainViewController<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,weak)IBOutlet UITableView *allTaskTable;

@property(nonatomic,weak)IBOutlet UITableView *myTaskTable;

@property(nonatomic,weak)IBOutlet UITableView *commentsTable;

@property(nonatomic,weak)IBOutlet UISegmentedControl *typeSegment;


@end
