//
//  NYEnviroument.m
//  SaicCarPlatform
//
//  Created by Akries.NY on 2018/8/22.
//  Copyright © 2018年 Saic. All rights reserved.
//

#import "NYEnviroument.h"

static NSString *kEnviroumentDefaultMode = @"release";

static NSString *__currentEnviroumentName = nil;
static NSString *__currentApiHost = nil;
static NSString *__currentMqttHost = nil;
static NSString *__currentReportURL = nil;

//static NSString *__currentAuthHost = nil;

NSString *ny_CurrentEnviroumentName(){
    return __currentEnviroumentName;
}

NSString *ny_CurrentApiHost(){
    return __currentApiHost;
}

NSString *ny_CurrentReportURL(){
    return __currentReportURL;
}

NSString *ny_CurrentMqttHost(){
    return __currentMqttHost;
}

//NSString *CurrentAuthHost(){
//    return __currentAuthHost;
//}

BOOL ny_isReleaseMode(){
#ifdef DEBUG
    return NO;
#else
    return YES;
#endif
}

@interface NYEnviroument()
    
    @property (nonatomic, strong) NSString *enviroumentName;
    @property (nonatomic, strong) NSString *fileType;
    @property (nonatomic, copy) NSString *enviroumentPath;
    
    @property (nonatomic, strong) NSMutableDictionary *allEnvs;
    @property (nonatomic, strong) NYEnviroumentModel *enviroumentModel;

@end

@implementation NYEnviroument

+ (instancetype)defaultEnviroument {
    static NYEnviroument *staticEnv;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        staticEnv = [[NYEnviroument alloc] init];
    });
    return staticEnv;
}

- (void)setEnviroumentsByConfigFile:(NSURL *)filePathUrl fileType:(NSString *)fileType {
    self.fileType = fileType;
    NSDictionary *config;
    if ([fileType isEqualToString:@"json"]) {
        NSData *data = [[NSData alloc] initWithContentsOfURL:filePathUrl];
        id result = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        if ([result isKindOfClass:[NSDictionary class]]) {
            config = result;
        }
    }else if ([fileType isEqualToString:@"plist"]){
        config = [NSDictionary dictionaryWithContentsOfURL:filePathUrl];
    }
    
    if (config) {
        [self.allEnvs addEntriesFromDictionary:config];
    }

    __currentEnviroumentName = self.enviroumentName;
    __currentApiHost = [self enviroumentValueForKey:kEnviroumentApiHostKey];
    __currentMqttHost = [self enviroumentValueForKey:kEnviroumentMqttHostKey];
    __currentReportURL = [self enviroumentValueForKey:kEnviroumentReportURLKey];
//    __currentAuthHost =  [self enviroumentValueForKey:kEnviroumentAuthHostKey];
}

- (void)modifyEnviroumentByName:(NSString *)envname {
    self.enviroumentName = envname;
    NSDictionary *env = self.allEnvs[envname];
    if (env) {
        [[NSUserDefaults standardUserDefaults] setObject:envname forKey:kEnviroumentNameLocalKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    __currentEnviroumentName = self.enviroumentName;
    __currentApiHost = [self enviroumentValueForKey:kEnviroumentApiHostKey];
    __currentMqttHost = [self enviroumentValueForKey:kEnviroumentMqttHostKey];
    __currentReportURL = [self enviroumentValueForKey:kEnviroumentReportURLKey];
//    __currentAuthHost = [self enviroumentValueForKey:kEnviroumentAuthHostKey];

}
    
- (id)enviroumentValueForKey:(NSString *)key {
    if ([self.fileType isEqualToString:@"json"]) {
        if (self.enviroumentName) {
            NSDictionary *env = self.allEnvs[self.enviroumentName];
            return env[key];
        }
        return nil;
    }else if ([self.fileType isEqualToString:@"plist"]) {
        return [self enviroumentValueForKey:key moudleName:@"DefaultModule"];
    }
}
    
- (id)enviroumentValueForKey:(NSString *)key moudleName:(NSString *)moduleName{
    if (self.enviroumentName) {
        NSDictionary *env = self.allEnvs[self.enviroumentName][moduleName];
        return env[key];
    }
    return nil;
}
    
- (NSArray *)enviroumentNames{
    return [self.allEnvs allKeys];
}

- (void)modifyEnviroumentByModel:(NYEnviroumentModel *)enviroumentModel{
    
    __currentApiHost = enviroumentModel.apiHost;
    __currentMqttHost = enviroumentModel.mqttHost;
//    __currentAuthHost = enviroumentModel.authHost;
}

#pragma mark - Getter
- (NSMutableDictionary *)allEnvs {
    if (!_allEnvs) {
        _allEnvs = [NSMutableDictionary dictionary];
    }
    return _allEnvs;
}

- (NSString *)enviroumentName {
    if (!_enviroumentName) {
        NSString *enviroumentName = [[NSUserDefaults standardUserDefaults] objectForKey:kEnviroumentNameLocalKey];
        if(enviroumentName.length > 0){
            _enviroumentName = enviroumentName;
        }else{
            //载入打包环境
            NSString *urlType = [[NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"url_type" ofType:@""] encoding:NSUTF8StringEncoding error:nil] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            if (urlType.length) {
                _enviroumentName = urlType;
            }else{
                _enviroumentName = kEnviroumentDefaultMode;
            }
        }
    }
    return _enviroumentName;
}

@end
