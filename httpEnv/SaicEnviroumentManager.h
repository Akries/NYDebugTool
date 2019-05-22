//
//  SaicEnviroumentManager.h
//  ios-shell-passenger
//
//  Created by niyang on 2019/5/22.
//  Copyright © 2019 app. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SaicEnviroumentManager : NSObject

+ (instancetype)manager;

/// 文件配置
- (void)configEnvironmentWithFilePath: (NSString *)filePath;
/// 根据网络环境获取host地址(dev,sit,prerelease,release)
- (NSString *)apiHostWithEnvironmentName:(NSString *)environmentName;
/// 根据网关类型获取host地址(driver,passenger,srdriver,srpassenger,auth,pay,cas,cms)
- (NSString *)apiHostWithGtwName:(NSString *)gtwName;

- (instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
