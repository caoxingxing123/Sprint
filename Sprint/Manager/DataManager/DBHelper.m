//
//  DBHelper.m
//  Cattle
//
//  Created by xxcao on 15/8/27.
//  Copyright (c) 2015年 xxcao. All rights reserved.
//

#import "DBHelper.h"
#import "STDbHandle.h"
#import "MacroDef.h"
#import "Common.h"

@implementation DBHelper

+ (NSString *)getDBFilePathByUserId:(NSString *)uId {
    NSString *dbDirectory = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    if([Common isEmptyString:uId]) return nil;
    NSString *serverAddStr = UserDefaultsGet(@"UserDefaultKey_AddressApi");
    NSString *dbName = nil;
    if ([Common isEmptyString:serverAddStr]) {
        dbName = [NSString stringWithFormat:@"cattle_db_%@.db",uId];
    } else {
        dbName = [NSString stringWithFormat:@"cattle_db_%@_%@.db",serverAddStr,uId];
    }
    if(![Common isEmptyString:dbDirectory]) {
        return [NSString stringWithFormat:@"%@/%@",dbDirectory,dbName];
    }
    return nil;
}

+ (BOOL)creatDBByUserId:(NSString *)uId IsNeedUpdate:(BOOL)isNeedUpdate {
    if([Common isEmptyString:uId]) return NO;
    NSString *userDbPath = [DBHelper getDBFilePathByUserId:uId];
    sqlite3 *db;
    BOOL isNewDb = YES;
    int flags = SQLITE_OPEN_READWRITE;
    if ([[NSFileManager defaultManager] fileExistsAtPath:userDbPath]) {
        flags = SQLITE_OPEN_READWRITE;
        isNewDb = NO;
    } else {
        flags = SQLITE_OPEN_READWRITE | SQLITE_OPEN_CREATE;
    }
    
    STDbHandle *handle = [STDbHandle shareDb];
    int rc = sqlite3_open_v2([userDbPath UTF8String], &db, flags, NULL);
    if (rc == SQLITE_OK) {
        if(isNewDb)
        {
            @try {
                [self onUpgradeVersion:db userId:uId];
                NSLog(@"create db success!");
                handle.sqlite3DB = db;
                handle.currentDbPath = userDbPath;
                return YES;
            }
            @catch (NSException *exception) {
                NSLog(@"onUpgradeVersion, error:%@",exception.debugDescription);
            }
            @finally {
                
            }
            sqlite3_close(db);
            NSError *error;
            [[NSFileManager defaultManager] removeItemAtPath:userDbPath error:&error];
            return NO;
        } else {
            if (isNeedUpdate) {
                //some times need update
                [self onUpgradeVersion:db userId:uId];
            }
            NSLog(@"%@ has existed!",userDbPath);
            handle.sqlite3DB = db;
            handle.currentDbPath = userDbPath;
            return NO;
        }
    }
    else {
        NSLog(@"create db failed!");
        return NO;
    }
}


+(void)checkTable:(sqlite3*)database
        tableName:(NSString*)tableName
        allFields:(NSMutableArray*)allFields
    allFieldTypes:(NSMutableArray*)allFieldTypes
      primaryKeys:(NSMutableArray*)primaryKeys
