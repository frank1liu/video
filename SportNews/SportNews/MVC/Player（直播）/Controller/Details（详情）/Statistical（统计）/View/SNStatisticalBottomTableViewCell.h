//
//  SNStatisticalBottomTableViewCell.h
//  SportNews
//
//  Created by kkk on 2021/1/26.
//

#import <UIKit/UIKit.h>
#import "LiveListModel.h"
#import "SNStatisticalModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SNStatisticalBottomTableViewCell : UITableViewCell

@property(nonatomic, strong) SNStatisticalModel *statisticalModel;
//列表
@property(nonatomic, strong) LiveListModel *model;

@end

NS_ASSUME_NONNULL_END
