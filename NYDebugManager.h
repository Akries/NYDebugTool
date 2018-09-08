//
//  NYDebugManager.h
//  SaicCarPlatform
//
//  Created by Akries.NY on 2018/8/22.
//  Copyright © 2018年 Saic. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^NYDebugChangedCallback)(void);

@interface NYDebugManager : NSObject

+ (instancetype)defaultManager;

@property (nonatomic, assign) BOOL allowSwitchDomain;

@property (nonatomic, assign) BOOL appDebugMode;

@property (nonatomic, copy) NYDebugChangedCallback changedCallback;

@end

FOUNDATION_EXTERN NSString * const AppDebugModeChangedNotification;
