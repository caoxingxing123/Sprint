//
//  NoteDetailCell.h
//  Sprint
//
//  Created by xxcao on 16/2/26.
//  Copyright © 2016年 xxcao. All rights reserved.
//
#import "DetailModel.h"
#import "SDWeiXinPhotoContainerView.h"

@interface NoteDetailCell : UITableViewCell


@property(nonatomic,strong)DetailModel *dataModel;

@property(nonatomic,strong)UIImageView *iconImgV;

@property(nonatomic,strong)UILabel *nameLab;

@property(nonatomic,strong)UILabel *contentLab;

@property(nonatomic,strong)UILabel *timeLab;

@property(nonatomic,strong)SDWeiXinPhotoContainerView *photoContainerView;

@end
