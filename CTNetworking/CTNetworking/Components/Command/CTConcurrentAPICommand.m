//
//  CTConcurrentAPICommand.m
//  CTNetworking
//
//  Created by Corotata on 2017/4/26.
//  Copyright © 2017年 Corotata. All rights reserved.
//

#import "CTConcurrentAPICommand.h"
#import "CTAPIBaseManager.h"

NSString * const kCTConcurrentAPIManagerListItemKeyManager = @"kCTConcurrentAPIManagerListItemKeyManager";
NSString * const kCTConcurrentAPIManagerListItemKeyOriginDelegate = @"kCTConcurrentAPIManagerListItemKeyOriginDelegate";

@interface CTConcurrentAPICommand()<CTAPIManagerCallBackDelegate>

@property (nonatomic, strong) NSMutableArray <NSMutableDictionary *> *apiManagerList;
@property (nonatomic, strong) NSMutableArray *successAPIManagerList;


@end

@implementation CTConcurrentAPICommand

#pragma mark - public methods
- (void)appendAPIManager:(CTAPIBaseManager *)APIManager
{
    NSMutableDictionary *item = [[NSMutableDictionary alloc] init];
    if (APIManager) {
        item[kCTConcurrentAPIManagerListItemKeyManager] = APIManager;
    } else {
        return;
    }
    
    [self.apiManagerList addObject:item];
}

- (void)excute
{
    [self.successAPIManagerList removeAllObjects];
    [self.apiManagerList enumerateObjectsUsingBlock:^(NSMutableDictionary * _Nonnull item, NSUInteger idx, BOOL * _Nonnull stop) {
        CTAPIBaseManager *manager = item[kCTConcurrentAPIManagerListItemKeyManager];
        if (manager.delegate) {
            item[kCTConcurrentAPIManagerListItemKeyOriginDelegate] = manager.delegate;
        }
        manager.delegate = self;
        [manager loadData];
    }];
}

- (void)cleanAPIManagerList
{
    [self.apiManagerList removeAllObjects];
}

#pragma mark - CTAPIManagerCallBackDelegate
- (void)managerCallAPIDidFailed:(CTAPIBaseManager *)manager
{
    [self.apiManagerList enumerateObjectsUsingBlock:^(NSMutableDictionary * _Nonnull item, NSUInteger idx, BOOL * _Nonnull stop) {
        if (item[kCTConcurrentAPIManagerListItemKeyManager] != manager) {
            [manager cancelAllRequests];
        }
        [item removeObjectForKey:kCTConcurrentAPIManagerListItemKeyOriginDelegate];
    }];
    if ([self.delegate respondsToSelector:@selector(commandCallAPIDidFailed:errorManager:)]) {
        [self.delegate commandCallAPIDidFailed:self errorManager:manager];
    }
}

- (void)managerCallAPIDidSuccess:(CTAPIBaseManager *)manager
{
    [self.apiManagerList enumerateObjectsUsingBlock:^(NSMutableDictionary * _Nonnull item, NSUInteger idx, BOOL * _Nonnull stop) {
        if (item[kCTConcurrentAPIManagerListItemKeyManager] == manager) {
            [self.successAPIManagerList addObject:manager];
            manager.delegate = item[kCTConcurrentAPIManagerListItemKeyOriginDelegate];
            [item removeObjectForKey:kCTConcurrentAPIManagerListItemKeyOriginDelegate];
        }
    }];
    if (self.successAPIManagerList.count == self.apiManagerList.count) {
        [self.delegate commandCallAPIDidSuccess:self apiManagerList:self.successAPIManagerList];
    }
}

#pragma mark - getters and setters
- (NSMutableArray<NSMutableDictionary *> *)apiManagerList
{
    if (_apiManagerList == nil) {
        _apiManagerList = [[NSMutableArray alloc] init];
    }
    return _apiManagerList;
}

- (NSMutableArray *)successAPIManagerList
{
    if (_successAPIManagerList == nil) {
        _successAPIManagerList = [[NSMutableArray alloc] init];
    }
    return _successAPIManagerList;
}



@end
