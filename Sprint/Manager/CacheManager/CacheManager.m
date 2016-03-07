//
//  CacheManager.m
//  Sprint
//
//  Created by xxcao on 16/1/7.
//  Copyright © 2016年 xxcao. All rights reserved.
//

#import "CacheManager.h"
#import "DataManager.h"
@implementation CacheManager

static CacheManager *singleton = nil;
+ (id)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singleton = [[CacheManager alloc] init];
        //内存缓存
        singleton.memoryCache = [[NSCache alloc] init];
        //文件缓存路径
        NSString *createFilePath = [NSString stringWithFormat:@"%@/FileCache", [CacheManager docPath]];
        [CacheManager createFilePath:createFilePath];
        singleton.fileDirectory = createFilePath;
    });
    return singleton;
}

//取
- (id)getCacheWithKey:(NSString *)cacheKey Info:(id)info CacheType:(ECacheType)cacheType {
    NSAssert([Common isEmptyString:cacheKey], @"cacheKey must not be nil");
    if (cacheType == ECacheTypeMemory) {
        if (self.memoryCache) {
            id value = [self.memoryCache objectForKey:cacheKey];
            return value;
        }
    } else if (cacheType == ECacheTypeDisk) {
        if ([Common string:cacheKey ContainSubString:TYPE_TABLENAME_KEY]) {
            //from database
            //expand here
            if (info) {
                NSArray *results = [DataManager selectSqlite3:info Table:cacheKey];
                return results;
            } else {
                NSArray *results = [DataManager getDatasFromTable:cacheKey];
                return results;
            }
        } else if ([Common string:cacheKey ContainSubString:TYPE_CUSTOM_KEY]){
            //from userfefaults
            id value = UserDefaultsGet(cacheKey);
            return value;
        } else {
            //file
            NSString *filePath = [NSString stringWithFormat:@"%@/%@",self.fileDirectory,cacheKey];
            NSData *data = [NSData dataWithContentsOfFile:filePath options:NSDataReadingMappedIfSafe error:nil];
            return data;
        }
    }
    return nil;
}

//存
- (BOOL)saveCacheWithKey:(NSString *)cacheKey Object:(id)object Info:(id)info CacheType:(ECacheType)cacheType IsExist:(BOOL)isExist {
    NSAssert([Common isEmptyString:cacheKey], @"cacheKey must not be nil");
    if (cacheType == ECacheTypeMemory) {
        if (self.memoryCache && object) {
            [self.memoryCache setObject:object forKey:cacheKey];
        }
    } else if (cacheType == ECacheTypeDisk) {
        if ([Common string:cacheKey ContainSubString:TYPE_TABLENAME_KEY]) {
            //expand here
            if (isExist) {
                //update database with sql langauge
            } else {
                //insert database with sql langauge
            }
        } else if ([Common string:cacheKey ContainSubString:TYPE_CUSTOM_KEY]){
            //from userfefaults
            if (object) {
                UserDefaultsSave(object, cacheKey);
            }
        } else {
            //file
            if (self.fileDirectory && object) {
                NSFileManager *fileManager = [NSFileManager defaultManager];
                NSString *filePath = [NSString stringWithFormat:@"%@/%@",self.fileDirectory,cacheKey];
                if ([fileManager fileExistsAtPath:filePath]) {
                    NSError *error = nil;
                    [fileManager removeItemAtPath:filePath error:&error];
                    if (error) {
                        NSLog(@"ERROR:%@",error.description);
                    }
                }
                //先删除、后创建
                [fileManager createFileAtPath:filePath contents:object attributes:nil];
            }
        }
    }
    return YES;
}

