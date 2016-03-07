//
//  SDiPhoneVersion.m
//  SDiPhoneVersion
//
//  Created by Sebastian Dobrincu on 09/09/14.
//  Copyright (c) 2014 Sebastian Dobrincu. All rights reserved.
//

#import "SDiPhoneVersion.h"

@implementation SDiPhoneVersion

+(NSDictionary*)deviceNamesByCode {
    
    static NSDictionary* deviceNamesByCode = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        deviceNamesByCode = @{
                              @"iPhone3,1" :[NSNumber numberWithInteger:iPhone4],
                              @"iPhone3,3" :[NSNumber numberWithInteger:iPhone4],
                              @"iPhone4,1" :[NSNumber numberWithInteger:iPhone4S],
                              @"iPhone5,1" :[NSNumber numberWithInteger:iPhone5],
                              @"iPhone5,2" :[NSNumber numberWithInteger:iPhone5],
                              @"iPhone5,3" :[NSNumber numberWithInteger:iPhone5C],
                              @"iPhone5,4" :[NSNumber numberWithInteger:iPhone5C],
                              @"iPhone6,1" :[NSNumber numberWithInteger:iPhone5S],
                              @"iPhone6,2" :[NSNumber numberWithInteger:iPhone5S],
                              @"iPhone7,2" :[NSNumber numberWithInteger:iPhone6],
                              @"iPhone7,1" :[NSNumber numberWithInteger:iPhone6Plus],
                              @"iPhone8,1" :[NSNumber numberWithInteger:iPhone6S],
                              @"iPhone8,2" :[NSNumber numberWithInteger:iPhone6SPlus],
                              @"i386"      :[NSNumber numberWithInteger:Simulator],
                              @"x86_64"    :[NSNumber numberWithInteger:Simulator]
                              };
    });
    
    return deviceNamesByCode;
}

+(DeviceVersion)deviceVersion {

    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *code = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    DeviceVersion version = (DeviceVersion)[[self.deviceNamesByCode objectForKey:code] integerValue];

    return version;
}

+(DeviceSize)deviceSize {
    
    CGFloat screenHeight = [[UIScreen mainScreen] bounds].size.height;
    if (screenHeight == 480)
        return iPhone35inch;
    else if(screenHeight == 568)
        return iPhone4inch;
    else if(screenHeight == 667)
        return  iPhone47inch;
    else if(screenHeight == 736)
        return iPhone55inch;
    else
        return 0;
}

+(NSString *)deviceScreen
{
    DeviceSize devs;
    CGFloat screenHeight = [[UIScreen mainScreen] bounds].size.height;
    if (screenHeight == 480)
        devs = iPhone35inch;
    else if(screenHeight == 568)
        devs = iPhone4inch;
    else if(screenHeight == 667)
        devs = iPhone47inch;
    else if(screenHeight == 736)
        devs = iPhone55inch;
    else
        devs = 0;
    
    if(devs == iPhone35inch)
        return @"iPhone35inch";
    if(devs == iPhone4inch)
        return @"iPhone4inch";
    if(devs == iPhone35inch)
        return @"iPhone35inch";
    if(devs == iPhone47inch)
        return @"iPhone47inch";
    if(devs == iPhone55inch)
        return @"iPhone55inch";
    return @"";
}
+(NSString*)deviceName {
    
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *code = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    if ([code isEqualToString:@"x86_64"] || [code isEqualToString:@"i386"]) {
        code = @"Simulator";
    }
    
    return code;
}

+(NSString*)deviceType:(DeviceVersion)version {
    switch (version) {
        case 3:{
            return @"iPhone4";
        }
        case 4:{
            return @"iPhone4S";
        }
        case 5:{
            return @"iPhone5";
        }
        case 6:{
            return @"iPhone5S";
        }
        case 7:{
            return @"iPhone6";
        }
        case 8:{
            return @"iPhone6Plus";
        }
        case 9:{
            return @"iPhone6S";
        }
        case 10:{
            return @"iPhone6SPlus";
        }
        case 0:{
            return @"Simulator";
        }
        default:{
            return NullString;
        }
    }
}

@end

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com


//----------------------机型对照--------------------------
/*
i386       on 32-bit Simulator
x86_64     on 64-bit Simulator
iPod1,1    on iPod Touch
iPod2,1    on iPod Touch Second Generation
iPod3,1    on iPod Touch Third Generation
iPod4,1    on iPod Touch Fourth Generation
iPod7,1    on iPod Touch 6th Generation

iPhone1,1  on iPhone
iPhone1,2  on iPhone 3G
iPhone2,1  on iPhone 3GS
iPhone3,1  on iPhone 4(GSM)
iPhone3,3  on iPhone 4(CDMA/Verizon/Sprint)
iPhone4,1  on iPhone 4S
iPhone5,1  on iPhone 5(model A1428, AT&T/Canada)
iPhone5,2  on iPhone 5(model A1429, everything else)
iPhone5,3  on iPhone 5c(model A1456, A1532|GSM)
iPhone5,4  on iPhone 5c(model A1507, A1516, A1526(China), A1529|Global)
iPhone6,1  on iPhone 5s(model A1433, A1533|GSM)
iPhone6,2  on iPhone 5s(model A1457, A1518, A1528(China), A1530|Global)
iPhone7,1  on iPhone 6 Plus
iPhone7,2  on iPhone 6
iPhone8,1  on iPhone 6S
iPhone8,2  on iPhone 6S Plus
 
iPad1,1    on iPad
iPad2,1    on iPad 2
iPad3,1    on 3rd Generation iPad
iPad3,4    on 4th Generation iPad
iPad2,5    on iPad Mini
iPad4,1    on 5th Generation iPad(iPad Air)-Wifi
iPad4,2    on 5th Generation iPad(iPad Air)-Cellular
iPad4,4    on 2nd Generation iPad Mini-Wifi
iPad4,5    on 2nd Generation iPad Mini-Cellular
iPad4,7    on 3rd Generation iPad Mini-Wifi(model A1599)

 */
