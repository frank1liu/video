//
//  NewPlayerView.h
//  SportNews
//
//  Created by yuhua on 2021/3/14.
//

#import <UIKit/UIKit.h>
#import "LiveListModel.h"
#import "ZFAVPlayerManager.h"
#import "ZFPlayerControlView.h"

NS_ASSUME_NONNULL_BEGIN

@interface NewPlayerView : UIView

- (instancetype)initWithFrame:(CGRect)frame withModel:(LiveListModel *)model;
 
/// 设置播放器的父view。播放过程中调用可实现播放窗口转移
@property (nonatomic, weak) UIView *fatherView;
/// 控制条
@property (nonatomic, strong) ZFPlayerControlView *controlView;

@property(nonatomic, strong) LiveListModel *model;

@property(nonatomic, strong) ZFAVPlayerManager *manager;

@property(nonatomic, assign) BOOL isLoaded;
/// 设置URL
- (void)setup:(NSString *)urlString;

/// 播放
- (void)play;

/// 停止播放
- (void)stop;

/// 是否全屏
- (BOOL)isFull;

@end

NS_ASSUME_NONNULL_END
