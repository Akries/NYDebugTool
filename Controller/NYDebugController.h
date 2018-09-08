//
//  NYDebugController.h
//  SaicCarPlatform
//
//  Created by Akries.NY on 2018/8/22.
//  Copyright © 2018年 Saic. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ChangeCurrentLocationBlock) (NSString *lat,NSString *lng);

@interface NYDebugController : UIViewController

@property(nonatomic,copy)ChangeCurrentLocationBlock changeBlock;


@end
