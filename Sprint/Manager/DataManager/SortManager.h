//
//  SortManager.h
//  MEAPLite
//
//  Created by xxcao on 14-8-19.
//
//
#import <Foundation/Foundation.h>
@interface SortManager : NSObject

//字典排序
+ (NSArray *)sortedArray:(NSArray *)srcArray Key:(id)key Ascending:(BOOL)ascending;

//属性排序
+ (NSArray *)sortedArray:(NSArray *)srcArray Property:(id)property Ascending:(BOOL)ascending;

//简单整型排序
+ (NSArray *)sortedSimpleArray:(NSArray *)srcArray Ascending:(BOOL)ascending;

//model去重
+ (NSArray *)distinctUnionModelArray:(NSArray *)src Key:(id)key;

//model分组
+ (NSArray *)distinctGroupModelArray:(NSArray *)src Key:(id)key;

@end
