//
//  SPTLeftViewController.h
//  Sprint
//
//  Created by xxcao on 15/12/28.
//  Copyright © 2015年 xxcao. All rights reserved.
//

#import "SPTMainViewController.h"

@interface SPTLeftViewController : SPTMainViewController<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *menuTable;

@property (strong, nonatomic) NSMutableArray *datas;

@end
