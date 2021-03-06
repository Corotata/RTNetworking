//
//  NSDictionary+CTNetworkingMethods.h
//  RTNetworking
//
//  Created by casa on 14-5-6.
//  Copyright (c) 2014年 casatwy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (CTNetworkingMethods)

- (NSString *)CT_urlParamsStringSignature:(BOOL)isForSignature;
- (NSString *)CT_jsonString;
- (NSArray *)CT_transformedUrlParamsArraySignature:(BOOL)isForSignature;

- (NSString *)CT_transformToUrlParamString;

@end
