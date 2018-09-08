//
//  NYEnviroumentModel.h
//  SaicCarPlatform
//
//  Created by Akries.NY on 2018/8/22.
//  Copyright © 2018年 Saic. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NYEnviroumentModel : NSObject
///网络域名
@property (nonatomic, copy) NSString *apiHost;
@property (nonatomic, copy) NSString *mqttHost;

//认证域名
//@property (nonatomic, copy) NSString *authHost;

@end
