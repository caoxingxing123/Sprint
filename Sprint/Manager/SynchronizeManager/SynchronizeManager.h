//
//  SynchronizeManager.h
//  Sprint
//
//  Created by xxcao on 16/1/19.
//  Copyright © 2016年 xxcao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SynchronizeManager : NSObject

+ (BOOL)synchronizeTotalData:(NSArray *)serverDatas
                   LocalData:(NSArray *)localDatas
                   TableName:(NSString *)tableName
                  PrimaryKey:(NSString *)primaryKey;

+ (BOOL)synchronizeIncreasingData:(NSArray *)serverDatas
                        TableName:(NSString *)tableName
                       PrimaryKey:(NSString *)primaryKey;

@end
