//
//  NoteHeaderReusableView.m
//  Sprint
//
//  Created by xxcao on 16/2/22.
//  Copyright © 2016年 xxcao. All rights reserved.
//

#import "NoteHeaderReusableView.h"
#import "UIImage+YYAdd.h"

@implementation NoteHeaderReusableView

- (void)awakeFromNib {
    // Initialization code
    
    //label
    self.descriLab.font = Font(15);
    self.descriLab.numberOfLines = 1;
    self.descriLab.text = @"曹兴星";
    self.descriLab.textAlignment = NSTextAlignmentLeft;
    self.descriLab.displaysAsynchronously = YES;
    
    //image view
    UIImage *image = [UIImage imageNamed:@"headImgIcon"];
    image = [image imageByResizeToSize:Size(40, 40) contentMode:UIViewContentModeScaleAspectFit];
    image = [image imageByRoundCornerRadius:20 borderWidth:(1.0 / ([UIScreen mainScreen].scale)) borderColor:[UIColor grayColor]];
    self.iconImgV.image = image;
}

- (void)reloadHeaderData:(id)data {
    
}

@end
