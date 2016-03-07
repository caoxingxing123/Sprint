//
//  LookPassController.m
//  DJRegisterViewDemo
//
//  Created by asios on 15/8/15.
//  Copyright (c) 2015年 梁大红. All rights reserved.
//

#import "SPTLookForPsdViewController.h"
#import "DJRegisterView.h"
@interface SPTLookForPsdViewController ()

@end

@implementation SPTLookForPsdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"找回密码";
    self.navigationItem.leftBarButtonItem = [Common createBackBarButton:@"返回" Selector:^{
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }];

    
    DJRegisterView *djzcView = [[DJRegisterView alloc]
                                initwithFrame:self.view.bounds djRegisterViewTypeSMS:DJRegisterViewTypeNoScanfSMS plTitle:@"请输入验证码"
                                title:@"提交"
                                
                                hq:^BOOL(NSString *phoneStr) {
                                    
                                    return YES;
                                }
                                
                                tjAction:^(NSString *yzmStr) {
                                    
                                }];
    [self.view addSubview:djzcView];
    self.view.backgroundColor = [UIColor whiteColor];
}
@end
