//
//  JsonData.h
//  MEAPLite
//
//  Created by pcbeta on 14-9-2.
//
//

#import <Foundation/Foundation.h>
#import "MacroDef.h"
@protocol IJsonSerializable
    -(void)fromDictionary:(NSDictionary*) dict;
    -(void)toDictionary:(NSMutableDictionary*) dict;
@end

@interface JsonData : NSObject<IJsonSerializable>
{
	
}
Assign BOOL success;
Copy NSString* msg;
Assign long long ticks;
Strong id tag;
Copy NSString* url;
Assign BOOL error;
//store the json data of the tag
Strong NSDictionary * jsonTag;
Strong NSDictionary* orignalResponseObject;
//Levin:这里存放的是tag字段所对应的object对象，由于EMRmoteService中历史原因没有将tag字段存放object对象，
//所以现在用此字段来存放，而tag字段存放的是json对象，与jsonTag字段重复了
Strong id objectTag;
@end


@interface BaseJsonStore : JsonData
{

}
    Strong NSMutableArray* rows;
    Assign int total;
    Assign int resultCount;
    Assign int start;
@end