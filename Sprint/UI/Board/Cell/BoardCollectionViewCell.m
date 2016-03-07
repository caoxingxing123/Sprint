//
//  BoardCollectionViewCell.m
//  Sprint
//
//  Created by xxcao on 16/2/19.
//  Copyright © 2016年 xxcao. All rights reserved.
//

#import "BoardCollectionViewCell.h"
#import "UIView+YYAdd.h"

@implementation BoardCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
    self.width = Screen_Width / 2.0;
}

- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    if (highlighted) {
        UIView *selView = [[UIView alloc] init];
        selView.backgroundColor = [UIColor greenColor];
        self.selectedBackgroundView = selView;
    }
}

- (void)setDataModel:(id)dataModel {
    _dataModel = dataModel;
    if ([dataModel isKindOfClass:[NSString class]]) {
        ////
        WeakSelf;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            // Create attributed string.
            NSMutableAttributedString *titleText = [[NSMutableAttributedString alloc] initWithString:dataModel];
            titleText.font = [UIFont systemFontOfSize:20];
            titleText.color = [UIColor darkTextColor];
            
            NSMutableAttributedString *contentText = [[NSMutableAttributedString alloc] initWithString:dataModel];
            contentText.font = [UIFont systemFontOfSize:16];
            contentText.color = [UIColor darkTextColor];

            // Create text container
            YYTextContainer *titleContainer = [YYTextContainer new];
            titleContainer.size = CGSizeMake(wself.width - 48.0 * 2, 44.0);
            titleContainer.maximumNumberOfRows = 1;
            titleContainer.truncationType = YYTextTruncationTypeEnd;
            
            YYTextContainer *contentContainer = [YYTextContainer new];
            contentContainer.size = CGSizeMake(wself.width - 5.0 * 2, 60.0);
            contentContainer.maximumNumberOfRows = 1;
            contentContainer.truncationType = YYTextTruncationTypeEnd;

            // Generate a text layout.
            YYTextLayout *titleLayout = [YYTextLayout layoutWithContainer:titleContainer text:titleText];
            
            YYTextLayout *contentLayout = [YYTextLayout layoutWithContainer:contentContainer text:contentText];

            dispatch_async(dispatch_get_main_queue(), ^{
                YYLabel *titleLab = nil;
                UIView *titleView = [self viewWithTag:1111];
                if (titleView && [titleView isKindOfClass:[YYLabel class]]) {
                    titleLab = (YYLabel *)titleView;
                } else {
                    titleLab = [YYLabel new];
                    titleLab.tag = 1111;
                    titleLab.left = 48.0;
                    titleLab.top = 18.0;
                    [self addSubview:titleLab];
                    titleLab.displaysAsynchronously = YES;
                    titleLab.ignoreCommonProperties = YES;
                }
                titleLab.size = titleLayout.textBoundingSize;
                titleLab.textLayout = titleLayout;
                
                YYLabel *contentLab = nil;
                UIView *contentView = [self viewWithTag:2222];
                if (contentView && [contentView isKindOfClass:[YYLabel class]]) {
                    contentLab = (YYLabel *)contentView;
                } else {
                    contentLab = [YYLabel new];
                    contentLab.tag = 2222;
                    contentLab.left = 5.0;
                    contentLab.top = 60.0;
                    [self addSubview:contentLab];
                    contentLab.displaysAsynchronously = YES;
                    contentLab.ignoreCommonProperties = YES;
                }
                contentLab.size = contentLayout.textBoundingSize;
                contentLab.textLayout = contentLayout;
            });
        });
    }
}

- (void)drawRect:(CGRect)rect {
    // 创建path
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, 0)];
    [path addLineToPoint:CGPointMake(0, self.height)];
    [path addLineToPoint:CGPointMake(self.width, self.height)];
    [path addLineToPoint:CGPointMake(self.width, 0)];
    [path addLineToPoint:CGPointMake(0, 0)];
    
    [[UIColor grayColor] setStroke];
    
    // 设置描边宽度（为了让描边看上去更清楚）
    [path setLineWidth:(0.5 / ([UIScreen mainScreen].scale))];
    
    // 将path绘制出来
    [path stroke];
    
}

#pragma -mark
#pragma -mark

@end
