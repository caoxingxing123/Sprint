//
//  DbObject.m
//  STQuickKit
//
//  Created by yls on 13-11-21.
//
// Version 1.0.4
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "STDbObject.h"
#import "STDbHandle.h"
#import "STDbVersion.h"
#import <objc/runtime.h>

@implementation STDbObject

- (id)init
{
    self = [super init];
    if (self) {
        self.expireDate = [NSDate distantFuture];
    }
    return self;
}

/**
 *	@brief	插入到数据库中
 */
- (BOOL)insertToDb
{
    @synchronized(self){
        return[[STDbHandle shareDb] insertDbObject:self];
    }
}

/**
 *	@brief	更新某些数据
 *
 *	@param 	where 	条件
 *          例：name='xue zhang' and sex='男'
 *
 */
- (BOOL)updateToDbsWhere:(NSString *)where NS_DEPRECATED(10_0, 10_4, 2_0, 2_0)
{
    @synchronized(self){
        return[[STDbHandle shareDb] updateDbObject:self condition:where];
    }
}

/**
 *	@brief	保证数据唯一
 */
- (BOOL)replaceToDb;
{
    @synchronized(self){
        return[[STDbHandle shareDb] replaceDbObject:self];
    }
}

/**
 *	@brief	更新数据到数据库中
 *
 *	@return	更新成功YES,否则NO
 */
- (BOOL)updatetoDb
{
    @synchronized(self){
        NSString *condition = [NSString stringWithFormat:@"%@=%zd", kDbId, self.__id__];
        return[[STDbHandle shareDb] updateDbObject:self condition:condition];
    }
}

/**
 *	@brief	从数据库删除对象
 *
 *	@return	更新成功YES,否则NO
 */
- (BOOL)removeFromDb
{
    @synchronized(self){
        NSMutableArray *subDbObjects = [NSMutableArray arrayWithCapacity:0];
        [self subDbObjects:subDbObjects];
        
        for (STDbObject *dbObj in subDbObjects) {
            NSString *where = [NSString stringWithFormat:@"%@=%zd", kDbId, dbObj.__id__];
           [[STDbHandle shareDb] removeDbObjects:[dbObj class] condition:where];
        }
        return YES;
    }
}