//删除
- (BOOL)removeCacheWithKey:(NSString *)cacheKey Object:(id)object Info:(id)info CacheType:(ECacheType)cacheType {
    NSAssert([Common isEmptyString:cacheKey], @"cacheKey must not be nil");
    if (cacheType == ECacheTypeMemory) {
        if (self.memoryCache && object) {
            [self.memoryCache removeObjectForKey:cacheKey];
        }
    } else if (cacheType == ECacheTypeDisk) {
        if ([Common string:cacheKey ContainSubString:TYPE_TABLENAME_KEY]) {
            //expand here
            //remove database with sql language

        } else if ([Common string:cacheKey ContainSubString:TYPE_CUSTOM_KEY]){
            //from userfefaults
            UserDefaultsRemove(cacheKey);
        } else {
            //file
            if (self.fileDirectory && object) {
                NSFileManager *fileManager = [NSFileManager defaultManager];
                NSString *filePath = [NSString stringWithFormat:@"%@/%@",self.fileDirectory,cacheKey];
                if ([fileManager fileExistsAtPath:filePath]) {
                    NSError *error = nil;
                    [fileManager removeItemAtPath:filePath error:&error];
                    if (error) {
                        NSLog(@"ERROR:%@",error.description);
                    }
                }
            }
        }
    }
    return YES;
}

//清空
- (BOOL)clearCacheWithCacheType:(ECacheType)cacheType {
    if(cacheType == ECacheTypeMemory) {
        if (self.memoryCache) {
            [self.memoryCache removeAllObjects];
        }
    } else if (cacheType == ECacheTypeDisk) {
        //只删文件，不删数据
        //file
        if (self.fileDirectory) {
            NSFileManager *fileManager = [NSFileManager defaultManager];
            NSError *error = nil;
            NSArray *subPaths = [fileManager subpathsOfDirectoryAtPath:self.fileDirectory error:&error];
            if (error) {
                NSLog(@"subpath ERROR:%@",error.description);
            }
            if (subPaths && subPaths.count > 0) {
                [subPaths enumerateObjectsUsingBlock:^(id  _Nonnull specificFileName, NSUInteger idx, BOOL * _Nonnull stop) {
                    NSString *filePath = [NSString stringWithFormat:@"%@/%@",self.fileDirectory,specificFileName];
                    if ([fileManager fileExistsAtPath:filePath]) {
                        NSError *error = nil;
                        [fileManager removeItemAtPath:filePath error:&error];
                        if (error) {
                            NSLog(@"remove file ERROR:%@",error.description);
                        }
                    }
                }];
            }
        }
    }
    return YES;
}

#pragma -mark
//only for file cache
- (CGFloat)cacheSize {
    //file size
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;
    NSArray *subPaths = [fileManager subpathsOfDirectoryAtPath:self.fileDirectory error:&error];
    if (error) {
        NSLog(@"subpath ERROR:%@",error.description);
    }
    __block long long sumSize = 0;
    if (subPaths && subPaths.count > 0) {
        [subPaths enumerateObjectsUsingBlock:^(id  _Nonnull objName, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *filePath = [NSString stringWithFormat:@"%@/%@",self.fileDirectory,objName];
            NSError *error = nil;
            long long tmpSumSize = [[fileManager attributesOfItemAtPath:filePath
                                                                  error:&error] fileSize];
            if (error) {
                NSLog(@"file size ERROR:%@",error.description);
            }
            if (tmpSumSize > 0) {
                sumSize += tmpSumSize;
            }
        }];
    }
    return sumSize;
}

//only for file cache
- (NSUInteger)cacheCount {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;
    //subPath contains subdirectories recursively
    NSArray *subPaths = [fileManager subpathsOfDirectoryAtPath:self.fileDirectory error:&error];
    if (error) {
        NSLog(@"subpath ERROR:%@",error.description);
    }
    return subPaths.count;
}

#pragma -mark
#pragma -mark  沙盒目录
+ (NSString *)homePath {
    return NSHomeDirectory();
}

+ (NSString *)docPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [paths objectAtIndex:0];
}

+ (NSString *)libCachePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    return [[paths objectAtIndex:0] stringByAppendingFormat:@"/Caches"];
}

+ (NSString *)tmpPath
{
    return [NSHomeDirectory() stringByAppendingFormat:@"/tmp"];
}

+ (BOOL)createFilePath:(NSString *)path
{
    if (![[NSFileManager defaultManager] fileExistsAtPath:path])
    {
        return [[NSFileManager defaultManager] createDirectoryAtPath:path
                                         withIntermediateDirectories:YES
                                                          attributes:nil
                                                               error:NULL];
        
    }
    return NO;
}

@end
