//
//  NSJSONSerialization+JSONString.m
//
//  Created by Frank Michael  on 6/3/13.
//  Copyright (c) 2013 Frank Michael . All rights reserved.
//

#import "NSJSONSerialization+JSONString.h"

@implementation NSJSONSerialization (JSONString)
+ (NSString *)jsonStringWithObject:(id)obj{
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:obj options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return jsonString;
}
@end
