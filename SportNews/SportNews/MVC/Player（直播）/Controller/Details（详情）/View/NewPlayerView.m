//
//  NewPlayerView.m
//  SportNews
//
//  Created by yuhua on 2021/3/14.
//

#import "NewPlayerView.h"
#import "ZFAVPlayerManager.h"
#import "SNPictureInPictureShare.h"


@interface NewPlayerView()

/// 播放的view
@property (nonatomic, strong) UIImageView *containerView;
/// 控制器
@property (nonatomic, strong) ZFPlayerController *player;

@property (nonatomic, strong) UIImageView     *videoLogo;

@end
  
/// 新播放器
@implementation NewPlayerView

- (instancetype)initWithFrame:(CGRect)frame withModel:(LiveListModel *)model {
    self = [super initWithFrame:frame];
    if (self) {
        /// 播放器管理
        self.model = model;
        ZFAVPlayerManager *manager = [ZFAVPlayerManager new];
        self.manager = manager;
        /// 自动播放
        manager.shouldAutoPlay = true;
        /// 设置防盗链
        manager.requestHeader = @{@"AVURLAssetHTTPHeaderFieldsKey": @{@"Referer":@"https://shuoqiudi.live/", @"accept": @"*/*",@"accept-encoding": @"gzip, deflate, br",@"accept-language": @"zh-CN,zh;q=0.9",@"connection": @"document",@"sec-fetch-mode": @"cors",@"sec-fetch-site": @"cross-site",@"user-agent": @"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/85.0.4183.102 Safari/537.36",@"Connection":@"keep-alive"
        }};
        /// 播放view
        self.containerView = [UIImageView new];
        [self addSubview:self.containerView];
        //[self addSubview:self.videoLogo];
        
        /// 设置控制器
        // self.player = [ZFPlayerController playerWithPlayerManager:manager containerView:self.containerView];
        self.player = [[ZFPlayerController alloc] initWithPlayerManager:manager containerView:self.containerView];
        /// 设置控制条
        self.player.controlView = self.controlView;
        /// 是否自动暂停
        self.player.pauseWhenAppResignActive = false;
        //是否支持旋转
        self.player.allowOrentitaionRotation = NO;
        /// 设置点击全屏时是否可旋转
        WeakSelf
        self.player.orientationWillChange = ^(ZFPlayerController * _Nonnull player, BOOL isFullScreen) {
            weakSelf.videoLogo.hidden = isFullScreen;
            ((AppDelegate*)[[UIApplication sharedApplication] delegate]).allowOrentitaionRotation = isFullScreen;
            // 新的SDK不支援
//            if (weakSelf.controlView.portraitControlView.danmuBtn.isSelected || !isFullScreen) {
//                [[BarrageManager shareManager] clearBarrage];
//            }
        };
    }
    return self;
}

- (void)setIsLoaded:(BOOL)isLoaded {
    self.player.allowOrentitaionRotation = self.isLoaded;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    /// 设置播放view布局
    self.containerView.frame = self.bounds;
}

//http://ivi.bupt.edu.cn/hls/cctv1hd.m3u8
- (void)setup:(NSString *)urlString {
    SNPictureInPictureShared.playerVc = nil;
    [SNPictureInPictureShared.picController.playerLayer.player pause];
    [SNPictureInPictureShared.picController stopPictureInPicture];
    NSURL *url = [NSURL URLWithString:urlString];
    if (url == nil) {
        return;
    }
    self.player.assetURLs = @[url];
    [self.player playTheIndex:0];
    /// 设置占位图片
    if (self.model.type.intValue == 1) {
        [self.controlView showTitle:@"" coverURLString:nil placeholderImage:[UIImage imageNamed:@"liveBg1"] fullScreenMode:ZFFullScreenModeAutomatic];
    }else {
        [self.controlView showTitle:@"" coverURLString:nil placeholderImage:[UIImage imageNamed:@"liveBg2"] fullScreenMode:ZFFullScreenModeAutomatic];
    }
    if (self.model.status.intValue != 0 && self.model.video_url.length > 0) {
        NSDictionary *recordDic = [[NSUserDefaults standardUserDefaults] objectForKey:SaveVideoSeekTime];
        if (recordDic && [[recordDic allKeys] containsObject:[NSString stringWithFormat:@"%@",self.model.ID]]) {
            NSString *current = recordDic[[NSString stringWithFormat:@"%@",self.model.ID]];
            self.manager.seekTime = [current integerValue];
        }
    }
}

- (BOOL)isFull {
    return self.player.isFullScreen;
}

- (void)play {
    [self.manager.player play];
}

- (void)stop {
    [self.player stop];
}

- (UIImageView *)videoLogo{
    if (!_videoLogo) {
        _videoLogo = [[UIImageView alloc]initWithFrame:CGRectMake(15, 15, 54.5, 18)];
        _videoLogo.image = [UIImage imageNamed:@"说球帝logo白"];
    }
    return _videoLogo;
}

/// 播放器控制条样式
- (ZFPlayerControlView *)controlView {
    if (!_controlView) {
        _controlView = [ZFPlayerControlView new];
        _controlView.fastViewAnimated = YES;
        _controlView.autoHiddenTimeInterval = 5;
        _controlView.autoFadeTimeInterval = 0.5;
        _controlView.prepareShowLoading = YES;
        _controlView.prepareShowControlView = NO;
        _controlView.showCustomStatusBar = YES;
        // 新的SDK不支援
        if (self.model.video_url.length > 0 && self.model.status.intValue != 0) {
            [_controlView.portraitControlView changeToMP4];
            // [_controlView.landScapeControlView changeToMP4];
        }
        
        @zf_weakify(self)
        _controlView.portraitControlView.rateTap = ^(NSString * _Nonnull rate) {
            @zf_strongify(self)
            self.manager.rate = [rate floatValue];
            // [self.controlView.landScapeControlView.rateBtn setTitle:[NSString stringWithFormat:@"x%@",rate] forState:UIControlStateNormal];
        };
        _controlView.portraitControlView.rate3 = ^{
            @zf_strongify(self)
            self.manager.rate = 2;
        };
//        _controlView.landScapeControlView.rateTap = ^(NSString * _Nonnull rate) {
//            @zf_strongify(self)
//            self.manager.rate = [rate floatValue];
//            [self.controlView.portraitControlView.rateBtn setTitle:[NSString stringWithFormat:@"x%@",rate] forState:UIControlStateNormal];
//        };
//        _controlView.landScapeControlView.rate3 = ^{
//            @zf_strongify(self)
//            self.manager.rate = 2;
//        };
    }
    return _controlView;
}


@end
