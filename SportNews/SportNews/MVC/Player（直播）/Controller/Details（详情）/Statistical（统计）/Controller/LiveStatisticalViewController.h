//
//  LiveStatisticalViewController.h
//  SportNews
//
//  Created by kkk on 2021/1/21.
//

#import <UIKit/UIKit.h>
#import "LiveListModel.h"
#import "SNStatisticalModel.h"
#import "JXPagerView.h"

NS_ASSUME_NONNULL_BEGIN

@interface LiveStatisticalViewController : UIViewController <JXPagerViewListViewDelegate>

@property (nonatomic, copy) void(^reloadDataBlock)(void);

//列表
@property(nonatomic, strong) LiveListModel *model;

//是否正在播放动画
@property (nonatomic , assign) PlayingStatus playStatus;
 
- (void)setupStatisticalModel:(SNStatisticalModel *)statisticalModel;

- (void)loadDataFailure;

- (void)updateScrollViewHeight:(PlayingStatus)playStatus;

@end

NS_ASSUME_NONNULL_END
