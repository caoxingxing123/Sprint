//
//  Common.h
//  iAPHD
//
//  Created by 曹兴星 on 13-6-9.
//  Copyright (c) 2013年 曹兴星. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
@interface Common : NSObject
/*==============================公用方法============================================*/


/*==============================系统相关===========================*/
//获取当前软件版本
+ (NSString *)getCurrentAppVersion;
//获取当前软件名称
+ (NSString *)getCurrentAppName;
//拨打电话
+ (BOOL)makeCall:(NSString *)telno;
//获取mac地址
+ (NSString *)getMacAddress;
//获取系统当前语言
+ (NSString *)getCurrentSystemLanguage;

/*==============================时间相关===========================*/
//获取系统当前时间
+ (NSString *)getCurrentTimeFormat:(NSString *)formatStr;
//根据时间戳转换成时间
+ (NSString *)timeIntervalSince1970:(NSTimeInterval)secs Format:(NSString*)formatStr;
//String ====> Date  （字符串转时间）
+ (NSDate *)dateFromString:(NSString *)dateString Formater:(NSString *)formater;
//Date =====> String （时间转字符串）
+ (NSString *)stringFromDate:(NSDate *)date Formater:(NSString *)formater;
//距离现在的天、时、分、秒
+ (NSString *)compareCurrentTime:(NSTimeInterval) interval;
//重新调整时间
+ (NSDate *)reSetCurrentDate:(NSDate *)date;

/*==============================正则匹配===========================*/
//手机号码的合法性
+ (BOOL)isMobileNumber:(NSString *)mobileNum;
//邮箱的合法性
+ (BOOL)isEmail:(NSString *)emailAddress;
//过滤特殊字符
+ (BOOL)isCharacter:(NSString *)characterNum;
//检测是否是纯数字
+ (BOOL)isAllNum:(NSString *)string;
//判断是否包含汉字
+ (BOOL)isContantChineseString:(NSString *)string;
//计算团队名字
+ (NSString *)caculateTeamText:(NSString *)name;
/*==============================加密解密===========================*/
//创建uuid
+ (NSString *)createOneUUID;
//字符串转字节流
+ (NSData *)hexToBytesByString:(NSString *)byteString;
//创建文件id
+ (NSString *)createFileIdByDate:(NSDate *)date FileSize:(NSNumber *)fSize FileExt:(NSString *)ext FileData:(NSData *)data;
//创建图片文件id
+ (NSString *)createImageFileIdByDate:(NSDate *)date FileSize:(NSNumber *)fSize FileExt:(NSString *)ext FileData:(NSData *)data;
//创建md5值
+ (NSString *)creatFileMD5:(NSData *)fileData;
/*==============================字符串处理===========================*/
//检查是否空字符串
+ (BOOL)isEmptyString:(NSString *)sourceStr;
//过滤html标签
+ (NSString *)flattenHTML:(NSString *)html;

//判断空值，如果为空，就返回字符串 @""
+ (id)isNull:(NSString *)object_1;
//滤掉前后空格
+ (NSString *)stringWithoutTrimmingCharacters:(NSString *)srcString;
//查找字串
+ (BOOL)string:(NSString *)srcStr ContainSubString:(NSString *)subStr;
/*==============================UI相关===========================*/
//去除UITableView多余分割线
+ (void)removeExtraCellLines:(UITableView *)tableView;
//生成BarItem
+ (UIBarButtonItem *)createBarItemWithTitle:(NSString *)name
                                     Nimage:(UIImage *)nImg
                                     Himage:(UIImage *)hImg
                                       Size:(CGSize)size
                                   Selector:(void (^)())block;
//生成BackBarItem
+ (UIBarButtonItem *)createBackBarButton:(NSString *)name
                                Selector:(void(^)())block;

//生成BoardBackBar
+ (UIBarButtonItem *)createBoardBackBarButton:(NSString *)name
                                     Selector:(void(^)())block;


//生成BarItem 不带block
+ (UIBarButtonItem *)createBarItemBySELWithTitle:(NSString *)name
                                          Nimage:(UIImage *)nImg
                                          Himage:(UIImage *)hImg
                                            Size:(CGSize)size
                                        Selector:(SEL)selector
                                          Target:(id)target;
//scale图片
+ (UIImage *)scaleImage:(UIImage*)image
                toSize:(CGSize)newSize;

+ (UIImage*)imageByScalingAndCroppingForSize:(UIImage*)anImage toSize:(CGSize)targetSize;

//等比压缩图片
+ (UIImage *)scaleImage:(UIImage *)image
                toScale:(CGFloat)scaleSize;

//截屏成UImageView
+ (UIImageView *)cutScreenImage;

//通过长宽和最小长度获取改变后的长宽
+ (CGSize)sizeWith:(CGSize)oldSize withMin:(CGFloat)minLen;

//绘制圆形图片
+ (UIImage *)circleImage:(UIImage*)image withParam:(CGFloat)inset;

//生成绘制图片
+ (UIImage *)drawImageSize:(CGSize)size
                     Color:(UIColor *)color;

//根据16进制显示颜色
+ (UIColor *)colorFromHexRGB:(NSString *)inColorString;

//加载动画
+ (void)animationImageView:(UIImageView *)imgV Images:(NSArray *)imgs;

//绘制下划线
+ (UIImageView *)addBottomLineWithYpos:(float)yPos;

//自定义push动画
+ (void)customPushAnimationFromNavigation:(UINavigationController *)nav ToViewController:(UIViewController *)vc;
//自定义pop动画
+ (void)customPopAnimationFromNavigation:(UINavigationController *)nav;
/*==============================VGUtility===========================*/
@end
