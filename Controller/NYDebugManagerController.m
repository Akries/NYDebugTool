//
//  NYDebugManagerController.m
//  SaicCarPlatform
//
//  Created by Akries.NY on 2018/8/22.
//  Copyright © 2018年 Saic. All rights reserved.
//

#import "NYDebugManagerController.h"
#import "NYEnviroument.h"
#import "NYDebugManager.h"
#import "UIUtilities.h"
#import "NYDebugLogo.h"
#import "NYDebugLatlngController.h"


NSString * const kDebugChangedNotification = @"";

@interface NYDebugManagerController ()

@end

@implementation NYDebugManagerController

- (instancetype)init{
    if(self = [super initWithStyle:UITableViewStyleGrouped]){
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"调试工具";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    [self.view addSubview:self.showLabel];
    
}

- (void)back{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    cell.accessoryView = nil;
    cell.detailTextLabel.text = @"";
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    if(indexPath.row == 0){
        cell.textLabel.text = @"当前环境";
        cell.detailTextLabel.text = [NYEnviroument defaultEnviroument].enviroumentName;
    }else if (indexPath.row == 1){
        cell.textLabel.text = @"开启debug";
        cell.accessoryView = [self addDebugModeSwitch];
    }else if (indexPath.row == 2){
        cell.textLabel.text = @"修改经纬度";
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"NYDebugControllerLatKey"]) {
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@,%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"NYDebugControllerLatKey"],[[NSUserDefaults standardUserDefaults] objectForKey:@"NYDebugControllerLngKey"]];
        }
    }else if (indexPath.row == 3){
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
        NSString *app_build = [infoDictionary objectForKey:@"CFBundleVersion"];
        cell.textLabel.text = @"APP版本(build)";
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@(%@)", app_Version, app_build];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    else if (indexPath.row == 4) {
        cell.textLabel.text = @"开启模拟导航";
        cell.accessoryView = [self addEmulatorNaviModeModeSwitch];
    }
    else if (indexPath.row == 5) {
        cell.textLabel.text = @"iPhone infomation";
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:{
            if (![NYDebugManager defaultManager].allowSwitchDomain){
                return;
            }
            [UIUtilities showActionSheetWithTitle:@"环境切换" cancelTitle:@"取消" cancelBlock:nil otherTitles: [[NYEnviroument defaultEnviroument] enviroumentNames] clickBlock:^(NSUInteger index) {
                
                
                [[NYEnviroument defaultEnviroument] modifyEnviroumentByName: [[NYEnviroument defaultEnviroument] enviroumentNames][index]];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"debugChangedNotification" object:nil];
                [[NYDebugLogo logo] refreshEnviroumentLabel];
                
                
                NSDictionary *envdic = [[NYEnviroument defaultEnviroument] allEnvs][ny_CurrentEnviroumentName()];
                NSString *envInfo = @"当前环境";
                if ([envdic.allKeys[0] isEqualToString:@"DefaultModule"]) {
                    for (int i = 0 ; i < [envdic[@"DefaultModule"] allKeys].count ; i ++) {
                        envInfo = [envInfo stringByAppendingString:[NSString stringWithFormat:@"\n%@ -> %@",[envdic[@"DefaultModule"] allKeys][i],[envdic[@"DefaultModule"] allValues][i]]];
                    }
                }else{
                    for (int i = 0 ; i < [envdic allKeys].count ; i ++) {
                        envInfo = [envInfo stringByAppendingString:[NSString stringWithFormat:@"\n%@ -> %@",[envdic allKeys][i],[envdic allValues][i]]];
                    }
                }
                self.showLabel.text = envInfo;

                [UIUtilities showAlertWithTitle:@"提醒" message:@"请杀掉app，重新进入！！！" buttonTitles:@[@"确定"] clickBlock:^(NSUInteger index) {}];
                [self.tableView reloadData];
            }];
        }break;
        case 2:{
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            Class class = NSClassFromString(@"NYDebugLatlngController");
            if (class) {
                NYDebugLatlngController *lClass = [class new];
                [lClass setChangeBlock:^(NSString * _Nonnull lat, NSString * _Nonnull lng) {
                    cell.detailTextLabel.text = ([lat floatValue] > 0) ? [NSString stringWithFormat:@"%@,%@",lat,lng] : @"";
                }];
                [self.navigationController pushViewController:lClass animated:YES];
            }
        }break;
        case 5:{
            Class class = NSClassFromString(@"NYiPhoneInfoController");
            if (class) {
                [self.navigationController pushViewController:[class new] animated:YES];
            }
        }
        default:
            break;
    }
}

#pragma mark - getter
- (UISwitch *)addDebugModeSwitch{
    UISwitch *debugModeShift = [[UISwitch alloc] initWithFrame:CGRectMake(0, 0, 65, 38)];
    debugModeShift.on = [NYDebugManager defaultManager].appDebugMode;
    [debugModeShift addTarget:self action:@selector(changeDebugMode:) forControlEvents:UIControlEventValueChanged];
    return debugModeShift;
}

- (UISwitch *)addEmulatorNaviModeModeSwitch{
    UISwitch *debugModeShift = [[UISwitch alloc] initWithFrame:CGRectMake(0, 0, 65, 38)];
    debugModeShift.on = [NYDebugManager defaultManager].appEmulatorNaviMode;
    [debugModeShift addTarget:self action:@selector(changeEmulatorNaviMode:) forControlEvents:UIControlEventValueChanged];
    return debugModeShift;
}

#pragma mark - AddDebugModeSwitch
- (void)changeDebugMode:(UISwitch *)debugSwitch{
    [NYDebugManager defaultManager].appDebugMode = debugSwitch.on;
}
- (void)changeEmulatorNaviMode:(UISwitch *)debugSwitch{
    [NYDebugManager defaultManager].appEmulatorNaviMode = debugSwitch.on;
}

- (UILabel *)showLabel
{
    if (!_showLabel) {
        _showLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, [UIScreen mainScreen].bounds.size.height - 300, [UIScreen mainScreen].bounds.size.width - 60, 250)];
        _showLabel.font = [UIFont systemFontOfSize:14.0];
        _showLabel.numberOfLines = 0;
//        _showLabel.text = [NSString stringWithFormat:@"当前域名:\n%@\n\n tcp:\n %@\n\n 数据上报\n%@",ny_CurrentApiHost(),ny_CurrentMqttHost(),ny_CurrentReportURL()];
        NSDictionary *envdic = [[NYEnviroument defaultEnviroument] allEnvs][ny_CurrentEnviroumentName()];
        NSString *envInfo = @"当前环境";
        if ([envdic.allKeys[0] isEqualToString:@"DefaultModule"]) {
            for (int i = 0 ; i < [envdic[@"DefaultModule"] allKeys].count ; i ++) {
                envInfo = [envInfo stringByAppendingString:[NSString stringWithFormat:@"\n%@ -> %@",[envdic[@"DefaultModule"] allKeys][i],[envdic[@"DefaultModule"] allValues][i]]];
            }
        }else{
            for (int i = 0 ; i < [envdic allKeys].count ; i ++) {
                envInfo = [envInfo stringByAppendingString:[NSString stringWithFormat:@"\n%@ -> %@",[envdic allKeys][i],[envdic allValues][i]]];
            }
        }
        _showLabel.text = envInfo;
    }
    return _showLabel;
}
@end
