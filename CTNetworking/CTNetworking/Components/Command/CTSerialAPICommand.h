//
//  CTSerialAPICommand.h
//  CTNetworking
//
//  Created by Corotata on 2017/4/26.
//  Copyright © 2017年 Corotata. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CTAPIBaseManager;
@class CTSerialAPICommand;

@protocol CTAPICommandDelegate <NSObject>

@required
- (void)commandDidSuccess:(CTSerialAPICommand *)command;
- (void)commandDidFailed:(CTSerialAPICommand *)command;

@end


@interface CTSerialAPICommand : NSObject


@property (nonatomic, weak) id<CTAPICommandDelegate> delegate;
@property (nonatomic, strong) CTSerialAPICommand *next;
@property (nonatomic, strong) CTAPIBaseManager *apiManager;

- (void)excute;



@end
