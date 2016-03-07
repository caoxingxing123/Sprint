//
//  UIImageView+Cache.h
//  Sprint
//
//  Created by xxcao on 16/1/7.
//  Copyright © 2016年 xxcao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^CompleteBlock)(UIImage *image);
typedef void (^FailureBlock)(void);


@interface UIImageView (Cache)

- (void)setImageWithURL:(NSString *)urlString;

- (void)setImageWithURL:(NSString *)urlString PlaceHolder:(UIImage *)placeHolderImgV;

- (void)setImageWithURL:(NSString *)urlString CompleteBlock:(CompleteBlock)success FailureBlock:(FailureBlock)failure;

- (void)setImageWithURL:(NSString *)urlString CompleteBlock:(CompleteBlock)success FailureBlock:(FailureBlock)failure PlaceHolder:(UIImage *)placeHolderImgV;

@end
