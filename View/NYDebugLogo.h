//
//  NYDebugLogo.h
//  SaicCarPlatform
//
//  Created by Akries.NY on 2018/8/22.
//  Copyright © 2018年 Saic. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NYDebugLogo : UIView

+ (instancetype)logo;

- (id)initWithFrame:(CGRect)frame NS_UNAVAILABLE;

- (void)refreshEnviroumentLabel;

@end
