
//
//  SetPassController.m
//  DJRegisterViewDemo
//
//  Created by asios on 15/8/15.
//  Copyright (c) 2015年 梁大红. All rights reserved.
//

#import "SetPassController.h"
#import "DJRegisterView.h"
@interface SetPassController ()

@end

@implementation SetPassController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    DJRegisterView *djSetPassView = [[DJRegisterView alloc]
                                     initwithFrame:self.view.bounds action:^(NSString *key1, NSString *key2) {
                                         NSLog(@"%@%@",key1,key2);
                                         
                                     }];
    [self.view addSubview:djSetPassView];
    
}
@end
