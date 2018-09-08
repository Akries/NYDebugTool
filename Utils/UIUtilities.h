//
//  UIUtilities.h
//  SaicCarPlatform
//
//  Created by Akries.NY on 2018/8/22.
//  Copyright © 2018年 Saic. All rights reserved.


//该类主要功能：获取当前显示控制器，获取某页面控制器栈顶的控制器对象，alert，actionsheet
#import <UIKit/UIKit.h>

@interface UIUtilities : NSObject

/**
 *  获取当前正被展示的页面控制器
 *
 *  @return 控制器对象
 */
+ (UIViewController *)currentDisplayController;

/**
 *  获取当前应用被展示的Window
 *
 *  @return Window对象
 */
+ (UIWindow *)currentAppWindow;

/**
 *  获取某页面控制器栈顶的控制器对象
 *
 *  @param viewController 目标查询控制器对象
 *
 *  @return 栈顶控制器对象
 */
+ (UIViewController *)getTopViewController:(UIViewController *)viewController;


/**
 创建系统弹框，根据block回调拿到点击index
 
 @param buttonTitles buttonTitles数组
 @param clickBlock 点击回调
 */
+ (void)showAlertWithTitle:(NSString *)title message:(NSString *)message buttonTitles:(NSArray<NSString *> *)buttonTitles clickBlock:(void (^)(NSUInteger index))clickBlock;


/**
 创建系统sheet弹框，根据block回调拿到点击index
 
 @param cancelBlock 取消回调
 @param otherTitles title数组
 @param clickBlock 点击回调
 */
+ (void)showActionSheetWithTitle:(NSString *)title cancelTitle:(NSString *)cancelTitle cancelBlock:(void (^)(void))cancelBlock otherTitles:(NSArray <NSString *> *)otherTitles clickBlock:(void (^)(NSUInteger index))clickBlock;

@end