- (void)subDbObjects:(NSMutableArray *)subObj
{
    @synchronized(self){
        if (!self || ![self isKindOfClass:[STDbObject class]]) {
            return;
        }
        
        [subObj addObject:self];
        
        unsigned int count;
        STDbObject *obj = self;
        objc_property_t *properties = class_copyPropertyList(self.class, &count);
        
        for (int i = 0; i < count; i++) {
            objc_property_t property = properties[i];
            NSString * key = [[NSString alloc]initWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
            id value = [obj valueForKey:key];

            if (value && (NSNull *)value != [NSNull null] && [value isKindOfClass:[STDbObject class]]) {
                [subObj addObject:value];
            }
            
            if ([value isKindOfClass:[NSArray class]]) {
                for (STDbObject *obj in value) {
                    if (obj && (NSNull *)obj != [NSNull null] && [obj isKindOfClass:[STDbObject class]]) {
                        [subObj addObject:obj];
                    }
                }
            }
            
            if ([value isKindOfClass:[NSDictionary class]]) {
                for (NSString *key in value) {
                    STDbObject *obj = value[key];
                    if (obj && (NSNull *)obj != [NSNull null] && [obj isKindOfClass:[STDbObject class]]) {
                        [subObj addObject:obj];
                    }
                }
            }
        }
    }
}

/**
 *	@brief	查看是否包含对象
 *
 *	@param 	where 	条件
 *          例：name='xue zhang' and sex='男'
 *
 *	@return	包含YES,否则NO
 */
+ (BOOL)existDbObjectsWhere:(NSString *)where
{
    @synchronized(self){
        NSArray *objs =[[STDbHandle shareDb] selectDbObjects:[self class] condition:where orderby:nil];
        if ([objs count] > 0) {
            return YES;
        }
        return NO;
    }
}

/**
 *	@brief	删除某些数据
 *
 *	@param 	where 	条件
 *          例：name='xue zhang' and sex='男'
 *          填入 all 为全部删除
 *
 *	@return 成功YES,否则NO
 */
+ (BOOL)removeDbObjectsWhere:(NSString *)where
{
    @synchronized(self){
        return [[STDbHandle shareDb] removeDbObjects:[self class] condition:where];
    }
}

/**
 *	@brief	根据条件取出某些数据
 *
 *	@param 	where 	条件
 *          例：name='xue zhang' and sex='男'
 *          填入 all 为全部
 *
 *	@param 	orderby 	排序
 *          例：name and age
 *
 *	@return	数据
 */
+ (NSArray *)dbObjectsWhere:(NSString *)where orderby:(NSString *)orderby
{
    @synchronized(self){
        return [[STDbHandle shareDb] selectDbObjects:[self class] condition:where orderby:orderby];
    }
}

+ (NSMutableArray *)dbObjectsWhere:(NSString *)where orderby:(NSString *)orderby limit:(int)limit offset:(int)offset {
    @synchronized(self){
        return [[STDbHandle shareDb] selectDbObjects:[self class] condition:where orderby:orderby Limit:limit Offset:offset];
    }
}

//查数据
+ (id)selectSqlite3:(NSString *)sqliteString {
    @synchronized(self){
        return [[STDbHandle shareDb] selectSqlite3:sqliteString Class:[self class]];
    }
}

//计算count(*)
+ (int)caculateCountSqlite3:(NSString *)sqliteString {
    @synchronized(self){
        return [[STDbHandle shareDb] caculateCountSqlite3:sqliteString];
    }
}

//计算sum(*)
+ (long long)caculateSumSqlite3:(NSString *)sqliteString {
    @synchronized(self){
        return [[STDbHandle shareDb] caculateSumSqlite3:sqliteString];
    }
}

//查数据(*)------自定义马洪涛 返回NSDictionary
+ (id)selectCustomeSqlite3Data:(NSString *)sqliteString {
    @synchronized(self){
        return [[STDbHandle shareDb] selectSqlite3Data:sqliteString];
    }
}
//执行操作
+ (BOOL)execSqlite3:(NSString *)sqlString {
    @synchronized(self){
        return [[STDbHandle shareDb] execSqlite3:sqlString];
    }
}

/**
 *	@brief	取出所有数据
 *
 *	@return	数据
 */
+ (NSMutableArray *)allDbObjects
{
    @synchronized(self){
        return [[STDbHandle shareDb] selectDbObjects:[self class] condition:@"all" orderby:nil];
    }
}

/*
 * 查看最后插入数据的行号
 */
+ (NSInteger)lastRowId;
{
    @synchronized(self){
        return [STDbHandle lastRowIdWithClass:self];
    }
}

/**
 *	@brief	objc to dictionary
 */
- (NSDictionary *)objcDictionary;
{
    @synchronized(self){
        unsigned int count;
        STDbObject *obj = self;
        objc_property_t *properties = class_copyPropertyList(self.class, &count);
        
        NSMutableDictionary *retDict = [NSMutableDictionary dictionary];
        
        for (int i = 0; i < count; i++) {
            objc_property_t property = properties[i];
            NSString *key = [[NSString alloc]initWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
            id value = [obj valueForKey:key];
            if (value) {
                [retDict setObject:value forKey:key];
            }
        }
        
        return retDict;
    }
}

/**
 *	@brief	objc from dictionary
 */
- (STDbObject *)objcFromDictionary:(NSDictionary *)dict;
{
    @synchronized(self){
        STDbObject *obj = [[[self class] alloc] init];
        
        unsigned int count;
        objc_property_t *properties = class_copyPropertyList(self.class, &count);
        for (int i = 0; i < count; i++) {
            objc_property_t property = properties[i];
            NSString * key = [[NSString alloc]initWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
            id value = [dict objectForKey:key];
            if (value) {
                [obj setValue:value forKey:key];
            }
        }
        return obj;
    }
}


-(void)fromDictionary:(NSDictionary *)dict
{
    
}

-(void)toDictionary:(NSMutableDictionary *)dict
{
    
}

@end

