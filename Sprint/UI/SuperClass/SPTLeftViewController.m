//
//  SPTLeftViewController.m
//  Sprint
//
//  Created by xxcao on 15/12/28.
//  Copyright © 2015年 xxcao. All rights reserved.
//

#import "SPTLeftViewController.h"
#import "SPTContentViewController.h"
#import "YRSideViewController.h"

@interface SPTLeftViewController ()

@end

@implementation SPTLeftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [Common removeExtraCellLines:self.menuTable];
    
    self.datas = [NSMutableArray array];
    [self.datas addObject:@"看板"];
    [self.datas addObject:@"设置"];

    
    self.menuTable.rowHeight = (Screen_Height - 100 * 2) * 1.0 / self.datas.count;
    self.menuTable.contentInset = UIEdgeInsetsMake(100, 0, 100, 0);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"cellIdentify";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.textLabel.text = self.datas[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SPTContentViewController *rootViewController = [SPTContentViewController sharedInstance];
    ETransitionStatus status = [rootViewController transitionViewControllerToIndex:indexPath.row];
    if (status == ETransStatusNormal || status == ETransStatusSame) {
        YRSideViewController *sideVC = (YRSideViewController *)self.parentViewController;
        [sideVC hideSideViewController:YES];
    } else {
        Alert(@"transition fail");
    }
}

@end
