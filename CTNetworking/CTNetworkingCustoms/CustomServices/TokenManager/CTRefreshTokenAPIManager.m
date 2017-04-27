//
//  CTRefreshTokenAPIManager.m
//  CTNetworking
//
//  Created by Corotata on 2017/4/27.
//  Copyright © 2017年 Long Fan. All rights reserved.
//

#import "CTRefreshTokenAPIManager.h"

@interface CTRefreshTokenAPIManager()<CTAPIManagerValidator, CTAPIManagerParamSource>

@end

@implementation CTRefreshTokenAPIManager

#pragma mark - life cycle
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.validator = self;
        self.paramSource = self;
    }
    return self;
}

#pragma mark - CTAPIManager
- (NSString *)methodName
{
    return @"xxx/token";

}

- (NSString *)serviceType
{
    return @"XXXService";
}

- (CTAPIManagerRequestType)requestType
{
    return CTAPIManagerRequestTypePost;
}

- (BOOL)beforePerformSuccessWithResponse:(CTURLResponse *)response
{
    [super beforePerformSuccessWithResponse:response];
    
    //做token内容的保存
    return YES;
}

#pragma mark - CTAPIManagerParamSource
- (NSDictionary *)paramsForApi:(CTAPIBaseManager *)manager
{
    return @{};
}

#pragma mark - CTAPIManagerValidator
- (BOOL)manager:(CTAPIBaseManager *)manager isCorrectWithParamsData:(NSDictionary *)data
{
    return YES;
}

- (BOOL)manager:(CTAPIBaseManager *)manager isCorrectWithCallBackData:(NSDictionary *)data
{
    return YES;
}


@end
