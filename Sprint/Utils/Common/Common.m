//
//  Common.m
//  iAPHD
//
//  Created by 曹兴星 on 13-6-9.
//  Copyright (c) 2013年 曹兴星. All rights reserved.
//

#import "Common.h"
#include <sys/socket.h> 
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
#import "BlockUI.h"
#import "MBProgressController.h"
#import "AppDelegate.h"
#import "MacroDef.h"
#import "NSString+Common.h"

@implementation Common

/*==============================公用方法===========================*/

#pragma -mark 系统相关
//获取当前软件版本
+ (NSString *)getCurrentAppVersion {
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    // app版本
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    return app_Version;
}

//获取当前软件名称
+ (NSString *)getCurrentAppName {
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    // app名称
    NSString *app_Name = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    return app_Name;
}


//拨打电话
+ (BOOL)makeCall:(NSString *)telno {
    if(!isIPhone){
        Alert(@"您的设备不是iPhone，不好拨打电话");
        return NO;
    }
    if(![Common isMobileNumber:telno]){
        Alert(@"电话号码不合法");
        return NO;
    }
    NSURL *phoneNumberURL = [NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@", telno]];
    [[UIApplication sharedApplication] openURL:phoneNumberURL];
    return YES;
}

//获取设备的mac地址
+ (NSString *)getMacAddress {
	int                    mib[6];
	size_t                 len;
	char                   *buf;
	unsigned char          *ptr;
	struct if_msghdr       *ifm;
	struct sockaddr_dl     *sdl;
	
	mib[0] = CTL_NET;
	mib[1] = AF_ROUTE;
	mib[2] = 0;
	mib[3] = AF_LINK;
	mib[4] = NET_RT_IFLIST;
	
	if ((mib[5] = if_nametoindex("en0")) == 0) {
		printf("Error: if_nametoindex error/n");
		return NULL;
	}
	
	if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
		printf("Error: sysctl, take 1/n");
		return NULL;
	}
	
	if ((buf = malloc(len)) == NULL) {
		printf("Could not allocate memory. error!/n");
		return NULL;
	}
	
	if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        free(buf);
		printf("Error: sysctl, take 2");
		return NULL;
	}
	
	ifm = (struct if_msghdr *)buf;
	sdl = (struct sockaddr_dl *)(ifm + 1);
	ptr = (unsigned char *)LLADDR(sdl);
	NSString *outstring = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
	free(buf);
	return [outstring uppercaseString];
}

//获取系统当前语言
+ (NSString *)getCurrentSystemLanguage {
//    NSString *currentLanguage = [[NSLocale preferredLanguages] firstObject];
    NSString *currentLanguage = [[[NSBundle mainBundle] preferredLocalizations] firstObject];
    return currentLanguage;
}

//时间相关
#pragma -mark 时间相关
//获取系统当前时间
+ (NSString *)getCurrentTimeFormat:(NSString *)formatStr {
    /* YYYY-MM-dd HH:mm:ss
       YY-MM-dd-HH-mm-ss
     时间格式
     */
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:formatStr];
    NSString *ret = [formatter stringFromDate:[NSDate date]];
    return ret;
}

//根据时间戳转换成时间
+ (NSString *)timeIntervalSince1970:(NSTimeInterval)secs Format:(NSString*)formatStr {
	NSDate *date = [NSDate dateWithTimeIntervalSince1970:secs];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:formatStr];
    NSString *ret = [formatter stringFromDate:date];
    return ret;
}

//String ====> Date  （字符串转时间）
+ (NSDate *)dateFromString:(NSString *)dateString
                  Formater:(NSString *)formater {
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
    NSTimeZone *zone = [NSTimeZone localTimeZone];
    [dateFormater setDateFormat:formater];
    [dateFormater setTimeZone:zone];
    NSDate *date = [dateFormater dateFromString:dateString];
    return date;
}

//Date =====> String （时间转字符串）
+ (NSString *)stringFromDate:(NSDate *)date
                    Formater:(NSString *)formater {
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
    [dateFormater setDateFormat:formater];
    NSString *dateString = [dateFormater stringFromDate:date];
    return dateString;
}

