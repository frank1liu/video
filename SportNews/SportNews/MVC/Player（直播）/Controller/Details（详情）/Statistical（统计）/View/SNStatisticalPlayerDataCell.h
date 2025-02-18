//
//  SNStatisticalPlayerDataCell.h
//  SportNews
//
//  Created by 根哥 on 2021/1/26.
//

#import <UIKit/UIKit.h>
#import "SNStatisticalModel.h"

NS_ASSUME_NONNULL_BEGIN


/// 篮球球员数据统计
@interface SNStatisticalPlayerDataCell : UITableViewCell

@property(nonatomic, assign) NSInteger section;

@property(nonatomic, strong) SNStatisticalModel *statisticalModel;

@end

NS_ASSUME_NONNULL_END
