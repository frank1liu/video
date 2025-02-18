//
//  SNSquadViewController.h
//  SportNews
//
//  Created by kkk on 2021/2/5.
//

#import <UIKit/UIKit.h>
#import "SNSquadModel.h"
#import "LiveListModel.h"
#import "JXPagerView.h"

NS_ASSUME_NONNULL_BEGIN

@interface SNSquadViewController : UIViewController <JXPagerViewListViewDelegate>
  
@property(nonatomic, strong) LiveListModel *model;

//是否正在播放动画
@property (nonatomic , assign) PlayingStatus playStatus;
   
- (void)updateScrollViewHeight:(PlayingStatus)playStatus;

@end

NS_ASSUME_NONNULL_END
