//
//  CacheManager.h
//  Sprint
//
//  Created by xxcao on 16/1/7.
//  Copyright © 2016年 xxcao. All rights reserved.
//

#import <Foundation/Foundation.h>

//cache key
//文件类
static NSString *const TYPE1_xxxxxxxxxxfileId_Key = @"xxxxxxxxxxxxxx.file";//不确定
//数据类
static NSString *const TYPE2_xxxxxxxxxxtableName_Key = @"xxxxxxxxxxtableName_Key";//一定含有表名
//其它类(自定义)
static NSString *const TYPE3_xxxxxxxxxxxxxxxx_Key = @"xxxxxxxxxxxxxx_Key";

#define TYPE_FILENAME_KEY    @"TYPE1"
#define TYPE_TABLENAME_KEY   @"TYPE2"
#define TYPE_CUSTOM_KEY      @"TYPE3"

#define kMAX_FILE_COUNT      500
#define kMAX_FILE_SIZE       (10 * 1024 * 1024)

typedef NS_ENUM(NSUInteger, ECacheType) {
    ECacheTypeNone = 0,//from network
    ECacheTypeMemory,
    ECacheTypeDisk,
};

@interface CacheManager : NSObject

@property(nonatomic,assign)CGFloat cacheSize;//缓存文件大小

@property(nonatomic,assign)NSUInteger cacheCount;//缓存文件个数

@property(nonatomic,assign)NSTimeInterval expireTimeInteval;//过期时间

@property(nonatomic,assign)BOOL isExpireAutoClear;//到期自动清

@property(nonatomic,assign)BOOL isNeedSecret;//是否加密

@property(nonatomic,assign)ECacheType cacheType;

@property(nonatomic,strong)NSCache *memoryCache;

@property(nonatomic,copy)NSString *fileDirectory;

#pragma -mark message
+ (id)sharedInstance;

//取
- (id)getCacheWithKey:(NSString *)cacheKey Info:(id)info CacheType:(ECacheType)cacheType;

//存
- (BOOL)saveCacheWithKey:(NSString *)cacheKey Object:(id)object Info:(id)info CacheType:(ECacheType)cacheType IsExist:(BOOL)isExist;

//删除
- (BOOL)removeCacheWithKey:(NSString *)cacheKey Object:(id)object Info:(id)info CacheType:(ECacheType)cacheType;

//清空
- (BOOL)clearCacheWithCacheType:(ECacheType)cacheType;

#pragma -mark other

@end
