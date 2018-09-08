//
//  NYDebugController.m
//  SaicCarPlatform
//
//  Created by Akries.NY on 2018/8/22.
//  Copyright © 2018年 Saic. All rights reserved.
//

#import "NYDebugController.h"


static NSString *NYDebugControllerLatKey = @"NYDebugControllerLatKey";
static NSString *NYDebugControllerLngKey = @"NYDebugControllerLngKey";

@interface NYDebugController ()

@property (weak, nonatomic) IBOutlet UITextField *latTf;
@property (weak, nonatomic) IBOutlet UITextField *lngTf;

@end

@implementation NYDebugController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    
    NSBundle *mainBundle = [NSBundle bundleForClass:[self class]];
    NSBundle *resourcesBundle = [NSBundle bundleWithPath:[mainBundle pathForResource:@"NYDebugTool" ofType:@"bundle"]];
    
    if(self = [super initWithNibName:@"NYDebugController" bundle:resourcesBundle]){
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.latTf.text = [[NSUserDefaults standardUserDefaults] objectForKey:NYDebugControllerLatKey];
    self.lngTf.text = [[NSUserDefaults standardUserDefaults] objectForKey:NYDebugControllerLngKey];

}

- (IBAction)modifyLocConfirmBtnTapped:(UIButton *)sender {
    if (self.latTf.text.length > 0) {
        [[NSUserDefaults standardUserDefaults] setObject:self.latTf.text forKey:NYDebugControllerLatKey];
    }else return;
    
    if (self.lngTf.text.length > 0) {
        [[NSUserDefaults standardUserDefaults] setObject:self.lngTf.text forKey:NYDebugControllerLngKey];
    }else return;
    
    if (_changeBlock) {
        _changeBlock(self.latTf.text,self.lngTf.text);
        
    }
}

- (IBAction)clearLocBtnTapped:(UIButton *)sender {
    self.latTf.text = @"";
    self.lngTf.text = @"";
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:NYDebugControllerLatKey];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:NYDebugControllerLngKey];
}


@end
