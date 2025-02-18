//
//  LiveDetailController.h
//  SportNews
//
//  Created by K哥 on 2020/12/30.
//

#import <UIKit/UIKit.h>
#import "LiveListModel.h"
#import "NewPlayerView.h"
#import <Superplayer/SuperPlayer.h>

@class LiveContentBottomView;
@class SNLiveDetailNaviView;

NS_ASSUME_NONNULL_BEGIN

@interface LiveDetailController : BaseTableViewController
 
@property(nonatomic, assign) BOOL isPushByVs;

@property(nonatomic, strong) LiveListModel *model;

@property (nonatomic , strong) LiveContentBottomView *bottomView;

@property (nonatomic , strong) SNLiveDetailNaviView *naviView;

@property (strong, nonatomic) NewPlayerView *systemPlayerView;

@property (nonatomic , strong) SuperPlayerModel *playModel;

@property(nonatomic, strong) UIView *tBackgroundView;

@property(nonatomic, assign) BOOL isClickPop;

- (void)setupTimer;

- (void)getDatas;

- (void)setupCategoryView; 

- (void)setupPlayModel;
 

@end

NS_ASSUME_NONNULL_END
