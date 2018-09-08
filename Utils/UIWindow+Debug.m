//
//  UIWindow+Debug.m
//  SaicCarPlatform
//
//  Created by Akries.NY on 2018/8/22.
//  Copyright © 2018年 Saic. All rights reserved.
//

#import "UIWindow+Debug.h"
#import "NYDebugLogo.h"

@implementation UIWindow (Debug)

- (void)resetRootViewControllerWithDebugFeatures:(UIViewController *)rootViewController
{
    self.rootViewController = rootViewController;
    [self addSubview:[NYDebugLogo logo]];
}

- (void)makeKeyAndVisibleWithDebugFeature
{
    [self makeKeyAndVisible];
    [self addSubview:[NYDebugLogo logo]];
}


@end
