//
//  LiveDetailViewController.h
//  SportNews
//
//  Created by K哥 on 2020/12/29.
//

#import <UIKit/UIKit.h>
#import "LiveListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LiveDetailViewController : BaseTableViewController

@property(nonatomic, strong) NSNumber *ID;

@property(nonatomic, strong) LiveListModel *model;

@end

NS_ASSUME_NONNULL_END
