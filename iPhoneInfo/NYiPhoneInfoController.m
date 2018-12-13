//
//  NYiPhoneInfoController.m
//  ClientTest
//
//  Created by Akries.NY on 2018/9/11.
//  Copyright © 2018年 Saic. All rights reserved.
//

#import "NYiPhoneInfoController.h"
#import "NYdeviceInfoManager.h"
#import "NetWorkInfoManager.h"


@interface BaseInfo : NSObject

@property (nonatomic, copy) NSString *infoKey;
@property (nonatomic, strong) NSObject *infoValue;

@end

@implementation BaseInfo
@end



@interface NYiPhoneInfoController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *infoArray;

@property (nonatomic, strong) UITableView *myTableView;

@end

@implementation NYiPhoneInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"iPhone信息大全";
    self.myTableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    self.myTableView.rowHeight = 52;
    
    [self.view addSubview:self.myTableView];
    
    if (@available(iOS 11.0, *)) {
        self.navigationController.navigationBar.prefersLargeTitles = YES;
        self.navigationController.navigationBar.largeTitleTextAttributes = @{
                                                                             NSFontAttributeName:[UIFont systemFontOfSize:28.0],
                                                                             NSForegroundColorAttributeName:[UIColor blackColor],
                                                                             };
    }
    [self setupiPhoneInfo];
}

