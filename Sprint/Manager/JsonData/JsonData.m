//
//  JsonData.m
//  MEAPLite
//
//  Created by pcbeta on 14-9-2.
//
//

#import "JsonData.h"

@implementation JsonData
-(void)fromDictionary:(NSDictionary *)dict
{
    if (![dict isKindOfClass:[NSDictionary class]]) {
        return;
    }
    _msg=dict[@"msg"];
    _ticks=[dict[@"ticks"] longLongValue];
    _url=dict[@"url"];
    _success=[dict[@"success"] boolValue];
    _tag= [dict[@"tag"] copy];
}

-(void)toDictionary:(NSMutableDictionary *)dict
{
    if (![dict isKindOfClass:[NSMutableDictionary class]]) {
        return;
    }
    dict[@"msg"]=_msg;
    dict[@"ticks"]=@(_ticks);
    dict[@"url"]=_url;
    dict[@"success"]=@(_success);
    dict[@"tag"]=_tag;
}
@end

@implementation BaseJsonStore


-(void)fromDictionary:(NSDictionary *)dict
{
    if (![dict isKindOfClass:[NSDictionary class]]) {
        return;
    }
    [super fromDictionary:dict];
    _total=[dict[@"total"] intValue];
    _resultCount=[dict[@"resultCount"] intValue];
    _start=[dict[@"start"] intValue];
    _rows = [NSMutableArray arrayWithArray:dict[@"rows"]];
}

-(void)toDictionary:(NSMutableDictionary *)dict
{
    if (![dict isKindOfClass:[NSMutableDictionary class]]) {
        return;
    }
    [super toDictionary:dict];
    dict[@"total"]=@(_total);
    dict[@"start"]=@(_start);
    dict[@"resultCount"]=@(_resultCount);
}

@end
