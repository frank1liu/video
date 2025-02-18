//
//  SNStatisticalSectionHeaderView.h
//  SportNews
//
//  Created by kkk on 2021/1/27.
//

#import <UIKit/UIKit.h>
#import "LiveListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SNStatisticalSectionHeaderView : UIView

@property (nonatomic, copy) void(^buttonClickWithTag)(NSInteger tag);

//列表
@property(nonatomic, strong) LiveListModel *model;

@end

NS_ASSUME_NONNULL_END
