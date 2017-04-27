//
//  CTSerialAPICommand.m
//  CTNetworking
//
//  Created by Corotata on 2017/4/26.
//  Copyright © 2017年 Corotata. All rights reserved.
//

#import "CTSerialAPICommand.h"
#import "CTAPIBaseManager.h"

@interface CTSerialAPICommand()<CTAPIManagerCallBackDelegate>

@end

@implementation CTSerialAPICommand

- (void)setApiManager:(CTAPIBaseManager *)apiManager {
    _apiManager = apiManager;
    _apiManager.delegate = self;
}


- (void)excute {
    [self.apiManager loadData];
}


#pragma mark - CTAPIManagerCallBackDelegate
- (void)managerCallAPIDidSuccess:(CTAPIBaseManager *)manager {
    if (manager == self.apiManager && [self.delegate respondsToSelector:@selector(commandDidSuccess:)]) {
        [self.delegate commandDidSuccess:self];
        if (self.next) {
            [self.next excute];
        }
    }
}

- (void)managerCallAPIDidFailed:(CTAPIBaseManager *)manager {
    if (manager == self.apiManager && [self.delegate respondsToSelector:@selector(commandDidFailed:)]) {
        [self.delegate commandDidFailed:self];
    }
}


@end