//距离现在的天、时、分、秒
+ (NSString *)compareCurrentTime:(NSTimeInterval) interval {
    int timeInterval = fabs(interval) / 1000;
    int daySec  = 60 * 60 * 24;
    int hourSec = 60 * 60;
    int tmpDay, tmpHour;
    NSMutableString *result = [NSMutableString string];
    if (timeInterval / daySec > 0) {
        tmpDay = timeInterval / daySec;
        [result appendFormat:@"%d天", tmpDay];
        if ((timeInterval % daySec) / hourSec > 0) {
            tmpHour = (timeInterval % daySec) / hourSec;
            [result appendFormat:@"%d时", tmpHour];
        }
    } else {
        if (timeInterval / hourSec > 0) {
            tmpHour = timeInterval / hourSec;
            if (timeInterval % hourSec == 0) {
                [result appendFormat:@"%d时", tmpHour];
            } else {
                [result appendFormat:@"%d.5时", tmpHour];
            }
        } else {
            [result appendString:@"0.5时"];
        }
    }
    return  result;
}

//重新调整时间
+ (NSDate *)reSetCurrentDate:(NSDate *)date {
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:date];
    return [date dateByAddingTimeInterval:interval];
}

//正则匹配
#pragma -mark 正则匹配
//电话号码合法性检查
+ (BOOL)isMobileNumber:(NSString *)mobileNum {
    //入参检查
    if([mobileNum containsString:@"-"]) {
        [mobileNum stringByReplacingOccurrencesOfString:@"-" withString:@""];
    }
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,181,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     * 增加：14开头的号码
     */
    NSString * MOBILE = @"^1(3[0-9]|4[0-9]|5[0-35-9]|8[0125-9])\\d{8}$";
    
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189
     22         */
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    NSPredicate *regextestphs = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", PHS];
    
    if (([regextestmobile evaluateWithObject:mobileNum])|| ([regextestcm evaluateWithObject:mobileNum])|| ([regextestct evaluateWithObject:mobileNum])|| ([regextestcu evaluateWithObject:mobileNum]) || ([regextestphs evaluateWithObject:mobileNum])) {
        return YES;
    } else {
        return NO;
    }
}

//邮箱合法性
+ (BOOL)isEmail:(NSString *)emailAddress {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:emailAddress];
}

+ (BOOL)isCharacter:(NSString *)characterNum {
    NSMutableCharacterSet *letterBase = [NSMutableCharacterSet letterCharacterSet];   //字母
    NSCharacterSet *decimalDigit = [NSCharacterSet decimalDigitCharacterSet];   //十进制数字
    [letterBase formUnionWithCharacterSet:decimalDigit];    //字母加十进制
    [letterBase invert];
    NSRange userNameRange = [characterNum rangeOfCharacterFromSet:letterBase];
    if (userNameRange.location != NSNotFound) {
        return YES;
    } else{
        return NO;
    }
}

//是否纯数字
+ (BOOL)isAllNum:(NSString *)string {
    if([Common isEmptyString:string]){
        return NO;
    }
    unichar c;
    for (int i = 0; i < string.length; i++) {
        c = [string characterAtIndex:i];
        if (!isdigit(c)) {
            return NO;
        }
    }
    return YES;
}

//判断是否包含汉字
+ (BOOL)isContantChineseString:(NSString *)string {
    for (int i = 0; i < string.length; i++) {
        int chr = [string characterAtIndex:i];
        if (chr >= 0x4e00 && chr <= 0x9fff) {
            return YES;
        }
    }
    return NO;
}

//查找子串
+ (BOOL)string:(NSString *)srcStr ContainSubString:(NSString *)subStr {
    if ([Common isEmptyString:srcStr] ||
        [Common isEmptyString:subStr]) {
        return NO;
    }
    BOOL isContain = NO;
    if(isIOS8) {
        isContain = [srcStr containsString:subStr];
    } else {
        if([srcStr rangeOfString:subStr].location == NSNotFound) {
            isContain = NO;
        } else {
            isContain = YES;
        }
    }
    return isContain;
}

// 计算团队名字
+ (NSString *)caculateTeamText:(NSString *)name {
    if ([Common isEmptyString:name]) {
        return NullString;
    }
    if (name.length == 1) {
        return [name uppercaseString];
    } else {
        int chr = [name characterAtIndex:0];
        if (chr >= 0x4e00 && chr <= 0x9fff) {
            return [name substringToIndex:1];
        } else {
            int chr2 = [name characterAtIndex:1];
            if (chr2 >= 0x4e00 && chr2 <= 0x9fff) {
                return [[name substringToIndex:1] uppercaseString];
            } else {
                return [NSString stringWithFormat:@"%@%@",[[name substringToIndex:1] uppercaseString], [[name substringWithRange:NSMakeRange(1, 1)] lowercaseString]];
            }
        }
    }
}