isFieldTypeChanged:(BOOL)isFieldTypeChanged
{
    if(!database||[Common isEmptyString:tableName]||
       allFields==nil||allFields.count<=0||
       allFieldTypes==nil||allFieldTypes.count<=0||
       allFields.count!=allFieldTypes.count) return;
    
    NSString* sql=[NSString stringWithFormat:@"select * from %@ where (1=0)", tableName];
    sqlite3_stmt *stmt;
    NSString* newTableName=[NSString stringWithFormat:@"%@_tmp", tableName];
    NSString* tempText1, *tempText2;
    const char * columnName=nil;
    NSHashTable* hash=[[NSHashTable alloc] init];
    int tmpRet = sqlite3_prepare_v2(database, [sql UTF8String], -1, &stmt, NULL);
    if (tmpRet == SQLITE_OK)
    {
        int column_count = sqlite3_column_count(stmt);
        //array=[[NSMutableArray alloc] init];
        for(int i=0;i<column_count;i++)
        {
            columnName= sqlite3_column_name(stmt, i);
            NSString* nsColumnName=[NSString stringWithUTF8String:columnName];
            [hash addObject:nsColumnName];
        }
        
        for(int i=0;i<allFields.count;i++)
        {
            tempText1=[allFields objectAtIndex:i];
            tempText2=[allFieldTypes objectAtIndex:i];
            if(![hash containsObject:tempText1]){
                sql=[NSString stringWithFormat:@"alter table %@ add column %@ %@", tableName, tempText1,tempText2];
                [DBHelper executeCommand:database sql:sql];
            }
        }
        
        if(isFieldTypeChanged)
        {
            [self onCreateTable:database tableName:newTableName allFields:allFields allFieldTypes:allFieldTypes primaryKeys:primaryKeys];
            [self onMoveTable:database tableName:tableName newTableName:newTableName allFields:allFields allFieldTypes:allFieldTypes hasKDbIdColumnInNewTable:YES];
            sql=[NSString stringWithFormat:@"drop table %@",tableName];
            [DBHelper executeCommand:database sql:sql];
            sql=[NSString stringWithFormat:@"alter table %@ rename to %@", newTableName, tableName];
            [DBHelper executeCommand:database sql:sql];
        }
    }
    else{
        [self onCreateTable:database tableName:tableName allFields:allFields allFieldTypes:allFieldTypes primaryKeys:primaryKeys];
    }
}

+(void)onMoveTable:(sqlite3*)database
         tableName:(NSString*)tableName
      newTableName:(NSString*)newTableName
         allFields:(NSMutableArray*)allFields
     allFieldTypes:(NSMutableArray*)allFieldTypes
hasKDbIdColumnInNewTable:(BOOL)hasKDbIdColumnInNewTable
{
    NSInteger index=[allFields indexOfObject:kDbId];
    if(index>=0) hasKDbIdColumnInNewTable=YES;
    NSMutableString* sb=[[NSMutableString alloc] init];
    [sb appendString:@"insert into "];
    [sb appendString:newTableName];
    [sb appendString:@"("];
    if(hasKDbIdColumnInNewTable)
    {
        [sb appendString:kDbId];
        [sb appendString:@","];
    }
    for(int i=0;i<allFields.count;i++)
        if(index<0||i==index)
        {
            [sb appendString:[allFields objectAtIndex:i]];
            [sb appendString:@","];
        }
    NSRange range;
    range.location=sb.length-1;
    range.length=1;
    [sb deleteCharactersInRange:range];
    [sb appendString:@") select "];
    if(hasKDbIdColumnInNewTable)
    {
        [sb appendString:@"(rowid-1) as "];
        [sb appendString:kDbId];
        [sb appendString:@","];
    }
    for(int i=0;i<allFields.count;i++)
        if(index<0||i==index)
        {
            [sb appendString:[allFields objectAtIndex:i]];
            [sb appendString:@","];
        }
    [sb deleteCharactersInRange:range];
    [sb appendString:@" from "];
    [sb appendString:tableName];
    [DBHelper executeCommand:database sql:sb];
}

+(void)onCreateTable:(sqlite3*)database
           tableName:(NSString*)tableName
           allFields:(NSMutableArray*)allFields
       allFieldTypes:(NSMutableArray*)allFieldTypes
         primaryKeys:(NSMutableArray*)primaryKeys
{
    BOOL has__id__=NO;
    if([allFields containsObject:kDbId])
    {
        has__id__=YES;
    }
    NSMutableString* sb=[[NSMutableString alloc] init];
    [sb appendString:@"create table "];
    [sb appendString:tableName];
    [sb appendString:@"("];
    if(!has__id__)
    {
        [sb appendString:kDbId];
        [sb appendString:@" "];
        [sb appendString:@" integer primary key,"];
    }
    for(int i=0;i<allFields.count;i++)
    {
        [sb appendString:[allFields objectAtIndex:i]];
        [sb appendString:@" "];
        [sb appendString:[allFieldTypes objectAtIndex:i]];
        [sb appendString:@","];
    }
    NSRange range;
    range.location=sb.length-1;
    range.length=1;
    [sb deleteCharactersInRange:range];
    [sb appendString:@")"];
    [DBHelper executeCommand:database sql:sb];
    
    //create the unique index for primary keys
    //for we already create the __id__ as the primary key
    if(primaryKeys&&primaryKeys.count>0)
    {
        NSString* uniqueIndex=[[Common createOneUUID] substringToIndex:20];
        sb=[[NSMutableString alloc] init];
        [sb appendString:@"create unique index INDEX_"];
        [sb appendString:uniqueIndex];
        [sb appendString:@" on "];
        [sb appendString:tableName];
        [sb appendString:@"("];
        for(int i=0;i<primaryKeys.count;i++)
        {
            [sb appendString:[primaryKeys objectAtIndex:i]];
            [sb appendString:@","];
        }
        range.location=sb.length-1;
        [sb deleteCharactersInRange:range];
        [sb appendString:@")"];
        [DBHelper executeCommand:database sql:sb];
    }
}


