//
//  NYDebugManager.m
//  SaicCarPlatform
//
//  Created by Akries.NY on 2018/8/22.
//  Copyright © 2018年 Saic. All rights reserved.
//

#import "NYDebugManager.h"
#import "UIWindow+Debug.h"

NSString * const AppDebugModeChangedNotification = @"AppDebugModeChanged";

@interface NYDebugManager()
@end

@implementation NYDebugManager

+ (instancetype)defaultManager{
    static NYDebugManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[NYDebugManager alloc] init];
    });
    return manager;
}

- (instancetype)init{
    if(self = [super init]){
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveDebugModeChanged) name:@"debugChangedNotification" object:nil];
    }
    return self;
}

- (void)setAppDebugMode:(BOOL)appDebugMode{
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:appDebugMode] forKey:@"appDebugMode"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:AppDebugModeChangedNotification object:nil userInfo:@{@"AppDebugMode":[NSNumber numberWithBool:appDebugMode]}];
    
}

- (BOOL)appDebugMode{
    
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"appDebugMode"] boolValue];
    
}

-(void)setAppEmulatorNaviMode:(BOOL)appEmulatorNaviMode {
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:appEmulatorNaviMode] forKey:@"appEmulatorNaviMode"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(BOOL)appEmulatorNaviMode {
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"appEmulatorNaviMode"] boolValue];
}

#pragma mark - kDebugChangedNotification
- (void)receiveDebugModeChanged{
    
    if(self.changedCallback){
        self.changedCallback();
    }
    
}

@end
