//
//  NoteHeaderReusableView.h
//  Sprint
//
//  Created by xxcao on 16/2/22.
//  Copyright © 2016年 xxcao. All rights reserved.
//

#import "YYKit.h"

@interface NoteHeaderReusableView : UICollectionReusableView

@property(nonatomic,weak)IBOutlet UIImageView *iconImgV;

@property(nonatomic,weak)IBOutlet YYLabel *descriLab;

- (void)reloadHeaderData:(id)data;

@end
