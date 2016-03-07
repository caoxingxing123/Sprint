//
//  DataManager.m
//  MEAPLite
//
//  Created by xxcao on 14-8-5.
//
//

#import "DataManager.h"
#import "STDbHandle.h"
@implementation DataManager


//从外部导入数据库
+ (void)importToDB:(NSString *)dbPathName {
    [STDbHandle importDb:dbPathName];
}

//从某一表中查询数据
+ (id)getDatasFromTable:(NSString *)dbTableName {
    Class class = NSClassFromString(dbTableName);
    id data = [class allDbObjects];
    return data;
}

//从某一表中插入数据
+ (BOOL)insertData:(id)data IntoTable:(NSString *)dbTableName {
    STDbObject *object = (STDbObject *)data;
    return [object insertToDb];
}

//从某一表中更新数据
+ (BOOL)updateData:(id)data IntoTable:(NSString *)dbTableName {
    STDbObject *object = (STDbObject *)data;
    return [object updatetoDb];
}

//从某一表中删除某条数据
+ (BOOL)deleteData:(id)data FromTable:(NSString *)dbTableName {
    STDbObject *object = (STDbObject *)data;
    return [object removeFromDb];
}

//删除数据
+ (BOOL)removeDatasFromTable:(NSString *)dbTableName {
    Class class = NSClassFromString(dbTableName);
    return[class removeDbObjectsWhere:@"all"];
}

//从某一表中根据条件查询数据
+ (id)selectDatasWhere:(NSString *)condition
                 Order:(NSString *)order
             FromTable:(NSString *)dbTableName {
    Class class = NSClassFromString(dbTableName);
    return [class dbObjectsWhere:condition orderby:order];
}

//从某一表中根据条件查询数据
+ (id)selectDatasWhere:(NSString *)condition
                 Order:(NSString *)order
                 Limit:(int)limit
                 Offset:(int)offset
             FromTable:(NSString *)dbTableName {
    Class class = NSClassFromString(dbTableName);
    return [class dbObjectsWhere:condition orderby:order limit:limit offset:offset];
}


//从某一表中根据条件删除数据
+ (BOOL)removeDatasWhere:(NSString *)condition
               FromTable:(NSString *)dbTableName {
    Class class = NSClassFromString(dbTableName);
    return [class removeDbObjectsWhere:condition];
}

//执行sqlite语句
+ (BOOL)execSqlite3:(NSString *)sqliteString Table:(NSString *)dbTableName{
    Class class = NSClassFromString(dbTableName);
    return [class execSqlite3:sqliteString];
}

//执行sqlite语句
+ (id)selectSqlite3:(NSString *)sqliteString Table:(NSString *)dbTableName {
    Class class = NSClassFromString(dbTableName);
    return [class selectSqlite3:sqliteString];
}

//获取count(*)
+ (int)caculateCountSqlite3:(NSString *)sqliteString Table:(NSString *)dbTableName {
    Class class = NSClassFromString(dbTableName);
    return [class caculateCountSqlite3:sqliteString];
}

//获取sum(*)
+ (long long)caculateSumSqlite3:(NSString *)sqliteString Table:(NSString *)dbTableName {
    Class class = NSClassFromString(dbTableName);
    return [class caculateSumSqlite3:sqliteString];
}

//执行sql语句（多表查询）返回数组。
+ (id)selectCountSqlite3Data:(NSString *)sqliteString
{
    
    return [[STDbHandle shareDb] selectSqlite3Data:sqliteString];
}

//事物操作
+ (void)beginEventToDB {
    if (![STDbHandle isOpened]) {
        [STDbHandle openDb];
    }
    if (gisTransaction) {
        return;
    }
    char *errorMsg;
    sqlite3_exec([[STDbHandle shareDb] sqlite3DB], "BEGIN", NULL, NULL, &errorMsg);
    gisTransaction = YES;
}

+ (void)commitEventToDB {
    if (![STDbHandle isOpened]) {
        return;
    }
    char *errorMsg;
    sqlite3_exec([[STDbHandle shareDb] sqlite3DB], "COMMIT", NULL, NULL, &errorMsg);
    [STDbHandle closeDb];
}

+ (void)rollbackEventToDB {
    if (![STDbHandle isOpened]) {
        return;
    }
    char *errorMsg;
    sqlite3_exec([[STDbHandle shareDb] sqlite3DB], "ROLLBACK", NULL, NULL, &errorMsg);
    [STDbHandle closeDb];
}

+ (void)runInTransation:(DBBlock)stdbBlock {
    STDbHandle *stbHandle = [STDbHandle shareDb];
    @synchronized(stbHandle){
        [DataManager beginEventToDB];
        if (stdbBlock()) {
            [DataManager commitEventToDB];
        } else {
            [DataManager rollbackEventToDB];
        }
    }
}

@end
