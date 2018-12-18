//
//  NYDebugLatlngController.m
//  AFNetworking
//
//  Created by niyang on 2018/12/18.
//

#import "NYDebugLatlngController.h"

static NSString *NYDebugControllerLatKey = @"NYDebugControllerLatKey";
static NSString *NYDebugControllerLngKey = @"NYDebugControllerLngKey";

@interface NYDebugLatlngController ()

@property (nonatomic, strong) UITextField *latTf;
@property (nonatomic, strong) UITextField *lngTf;

@property (nonatomic, strong) UIButton *modifyBtn;
@property (nonatomic, strong) UIButton *clearBtn;

@end

@implementation NYDebugLatlngController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.latTf.text = [[NSUserDefaults standardUserDefaults] objectForKey:NYDebugControllerLatKey];
    self.lngTf.text = [[NSUserDefaults standardUserDefaults] objectForKey:NYDebugControllerLngKey];
    
}

- (UITextField *)latTf
{
    if (!_latTf) {
        _latTf = [[UITextField alloc] initWithFrame:CGRectMake(30, 170, 300, 40)];
        _latTf.textAlignment = NSTextAlignmentLeft;
        _latTf.placeholder = @"请输入您需要的维度";
        [self.view addSubview:_latTf];
    }
    return _latTf;
}

- (UITextField *)lngTf
{
    if (!_lngTf) {
        _lngTf = [[UITextField alloc] initWithFrame:CGRectMake(30, 120, 300, 40)];
        _lngTf.textAlignment = NSTextAlignmentLeft;
        _lngTf.placeholder = @"请输入您需要的经度";
        [self.view addSubview:_lngTf];
    }
    return _lngTf;
}

- (UIButton *)modifyBtn
{
    if (_modifyBtn) {
        _modifyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _modifyBtn.frame = CGRectMake(40,220,60,30);
        [_modifyBtn setTitle:@"修改经纬度" forState:UIControlStateNormal];
        [_modifyBtn addTarget:self action:@selector(modifyLatlng:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_modifyBtn];
    }
    return _modifyBtn;
}

- (UIButton *)clearBtn
{
    if (_clearBtn) {
        _clearBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _clearBtn.frame = CGRectMake(260,220,60,30);
        [_modifyBtn setTitle:@"清空经纬度" forState:UIControlStateNormal];
        [_modifyBtn addTarget:self action:@selector(clearLatlng:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_modifyBtn];
    }
    return _clearBtn;
}

- (void)modifyLatlng:(UIButton *)sender
{
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

- (void)clearLatlng:(UIButton *)sender
{
    self.latTf.text = @"";
    self.lngTf.text = @"";
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:NYDebugControllerLatKey];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:NYDebugControllerLngKey];
}


@end
