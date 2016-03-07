//
//  UIImageView+Cache.m
//  Sprint
//
//  Created by xxcao on 16/1/7.
//  Copyright © 2016年 xxcao. All rights reserved.
//

#import "UIImageView+Cache.h"
#import "CacheManager.h"

#define kImageSize  Size(self.frame.Width * ([UIScreen mainScreen].scale), self.frame.Height * ([UIScreen mainScreen].scale))

@implementation UIImageView (Cache)

- (void)setImageWithURL:(NSString *)urlString {
    [self setImageWithURL:urlString PlaceHolder:nil];
}

- (void)setImageWithURL:(NSString *)urlString PlaceHolder:(UIImage *)placeHolderImgV {
    [self setImageWithURL:urlString CompleteBlock:nil FailureBlock:nil PlaceHolder:placeHolderImgV ];
}

- (void)setImageWithURL:(NSString *)urlString CompleteBlock:(CompleteBlock)success FailureBlock:(FailureBlock)failure {
    [self setImageWithURL:urlString CompleteBlock:success FailureBlock:failure PlaceHolder:nil];
}

- (void)setImageWithURL:(NSString *)urlString CompleteBlock:(CompleteBlock)success FailureBlock:(FailureBlock)failure PlaceHolder:(UIImage *)placeHolderImgV {
    if (placeHolderImgV) {
        self.image = placeHolderImgV;
    }
    //取图片缓存
    CacheManager *cacheManager = [CacheManager sharedInstance];
    NSData *imgData = [cacheManager getCacheWithKey:urlString Info:nil CacheType:ECacheTypeMemory];
    if (imgData) {
        UIImage *img = [UIImage imageWithData:imgData];
        img = [Common scaleImage:img toSize:kImageSize];
        self.image = img;
        if (success) {
            success(img);
        }
    } else {
        //from file
        UIImage *timage = [cacheManager getCacheWithKey:urlString Info:nil CacheType:ECacheTypeDisk];
        if(timage) {
            //写入cache
            [cacheManager saveCacheWithKey:urlString Object:timage Info:nil CacheType:ECacheTypeMemory IsExist:YES];
            UIImage *img = timage;
            img = [Common scaleImage:img toSize:kImageSize];
            self.image = img;
            if (success) {
                success(img);
            }
        } else {
            //download
            WeakSelf;
            UIImageFromURL([NSURL URLWithString:urlString], ^(UIImage *image) {
                //写入memory
                [cacheManager saveCacheWithKey:urlString Object:timage Info:nil CacheType:ECacheTypeMemory IsExist:NO];
                //写入disk
                [cacheManager saveCacheWithKey:urlString Object:image Info:nil CacheType:ECacheTypeDisk IsExist:NO];
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIImage *img = image;
                    img = [Common scaleImage:img toSize:kImageSize];
                    wself.image = img;
                    if (success) {
                        success(img);
                    }
                });
            }, ^(void){
                NSLog(@"download image error!");
                if (failure) {
                    failure();
                }
            });
        }
    }
}

#pragma mark - 异步下载图片
void UIImageFromURL(NSURL * URL, void (^imageBlock)(UIImage * image), void (^errorBlock)(void)) {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        NSData *data = [NSData dataWithContentsOfURL:URL];
        UIImage *image = [UIImage imageWithData:data];
        if(image){
            imageBlock(image);
        } else {
            errorBlock();
        }
    });
}

@end
