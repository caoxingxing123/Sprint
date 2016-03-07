//
//  SPTNoteDetailViewController.h
//  Sprint
//
//  Created by xxcao on 16/2/25.
//  Copyright © 2016年 xxcao. All rights reserved.
//

#import "SPTMainViewController.h"
#import "SDCycleScrollView.h"

@interface SPTNoteDetailViewController : SPTMainViewController<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,weak)IBOutlet UITableView *table;

@property(nonatomic,strong)UIView *headerView;

@property(nonatomic,strong)NSMutableArray *datas;
@end
