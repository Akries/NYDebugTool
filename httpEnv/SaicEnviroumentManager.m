//
//  SaicEnviroumentManager.m
//  ios-shell-passenger
//
//  Created by niyang on 2019/5/22.
//  Copyright © 2019 app. All rights reserved.
//

#import "SaicEnviroumentManager.h"

@interface SaicEnviroumentManager()
@property (nonatomic, copy) NSString *envName;
@property (nonatomic, copy) NSString *gtwName;

@property (nonatomic, strong) NSDictionary *configDict;
@property (nonatomic, strong) NSArray <NSString *>*environmentArray;
@end

@implementation SaicEnviroumentManager

+ (instancetype)manager {
    static SaicEnviroumentManager *_manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[self alloc] init];
        // 默认release
        _manager.envName = @"release";
        _manager.gtwName = @"";
        _manager.configDict = [[NSDictionary alloc] init];
        _manager.environmentArray = [[NSArray alloc] init];
        NSBundle *resourceBundle = [NSBundle bundleWithPath:[[NSBundle bundleForClass:[self class]]
                                                             pathForResource:NSStringFromClass([self class])
                                                             ofType:@"bundle"]];
        NSString *path = [resourceBundle pathForResource:@"gtw-environment" ofType:@"json"];
        [_manager configEnvironmentWithFilePath:path];
    });
    return _manager;
}

- (void)configEnvironmentWithFilePath: (NSString *)filePath {
    if ([self isNotEmpty:filePath]) {
        BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:filePath];
        if (isExist) {
            NSData *data = [NSData dataWithContentsOfFile:filePath];
            if (data) {
                NSError *error;
                _configDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
                _environmentArray = _configDict.allKeys;
                if (error) {
                    NSLog(@"environment json parse fail with error: %@", error);
                }
            }
        } else {
            NSLog(@"environment json not exist at %@", filePath);
        }
    }
}

- (NSString *)apiHostWithEnvironmentName:(NSString *)environmentName {
    if ([self isNotEmpty:environmentName]) {
        self.envName = environmentName;
        return [self apiHostWithEnvironmentName:environmentName gtwName:self.gtwName];
    }
    return @"";
}
- (NSString *)apiHostWithGtwName:(NSString *)gtwName {
    if ([self isNotEmpty:gtwName]) {
        self.gtwName = gtwName;
        return [self apiHostWithEnvironmentName:self.envName gtwName:gtwName];
    }
    return @"";
}

#pragma mark - Private
- (NSString *)apiHostWithEnvironmentName:(NSString *)environmentName gtwName:(NSString *)gtwName {
    if (![self isNotEmpty:environmentName] || ![self isNotEmpty:gtwName] || self.configDict.count == 0) {
        return nil;
    }
    BOOL hasEnv =  [self.environmentArray containsObject:environmentName];
    if (hasEnv) {
        NSDictionary *gtws = self.configDict[environmentName];
        if (gtws && [gtws isKindOfClass:[NSDictionary class]]) {
            if ([gtws.allKeys containsObject:gtwName]) {
                NSString *apiHost = gtws[gtwName];
                return apiHost;
            } else {
                NSLog(@"can't find gtw:%@ at gtws:%@", gtwName, gtws);
                return nil;
            }
        }
    } else {
        NSLog(@"can't find env:%@ at envs:%@", environmentName, self.environmentArray);
        return nil;
    }
    return nil;
}

- (BOOL)isNotEmpty:(NSString *)string {
    if (!string || [string isKindOfClass:[NSNull class]]) {
        return NO;
    }
    if ([string isKindOfClass:[NSString class]] && string.length >0) {
        return YES;
    }
    return NO;
}
@end