+ (void)preparePredefineDatas:(sqlite3*)database
                    commands:(NSMutableArray*)commands
                      userId:(NSString*)userId {
    void* handle= [DBHelper beginTranscation:database];
    NSString* sql;
    for(int i=0;i<commands.count;i++)
    {
        @try {
            sql=[commands objectAtIndex:i];
            NSString* tsql=[sql stringByReplacingOccurrencesOfString:@"{user_id}" withString:userId];
            [DBHelper executeCommand:database sql:tsql];
        }
        @catch (NSException *exception) {
            NSLog(@"%@",exception.description);
        }
        @finally {
            
        }
    }
    [DBHelper endTranscation:handle success:YES];
}

#pragma mark - tool methods
+(int)executeCommand:(sqlite3*)db sql:(NSString*)sql
{
    char* errmsg;
    int tmpRet = sqlite3_exec(db,[sql UTF8String], NULL, NULL, &errmsg);
    if(tmpRet==SQLITE_OK)
    {
        int changes= sqlite3_changes(db);
        return changes;
    }
    NSLog(@"[SQL_ERROR][Code:%d][Msg:%s][Sql:%@]",tmpRet, errmsg, sql);
    return -tmpRet;
}

+(void*)beginTranscation:(sqlite3 *)db
{
    char *errorMsg;
    if(sqlite3_exec(db, "BEGIN", NULL, NULL, &errorMsg)==SQLITE_OK)
        return db;
    return nil;
}

+(void)endTranscation:(void *)handle success:(BOOL)success
{
    char *errorMsg;
    if(success)
        sqlite3_exec(handle, "COMMIT", NULL, NULL, &errorMsg);
    else sqlite3_exec(handle, "ROLLBACK", NULL, NULL, &errorMsg);
}

