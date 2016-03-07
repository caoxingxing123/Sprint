//
//  DBHelper.h
//  Cattle
//
//  Created by xxcao on 15/8/27.
//  Copyright (c) 2015年 xxcao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import <objc/runtime.h>

@interface DBHelper : NSObject

+ (NSString *)getDBFilePathByUserId:(NSString *)uId;

//创建数据库
+ (BOOL)creatDBByUserId:(NSString *)uId IsNeedUpdate:(BOOL)isNeedUpdate;

//检查表
+ (void)checkTable:(sqlite3*)database
         tableName:(NSString*)tableName
         allFields:(NSMutableArray*)allFields
     allFieldTypes:(NSMutableArray*)allFieldTypes
       primaryKeys:(NSMutableArray*)primaryKeys
isFieldTypeChanged:(BOOL)isFieldTypeChanged;

//移动表
+ (void)onMoveTable:(sqlite3*)database
         tableName:(NSString*)tableName
      newTableName:(NSString*)newTableName
         allFields:(NSMutableArray*)allFields
     allFieldTypes:(NSMutableArray*)allFieldTypes
hasKDbIdColumnInNewTable:(BOOL)hasKDbIdColumnInNewTable;

//创建表
+ (void)onCreateTable:(sqlite3*)database
           tableName:(NSString*)tableName
           allFields:(NSMutableArray*)allFields
       allFieldTypes:(NSMutableArray*)allFieldTypes
         primaryKeys:(NSMutableArray*)primaryKeys;


+ (int)executeCommand:(sqlite3*)db sql:(NSString*)sql;

@end
