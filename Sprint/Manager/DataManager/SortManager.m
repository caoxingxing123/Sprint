//
//  SortManager.m
//  MEAPLite
//
//  Created by xxcao on 14-8-19.
//
//

#import "SortManager.h"
#import "Common.h"
#import "MacroDef.h"

@implementation SortManager

#pragma -mark
#pragma -mark Sorted Array Methods

+ (NSArray *)sortedArray:(NSArray *)srcArray Key:(id)key Ascending:(BOOL)ascending {
    NSArray *resultArray = [srcArray sortedArrayUsingComparator: ^NSComparisonResult(NSDictionary *dic1, NSDictionary *dic2) {
        NSComparisonResult result = [dic1[key]compare:dic1[key]];
        if (ascending) {
            return result == NSOrderedAscending;
        } else {
            return result == NSOrderedDescending;
        }
    }];
    return resultArray;
}

+ (NSArray *)sortedArray:(NSArray *)srcArray Property:(id)property Ascending:(BOOL)ascending {
    //这里类似KVO的读取属性的方法，直接从字符串读取对象属性，注意不要写错
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:property
                                                                     ascending:ascending];
    //这个数组保存的是排序好的对象
    NSArray *resultArray = [srcArray sortedArrayUsingDescriptors:@[sortDescriptor]];
    return resultArray;
}

//简单整型排序(选择排序)
+ (NSArray *)sortedSimpleArray:(NSArray *)srcArray Ascending:(BOOL)ascending {
    if (!srcArray) return nil;
    else if (srcArray.count == 0) return srcArray;
    
    NSMutableArray *resArray = [NSMutableArray arrayWithArray:srcArray];
    for (int i = 0; i < resArray.count - 1; i++) {
        for (int j = i + 1; j < resArray.count; j++) {
            if (ascending) {
                if ([resArray[i] intValue] > [resArray[j] intValue]) {
                    int tmpNum = [resArray[i] intValue];
                    resArray[i] = resArray[j];
                    resArray[j] = [NSString stringWithFormat:@"%d",tmpNum];
                }
            } else {
                if ([resArray[i] intValue] < [resArray[j] intValue]) {
                    int tmpNum = [resArray[i] intValue];
                    resArray[i] = resArray[j];
                    resArray[j] = [NSString stringWithFormat:@"%d",tmpNum];
                }
            }
        }
    }
    return resArray;
}

//针对model去重
+ (NSArray *)distinctUnionModelArray:(NSArray *)src Key:(id)key {
    NSMutableArray *keys = [NSMutableArray array];
    [src enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        id tmpKey = [obj valueForKey:key];
        if (![Common isEmptyString:StringFromId(tmpKey)]) {
            [keys addObject:StringFromId(tmpKey)];
        }
    }];
    NSSet *set = [NSSet setWithArray:keys];
    NSMutableArray *resKeys = [NSMutableArray array];
    [set enumerateObjectsUsingBlock:^(NSString *tmpKey, BOOL *stop) {
        if (![Common isEmptyString:tmpKey]) {
            [resKeys addObject:tmpKey];
        }
    }];
    return resKeys;
}

//Model分组
+ (NSArray *)distinctGroupModelArray:(NSArray *)src Key:(id)key {
    NSArray *keys = [SortManager distinctUnionModelArray:src Key:key];
    NSMutableArray *resArray = [NSMutableArray array];
    [keys enumerateObjectsUsingBlock:^(NSString *tmpKey, NSUInteger idx, BOOL *stop) {
        NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
            if ([[evaluatedObject valueForKey:key] isKindOfClass:[NSNumber class]]) {
                return [[evaluatedObject valueForKey:key] intValue] == tmpKey.intValue;
            } else {
                return [[evaluatedObject valueForKey:key] isEqualToString:tmpKey];
            }
        }];
        NSArray *tmpArray = [src filteredArrayUsingPredicate:predicate];
        [resArray addObject:tmpArray];
    }];
    return resArray;
}

@end
