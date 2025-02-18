//
//  SettingViewController.h
//  SportNews
//
//  Created by kkk on 2020/12/4.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface SettingViewController : BaseNavTableViewController

@property (nonatomic, copy) void(^loginOutBlock)(void);

@end

NS_ASSUME_NONNULL_END
