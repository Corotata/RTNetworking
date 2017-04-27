//
//  CTTokenManager.m
//  CTNetworking
//
//  Created by Corotata on 2017/4/25.
//  Copyright © 2017年 Corotata. All rights reserved.
//

#import "CTTokenManager.h"
#import "CTAPIBaseManager.h"
#import "CTNotificationCenterConst.h"
#import "CTRefreshTokenAPIManager.h"
@interface CTTokenManager()<CTAPIManagerCallBackDelegate>


@property (nonatomic, strong) NSMutableArray <CTAPIBaseManager *> *pendingAccessTokenRequestList;
@property (nonatomic, strong) NSMutableArray <CTAPIBaseManager *> *pendingLoginRequestList;

@property (nonatomic, assign) BOOL isShowingLoginPage;
@property (nonatomic, assign) BOOL isRefreshingAccessToken;

@property (nonatomic, strong) CTRefreshTokenAPIManager *refreshTokenAPIManager;
@end


@implementation CTTokenManager

#pragma mark - Life cycle
+ (void)load
{
    [CTTokenManager sharedInstance];
}

+ (instancetype)sharedInstance
{
    static CTTokenManager *tokenManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tokenManager = [[CTTokenManager alloc] init];
    });
    return tokenManager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _isShowingLoginPage = NO;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceivedkBSUserTokenInvalidNotification:) name:kBSUserTokenInvalidNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceivedkBSUserTokenIllegalNotification:) name:kBSUserTokenIllegalNotification object:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - CTAPIManagerCallBackDelegate
- (void)managerCallAPIDidSuccess:(CTAPIBaseManager *)manager
{
    if (manager == self.refreshTokenAPIManager) {
        self.isRefreshingAccessToken = NO;
        //刷新token失败，原先所有保留接口重新请求数据
        [self loadPendingRequests:self.pendingAccessTokenRequestList];
    }
}

- (void)managerCallAPIDidFailed:(CTAPIBaseManager *)manager
{
    if (manager == self.refreshTokenAPIManager) {
        self.isRefreshingAccessToken = NO;
        //刷新token失败，原先所有保留接口回调失败
        [self failPendingRequests:self.pendingAccessTokenRequestList errorType:CTAPIManagerErrorTypeNoNetWork];
    }
}

#pragma mark - Notification
- (void)didReceivedkBSUserTokenInvalidNotification:(NSNotification *)notification
{
    if (notification.userInfo[kBSUserTokenNotificationUserInfoKeyManagerToContinue]) {
        CTAPIBaseManager *manager = notification.userInfo[kBSUserTokenNotificationUserInfoKeyManagerToContinue];
        [self.pendingAccessTokenRequestList addObject:manager];
        
        
    //token失效时，存储所有当前失效的请求，并且刷新token
        if (self.isRefreshingAccessToken == NO) {
            self.isRefreshingAccessToken = YES;
            [self.refreshTokenAPIManager loadData];
        }
    }
}

- (void)didReceivedkBSUserTokenIllegalNotification:(NSNotification *)notification
{

    //token非法的场景
    //  1.类似于微信，基本是登录后才能使用，所以如果是被挤掉线，进去时一般都是采用window.rootViewController = LoginViewController,所以这种状况下，恢复原先请求的必要性感觉不是太大，因为原来的主业务控制器都已经被重置，所以我更提倡，在主控制器去这部分监听，这里就不参与UI逻辑的内容了，所以这里的做法是不处理，在service拦截处返回YES，让程序正常回调。
    
    //  2.类似于京东，电商APP，一般情况出现在在登录状态下，浏览产品时，然后在网页端修改密码，当你添加到购物车时，假设触发了token非法，那么你重新登录完，为了更好的体验，原先添加进购物车的请求应该也生效，那么你就可以使用以下的方式，在service拦截处返回NO，让原先的请求都挂起。
    if (notification.userInfo[kBSUserTokenNotificationUserInfoKeyManagerToContinue]) {
        CTAPIBaseManager *manager = notification.userInfo[kBSUserTokenNotificationUserInfoKeyManagerToContinue];
        [self.pendingLoginRequestList addObject:manager];
    }
    
    if (self.isShowingLoginPage == NO) {
        self.isShowingLoginPage = YES;
        //伪代码大概是这样写的
        /*
         __weak typeof(self) weakSelf = self;
         [XXX loginSuccessHandler:^{
         
            __strong typeof(weakSelf) strongSelf = weakSelf;
            strongSelf.isShowingLoginPage = NO;
            [strongSelf loadPendingRequests:self.pendingLoginRequestList];
         
         } cancelHandler:^{
         
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf failPendingRequests:strongSelf.pendingLoginRequestList errorType:CTAPIManagerErrorTypeLoginCanceled];
         
         } failedHandler:^{
         
            __strong typeof(weakSelf) strongSelf = weakSelf;
           [strongSelf failPendingRequests:strongSelf.pendingLoginRequestList errorType:CTAPIManagerErrorTypeNoNetWork];
         }];

        */
    }
    
    
    //所以综合上面两种场景，该方式不是唯一性，也会根据业务不同有不同的扩展，而且不易统一，所以这块代码就不并到CTNetworking里面去了    
}

#pragma mark - Private methods
- (void)loadPendingRequests:(NSMutableArray <CTAPIBaseManager *> *)pendingRequests
{
    [pendingRequests makeObjectsPerformSelector:@selector(loadData)];
    [pendingRequests removeAllObjects];
}

- (void)failPendingRequests:(NSMutableArray <CTAPIBaseManager *> *)pendingRequests errorType:(CTAPIManagerErrorType)errorType
{
    [pendingRequests enumerateObjectsUsingBlock:^(CTAPIBaseManager * _Nonnull manager, NSUInteger idx, BOOL * _Nonnull stop) {
        [manager failedOnCallingAPI:nil withErrorType:errorType];
    }];
    [pendingRequests removeAllObjects];
}

#pragma mark - Getter and setter

- (CTRefreshTokenAPIManager *)refreshTokenAPIManager {
    if (_refreshTokenAPIManager == nil)
    {
        _refreshTokenAPIManager = [[CTRefreshTokenAPIManager alloc]init];
        _refreshTokenAPIManager.delegate = self;
    }
    return _refreshTokenAPIManager;
}

- (NSMutableArray *)pendingAccessTokenRequestList
{
    if (_pendingAccessTokenRequestList == nil) {
        _pendingAccessTokenRequestList = [[NSMutableArray alloc] init];
    }
    return _pendingAccessTokenRequestList;
}

- (NSMutableArray *)pendingLoginRequestList
{
    if (_pendingLoginRequestList == nil) {
        _pendingLoginRequestList = [[NSMutableArray alloc] init];
    }
    return _pendingLoginRequestList;
}



@end
