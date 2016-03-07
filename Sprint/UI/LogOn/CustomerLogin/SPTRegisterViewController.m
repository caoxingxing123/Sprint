
//
//  ZCController.m
//  DJRegisterViewDemo
//
//  Created by asios on 15/8/15.
//  Copyright (c) 2015年 梁大红. All rights reserved.
//

#import "SPTRegisterViewController.h"
#import "DJRegisterView.h"
@interface SPTRegisterViewController ()

@end

@implementation SPTRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"注册";
    self.navigationItem.leftBarButtonItem = [Common createBackBarButton:@"返回" Selector:^{
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }];

    DJRegisterView *djzcView = [[DJRegisterView alloc]
                                initwithFrame:self.view.bounds djRegisterViewTypeSMS:DJRegisterViewTypeScanfPhoneSMS plTitle:@"请输入获取到的验证码"
                                title:@"下一步"
                                
                                hq:^BOOL(NSString *phoneStr) {
                                    
                                    return YES;
                                }
                                
                                tjAction:^(NSString *yzmStr) {
                                    
                                }];
    [self.view addSubview:djzcView];
    self.view.backgroundColor = [UIColor whiteColor];
}

@end