- (void)setupiPhoneInfo {
    const NSString *deviceName = [[NYdeviceInfoManager sharedManager] getDeviceName];
    
    [self _addInfoWithKey:@"设备型号" infoValue:[deviceName copy]];

    NSString *appVerion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [self _addInfoWithKey:@"app版本号" infoValue:appVerion];
    
    NSString *systemVersion = [UIDevice currentDevice].systemVersion;
    [self _addInfoWithKey:@"当前系统版本号" infoValue:systemVersion];
    // 广告位标识符：在同一个设备上的所有App都会取到相同的值，是苹果专门给各广告提供商用来追踪用户而设的，用户可以在 设置|隐私|广告追踪里重置此id的值，或限制此id的使用，故此id有可能会取不到值，但好在Apple默认是允许追踪的，而且一般用户都不知道有这么个设置，所以基本上用来监测推广效果，是戳戳有余了
    NSString *idfa = [[NYdeviceInfoManager sharedManager] getIDFA];
    [self _addInfoWithKey:@"广告位标识符idfa" infoValue:idfa];
    
    //  UUID是Universally Unique Identifier的缩写，中文意思是通用唯一识别码。它是让分布式系统中的所有元素，都能有唯一的辨识资讯，而不需要透过中央控制端来做辨识资讯的指 定。这样，每个人都可以建立不与其它人冲突的 UUID。在此情况下，就不需考虑数据库建立时的名称重复问题。苹果公司建议使用UUID为应用生成唯一标识字符串。
    NSString *uuid = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    [self _addInfoWithKey:@"唯一识别码uuid" infoValue:uuid];
    
    NSString *aMapServices_identifier = [[AMapServices sharedServices] identifier];
    [self _addInfoWithKey:@"aMapServices_identifier" infoValue:aMapServices_identifier];
    
    NSString *macAddress = [[NYdeviceInfoManager sharedManager] getMacAddress];
    [self _addInfoWithKey:@"macAddress" infoValue:macAddress];
    
    NSString *deviceIP = [[NetWorkInfoManager sharedManager] getDeviceIPAddresses];
    [self _addInfoWithKey:@"deviceIP" infoValue:deviceIP];
    
    NSString *cellIP = [[NetWorkInfoManager sharedManager] getIpAddressCell];
    [self _addInfoWithKey:@"蜂窝地址" infoValue:cellIP];
    
    NSString *wifiIP = [[NetWorkInfoManager sharedManager] getIpAddressWIFI];
    [self _addInfoWithKey:@"WIFI IP地址" infoValue:wifiIP];

    NSArray *perCPUArr = [[NYdeviceInfoManager sharedManager] getPerCPUUsage];
    NSMutableString *perCPUUsage = [NSMutableString string];
    for (NSNumber *per in perCPUArr) {
        
        [perCPUUsage appendFormat:@"%.2f<-->", per.floatValue];
    }
    [self _addInfoWithKey:@"单个CPU使用比例" infoValue:perCPUUsage];
    
    
    NSString *applicationSize = [[NYdeviceInfoManager sharedManager] getApplicationSize];
    [self _addInfoWithKey:@"当前 App 所占内存空间" infoValue:applicationSize];

    int64_t totalMemory = [[NYdeviceInfoManager sharedManager] getTotalMemory];
    NSString *totalMemoryInfo = [NSString stringWithFormat:@" %.2f MB == %.2f GB", totalMemory/1024/1024.0, totalMemory/1024/1024/1024.0];
    [self _addInfoWithKey:@"系统总内存空间" infoValue:totalMemoryInfo];
    
    int64_t freeMemory = [[NYdeviceInfoManager sharedManager] getFreeMemory];
    NSString *freeMemoryInfo = [NSString stringWithFormat:@" %.2f MB == %.2f GB", freeMemory/1024/1024.0, freeMemory/1024/1024/1024.0];
    [self _addInfoWithKey:@"空闲的内存空间" infoValue:freeMemoryInfo];
    
    int64_t usedMemory = [[NYdeviceInfoManager sharedManager] getFreeDiskSpace];
    NSString *usedMemoryInfo = [NSString stringWithFormat:@" %.2f MB == %.2f GB", usedMemory/1024/1024.0, usedMemory/1024/1024/1024.0];
    [self _addInfoWithKey:@"已使用的内存空间" infoValue:usedMemoryInfo];
    
    int64_t activeMemory = [[NYdeviceInfoManager sharedManager] getActiveMemory];
    NSString *activeMemoryInfo = [NSString stringWithFormat:@"正在使用或者很短时间内被使用过 %.2f MB == %.2f GB", activeMemory/1024/1024.0, activeMemory/1024/1024/1024.0];
    [self _addInfoWithKey:@"活跃的内存" infoValue:activeMemoryInfo];
    
    int64_t inActiveMemory = [[NYdeviceInfoManager sharedManager] getInActiveMemory];
    NSString *inActiveMemoryInfo = [NSString stringWithFormat:@"但是目前处于不活跃状态的内存 %.2f MB == %.2f GB", inActiveMemory/1024/1024.0, inActiveMemory/1024/1024/1024.0];
    [self _addInfoWithKey:@"最近使用过" infoValue:inActiveMemoryInfo];
    
    int64_t wiredMemory = [[NYdeviceInfoManager sharedManager] getWiredMemory];
    NSString *wiredMemoryInfo = [NSString stringWithFormat:@"framework、用户级别的应用无法分配 %.2f MB == %.2f GB", wiredMemory/1024/1024.0, wiredMemory/1024/1024/1024.0];
    [self _addInfoWithKey:@"用来存放内核和数据结构的内存" infoValue:wiredMemoryInfo];
    
    int64_t purgableMemory = [[NYdeviceInfoManager sharedManager] getPurgableMemory];
    NSString *purgableMemoryInfo = [NSString stringWithFormat:@"大对象存放所需的大块内存空间 %.2f MB == %.2f GB", purgableMemory/1024/1024.0, purgableMemory/1024/1024/1024.0];
    [self _addInfoWithKey:@"可释放的内存空间：内存吃紧自动释放" infoValue:purgableMemoryInfo];
    
    [self.myTableView reloadData];
}



- (void)_addInfoWithKey:(NSString *)infoKey infoValue:(NSObject *)infoValue {
    BaseInfo *info = [[BaseInfo alloc] init];
    info.infoKey = infoKey;
    info.infoValue = infoValue;
    NSLog(@"%@---%@", infoKey, infoValue);
    [self.infoArray addObject:info];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.infoArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *idetifier = @"kIndentifier";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:idetifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:idetifier];
    }
    
    BaseInfo *infoModel = self.infoArray[indexPath.row];
    cell.textLabel.text = infoModel.infoKey;
    cell.textLabel.font = [UIFont systemFontOfSize:14.0];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:12.0];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"------>%@", infoModel.infoValue];
    cell.detailTextLabel.textColor = [UIColor orangeColor];
    cell.detailTextLabel.numberOfLines = 0;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.myTableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - setters && getters
- (NSMutableArray *)infoArray {
    if (!_infoArray) {
        _infoArray = [NSMutableArray array];
    }
    return _infoArray;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
