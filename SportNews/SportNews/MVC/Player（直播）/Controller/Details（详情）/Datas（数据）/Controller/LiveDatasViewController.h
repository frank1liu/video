//
//  LiveDatasViewController.h
//  SportNews
//
//  Created by kkk on 2021/1/16.
//

#import <UIKit/UIKit.h>
#import "LiveListModel.h"
#import "SNDatasModel.h"
#import "JXPagerView.h"

NS_ASSUME_NONNULL_BEGIN

@interface LiveDatasViewController : UIViewController <JXPagerViewListViewDelegate>

@property (nonatomic, copy) void(^reloadDataBlock)(void);

@property(nonatomic, strong) UIView *detailView;

@property(nonatomic, strong) LiveListModel *model;

//是否正在播放动画
@property (nonatomic , assign) PlayingStatus playStatus;

- (void)setupDatasModel:(SNDatasModel *)datasModel;

- (void)loadDataFailure;

- (void)hideScreenView:(BOOL)isLeave;

- (void)updateScrollViewHeight:(PlayingStatus)playStatus;

@end

NS_ASSUME_NONNULL_END