#pragma -mark
#pragma -mark 更新表
+(BOOL)onUpgradeVersion:(sqlite3*)database userId:(NSString*)userId
{
    //T_APP_APPLICATION
    [self checkTable:database
           tableName:@"T_APP_APPLICATION"
           allFields:[NSMutableArray arrayWithObjects:@"application_id",@"application_identify",@"name",@"short_name",@"descriptions",@"is_valid",@"creation_date",@"last_edit_date",@"visit_count",@"download_count",@"creation_user_id",@"last_edit_user_id",@"audit_status_code",@"audit_work_flow_id",@"version",@"publish_time",@"publisher_name",@"last_publish_time",@"development_team",@"update_log",@"application_category_names",@"application_category_ids",@"application_type_code",@"evaluate_count",@"praise_count",@"company_id",@"start_url",@"remote_url_format",@"icon_path",@"icon_attachment_id",@"notice",@"position",@"pinyin_name",@"app_pack_attach_id",@"current_visit_count",@"current_date_stamp",@"last_visit_time",@"last_read_time",@"notice_count",@"app_image_path",nil]
       allFieldTypes:[NSMutableArray arrayWithObjects:@"NVARCHAR",@"NVARCHAR",@"NVARCHAR",@"NVARCHAR",@"NVARCHAR",@"TINYINT",@"BIGINT",@"BIGINT",@"INT",@"INT",@"NVARCHAR",@"NVARCHAR",@"NCHAR",@"NVARCHAR",@"NVARCHAR",@"BIGINT",@"NVARCHAR",@"BIGINT",@"NVARCHAR",@"NVARCHAR",@"NVARCHAR",@"NVARCHAR",@"NCHAR",@"INT",@"INT",@"NVARCHAR",@"NVARCHAR",@"NVARCHAR",@"NVARCHAR",@"NVARCHAR",@"NVARCHAR",@"INT",@"NVARCHAR",@"NVARCHAR",@"INT",@"NVARCHAR",@"BIGINT",@"BIGINT",@"INT",@"NVARCHAR",nil]
         primaryKeys:[NSMutableArray arrayWithObjects:@"application_id",nil]
		isFieldTypeChanged:NO
     ];
    
    [self checkTable:database
           tableName:@"T_APP_APPLICATION_MSG"
           allFields:[NSMutableArray arrayWithObjects:@"application_msg_id",@"application_id",@"content",@"is_valid",@"creation_date",@"is_visit",@"last_read_time",nil]
       allFieldTypes:[NSMutableArray arrayWithObjects:@"NVARCHAR",@"NVARCHAR",@"NVARCHAR",@"TINYINT",@"BIGINT",@"TINYINT",@"BIGINT",nil]
         primaryKeys:[NSMutableArray arrayWithObjects:@"application_msg_id",nil]
		isFieldTypeChanged:NO
     ];
    
    //T_APP_APPLICATION_2_CATEGORY
    [self checkTable:database
           tableName:@"T_APP_APPLICATION_2_CATEGORY"
           allFields:[NSMutableArray arrayWithObjects:@"application_category_code",@"application_id",nil]
       allFieldTypes:[NSMutableArray arrayWithObjects:@"NCHAR",@"NVARCHAR",nil]
         primaryKeys:[NSMutableArray arrayWithObjects:@"application_category_code",@"application_id",nil]
		isFieldTypeChanged:NO
     ];
    //T_APP_APPLICATION_2_USER
    [self checkTable:database
           tableName:@"T_APP_APPLICATION_2_USER"
           allFields:[NSMutableArray arrayWithObjects:@"application_2_user_id",@"user_id",@"application_identify",@"application_id",@"is_visible",@"is_grant",@"is_installed",@"last_visit_time",@"last_push_time",@"visit_count",@"position",nil]
       allFieldTypes:[NSMutableArray arrayWithObjects:@"NVARCHAR",@"NVARCHAR",@"NVARCHAR",@"NVARCHAR",@"TINYINT",@"TINYINT",@"TINYINT",@"BIGINT",@"BIGINT",@"INT",@"INT",nil]
         primaryKeys:[NSMutableArray arrayWithObjects:@"application_2_user_id",nil]
		isFieldTypeChanged:NO
     ];
    //T_APP_APPLICATION_EVALUATE
    [self checkTable:database
           tableName:@"T_APP_APPLICATION_EVALUATE"
           allFields:[NSMutableArray arrayWithObjects:@"application_evaluate_id",@"user_id",@"application_id",@"creation_date",@"evaludate_value",@"remark",@"is_useful",@"version",nil]
       allFieldTypes:[NSMutableArray arrayWithObjects:@"NVARCHAR",@"NVARCHAR",@"NVARCHAR",@"BIGINT",@"NCHAR",@"NVARCHAR",@"TINYINT",@"NVARCHAR",nil]
         primaryKeys:[NSMutableArray arrayWithObjects:@"application_evaluate_id",nil]
		isFieldTypeChanged:NO
     ];
    //T_APP_DAILY_STAT
    [self checkTable:database
           tableName:@"T_APP_DAILY_STAT"
           allFields:[NSMutableArray arrayWithObjects:@"application_id",@"date_stamp",@"visit_count",nil]
       allFieldTypes:[NSMutableArray arrayWithObjects:@"NVARCHAR",@"NVARCHAR",@"INT",nil]
         primaryKeys:[NSMutableArray arrayWithObjects:@"application_id",@"date_stamp",nil]
		isFieldTypeChanged:NO
     ];
    
    //T_CODE_APP_CATEGORY
    [self checkTable:database
           tableName:@"T_CODE_APP_CATEGORY"
           allFields:[NSMutableArray arrayWithObjects:@"application_category_code",@"name",@"short_name",@"creation_date",@"last_edit_date",@"is_valid",@"position",nil]
       allFieldTypes:[NSMutableArray arrayWithObjects:@"NCHAR",@"NVARCHAR",@"NVARCHAR",@"BIGINT",@"BIGINT",@"TINYINT",@"INT",nil]
         primaryKeys:[NSMutableArray arrayWithObjects:@"application_category_code",nil]
		isFieldTypeChanged:NO
     ];
    //T_CODE_APP_TYPE
    [self checkTable:database
           tableName:@"T_CODE_APP_TYPE"
           allFields:[NSMutableArray arrayWithObjects:@"application_type_code",@"name",@"short_name",@"creation_date",@"last_edit_date",@"is_valid",@"position",nil]
       allFieldTypes:[NSMutableArray arrayWithObjects:@"NCHAR",@"NVARCHAR",@"NVARCHAR",@"BIGINT",@"BIGINT",@"TINYINT",@"INT",nil]
         primaryKeys:[NSMutableArray arrayWithObjects:@"application_type_code",nil]
		isFieldTypeChanged:NO
     ];
    
    //T_USER_ATTR
    [self checkTable:database
           tableName:@"T_USER_ATTR"
           allFields:[NSMutableArray arrayWithObjects:@"user_id",@"name",@"user_name",@"pinyin_name",@"gender",@"creation_date",@"last_edit_date",@"audit_time",@"audit_status_code",@"register_time",@"email",@"birthday",@"work_phone",@"address",@"name_card",@"photo_attachment_id",@"lower_user_name",@"nick_name",@"is_anonymous",@"last_update_date",@"password",@"lower_email",@"mobile_phone",@"mobile_pin",@"is_audit",@"remark",@"user_type_code",@"account_status_code",@"last_logon_time",@"last_active_time",@"last_logon_id",@"last_connect_id",@"last_device_id",@"last_session_id",@"is_logon",@"company_id",@"company_name",@"department_id",@"department_name",@"title_id",@"title_name",@"fans_count",@"friends_count",@"add_friend_type_code",@"focus_tag_codes",@"is_add_friend_enable",@"is_add_article_enable",@"is_add_im_group_enable",@"is_access_architure_enable",@"position",@"level",nil]
       allFieldTypes:[NSMutableArray arrayWithObjects:@"NVARCHAR",@"NVARCHAR",@"NVARCHAR",@"NVARCHAR",@"TINYINT",@"BIGINT",@"BIGINT",@"BIGINT",@"NCHAR",@"BIGINT",@"NVARCHAR",@"NVARCHAR",@"NVARCHAR",@"NVARCHAR",@"NVARCHAR",@"NVARCHAR",@"NVARCHAR",@"NVARCHAR",@"TINYINT",@"BIGINT",@"NVARCHAR",@"NVARCHAR",@"NVARCHAR",@"NVARCHAR",@"TINYINT",@"NVARCHAR",@"NCHAR",@"NCHAR",@"BIGINT",@"BIGINT",@"NVARCHAR",@"NVARCHAR",@"NVARCHAR",@"NVARCHAR",@"TINYINT",@"NVARCHAR",@"NVARCHAR",@"NVARCHAR",@"NVARCHAR",@"NVARCHAR",@"NVARCHAR",@"INT",@"INT",@"NCHAR",@"NVARCHAR",@"TINYINT",@"TINYINT",@"TINYINT",@"TINYINT",@"INT",@"INT",nil]
         primaryKeys:[NSMutableArray arrayWithObjects:@"user_id",nil]
		isFieldTypeChanged:NO
     ];
    //T_USER_ATTR_S
    [self checkTable:database
           tableName:@"T_USER_ATTR_S"
           allFields:[NSMutableArray arrayWithObjects:@"user_id",@"name",@"company_name",@"title_name",@"photo_attachment_id",@"gender",@"user_name",@"fans_count",@"friends_count",@"work_phone",@"email",@"focus_count",nil]
       allFieldTypes:[NSMutableArray arrayWithObjects:@"NVARCHAR",@"NVARCHAR",@"NVARCHAR",@"NVARCHAR",@"NVARCHAR",@"TINYINT",@"NVARCHAR",@"INT",@"INT",@"NVARCHAR",@"NVARCHAR",@"INT",nil]
         primaryKeys:[NSMutableArray arrayWithObjects:@"user_id",nil]
		isFieldTypeChanged:NO
     ];
    
    //LeaveApprove
    [self checkTable:database
           tableName:@"LeaveApprove"
           allFields:[@[@"userId",@"code",@"askId",@"cattleId",@"leaveType"] mutableCopy]
       allFieldTypes:[@[@"NVARCHAR",@"NVARCHAR",@"NVARCHAR",@"NVARCHAR",@"NVARCHAR"] mutableCopy]
         primaryKeys:[@[@"cattleId"] mutableCopy]
  isFieldTypeChanged:NO];
    //T_MY_TEAM_GROUPS
    [self checkTable:database
           tableName:@"T_MY_TEAM_GROUPS"
           allFields:[NSMutableArray arrayWithObjects:@"group_id",@"group_name",@"group_member_count",@"is_read",@"creation_date",@"owner_id",nil]
       allFieldTypes:[NSMutableArray arrayWithObjects:@"NVARCHAR",@"NVARCHAR",@"TINYINT",@"TINYINT",@"BIGINT",@"NVARCHAR",nil]
         primaryKeys:[NSMutableArray arrayWithObjects:@"group_id",nil]
		isFieldTypeChanged:NO
     ];
    //T_MY_TEAM_MEMBERS
    [self checkTable:database
           tableName:@"T_MY_TEAM_MEMBERS"
           allFields:[NSMutableArray arrayWithObjects:@"group_id",@"group_name",@"cattle_id",@"user_name",@"creation_date",@"is_read",@"owner_id",nil]
       allFieldTypes:[NSMutableArray arrayWithObjects:@"NVARCHAR",@"NVARCHAR",@"NVARCHAR",@"NVARCHAR",@"BIGINT",@"TINYINT",@"NVARCHAR",nil]
         primaryKeys:[NSMutableArray arrayWithObjects:@"cattle_id",nil]
		isFieldTypeChanged:NO
     ];

    //add preparePredefineDatas
    [DBHelper preparePredefineDatas:database commands:
     [@[
        @"delete from T_CODE_APP_CATEGORY",
        @"INSERT INTO T_CODE_APP_CATEGORY(__id__,application_category_code, IS_VALID, NAME, POSITION) VALUES(1,'10',1,'#e61515',1)",
        @"INSERT INTO T_CODE_APP_CATEGORY(__id__,application_category_code, IS_VALID, NAME, POSITION) VALUES(2,'11',1,'#ff9002',2)",
        @"INSERT INTO T_CODE_APP_CATEGORY(__id__,application_category_code, IS_VALID, NAME, POSITION) VALUES(3,'12',1,'#1995f5',3)",
        @"INSERT INTO T_CODE_APP_CATEGORY(__id__,application_category_code, IS_VALID, NAME, POSITION) VALUES(4,'13',1,'#ffd800',4)",
        @"INSERT INTO T_CODE_APP_CATEGORY(__id__,application_category_code, IS_VALID, NAME, POSITION) VALUES(5,'14',1,'#cccccc',5)",
        @"INSERT INTO T_CODE_APP_CATEGORY(__id__,application_category_code, IS_VALID, NAME, POSITION) VALUES(6,'15',1,'#91bf42',6)",
        @"INSERT INTO T_CODE_APP_CATEGORY(__id__,application_category_code, IS_VALID, NAME, POSITION) VALUES(7,'16',1,'#41c4f0',7)",
        @"INSERT INTO T_CODE_APP_CATEGORY(__id__,application_category_code, IS_VALID, NAME, POSITION) VALUES(8,'17',1,'#dcad62',8)",
        @"update T_CODE_APP_CATEGORY set short_name=name",
        
        
        @"delete from T_APP_APPLICATION",
        @"INSERT INTO T_APP_APPLICATION(__id__,application_id, name, short_name, application_type_code, notice_count,app_image_path) VALUES(1,'cf3ca88c804743fc9334c5a8a4c4fc72','党群生活','党','10',3,'dqsh')",
        @"INSERT INTO T_APP_APPLICATION(__id__,application_id, name, short_name, application_type_code, notice_count,app_image_path) VALUES(2,'841ea9cf5db648e0bac134f38ce729e1','知识库','知','11',0,'zsk')",
        @"INSERT INTO T_APP_APPLICATION(__id__,application_id, name, short_name, application_type_code, notice_count,app_image_path) VALUES(3,'092ad3c991374d7a83ca62cb3f01c837','TMS','Tm','12',2,'tms')",
        @"INSERT INTO T_APP_APPLICATION(__id__,application_id, name, short_name, application_type_code, notice_count,app_image_path) VALUES(4,'e1448814059548f59ab43f2e5300b716','IMS','Im','13',1,'ims')",
        @"INSERT INTO T_APP_APPLICATION(__id__,application_id, name, short_name, application_type_code, notice_count,app_image_path) VALUES(5,'c9a796c3ffd24e9d89aeab228bb0bb1b','OMS','Om','14',1,'oms')",
        @"INSERT INTO T_APP_APPLICATION(__id__,application_id, name, short_name, application_type_code, notice_count,app_image_path) VALUES(6,'8a0aa594078e4378a05a505865948254','DVS','Dv','15',0,'dvs')",
        @"INSERT INTO T_APP_APPLICATION(__id__,application_id, name, short_name, application_type_code, notice_count,app_image_path) VALUES(7,'d01d9c74836a4fdebab4382c2c4a9587','PMS','Pm','16',3,'pms')",
        @"INSERT INTO T_APP_APPLICATION(__id__,application_id, name, short_name, application_type_code, notice_count,app_image_path) VALUES(8,'a0be5f1e377044a0a6862deb046d744c','品质管理','品','17',0,'pzgl')",
        
        @"delete from T_APP_APPLICATION_MSG",
        @"INSERT INTO T_APP_APPLICATION_MSG(__id__,application_msg_id, application_id, content, is_valid, is_visit) VALUES(1,'cf3ca900804743fc9334c5a8a4c4fc72','092ad3c991374d7a83ca62cb3f01c837','项目组已报批9月6日全网检修票。',1,1)",
        @"INSERT INTO T_APP_APPLICATION_MSG(__id__,application_msg_id, application_id, content, is_valid, is_visit) VALUES(2,'841ea9015db648e0bac134f38ce729e1','d01d9c74836a4fdebab4382c2c4a9587','5月15日，东北申网公司召开PMS建设启动电申活动',1,1)",
        @"INSERT INTO T_APP_APPLICATION_MSG(__id__,application_msg_id, application_id, content, is_valid, is_visit) VALUES(3,'092ad90291374d7a83ca62cb3f01c837','d01d9c74836a4fdebab4382c2c4a9587','4月6日，国网PMS配深化应用试点项目在天津市电力公司启动',1,0)",
        @"INSERT INTO T_APP_APPLICATION_MSG(__id__,application_msg_id, application_id, content, is_valid, is_visit) VALUES(4,'e1448903059548f59ab43f2e5300b716','d01d9c74836a4fdebab4382c2c4a9587','8月27日国网信通部在东北召开 I6000评审会。',1,1)",
        @"INSERT INTO T_APP_APPLICATION_MSG(__id__,application_msg_id, application_id, content, is_valid, is_visit) VALUES(5,'c9a79904ffd24e9d89aeab228bb0bb1b','e1448814059548f59ab43f2e5300b716','公司成功中标南网IT集中运行管控系统建设项目',1,1)",
        @"INSERT INTO T_APP_APPLICATION_MSG(__id__,application_msg_id, application_id, content, is_valid, is_visit) VALUES(6,'8a0aa905078e4378a05a505865948254','cf3ca88c804743fc9334c5a8a4c4fc72','关于派遣员工入工会，请参考工会纪律简章106条规章制度。',1,0)",
        @"INSERT INTO T_APP_APPLICATION_MSG(__id__,application_msg_id, application_id, content, is_valid, is_visit) VALUES(7,'d01d9906836a4fdebab4382c2c4a9587','cf3ca88c804743fc9334c5a8a4c4fc72','截止目前，公司总体回溯欠5.36亿元完成。',1,1)",
        @"INSERT INTO T_APP_APPLICATION_MSG(__id__,application_msg_id, application_id, content, is_valid, is_visit) VALUES(8,'a0be5907377044a0a6862deb046d744c','c9a796c3ffd24e9d89aeab228bb0bb1b','贵州电网运行管理系统(OMS)二期建设现已开展。',1,1)",
        @"INSERT INTO T_APP_APPLICATION_MSG(__id__,application_msg_id, application_id, content, is_valid, is_visit) VALUES(9,'a0be5908377044a0a6862deb046d744c','cf3ca88c804743fc9334c5a8a4c4fc72','阅兵日率先进场方队亮相。',1,0)",
        @"INSERT INTO T_APP_APPLICATION_MSG(__id__,application_msg_id, application_id, content, is_valid, is_visit) VALUES(10,'a0be5909377044a0a6862deb046d744c','092ad3c991374d7a83ca62cb3f01c837','新一代雷电检测系统实现全网覆盖',1,0)",

        ]mutableCopy] userId:userId];

    return YES;
}

@end