//加密解密
#pragma -mark 加密解密
//创建uuid
+ (NSString *)createOneUUID {
//    //1.cfuuid
//    CFUUIDRef cfuuid = CFUUIDCreate(kCFAllocatorDefault);
//    NSString *cfuuidString = (NSString *)CFBridgingRelease(CFUUIDCreateString(kCFAllocatorDefault, cfuuid));
//    return [cfuuidString stringByReplacingOccurrencesOfString:@"-" withString:NullString];
    //2.nsuuid
    NSString *uuid = [[NSUUID UUID] UUIDString];
    return  [[uuid stringByReplacingOccurrencesOfString:@"-" withString:NullString] lowercaseString];
}

//字符串转字节流
+ (NSData *)hexToBytesByString:(NSString *)byteString{
    NSMutableData *mData = [NSMutableData data];
    int idx = 0;
    for (;idx + 2 <= byteString.length; idx += 2) {
        NSRange range = NSMakeRange(idx, 2);
        NSString *hexStr = [byteString substringWithRange:range];
        NSScanner *scanner = [NSScanner scannerWithString:hexStr];
        unsigned int intValue;
        [scanner scanHexInt:&intValue];
        [mData appendBytes:&intValue length:1];
    }
    return mData;
}

//创建文件id
+ (NSString *)createFileIdByDate:(NSDate *)date FileSize:(NSNumber *)fSize FileExt:(NSString *)fExt FileData:(NSData *)fData {
    NSString *fileId = [NSString stringWithFormat:@"%@-%@-%@.%@",[Common stringFromDate:date Formater:@"yyyyMMddHHmmss"],[Common creatFileMD5:fData],@(fData.length),fExt];
    fileId = [fileId stringByReplacingOccurrencesOfString:@":" withString:NullString];
    return fileId;
}

//创建图片文件id
+ (NSString *)createImageFileIdByDate:(NSDate *)date FileSize:(NSNumber *)fSize FileExt:(NSString *)fExt FileData:(NSData *)fData; {
    NSString *fileId = [NSString stringWithFormat:@"%@-%@-%@.%@",[Common stringFromDate:date Formater:@"yyyyMMddHHmmss"],[Common creatFileMD5:fData],@(fData.length),fExt];
    fileId = [fileId stringByReplacingOccurrencesOfString:@":" withString:NullString];
    return fileId;
}

+ (NSString *)creatFileMD5:(NSData *)fileData {
    NSString *imgString = [NSString stringWithFormat:@"%@",fileData];
    imgString = [imgString stringByReplacingOccurrencesOfString:@" " withString:NullString];
    imgString = [imgString stringByReplacingOccurrencesOfString:@"<" withString:NullString];
    imgString = [imgString stringByReplacingOccurrencesOfString:@">" withString:NullString];
    return [imgString MD5Hash];
}

//字符串处理
#pragma -mark 字符串处理
//过滤HTML标签
+ (NSString *)flattenHTML:(NSString *)html {
	if (!html) {
		return nil;
	}
    NSScanner *theScanner;
    NSString *text = nil;
    
    theScanner = [NSScanner scannerWithString:html];
    NSString *ret = [NSString stringWithString:html];
    
    while (![theScanner isAtEnd]) {
        // find start of tag
        [theScanner scanUpToString:@"<" intoString:NULL] ;
        // find end of tag
        [theScanner scanUpToString:@">" intoString:&text] ;
        // replace the found tag with a space
        //(you can filter multi-spaces out later if you wish)
        ret = [ret stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>", text]
                                             withString:@" "];
        //过滤&nbsp;
        ret = [ret stringByReplacingOccurrencesOfString:@"&nbsp;"
                                             withString:@" "];
    }
    return ret;
}

//字符串为空检查
+ (BOOL)isEmptyString:(NSString *)sourceStr {
    if ((NSNull *)sourceStr == [NSNull null]) {
        return YES;
    }
    if (sourceStr == NULL) {
        return YES;
    }
    if (sourceStr == nil) {
        return YES;
    }
    if ([sourceStr isEqualToString:NullString]) {
        return YES;
    }
    if (sourceStr.length == 0) {
        return YES;
    }
    if ([sourceStr isEqualToString:@"null"]) {
        return YES;
    }
    return NO;
}

//判断空值，如果为空，就返回字符串 @""
+ (id)isNull:(NSString *)object_1
{
    if ([Common isEmptyString:object_1]) {
        return NullString;
    }
    else
    {
        return object_1;
    }
}

