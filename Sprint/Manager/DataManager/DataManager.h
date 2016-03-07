//
//  DataManager.h
//  MEAPLite
//
//  Created by xxcao on 14-8-5.
//
//
#import <Foundation/Foundation.h>
typedef BOOL(^DBBlock)(void);

@interface DataManager : NSObject


//从外部导入数据库
+ (void)importToDB:(NSString *)dbPathName;

//从某一表中查询数据
+ (id)getDatasFromTable:(NSString *)dbTableName;

//从某一表中插入数据
+ (BOOL)insertData:(id)data IntoTable:(NSString *)dbTableName;

//从某一表中更新数据
+ (BOOL)updateData:(id)data IntoTable:(NSString *)dbTableName;

//从某一表中删除某条数据
+ (BOOL)deleteData:(id)data FromTable:(NSString *)dbTableName;

//从某一表中清空数据
+ (BOOL)removeDatasFromTable:(NSString *)dbTableName;

//从某一表中根据条件查询数据
+ (id)selectDatasWhere:(NSString *)condition
                 Order:(NSString *)order
             FromTable:(NSString *)dbTableName;

//从某一表中根据条件查询数据
+ (id)selectDatasWhere:(NSString *)condition
                 Order:(NSString *)order
                 Limit:(int)limit
                Offset:(int)offset
             FromTable:(NSString *)dbTableName;

//从某一表中根据条件删除数据
+ (BOOL)removeDatasWhere:(NSString *)condition
               FromTable:(NSString *)dbTableName;

//执行sqlite语句
+ (BOOL)execSqlite3:(NSString *)sqliteString Table:(NSString *)dbTableName;
//查询sqlite语句
+ (id)selectSqlite3:(NSString *)sqliteString Table:(NSString *)dbTableName;
//获取count(*)
+ (int)caculateCountSqlite3:(NSString *)sqliteString Table:(NSString *)dbTableName;
//获取sum(*)
+ (long long)caculateSumSqlite3:(NSString *)sqliteString Table:(NSString *)dbTableName;
//执行sql语句（多表查询）返回数组。
+ (id)selectCountSqlite3Data:(NSString *)sqliteString;
//事物操作
+ (void)beginEventToDB;
+ (void)commitEventToDB;
+ (void)rollbackEventToDB;
//在事物中同步数据
+ (void)runInTransation:(DBBlock) stdbBlock;

@end
