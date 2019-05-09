//
//  NYDebugLatlngController.h
//  AFNetworking
//
//  Created by niyang on 2018/12/18.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^ChangeCurrentLocationBlock) (NSString *lat,NSString *lng);

@interface NYDebugLatlngController : UIViewController

@property(nonatomic,copy)ChangeCurrentLocationBlock changeBlock;
- (void)setChangeBlock:(ChangeCurrentLocationBlock)changeBlock;
@end

NS_ASSUME_NONNULL_END
