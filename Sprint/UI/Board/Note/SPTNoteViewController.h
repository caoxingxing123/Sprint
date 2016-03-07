//
//  SPTNoteViewController.h
//  Sprint
//
//  Created by xxcao on 16/2/22.
//  Copyright © 2016年 xxcao. All rights reserved.
//

#import "SPTMainViewController.h"
#import "UICollectionView+Draggable.h"

@interface SPTNoteViewController : SPTMainViewController<UICollectionViewDataSource_Draggable,UICollectionViewDelegate> {
    int _phaseCount;
}

@property(strong,nonatomic)NSMutableArray *phases;

@property(strong,nonatomic)NSMutableArray *layers;

@property(strong,nonatomic)NSMutableArray *datas;

@end
