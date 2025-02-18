//
//  SNExponentViewController.h
//  SportNews
//
//  Created by kkk on 2021/2/5.
//

#import <UIKit/UIKit.h>
#import "SNExponentModel.h"
#import "LiveListModel.h"
#import "JXPagerView.h"

NS_ASSUME_NONNULL_BEGIN

@interface SNExponentViewController : UIViewController <JXPagerViewListViewDelegate>

@property (nonatomic, copy) void(^reloadDataBlock)(void);

@property (nonatomic, copy) void(^jumpDetail)(NSInteger, NSInteger);

@property(nonatomic, strong) LiveListModel *model;

//是否正在播放动画
@property (nonatomic , assign) PlayingStatus playStatus;

- (void)setupExponentModel:(SNExponentModel *)exponentModel;

- (void)loadDataFailure;

@end

NS_ASSUME_NONNULL_END
