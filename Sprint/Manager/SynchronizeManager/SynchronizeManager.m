//
//  SynchronizeManager.m
//  Sprint
//
//  Created by xxcao on 16/1/19.
//  Copyright © 2016年 xxcao. All rights reserved.
//

#import "SynchronizeManager.h"
#import "DataManager.h"
#import "STDbObject.h"

@implementation SynchronizeManager

//放置线程中去做
+ (BOOL)synchronizeTotalData:(NSArray *)serverDatas
                   LocalData:(NSArray *)localDatas
                   TableName:(NSString *)tableName
                  PrimaryKey:(NSString *)primaryKey{
    //本地主键ids
    NSSet *localSet = [NSSet setWithArray:localDatas];
    //服务器主键ids
    NSSet *serverSet = [NSSet setWithArray:serverDatas];

    NSMutableSet *localCopySet = [localSet mutableCopy];
    [localCopySet intersectSet:serverSet];
    if (localCopySet.count == 0) {
        //无交集，先delete 后insert
        [DataManager removeDatasFromTable:tableName];
        [serverDatas enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            STDbObject *tmpObject = nil;
            if ([obj isKindOfClass:[NSDictionary class]]) {
                tmpObject = [[STDbObject alloc] init];
                [tmpObject objcFromDictionary:obj];
            } else {
                tmpObject = (STDbObject *)obj;
            }
            [DataManager insertData:tmpObject IntoTable:tableName];
        }];
    } else {
        //有交集，并且交集为 localCopySet
        NSMutableSet *localCopy2Set = [localSet mutableCopy];
        [localCopy2Set minusSet:serverSet];
        
        //
        NSMutableSet *serverCopy2Set = [serverSet mutableCopy];
        [serverCopy2Set minusSet:localSet];

        if (localCopy2Set.count != 0) {
            //删除差集
            [localCopy2Set enumerateObjectsUsingBlock:^(id  _Nonnull obj, BOOL * _Nonnull stop) {
                [DataManager removeDatasWhere:[NSString stringWithFormat:@"%@=%@",primaryKey,obj] FromTable:tableName];
            }];
        }
        
        if (serverCopy2Set.count != 0) {
            //插入新值
            NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(id  _Nonnull evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
                id value = [evaluatedObject valueForKey:primaryKey];
                return [serverCopy2Set containsObject:value];
            }];
            NSArray *insertArray = [serverDatas filteredArrayUsingPredicate:predicate];
            //插入
           [insertArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
               STDbObject *tmpObject = nil;
               if ([obj isKindOfClass:[NSDictionary class]]) {
                   tmpObject = [[STDbObject alloc] init];
                   [tmpObject objcFromDictionary:obj];
               } else {
                   tmpObject = (STDbObject *)obj;
               }
               [DataManager insertData:tmpObject IntoTable:tableName];
           }];
        }
        //更新交集
        NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(id  _Nonnull evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
            id value = [evaluatedObject valueForKey:primaryKey];
            return [localCopySet containsObject:value];
        }];
        NSArray *array = [serverDatas filteredArrayUsingPredicate:predicate];
        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            STDbObject *tmpObject = nil;
            if ([obj isKindOfClass:[NSDictionary class]]) {
                tmpObject = [[STDbObject alloc] init];
                [tmpObject objcFromDictionary:obj];
            } else {
                tmpObject = (STDbObject *)obj;
            }
            [DataManager updateData:tmpObject IntoTable:tableName];
        }];
    }
    return YES;
}

+ (BOOL)synchronizeIncreasingData:(NSArray *)serverDatas
                        TableName:(NSString *)tableName
                       PrimaryKey:(NSString *)primaryKey {
    [serverDatas enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        STDbObject *tmpObject = nil;
        if ([obj isKindOfClass:[NSDictionary class]]) {
            tmpObject = [[STDbObject alloc] init];
            [tmpObject objcFromDictionary:obj];
        } else {
            tmpObject = (STDbObject *)obj;
        }
        BOOL insertSuccess = [DataManager insertData:tmpObject IntoTable:tableName];
        if (!insertSuccess) {
            [DataManager removeDatasWhere:[NSString stringWithFormat:@"%@=%@",primaryKey,[tmpObject valueForKey:primaryKey]] FromTable:tableName];
            [DataManager insertData:tmpObject IntoTable:tableName];
        };
    }];
    return YES;
}

@end
