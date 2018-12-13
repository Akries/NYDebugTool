//
//  NetWorkInfoManager.h
//  ClientTest
//
//  Created by Akries.NY on 2018/9/11.
//  Copyright © 2018年 Saic. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetWorkInfoManager : NSObject


+ (instancetype)sharedManager;

/** 获取ip */
- (NSString *)getDeviceIPAddresses;

- (NSString *)getIpAddressWIFI;
- (NSString *)getIpAddressCell;

@end
