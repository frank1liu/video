//
//  SNZFPlayerWindow.h
//  SportNews
//
//  Created by kkk on 2021/5/14.
//

#import <UIKit/UIKit.h>
#import "NewPlayerView.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^ZFPlayerWindowEventHandler)(void);

/// 播放器小窗Window
@interface SNZFPlayerWindow : UIWindow

/// 显示小窗
- (void)show;
/// 隐藏小窗
- (void)hide;
/// 单例
+ (instancetype)sharedInstance;

@property(nonatomic, copy) NSString *videoURL;

@property (nonatomic,copy) ZFPlayerWindowEventHandler backHandler;
/// 小窗播放器
@property (nonatomic,weak) NewPlayerView *zfPlayer;
/// 小窗主view
@property (readonly) UIView *rootView;
/// 点击小窗返回的controller
@property (nonatomic, strong, nullable) UIViewController *backController;
/// 小窗是否显示
@property (readonly) BOOL isShowing;  //

@end

NS_ASSUME_NONNULL_END
