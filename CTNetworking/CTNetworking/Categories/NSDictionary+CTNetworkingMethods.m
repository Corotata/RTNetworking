//
//  NSDictionary+CTNetworkingMethods.m
//  RTNetworking
//
//  Created by casa on 14-5-6.
//  Copyright (c) 2014年 casatwy. All rights reserved.
//

#import "NSDictionary+CTNetworkingMethods.h"
#import "NSArray+CTNetworkingMethods.h"

@implementation NSDictionary (CTNetworkingMethods)

/** 字符串前面是没有问号的，如果用于POST，那就不用加问号，如果用于GET，就要加个问号 */
- (NSString *)CT_urlParamsStringSignature:(BOOL)isForSignature
{
    NSArray *sortedArray = [self CT_transformedUrlParamsArraySignature:isForSignature];
    return [sortedArray CT_paramsString];
}

/** 字典变json */
- (NSString *)CT_jsonString
{
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:NULL];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

/** 转义参数 */
- (NSArray *)CT_transformedUrlParamsArraySignature:(BOOL)isForSignature
{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if (![obj isKindOfClass:[NSString class]]) {
            obj = [NSString stringWithFormat:@"%@", obj];
        }
        if (!isForSignature) {
            obj = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,  (CFStringRef)obj,  NULL,  (CFStringRef)@"!*'();:@&;=+$,/?%#[]",  kCFStringEncodingUTF8));
        }
        if ([obj length] > 0) {
            [result addObject:[NSString stringWithFormat:@"%@=%@", key, obj]];
        }
    }];
    NSArray *sortedResult = [result sortedArrayUsingSelector:@selector(compare:)];
    return sortedResult;
}


- (NSString *)CT_transformToUrlParamString
{
    NSMutableString *paramString = [NSMutableString string];
    for (int i = 0; i < self.count; i ++) {
        NSString *string;
        if (i == 0) {
            string = [NSString stringWithFormat:@"?%@=%@", self.allKeys[i], self[self.allKeys[i]]];
        } else {
            string = [NSString stringWithFormat:@"&%@=%@", self.allKeys[i], self[self.allKeys[i]]];
        }
        [paramString appendString:string];
    }
    return paramString;
}


@end
