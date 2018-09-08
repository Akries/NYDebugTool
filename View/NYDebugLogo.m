//
//  NYDebugLogo.m
//  SaicCarPlatform
//
//  Created by Akries.NY on 2018/8/22.
//  Copyright © 2018年 Saic. All rights reserved.
//

#import "NYDebugLogo.h"
#import "NYDebugManager.h"
#import "NYDebugManagerController.h"
#import "UIUtilities.h"
#import "NYEnviroument.h"

@implementation NYDebugLogo{
    UILabel *roundView;
}

+ (instancetype)logo{
    static NYDebugLogo *logo;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        logo = [[NYDebugLogo alloc] _init];
    });
    return logo;
}

- (id)init{
    return [NYDebugLogo logo];
}

- (id)_init{
    CGRect screen = [UIScreen mainScreen].bounds;
    if (self = [super initWithFrame:CGRectMake(screen.size.width-65, screen.size.height/2, 55, 55)]) {
        self.backgroundColor = [UIColor clearColor];
        
        roundView = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 45, 45)];
        roundView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        roundView.textAlignment = NSTextAlignmentCenter;
        roundView.font = [UIFont systemFontOfSize:13];
        roundView.textColor = [UIColor whiteColor];
        roundView.adjustsFontSizeToFitWidth = YES;
        roundView.minimumScaleFactor = 0.2;
        roundView.clipsToBounds = YES;
        roundView.layer.borderColor = [[UIColor colorWithRed:1 green:1 blue:1 alpha:0.7] CGColor];
        roundView.layer.borderWidth = 1;
        roundView.layer.cornerRadius = roundView.frame.size.width/2;
        roundView.layer.shadowColor = [[UIColor blackColor] CGColor];
        roundView.layer.shadowOffset = CGSizeMake(0, 0);
        roundView.layer.shadowRadius = 5;
        roundView.layer.shadowOpacity = 0.8;
        roundView.text = [NYEnviroument defaultEnviroument].enviroumentName;
        [self addSubview:roundView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
        tap.numberOfTapsRequired = 2;
        [self addGestureRecognizer:tap];
        
        if ([NYDebugManager defaultManager].appDebugMode) {
            self.hidden = NO;
        }else {
            self.hidden = YES;
        }
#ifdef DEBUG
        self.hidden = NO;
#else
#endif
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(debugModeChanged:) name:AppDebugModeChangedNotification object:nil];
        
    }
    return self;
}

- (void)refreshEnviroumentLabel{
    roundView.text = [NYEnviroument defaultEnviroument].enviroumentName;
}

- (void)setHidden:(BOOL)hidden{
    [super setHidden:hidden];
}

- (void)debugModeChanged:(NSNotification *)noti{
    NSNumber *value = noti.userInfo[@"AppDebugMode"];
    if ([value boolValue]) {
        self.hidden = NO;
    }else {
        self.hidden = YES;
    }
}

#pragma mark - touch events

- (void)viewTapped:(UITapGestureRecognizer *)recognizer{
    UIViewController *root = [[UIApplication sharedApplication] keyWindow].rootViewController;
    if (root.presentedViewController && [root.presentedViewController isKindOfClass:[UINavigationController class]]) {
        UIViewController *controller = ((UINavigationController *)root.presentedViewController).viewControllers.firstObject;
        if ([controller isKindOfClass:[NYDebugManagerController class]]) {
            return;
        }
    }
    
    NYDebugManagerController *controller = [[NYDebugManagerController alloc] init];
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:controller];
    [[UIUtilities currentDisplayController] presentViewController:navi animated:YES completion:nil];
    [UIView animateWithDuration:0.2 animations:^{
        self.center = [self calculateEndPosition:self.center];
    }];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesMoved:touches withEvent:event];
    
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.superview];
    
    self.center = point;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesEnded:touches withEvent:event];
    
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.superview];
    
    [UIView animateWithDuration:0.2 animations:^{
        self.center = [self calculateEndPosition:point];
    }];
}

- (CGPoint)calculateEndPosition:(CGPoint)point{
    CGPoint _resumePoint = CGPointZero;
    
    if (point.y < 80) {
        // stick to top
        if (point.x < 10 + self.frame.size.width/2) {
            _resumePoint.x = 10 + self.frame.size.width/2;
        }else if (point.x > self.superview.frame.size.width - 10 - self.frame.size.width/2) {
            _resumePoint.x = self.superview.frame.size.width - 10 - self.frame.size.width/2;
        }else {
            _resumePoint.x = point.x;
        }
        _resumePoint.y = 25 + self.frame.size.height/2;
    }else if (point.y > self.superview.frame.size.height - 80) {
        // stick to bottom
        if (point.x < 10 + self.frame.size.width/2) {
            _resumePoint.x = 10 + self.frame.size.width/2;
        }else if (point.x > self.superview.frame.size.width - 10 - self.frame.size.width/2) {
            _resumePoint.x = self.superview.frame.size.width - 10 - self.frame.size.width/2;
        }else {
            _resumePoint.x = point.x;
        }
        _resumePoint.y = self.superview.frame.size.height - 10 - self.frame.size.height/2;
    }else {
        // stick to left or right
        if (point.x < 10 + self.frame.size.width/2) {
            _resumePoint.x = 10 + self.frame.size.width/2;
        }else if (point.x > self.superview.frame.size.width - 10 - self.frame.size.width/2) {
            _resumePoint.x = self.superview.frame.size.width - 10 - self.frame.size.width/2;
        }else {
            if (point.x < self.superview.frame.size.width/2) {
                _resumePoint.x = 10 + self.frame.size.width/2;
            }else {
                _resumePoint.x = self.superview.frame.size.width - 10 - self.frame.size.width/2;
            }
        }
        if (point.y < 20 + self.frame.size.height/2) {
            _resumePoint.y = 20 + self.frame.size.height/2;
        }else if (point.y > self.superview.frame.size.height - 10 - self.frame.size.height/2) {
            _resumePoint.y = self.superview.frame.size.height - 10 - self.frame.size.height/2;
        }else {
            _resumePoint.y = point.y;
        }
    }
    return _resumePoint;
}

@end
