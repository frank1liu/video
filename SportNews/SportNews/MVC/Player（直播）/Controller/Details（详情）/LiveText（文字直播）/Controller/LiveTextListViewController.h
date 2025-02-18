//
//  LiveTextListViewController.h
//  SportNews
//
//  Created by kkk on 2021/1/16.
//

#import <UIKit/UIKit.h>
#import "LiveListModel.h"
#import "SNFootBallResult.h"
#import "SNBasketBallResult.h"
#import "JXPagerView.h"

NS_ASSUME_NONNULL_BEGIN

@interface LiveTextListViewController : UIViewController <JXPagerViewListViewDelegate>

@property (nonatomic, copy) void(^reloadDataBlock)(void);

//列表
@property(nonatomic, strong) LiveListModel *model;

//足球直播
@property(nonatomic, strong) SNFootBallResult *resultFootObj;
 
//篮球直播
@property(nonatomic, strong) SNBasketBallResult *resultBasketObj;

//是否正在播放动画
@property (nonatomic , assign) PlayingStatus playStatus;

- (void)loadDataFailure;

- (void)updateScrollViewHeight:(PlayingStatus)playStatus;

@end

NS_ASSUME_NONNULL_END
