//
//  NSURLRequest+CTNetworkingMethods.h
//  RTNetworking
//
//  Created by casa on 14-5-26.
//  Copyright (c) 2014年 casatwy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CTService.h"

@interface NSURLRequest (CTNetworkingMethods)

@property (nonatomic, copy) NSDictionary *actualRequestParams;
@property (nonatomic, copy) NSDictionary *originRequestParams;
@property (nonatomic, strong) CTService *service;

@end