//滤掉前后空格
+ (NSString *)stringWithoutTrimmingCharacters:(NSString *)srcString {
    if(![Common isEmptyString:srcString]) {
       return [srcString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    }
    return srcString;
}

//UI相关
#pragma -mark UI相关
//去除UITableView多余分割线
+ (void)removeExtraCellLines:(UITableView *)tableView {
    UIView *view = [UIView new];
    view.backgroundColor = ClearColor;
    [tableView setTableFooterView:view];
}

//生成BarItem
+ (UIBarButtonItem *)createBarItemWithTitle:(NSString *)name
                                     Nimage:(UIImage *)nImg
                                     Himage:(UIImage *)hImg
                                       Size:(CGSize)size
                                   Selector:(void (^)())block {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, size.width, size.height);
    [btn handleControlEvent:UIControlEventTouchUpInside withBlock:block];
    [btn setBackgroundImage:nImg
                   forState:UIControlStateNormal];
    [btn setBackgroundImage:hImg
                   forState:UIControlStateHighlighted];
    if (![Common isEmptyString:name]) {
        [btn setTitle:name
             forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor]
                  forState:UIControlStateNormal];
        [btn.titleLabel setFont:Font(16.0)];
        [btn sizeToFit];
    }
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    return barItem;
}

//生成BarItem
+ (UIBarButtonItem *)createBarItemBySELWithTitle:(NSString *)name
                                          Nimage:(UIImage *)nImg
                                          Himage:(UIImage *)hImg
                                            Size:(CGSize)size
                                        Selector:(SEL)selector
                                          Target:(id)target {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, size.width, size.height);
    [btn addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    [btn setBackgroundImage:nImg
                   forState:UIControlStateNormal];
    [btn setBackgroundImage:hImg
                   forState:UIControlStateHighlighted];
    if (![Common isEmptyString:name]) {
        [btn setTitle:name
             forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor]
                  forState:UIControlStateNormal];
        [btn.titleLabel setFont:Font(16.0)];
        [btn sizeToFit];
    }
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    return barItem;
}


+ (UIBarButtonItem *)createBackBarButton:(NSString *)name
                                Selector:(void(^)())block {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 24, 24);
    [btn handleControlEvent:UIControlEventTouchUpInside withBlock:block];
    [btn setImage:Image(@"returnIcon.png")
                   forState:UIControlStateNormal];
    [btn setImage:Image(@"returnIcon.png")
                   forState:UIControlStateHighlighted];
    if (![Common isEmptyString:name]) {
        [btn setTitle:name
             forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor]
                  forState:UIControlStateNormal];
        [btn.titleLabel setFont:Font(16.0)];
        [btn sizeToFit];
    }
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    return barItem;
}

+ (UIBarButtonItem *)createBoardBackBarButton:(NSString *)name
                                Selector:(void(^)())block {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 24, 24);
    [btn handleControlEvent:UIControlEventTouchUpInside withBlock:block];
    [btn setImage:Image(@"boardreturnIcon")
         forState:UIControlStateNormal];
    [btn setImage:Image(@"boardreturnIcon")
         forState:UIControlStateHighlighted];
    if (![Common isEmptyString:name]) {
        [btn setTitle:name
             forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor]
                  forState:UIControlStateNormal];
        [btn.titleLabel setFont:Font(16.0)];
        [btn sizeToFit];
    }
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    return barItem;
}

//通过长宽和最小长度获取改变后的长宽
+ (CGSize)sizeWith:(CGSize)oldSize withMin:(CGFloat)minLen {
    BOOL isWidth = YES;
    if (oldSize.height < oldSize.width) {
        isWidth = NO;
    }
    CGFloat minOfsize = MIN(oldSize.height, oldSize.width);
    CGFloat scale = minOfsize / minLen;
    
    CGSize retSize;
    
    if (isWidth) {
        retSize.width = minLen;
        retSize.height = oldSize.height / scale;
    } else {
        retSize.height = minLen;
        retSize.width = oldSize.width / scale;
    }
    
    return  retSize;
}

//改变图片大小
+ (UIImage*)scaleImage:(UIImage*)image
                toSize:(CGSize)newSize {
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+ (UIImage*)imageByScalingAndCroppingForSize:(UIImage*)anImage toSize:(CGSize)targetSize
{
    UIImage* sourceImage = anImage;
    UIImage* newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);
    
    if (CGSizeEqualToSize(imageSize, targetSize) == NO) {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor) {
            scaleFactor = widthFactor; // scale to fit height
        } else {
            scaleFactor = heightFactor; // scale to fit width
        }
        scaledWidth = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor) {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        } else if (widthFactor < heightFactor) {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    UIGraphicsBeginImageContext(targetSize); // this will crop
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if (newImage == nil) {
        NSLog(@"could not scale image");
    }
    
    // pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}


//等比压缩图片
+ (UIImage *)scaleImage:(UIImage *)image
                toScale:(CGFloat)scaleSize {
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width * scaleSize, image.size.height * scaleSize));
    [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height * scaleSize)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

