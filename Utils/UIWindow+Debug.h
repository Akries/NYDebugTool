//
//  UIWindow+Debug.h
//  SaicCarPlatform
//
//  Created by Akries.NY on 2018/8/22.
//  Copyright © 2018年 Saic. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIWindow (Debug)

- (void)resetRootViewControllerWithDebugFeatures:(UIViewController *)rootViewController;
- (void)makeKeyAndVisibleWithDebugFeature;

@end
