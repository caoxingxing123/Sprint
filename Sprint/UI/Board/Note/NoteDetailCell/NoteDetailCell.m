//
//  NoteDetailCell.m
//  Sprint
//
//  Created by xxcao on 16/2/26.
//  Copyright © 2016年 xxcao. All rights reserved.
//

#import "NoteDetailCell.h"
#import "UIView+SDAutoLayout.h"
#import "UIImage+YYAdd.h"
#import "UIView+YYAdd.h"

@implementation NoteDetailCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    _iconImgV = [UIImageView new];
    [self.contentView addSubview:_iconImgV];
    
    _nameLab = [UILabel new];
    _nameLab.font = [UIFont systemFontOfSize:14];
    _nameLab.textColor = [UIColor colorWithRed:(54 / 255.0) green:(71 / 255.0) blue:(121 / 255.0) alpha:0.9];
    [self.contentView addSubview:_nameLab];
    
    _contentLab = [UILabel new];
    _contentLab.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:_contentLab];
    
    _photoContainerView = [SDWeiXinPhotoContainerView new];
    [self.contentView addSubview:_photoContainerView];

    
    _timeLab = [UILabel new];
    _timeLab.font = [UIFont systemFontOfSize:13];
    _timeLab.textColor = [UIColor lightGrayColor];
    [self.contentView addSubview:_timeLab];

    _iconImgV.sd_layout.leftSpaceToView(self.contentView,10).topSpaceToView(self.contentView,15).heightIs(40).widthIs(40);
    
    _nameLab.sd_layout.leftSpaceToView(_iconImgV,10).topEqualToView(_iconImgV).heightIs(18);
    [_nameLab setSingleLineAutoResizeWithMaxWidth:200];
    
    _contentLab.sd_layout.leftEqualToView(_nameLab).topSpaceToView(_nameLab,10).rightSpaceToView(self.contentView,10).autoHeightRatio(0);
    
    _photoContainerView.sd_layout.leftEqualToView(_contentLab);
    
    _timeLab.sd_layout.leftEqualToView(_contentLab).topSpaceToView(_photoContainerView,10).heightIs(15).autoHeightRatio(0);

    [self setupAutoHeightWithBottomView:_timeLab bottomMargin:10];
    
}

- (void)setDataModel:(DetailModel *)dataModel {
    
    _nameLab.text = dataModel.nameStr;
    _contentLab.text = dataModel.contentStr;
    _timeLab.text = dataModel.timeStr;
    
    //image view
    UIImage *image = [UIImage imageNamed:dataModel.iconStr];
    image = [image imageByResizeToSize:_iconImgV.size contentMode:UIViewContentModeScaleAspectFit];
    self.iconImgV.image = image;
    
    if (dataModel.photeNameArry.count > 0) {
        _photoContainerView.sd_layout.topSpaceToView(_contentLab,10);
    } else {
        _photoContainerView.sd_layout.topSpaceToView(_contentLab,0);
    }
    _photoContainerView.picPathStringsArray = dataModel.photeNameArry;

}

@end
