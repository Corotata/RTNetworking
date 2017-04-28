//
//  AXLogger.h
//  RTNetworking
//
//  Created by casa on 14-5-6.
//  Copyright (c) 2014年 casatwy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CTService.h"
#import "CTLoggerConfiguration.h"
#import "CTURLResponse.h"


@interface CTLogger : NSObject

+ (NSString *)logDebugInfoWithRequest:(NSURLRequest *)request apiName:(NSString *)apiName service:(CTService *)service;
+ (NSString *)logDebugInfoWithResponse:(NSHTTPURLResponse *)response rawResponseData:(NSData *)rawResponseData responseString:(NSString *)responseString request:(NSURLRequest *)request error:(NSError *)error;
+ (NSString *)logDebugInfoWithCachedResponse:(CTURLResponse *)response methodName:(NSString *)methodName service:(CTService *)service params:(NSDictionary *)params;

@end
