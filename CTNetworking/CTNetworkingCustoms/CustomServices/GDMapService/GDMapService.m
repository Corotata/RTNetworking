//
//  GDMapService.m
//  CTNetworking
//
//  Created by casa on 16/4/12.
//  Copyright © 2016年 casa. All rights reserved.
//

#import "GDMapService.h"
#import "CTNetworkingConfigurationManager.h"
#import "CTNotificationCenterConst.h"
@implementation GDMapService

#pragma mark - CTServiceProtocal
- (BOOL)isOnline
{
    return [CTNetworkingConfigurationManager sharedInstance].serviceIsOnline;
}

- (NSString *)offlineApiBaseUrl
{
    return @"http://restapi.amap.com";
}

- (NSString *)onlineApiBaseUrl
{
    return @"http://restapi.amap.com";
}

- (NSString *)offlineApiVersion
{
    return @"v3";
}

- (NSString *)onlineApiVersion
{
    return @"v3";
}

- (NSString *)onlinePublicKey
{
    return @"384ecc4559ffc3b9ed1f81076c5f8424";
}

- (NSString *)offlinePublicKey
{
    return @"384ecc4559ffc3b9ed1f81076c5f8424";
}

- (NSString *)onlinePrivateKey
{
    return @"";
}

- (NSString *)offlinePrivateKey
{
    return @"";
}

//为某些Service需要拼凑额外字段到URL处
- (NSDictionary *)extraParmas {
    return @{@"mars": @"374910422"};
//    return nil;
}

//为某些Service需要拼凑额外的HTTPToken，如accessToken
- (NSDictionary *)extraHttpHeadParmasWithMethodName:(NSString *)method {
    return @{@"sessionID": [[NSUUID UUID]UUIDString]};
}

//- (NSString *)urlGeneratingRuleByMethodName:(NSString *)methodName {
//    return [NSString stringWithFormat:@"%@/%@/%@", self.apiBaseUrl, self.apiVersion, methodName];
//}

- (BOOL)shouldCallBackByFailedOnCallingAPI:(CTAPIBaseManager *)apiManager {
    
    CTURLResponse *response = apiManager.response;
    BOOL result = YES;
    if ([response.content[@"id"] isEqualToString:@"expired_access_token"]) {
        // token 失效
        [[NSNotificationCenter defaultCenter] postNotificationName:kBSUserTokenInvalidNotification
                                                            object:nil
                                                          userInfo:@{
                                                                     kBSUserTokenNotificationUserInfoKeyManagerToContinue:[response.request mutableCopy],
                                                                     kBSUserTokenNotificationUserInfoKeyManagerToContinue:self
                                                                     }];
        result = YES;
    } else if ([response.content[@"id"] isEqualToString:@"illegal_access_token"]) {
        // token 非法，重新登录
        [[NSNotificationCenter defaultCenter] postNotificationName:kBSUserTokenIllegalNotification
                                                            object:nil
                                                          userInfo:@{
                                                                     kBSUserTokenNotificationUserInfoKeyManagerToContinue:[response.request mutableCopy],
                                                                     kBSUserTokenNotificationUserInfoKeyManagerToContinue:self
                                                                     }];
        result = YES;
    } else if ([response.content[@"id"] isEqualToString:@"no_permission_for_this_api"]) {
        // token 非法，重新登录
        [[NSNotificationCenter defaultCenter] postNotificationName:kBSUserTokenIllegalNotification
                                                            object:nil
                                                          userInfo:@{
                                                                     kBSUserTokenNotificationUserInfoKeyManagerToContinue:[response.request mutableCopy],
                                                                     kBSUserTokenNotificationUserInfoKeyManagerToContinue:self
                                                                     }];
        result = NO;
    }
    return result;

}




@end
