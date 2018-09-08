//
//  NYEnviroument.h
//  SaicCarPlatform
//
//  Created by Akries.NY on 2018/8/22.
//  Copyright © 2018年 Saic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NYEnviroumentModel.h"

static NSString * const kEnviroumentNameLocalKey = @"com.Akries.NY.Enviroument.name";

static NSString * const kEnviroumentApiHostKey = @"ApiHost";

static NSString * const kEnviroumentMqttHostKey = @"MqttHost";

static NSString * const kEnviroumentReportURLKey = @"ReportURL";


//static NSString * const kEnviroumentAuthHostKey = @"";

NSString *ny_CurrentApiHost(void);

NSString *ny_CurrentMqttHost(void);

NSString *ny_CurrentReportURL(void);

//NSString *CurrentAuthHost(void);


BOOL ny_isReleaseMode(void);

@interface NYEnviroument : NSObject

///环境名
@property (nonatomic, strong, readonly) NSString *enviroumentName;

///plist环境名字典
@property (nonatomic, strong, readonly) NSMutableDictionary *allEnvs;


+ (instancetype)defaultEnviroument;

/**
 根据配置文件设置网络环境
 @param filePath 配置文件的路径
 */
- (void)setEnviroumentsByConfigFile:(NSString *)filePath;

/**
 切换网络环境
 @param envname 网络环境的名称
 */
- (void)modifyEnviroumentByName:(NSString *)envname;


/**
 获取当前环境变量
 @param key 环境变量名
 @param moduleName 模块名
 @return 环境变量的值
 */
- (id)enviroumentValueForKey:(NSString *)key moudleName:(NSString *)moduleName;

/**
 获取配置文件所有环境名称数组
 
 @return 环境名称数组
 */
- (NSArray *)enviroumentNames;

/**
 修改环境模型
 
 @param enviroumentModel 环境变量模型
 */
- (void)modifyEnviroumentByModel:(NYEnviroumentModel *)enviroumentModel;

@end
