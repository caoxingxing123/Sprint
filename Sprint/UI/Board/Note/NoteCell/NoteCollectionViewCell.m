//
//  NoteCollectionViewCell.m
//  Sprint
//
//  Created by xxcao on 16/2/22.
//  Copyright © 2016年 xxcao. All rights reserved.
//

#import "NoteCollectionViewCell.h"
#import "UIView+YYAdd.h"

@implementation NoteCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
    CGFloat itemWidth = (Screen_Width - 10 * 5) / 4.0;
    self.height = itemWidth;
    self.width = itemWidth;
}

- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    if (highlighted) {
        self.alpha = 0.5;
        UIView *selView = [[UIView alloc] init];
        selView.backgroundColor = [UIColor greenColor];
        self.selectedBackgroundView = selView;
    }
    else {
        self.alpha = 1.f;
    }
}

- (void)setDataModel:(id)dataModel {
    WeakSelf;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // Create attributed string.
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:dataModel];
        text.font = [UIFont systemFontOfSize:10];
        text.color = [UIColor darkTextColor];
        
        // Create text container
        YYTextContainer *container = [YYTextContainer new];
        container.size = CGSizeMake(wself.width - 12.0, wself.height - 18.0);
        container.maximumNumberOfRows = 0;
        container.truncationType = YYTextTruncationTypeEnd;
        
        // Generate a text layout.
        YYTextLayout *layout = [YYTextLayout layoutWithContainer:container text:text];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            YYLabel *label = nil;
            UIView *tmpLabel = [wself viewWithTag:2016];
            if (tmpLabel && [tmpLabel isKindOfClass:[YYLabel class]]) {
                label = (YYLabel *)tmpLabel;
            } else {
                //new
                label = [YYLabel new];
                label.tag = 2016;
                label.left = 4.0;
                label.top = 4.0;
                [wself addSubview:label];
                
                label.displaysAsynchronously = YES;
                label.ignoreCommonProperties = YES;
            }
            label.size = layout.textBoundingSize;
            label.textLayout = layout;
        });
    });
}

@end
