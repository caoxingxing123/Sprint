//
//  SPTBoardViewController.h
//  Sprint
//
//  Created by xxcao on 15/12/28.
//  Copyright © 2015年 xxcao. All rights reserved.
//

#import "SPTMainViewController.h"

@interface SPTBoardViewController: SPTMainViewController<UICollectionViewDataSource,UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *boardCollectionView;

@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *collectionViewLayOut;
@end
