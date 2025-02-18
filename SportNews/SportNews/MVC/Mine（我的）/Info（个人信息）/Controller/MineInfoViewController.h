//
//  MineInfoViewController.h
//  SportNews
//
//  Created by kkk on 2020/12/4.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface MineInfoViewController : BaseNavTableViewController

@property (nonatomic, copy) void(^successUploadImage)(UIImage *image);
@property(nonatomic, strong) UIImage *iconImage;

@property(nonatomic, assign) BOOL isLeftPush;

@end

NS_ASSUME_NONNULL_END
