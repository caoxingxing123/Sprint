//
//  SPTRightViewController.m
//  Sprint
//
//  Created by xxcao on 15/12/28.
//  Copyright © 2015年 xxcao. All rights reserved.
//

#import "SPTRightViewController.h"
#import "UIView+YYAdd.h"

@interface SPTRightViewController ()

@end

@implementation SPTRightViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [Common removeExtraCellLines:self.allTaskTable];
    [Common removeExtraCellLines:self.myTaskTable];
    [Common removeExtraCellLines:self.commentsTable];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITableView DataSource & Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"cellIdentify";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    if (tableView == self.allTaskTable) {
        cell.textLabel.text = [NSString stringWithFormat:@"Name:All--Idx:%zd",indexPath.row];
    } else if (tableView == self.myTaskTable) {
        cell.textLabel.text = [NSString stringWithFormat:@"Name:MY--Idx:%zd",indexPath.row];
    } else {
        cell.textLabel.text = [NSString stringWithFormat:@"Name:Com--Idx:%zd",indexPath.row];
    }
    cell.textLabel.font = Font(12);
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Segment Control Action
- (IBAction)selectOtherTypeSegmentAction:(UISegmentedControl *)sender {
    NSLog(@"%zd",sender.selectedSegmentIndex);
    CGFloat tableWidth = 150;
    [UIView animateWithDuration:0.3 animations:^{
        self.allTaskTable.left = Screen_Width - tableWidth * sender.selectedSegmentIndex - tableWidth;
        self.myTaskTable.left = Screen_Width - tableWidth * sender.selectedSegmentIndex;
        self.commentsTable.left = Screen_Width - tableWidth * sender.selectedSegmentIndex + tableWidth;
    }];
}

@end
