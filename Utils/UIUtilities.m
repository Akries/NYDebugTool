//
//  UIUtilities.m
//  SaicCarPlatform
//
//  Created by Akries.NY on 2018/8/22.
//  Copyright © 2018年 Saic. All rights reserved.

#import "UIUtilities.h"

@implementation UIUtilities

+ (UIViewController *)currentDisplayController{
    UIWindow *window = [UIUtilities currentAppWindow];
    if (!window) return nil;
    UIViewController *viewController = [window rootViewController];
    if (!viewController) return nil;
    return [UIUtilities getTopViewController:viewController];
}

+ (UIWindow * )currentAppWindow{
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal) {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for (UIWindow *tmpWindow in windows) {
            if (tmpWindow.windowLevel == UIWindowLevelNormal) {
                return tmpWindow;
            }
        }
    }
    return window;
}

+ (UIViewController *)getTopViewController:(UIViewController *)viewController{
    UIViewController *result;
    if ([viewController presentedViewController]) {
        UIViewController *controller = viewController.presentedViewController;
        result = [UIUtilities getTopViewController:controller];
    }else if ([viewController isKindOfClass:[UINavigationController class]]){
        UINavigationController *nvc  = (UINavigationController *)viewController;
        UIViewController *controller = nvc.visibleViewController;
        result = [UIUtilities getTopViewController:controller];
    }else if ([viewController isKindOfClass:[UITabBarController class]]){
        UITabBarController *tab = (UITabBarController *)viewController;
        UIViewController *controller = tab.selectedViewController;
        result = [UIUtilities getTopViewController:controller];
    }else{
        result = viewController;
    }
    return result;
}

+ (void)showAlertWithTitle:(NSString *)title message:(NSString *)message buttonTitles:(NSArray<NSString *> *)buttonTitles clickBlock:(void (^)(NSUInteger index))clickBlock{
    
    if (@available(iOS 8.0, *)) {
        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:title
                                              message:message
                                              preferredStyle:UIAlertControllerStyleAlert];
        for (int i = 0; i < buttonTitles.count; i++) {
            if (@available(iOS 8.0, *)) {
                UIAlertAction *alertAction = [UIAlertAction actionWithTitle:buttonTitles[i] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    if (clickBlock) clickBlock(i);
                }];
                [alertController addAction:alertAction];
            } else {

                //乔布斯都不在了,早期版本处理毛啊`````
            }
        }
        [[UIUtilities currentDisplayController] presentViewController:alertController animated:YES completion:nil];
    }
    
}

+ (void)showActionSheetWithTitle:(NSString *)title cancelTitle:(NSString *)cancelTitle cancelBlock:(void (^)(void))cancelBlock otherTitles:(NSArray <NSString *> *)otherTitles clickBlock:(void (^)(NSUInteger index))clickBlock{
    if (cancelTitle.length == 0 && otherTitles.count == 0) {
        return;
    }
    if (@available(iOS 8.0, *)) {
        UIAlertController *controller = [UIAlertController
                                         alertControllerWithTitle:title
                                         message:nil
                                         preferredStyle:UIAlertControllerStyleActionSheet];
        if (cancelTitle.length > 0) {
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                if (cancelBlock) {
                    cancelBlock();
                }
            }];
            [controller addAction:cancelAction];
        }
        
        for (int i = 0; i < otherTitles.count; i++) {
            UIAlertAction *otherAction = [UIAlertAction actionWithTitle:otherTitles[i] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                if (clickBlock) {
                    clickBlock(i);
                }
            }];
            [controller addAction:otherAction];
        }
        [[UIUtilities currentDisplayController]  presentViewController:controller animated:YES completion:nil];
    }
    
}
@end

