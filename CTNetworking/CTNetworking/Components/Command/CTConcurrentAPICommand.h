//
//  CTConcurrentAPICommand.h
//  CTNetworking
//
//  Created by Corotata on 2017/4/26.
//  Copyright © 2017年 Long Fan. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CTAPIBaseManager;
@class CTConcurrentAPICommand;

@protocol CTConcurrentAPICommandDelegate <NSObject>

- (void)commandCallAPIDidSuccess:(CTConcurrentAPICommand *)command apiManagerList:(NSArray <CTAPIBaseManager *> *)apiManagerList;
- (void)commandCallAPIDidFailed:(CTConcurrentAPICommand *)command errorManager:(CTAPIBaseManager *)errorManager;

@end

@interface CTConcurrentAPICommand : NSObject

@property (nonatomic, weak) id<CTConcurrentAPICommandDelegate> delegate;

- (void)excute;
- (void)cleanAPIManagerList;
- (void)appendAPIManager:(CTAPIBaseManager *)APIManager;

@end