//截屏成UIImageView图片
+ (UIImageView *)cutScreenImage {
    UIGraphicsBeginImageContextWithOptions(SingletonApplication.keyWindow.frame.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [SingletonApplication.keyWindow.layer renderInContext:context];
    UIImage *cutImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImageView *imgV = [[UIImageView alloc] initWithFrame:SingletonApplication.keyWindow.bounds];
    imgV.image = cutImage;
    return imgV;
}


//绘制圆形Image
+ (UIImage*)circleImage:(UIImage*)image withParam:(CGFloat) inset {
    UIGraphicsBeginImageContext(image.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 2);
    CGContextSetStrokeColorWithColor(context, [UIColor clearColor].CGColor);
    CGRect rect = CGRectMake(inset, inset, image.size.width - inset * 2.0f, image.size.height - inset * 2.0f);
    CGContextAddEllipseInRect(context, rect);
    CGContextClip(context);
    
    [image drawInRect:rect];
    CGContextAddEllipseInRect(context, rect);
    CGContextStrokePath(context);
    UIImage *newimg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newimg;
}

//生成自己绘制的图片
+ (UIImage *)drawImageSize:(CGSize)size
                     Color:(UIColor *)color {
    UIGraphicsBeginImageContextWithOptions(size, 0, [UIScreen mainScreen].scale);
    [color set];
    UIRectFill(Frame(0, 0, size.width, size.height));
    UIImage *resImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resImg;
}

//根据16进制显示颜色
+ (UIColor *)colorFromHexRGB:(NSString *)inColorString {
    UIColor *result = nil;
    unsigned int colorCode = 0;
    unsigned char redByte, greenByte, blueByte;
    if (![Common isEmptyString:inColorString]) {
        NSScanner *scanner = [NSScanner scannerWithString:inColorString];
        (void) [scanner scanHexInt:&colorCode]; // ignore error
    }
    redByte = (unsigned char) (colorCode >> 16);
    greenByte = (unsigned char) (colorCode >> 8);
    blueByte = (unsigned char) (colorCode); // masks off high bits
    result = [UIColor
              colorWithRed: (float)redByte / 0xff
                     green: (float)greenByte/ 0xff
                      blue: (float)blueByte / 0xff
                     alpha: 1.0];
    return result;
}

//加载动画
+ (void)animationImageView:(UIImageView *)imgV Images:(NSArray *)imgs {
    if (imgV && imgs && imgs.count != 0) {
        imgV.animationImages = [NSArray arrayWithArray:imgs];
        //设置动画总时间
        imgV.animationDuration = 1.0;
        //设置重复次数，0表示不重复
        imgV.animationRepeatCount = 0;
        //开始动画
        [imgV startAnimating];
    }
}

//绘制下划线
+ (UIImageView *)addBottomLineWithYpos:(float)yPos {
    UIImageView *lineImgV = [[UIImageView alloc] initWithFrame:Frame(0, yPos, Screen_Width, minLineWidth)];
    lineImgV.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.7];
    if (isIPad && !isRetina_iPad) {
        SetFrameByHeight(lineImgV.frame, 1.0);
    }
    return lineImgV;
}

//自定义push动画
+ (void)customPushAnimationFromNavigation:(UINavigationController *)nav ToViewController:(UIViewController *)vc {
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3f;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionMoveIn;
    transition.subtype = kCATransitionFromTop;
    [nav.view.layer addAnimation:transition forKey:nil];
    [nav pushViewController:vc animated:NO];

}

//自定义pop动画
+ (void)customPopAnimationFromNavigation:(UINavigationController *)nav {
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3f;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionReveal;
    transition.subtype = kCATransitionFromBottom;
    [nav.view.layer addAnimation:transition forKey:nil];
    [nav popViewControllerAnimated:NO];
}

/*
animation.type = kCATransitionFade;
animation.type = kCATransitionPush;
animation.type = kCATransitionReveal;
animation.type = kCATransitionMoveIn;
animation.type = @"cube";
animation.type = @"suckEffect";
animation.type = @"oglFlip";
animation.type = @"rippleEffect";
animation.type = @"pageCurl";
animation.type = @"pageUnCurl";
animation.type = @"cameraIrisHollowOpen";
animation.type = @"cameraIrisHollowClose";
*/

@end
