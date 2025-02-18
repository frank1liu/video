//
//  ZFPortraitControlView.m
//  ZFPlayer
//
// Copyright (c) 2016年 任子丰 ( http://github.com/renzifeng )
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "ZFPortraitControlView.h"
#import "UIView+ZFFrame.h"
#import "ZFUtilities.h"
#if __has_include(<ZFPlayer/ZFPlayer.h>)
#import <ZFPlayer/ZFPlayerConst.h>
#else
#import "ZFPlayerConst.h"
#endif

#import "SuperPlayer.h"
#import "ZFAVPlayerManager.h"

@interface ZFPortraitControlView () <ZFSliderViewDelegate>
/// 底部工具栏
@property (nonatomic, strong) UIView *bottomToolView;
/// 顶部工具栏
@property (nonatomic, strong) UIView *topToolView;
/// 标题
@property (nonatomic, strong) UILabel *titleLabel;
/// 播放或暂停按钮
@property (nonatomic, strong) UIButton *playOrPauseBtn;
/// 播放或暂停按钮
@property (nonatomic, strong) UIButton *playOrPauseBtnBottom;
/// 播放的当前时间 
@property (nonatomic, strong) UILabel *currentTimeLabel;
/// 滑杆
@property (nonatomic, strong) ZFSliderView *slider;
/// 视频总时间
@property (nonatomic, strong) UILabel *totalTimeLabel;
/// 全屏按钮
@property (nonatomic, strong) UIButton *fullScreenBtn;

@property (nonatomic, strong) UIView            *videoTypeDotView; //视频类型(直播、点播)
@property (nonatomic, strong) UILabel           *videoTypeLabel; //视频类型dot

//投屏
@property (nonatomic, strong) UIButton                *touPingBtn;
//分享
@property (nonatomic, strong) UIButton                *shareBtn;
//画中画
@property (nonatomic, strong) UIButton                *xiaoPingBtn;

@property (nonatomic, assign) BOOL isShow;

@property (nonatomic, assign) BOOL isSeek;

@property (nonatomic, assign) BOOL is3play;

@end

@implementation ZFPortraitControlView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.is3play = NO;
        // 添加子控件
        [self addSubview:self.topToolView];
        [self addSubview:self.bottomToolView];
        [self addSubview:self.playOrPauseBtn];
        [self.topToolView addSubview:self.titleLabel];
        [self.topToolView addSubview:self.touPingBtn];
        [self.topToolView addSubview:self.shareBtn];
        
        [self.bottomToolView addSubview:self.playOrPauseBtnBottom];
        [self.bottomToolView addSubview:self.currentTimeLabel];
        [self.bottomToolView addSubview:self.slider];
        [self.bottomToolView addSubview:self.totalTimeLabel];
        [self.bottomToolView addSubview:self.rateBtn];
        self.currentTimeLabel.hidden = YES;
        self.rateBtn.hidden = YES;
        self.slider.hidden = YES;
        self.totalTimeLabel.hidden = YES;
        self.playOrPauseBtnBottom.hidden = true;
        if ([[[BarrageManager shareManager] getDanMu] isEqualToString:@"off"]) {
            self.danmuBtn.selected = YES;
        } else if ([[[BarrageManager shareManager] getDanMu] isEqualToString:@"on"]) {
            self.danmuBtn.selected = NO;
        } else {
            self.danmuBtn.selected = YES;
        }
        
        [self.bottomToolView addSubview:self.fullScreenBtn];
        [self.bottomToolView addSubview:self.xiaoPingBtn];
        [self.bottomToolView addSubview:self.danmuBtn];
        [self.bottomToolView addSubview:self.videoTypeDotView];
        [self.bottomToolView addSubview:self.videoTypeLabel];
        [self.bottomToolView addSubview:self.fbl];
        [self addSubview:self.fblView];
        [self addSubview:self.rateView];
        
        [self buildRate];
        
        // 设置子控件的响应事件
        [self makeSubViewsAction];
        
        [self resetControlView];
        self.clipsToBounds = YES;
        
        
        [self.shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(self.topToolView).offset(-5);
            make.top.equalTo(self.topToolView).offset(7+8);
            make.width.mas_equalTo(@40);
        }];
        
        [self.touPingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(self.topToolView).offset(-45);
            make.top.equalTo(self.topToolView).offset(7+8);
            make.width.mas_equalTo(@40);
        }];
        
        [self.videoTypeDotView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.bottomToolView).offset(12);
            make.bottom.equalTo(self.bottomToolView).offset(-12);
            make.width.height.mas_equalTo(6);
        }];
        
        [self.videoTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.videoTypeDotView.mas_right).offset(5);
            make.centerY.equalTo(self.videoTypeDotView);
        }];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playVideo) name:VideoOK object:nil];
        
    }
    return self;
}

- (void)tap:(UITapGestureRecognizer *)tap {
    CGPoint point = [tap locationInView:self];
    CGFloat width = MIN(kScreenWidth, kScreenHeight);
    float value = self.player.totalTime*self.slider.value;
    if (point.x <= width/3) {
        value -= 10;
    }else if (point.x >= width/3*2) {
        value += 10;
    }else{
        self.isUserPause = YES;
        [self playOrPause];
        return;
    }
    value = value/self.player.totalTime;
    self.slider.value = value;
    [self sliderTapped:value];
}

- (void)longPress:(UILongPressGestureRecognizer *)longPress {
    if (longPress.state == UIGestureRecognizerStateBegan) {
        CGPoint point = [longPress locationInView:self];
        CGFloat width = MIN(kScreenWidth, kScreenHeight);
        if (point.x > width/2) {
            self.is3play = YES;
            self.rate3();
        }
    } else if (longPress.state == UIGestureRecognizerStateEnded && self.is3play) {
        self.is3play = NO;
        self.rateTap(@"1.0");
    }
}

- (void)playVideo {
    if (self.isSeek) {
        self.isSeek = false;
        [self.player.currentPlayerManager play];
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:VideoOK object:nil];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat min_x = 0;
    CGFloat min_y = 0;
    CGFloat min_w = 0;
    CGFloat min_h = 0;
    CGFloat min_view_w = self.bounds.size.width;
    CGFloat min_view_h = self.bounds.size.height;
    CGFloat min_margin = 9;
    
    min_x = 0;
    min_y = 0;
    min_w = min_view_w;
    min_h = 40;
    self.topToolView.frame = CGRectMake(min_x, min_y, min_w, min_h);
    
    min_x = 15;
    min_y = 5;
    min_w = min_view_w - min_x - 15;
    min_h = 30;
    self.titleLabel.frame = CGRectMake(min_x, min_y, min_w, min_h);
    
    min_h = 40;
    min_x = 0;
    min_y = min_view_h - min_h;
    min_w = min_view_w;
    self.bottomToolView.frame = CGRectMake(min_x, min_y, min_w, min_h);
    
    min_x = 0;
    min_y = 0;
    min_w = 44;
    min_h = min_w;
    self.playOrPauseBtn.frame = CGRectMake(min_x, min_y, min_w, min_h);
    self.playOrPauseBtn.center = self.center;
     
    min_x = 10;
    min_y = 32;
    min_w = 25;
    min_h = 25;
    self.playOrPauseBtnBottom.frame = CGRectMake(min_x, min_y, min_w, min_h);
    
    min_x = self.playOrPauseBtnBottom.zf_right + 1;
    min_w = 62;
    min_h = 28;
    min_y = (self.bottomToolView.zf_height - min_h)/2;
    self.currentTimeLabel.frame = CGRectMake(min_x, min_y, min_w, min_h);
    self.playOrPauseBtnBottom.zf_centerY = self.currentTimeLabel.zf_centerY;
  
    min_w = 28;
    min_h = min_w;
    min_x = self.bottomToolView.zf_width - min_w - min_margin;
    min_y = 0;
    self.fullScreenBtn.frame = CGRectMake(min_x, min_y, min_w, min_h);
    self.fullScreenBtn.zf_centerY = self.currentTimeLabel.zf_centerY;
    
    min_w = 28;
    min_h = min_w;
    min_x = self.bottomToolView.zf_width - (min_w + min_margin)*2;
    min_y = 0;
    self.xiaoPingBtn.frame = CGRectMake(min_x, min_y, min_w, min_h);
    self.xiaoPingBtn.zf_centerY = self.currentTimeLabel.zf_centerY;
    
    min_w = 28;
    min_h = min_w;
    min_x = self.bottomToolView.zf_width - (min_w + min_margin)*3;
    min_y = 0;
    self.danmuBtn.frame = CGRectMake(min_x, min_y, min_w, min_h);
    self.danmuBtn.zf_centerY = self.currentTimeLabel.zf_centerY;
    
    min_w = 28;
    min_h = min_w;
    min_x = self.bottomToolView.zf_width - (min_w + min_margin)*4 -5;
    min_y = 0;
    self.rateBtn.frame = CGRectMake(min_x, min_y, min_w+7, min_h);
    self.rateBtn.zf_centerY = self.currentTimeLabel.zf_centerY;
    
    min_w = 62;
    min_h = 28;
    min_x = self.rateBtn.zf_left - min_w - 4;
    min_y = 0;
    self.totalTimeLabel.frame = CGRectMake(min_x, min_y, min_w, min_h);
    self.totalTimeLabel.zf_centerY = self.currentTimeLabel.zf_centerY;
    
    min_x = self.currentTimeLabel.zf_right + 4;
    min_y = 0;
    min_w = self.totalTimeLabel.zf_left - min_x - 4;
    min_h = 30;
    self.slider.frame = CGRectMake(min_x, min_y, min_w, min_h);
    self.slider.zf_centerY = self.currentTimeLabel.zf_centerY;
    
    NSString *fbl = self.fbl.titleLabel.text;
    CGFloat w = [self evaluteWidth:fbl];
    min_w = w;
    min_h = 28;
    min_x = self.bottomToolView.zf_width - (28 + min_margin)*3 - min_margin - min_w - 5;
    min_y = 0;
    self.fbl.frame = CGRectMake(min_x, min_y, min_w, min_h);
    self.fbl.zf_centerY = self.currentTimeLabel.zf_centerY;
    
    if (!self.isShow) {
        self.topToolView.zf_y = -self.topToolView.zf_height;
        self.bottomToolView.zf_y = self.zf_height;
        self.playOrPauseBtn.alpha = 0;
    } else {
        self.topToolView.zf_y = 0;
        self.bottomToolView.zf_y = self.zf_height - self.bottomToolView.zf_height;
        self.playOrPauseBtn.alpha = 1;
    }
}

- (void)rateSelected:(QMUIButton *)btn {
    NSString *rate = [btn qmui_getBoundObjectForKey:@"rate"];
    self.rateTap(rate);
    self.rateView.hidden = YES;
    [self.rateBtn setTitle:[NSString stringWithFormat:@"x%@",rate] forState:UIControlStateNormal];
}

- (void)fblSelected:(QMUIButton *)btn {
    NSString *fblUrl = [btn qmui_getBoundObjectForKey:@"fbl"];
    LiveCartoonModel *currentModel;
    for (LiveCartoonModel *model in self.fblModels) {
        if ([fblUrl isEqualToString:model.url]) {
            currentModel = model;
        }
    }
    self.fblTap(currentModel);
    CGFloat w = [self evaluteWidth:currentModel.name];
    CGFloat min_x = self.bottomToolView.zf_width - (28 + 9)*2 - w - 25;
    self.fbl.x = min_x;
    self.fbl.width = w;
    self.fblView.hidden = YES;
}

- (CGFloat)evaluteWidth:(NSString *)text {
    NSDictionary *textAtt = @{NSFontAttributeName : [UIFont fontWithName:@"PingFangSC-Semibold" size:14]};
    CGSize evaluteLabelSize = [text boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:textAtt context:nil].size;
    CGFloat evaluteLabelSizeW = evaluteLabelSize.width + 1;
    return evaluteLabelSizeW;
}

- (void)fblSelected {
    self.fblView.hidden = !self.fblView.hidden;
}

- (void)rateSelected {
    self.rateView.hidden = !self.rateView.hidden;
}
 
- (void)buildFBL {
    QMUIButton *up;
    for (LiveCartoonModel *model in self.fblModels) {
        QMUIButton *btn = [QMUIButton new];
        [btn setTitle:model.name forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:14];
        [btn qmui_bindObject:model.url forKey:@"fbl"];
        [self.fblView addSubview:btn];
        if (up) {
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(up.mas_bottom);
                make.left.equalTo(self.fblView);
                make.right.equalTo(self.fblView);
                make.height.mas_equalTo(30);
            }];
        } else {
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.fblView);
                make.left.equalTo(self.fblView);
                make.right.equalTo(self.fblView);
                make.height.mas_equalTo(30);
            }];
        }
        [btn addTarget:self action:@selector(fblSelected:) forControlEvents:UIControlEventTouchUpInside];
        up = btn;
    }
}

- (void)buildRate {
    
    [_rateView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.rateBtn.mas_top);
        make.centerX.equalTo(self.rateBtn.mas_centerX);
        make.height.mas_equalTo(125);
        make.width.mas_equalTo(50);
    }];
    
    QMUIButton *up;
    NSArray *rateTitles = @[@"2.0",@"1.5",@"1.25",@"1.0",@"0.8"];
    for (NSString *title in rateTitles) {
        QMUIButton *btn = [QMUIButton new];
        [btn setTitle:title forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:14];
        [btn qmui_bindObject:title forKey:@"rate"];
        [self.rateView addSubview:btn];
        if (up) {
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(up.mas_bottom);
                make.left.equalTo(self.rateView);
                make.right.equalTo(self.rateView);
                make.height.mas_equalTo(25);
            }];
        } else {
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.rateView);
                make.left.equalTo(self.rateView);
                make.right.equalTo(self.rateView);
                make.height.mas_equalTo(25);
            }];
        }
        [btn addTarget:self action:@selector(rateSelected:) forControlEvents:UIControlEventTouchUpInside];
        up = btn;
    }
}


- (void)changeToMP4 {
    self.videoTypeDotView.hidden = YES;
    self.videoTypeLabel.hidden = YES;
    self.currentTimeLabel.hidden = NO;
    self.slider.hidden = NO;
    self.totalTimeLabel.hidden = NO;
    self.playOrPauseBtnBottom.hidden = false;
    self.fblView.hidden = true;
    self.fbl.hidden = true;
    self.rateView.hidden = false;
    self.rateBtn.hidden = false;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    tap.numberOfTapsRequired = 2;
    [self addGestureRecognizer:tap];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    [self addGestureRecognizer:longPress];
}

- (void)makeSubViewsAction {
    [self.playOrPauseBtn addTarget:self action:@selector(playPauseButtonClickAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.playOrPauseBtnBottom addTarget:self action:@selector(playPauseButtonClickAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.touPingBtn addTarget:self action:@selector(touPingAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.shareBtn addTarget:self action:@selector(shareAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.fullScreenBtn addTarget:self action:@selector(fullScreenButtonClickAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.xiaoPingBtn addTarget:self action:@selector(xiaoPingBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(barrageChange:) name:@"BarrageStatusDidChange" object:nil];
}

#pragma mark - action
- (void)touPingAction:(UIButton *)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"toupingNotification" object:nil];
}

- (void)shareAction:(UIButton *)sender {
    if (self.btnTapBlock) {
        self.btnTapBlock(0);
    }
}

- (void)xiaoPingBtnClick:(UIButton *)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"xiaochuangkouNotification" object:nil];
}

- (void)playPauseButtonClickAction:(UIButton *)sender {
    self.isUserPause = YES;
    [self playOrPause];
}

- (void)fullScreenButtonClickAction:(UIButton *)sender {
    [self.player enterFullScreen:YES animated:YES];
}
 
/// 根据当前播放状态取反
- (void)playOrPause {
    self.playOrPauseBtn.selected = !self.playOrPauseBtn.isSelected;
    self.playOrPauseBtnBottom.selected = !self.playOrPauseBtnBottom.isSelected;
    self.playOrPauseBtn.isSelected? [self.player.currentPlayerManager play]: [self.player.currentPlayerManager pause];
}

- (void)playBtnSelectedState:(BOOL)selected {
    self.playOrPauseBtn.selected = selected;
    self.playOrPauseBtnBottom.selected = selected;
}

#pragma mark - ZFSliderViewDelegate

- (void)sliderTouchBegan:(float)value {
    self.slider.isdragging = YES;
    self.isSeek = true;
}

- (void)sliderTouchEnded:(float)value {
    if (self.player.totalTime > 0) {
        self.slider.isdragging = YES;
        if (self.sliderValueChanging) self.sliderValueChanging(value, self.slider.isForward);
        @zf_weakify(self)
        [self.player seekToTime:self.player.totalTime*value completionHandler:^(BOOL finished) {
            @zf_strongify(self)
            //if (finished) {
                self.slider.isdragging = NO;
                if (self.sliderValueChanged) self.sliderValueChanged(value);
            //}
        }];
        if (self.seekToPlay) {
            [self.player.currentPlayerManager play];
        }
    } else {
        self.slider.isdragging = NO;
        self.slider.value = 0;
    }
}

- (void)sliderValueChanged:(float)value {
    if (self.player.totalTime == 0) {
        self.slider.value = 0;
        return;
    }
    self.slider.isdragging = YES;
    self.currentTimeStr = [NSString stringWithFormat:@"%.0f",self.player.totalTime*value];
    NSString *currentTimeString = [ZFUtilities convertTimeSecond:self.player.totalTime*value];
    self.currentTimeLabel.text = currentTimeString;
    if (self.sliderValueChanging) self.sliderValueChanging(value,self.slider.isForward);
}

- (void)sliderTapped:(float)value {
    [self sliderTouchEnded:value];
    self.currentTimeStr = [NSString stringWithFormat:@"%.0f",self.player.totalTime*value];
    NSString *currentTimeString = [ZFUtilities convertTimeSecond:self.player.totalTime*value];
    self.currentTimeLabel.text = currentTimeString;
}

- (void)danmuBtnSelected:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    [[BarrageManager shareManager] stopBarrage:sender.isSelected];
}

- (void)barrageChange:(NSNotification *)info {
    BOOL isStop = [info.object boolValue];
    self.danmuBtn.selected = isStop;
}

#pragma mark - public method
/** 重置ControlView */
- (void)resetControlView {
    self.bottomToolView.alpha        = 1;
    self.slider.value                = 0;
    self.slider.bufferValue          = 0;
    self.currentTimeLabel.text       = @"00:00";
    self.totalTimeLabel.text         = @"00:00";
    self.backgroundColor             = [UIColor clearColor];
    self.playOrPauseBtn.selected     = YES;
    self.playOrPauseBtnBottom.selected     = YES;
    self.titleLabel.text             = @"";
}

- (void)showControlView {
    self.topToolView.alpha           = 1;
    self.bottomToolView.alpha        = 1;
    self.isShow                      = YES;
    self.topToolView.zf_y            = 0;
    self.bottomToolView.zf_y         = self.zf_height - self.bottomToolView.zf_height;
    self.playOrPauseBtn.alpha        = 1;
    self.player.statusBarHidden      = NO;
    self.fblView.hidden = true;
    self.rateView.hidden = true;
}

- (void)hideControlView {
    self.isShow                      = NO;
    self.topToolView.zf_y            = -self.topToolView.zf_height;
    self.bottomToolView.zf_y         = self.zf_height;
    self.player.statusBarHidden      = NO;
    self.playOrPauseBtn.alpha        = 0;
    self.topToolView.alpha           = 0;
    self.bottomToolView.alpha        = 0;
    self.fblView.hidden = true;
    self.rateView.hidden = true;
}

- (BOOL)shouldResponseGestureWithPoint:(CGPoint)point withGestureType:(ZFPlayerGestureType)type touch:(nonnull UITouch *)touch {
    CGRect sliderRect = [self.bottomToolView convertRect:self.slider.frame toView:self];
    if (CGRectContainsPoint(sliderRect, point)) {
        return NO;
    }
    return YES;
}

- (void)videoPlayer:(ZFPlayerController *)videoPlayer currentTime:(NSTimeInterval)currentTime totalTime:(NSTimeInterval)totalTime {
    if (!self.slider.isdragging) {
        self.currentTimeStr = [NSString stringWithFormat:@"%.0f",currentTime];
        NSString *currentTimeString = [ZFUtilities convertTimeSecond:currentTime];
        self.currentTimeLabel.text = currentTimeString;
        
        self.totalTimeStr = [NSString stringWithFormat:@"%.0f",totalTime];
        NSString *totalTimeString = [ZFUtilities convertTimeSecond:totalTime];
        self.totalTimeLabel.text = totalTimeString;
        self.slider.value = videoPlayer.progress;
    }
}

- (void)videoPlayer:(ZFPlayerController *)videoPlayer bufferTime:(NSTimeInterval)bufferTime {
    self.slider.bufferValue = videoPlayer.bufferProgress;
}

- (void)showTitle:(NSString *)title fullScreenMode:(ZFFullScreenMode)fullScreenMode {
    self.titleLabel.text = title;
    self.player.orientationObserver.fullScreenMode = fullScreenMode;
}

/// 调节播放进度slider和当前时间更新
- (void)sliderValueChanged:(CGFloat)value currentTimeString:(NSString *)timeString {
    self.currentTimeStr = [NSString stringWithFormat:@"%.0f",self.player.totalTime*value];
    self.slider.value = value;
    self.currentTimeLabel.text = timeString;
    self.slider.isdragging = YES;
    [UIView animateWithDuration:0.3 animations:^{
        self.slider.sliderBtn.transform = CGAffineTransformMakeScale(1.2, 1.2);
    }];
}

/// 滑杆结束滑动
- (void)sliderChangeEnded {
    self.slider.isdragging = NO;
    [UIView animateWithDuration:0.3 animations:^{
        self.slider.sliderBtn.transform = CGAffineTransformIdentity;
    }];
}

#pragma mark - setter

- (void)setFullScreenMode:(ZFFullScreenMode)fullScreenMode {
    _fullScreenMode = fullScreenMode;
    self.player.orientationObserver.fullScreenMode = fullScreenMode;
}

#pragma mark - getter

- (UIButton *)touPingBtn {
    if (!_touPingBtn) {
        _touPingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_touPingBtn setImage:[UIImage imageNamed:@"投屏"] forState:UIControlStateNormal];
    }
    return _touPingBtn;
}

- (UIButton *)shareBtn {
    if (!_shareBtn) {
        _shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_shareBtn setImage:[UIImage imageNamed:@"分享 (2)"] forState:UIControlStateNormal];
    }
    return _shareBtn;
}
 
- (QMUIButton *)rateBtn {
    if (!_rateBtn) {
        _rateBtn = [QMUIButton new];
        [_rateBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_rateBtn setTitle:@"倍速" forState:UIControlStateNormal];
        _rateBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:14];
        [_rateBtn addTarget:self action:@selector(rateSelected) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rateBtn;
}

- (UILabel *)videoTypeLabel {
    if (!_videoTypeLabel) {
        _videoTypeLabel = [[UILabel alloc]init];
        _videoTypeLabel.text = @"直播";
        _videoTypeLabel.textColor =  UIColor.whiteColor;
        _videoTypeLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:12];
    }
    return _videoTypeLabel;
}

- (UIView *)videoTypeDotView {
    if (!_videoTypeDotView) {
        _videoTypeDotView = [[UIView alloc] initWithFrame:CGRectZero];
        _videoTypeDotView.layer.cornerRadius = 3;
        _videoTypeDotView.backgroundColor = Blue_Color;
    }
    return _videoTypeDotView;
}

- (UIView *)topToolView {
    if (!_topToolView) {
        _topToolView = [[UIView alloc] init];
        UIImage *image = ZFPlayer_Image(@"ZFPlayer_top_shadow");
        _topToolView.layer.contents = (id)image.CGImage;
    }
    return _topToolView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = [UIFont systemFontOfSize:15.0];
    }
    return _titleLabel;
}

- (UIView *)bottomToolView {
    if (!_bottomToolView) {
        _bottomToolView = [[UIView alloc] init];
        UIImage *image = ZFPlayer_Image(@"ZFPlayer_bottom_shadow");
        _bottomToolView.layer.contents = (id)image.CGImage;
    }
    return _bottomToolView;
}

- (UIButton *)playOrPauseBtnBottom {
    if (!_playOrPauseBtnBottom) {
        _playOrPauseBtnBottom = [UIButton buttonWithType:UIButtonTypeCustom]; 
        [_playOrPauseBtnBottom setImage:SuperPlayerImage(@"play") forState:UIControlStateNormal];
        [_playOrPauseBtnBottom setImage:SuperPlayerImage(@"pause") forState:UIControlStateSelected];
    }
    return _playOrPauseBtnBottom;
}

- (UIButton *)xiaoPingBtn {
    if (!_xiaoPingBtn) {
        _xiaoPingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_xiaoPingBtn setImage:[UIImage imageNamed:@"小窗口"] forState:UIControlStateNormal];
    }
    return _xiaoPingBtn;
}
- (UIButton *)playOrPauseBtn {
    if (!_playOrPauseBtn) {
        _playOrPauseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playOrPauseBtn setImage:ZFPlayer_Image(@"new_allPlay_44x44_") forState:UIControlStateNormal];
        [_playOrPauseBtn setImage:ZFPlayer_Image(@"new_allPause_44x44_") forState:UIControlStateSelected];
    }
    return _playOrPauseBtn;
}

- (UILabel *)currentTimeLabel {
    if (!_currentTimeLabel) {
        _currentTimeLabel = [[UILabel alloc] init];
        _currentTimeLabel.textColor = [UIColor whiteColor];
        _currentTimeLabel.font = [UIFont systemFontOfSize:14.0f];
        _currentTimeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _currentTimeLabel;
}

- (ZFSliderView *)slider {
    if (!_slider) {
        _slider = [[ZFSliderView alloc] init];
        _slider.delegate = self;
        _slider.maximumTrackTintColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.8];
        _slider.bufferTrackTintColor  = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.5];
        _slider.minimumTrackTintColor = Blue_Color;
        [_slider setThumbImage:ZFPlayer_Image(@"ZFPlayer_slider") forState:UIControlStateNormal];
        _slider.sliderHeight = 2;
    }
    return _slider;
}

- (UILabel *)totalTimeLabel {
    if (!_totalTimeLabel) {
        _totalTimeLabel = [[UILabel alloc] init];
        _totalTimeLabel.textColor = [UIColor whiteColor];
        _totalTimeLabel.font = [UIFont systemFontOfSize:14.0f];
        _totalTimeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _totalTimeLabel;
}

- (UIButton *)fullScreenBtn {
    if (!_fullScreenBtn) {
        _fullScreenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_fullScreenBtn setImage:[UIImage imageNamed:@"全屏"] forState:UIControlStateNormal];
    }
    return _fullScreenBtn;
}

- (QMUIButton *)fbl {
    if (!_fbl) {
        _fbl = [QMUIButton new];
        [_fbl setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_fbl setTitle:@"分辨率" forState:UIControlStateNormal];
        _fbl.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:14];
        [_fbl addTarget:self action:@selector(fblSelected) forControlEvents:UIControlEventTouchUpInside]; 
    }
    return _fbl;
}

- (QMUIButton *)danmuBtn {
    if (!_danmuBtn) {
        _danmuBtn = [QMUIButton new];
        [_danmuBtn setImage:[UIImage imageNamed:@"开启弹幕"] forState:UIControlStateNormal];
        [_danmuBtn setImage:[UIImage imageNamed:@"关闭弹幕"] forState:UIControlStateSelected];
        [_danmuBtn addTarget:self action:@selector(danmuBtnSelected:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _danmuBtn;
}

- (UIView *)fblView {
    if (!_fblView) {
        _fblView = [UIView new];
        _fblView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        _fblView.layer.cornerRadius = 5;
    }
    return _fblView;
}

- (UIView *)rateView {
    if (!_rateView) {
        _rateView = [UIView new];
        _rateView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        _rateView.layer.cornerRadius = 5;
    }
    return _rateView;
}
 
- (void)setFblModels:(NSArray *)fblModels {
    _fblModels = fblModels;
    CGFloat height = 30 * _fblModels.count;
    [_fblView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.fbl.mas_top);
        make.centerX.equalTo(self.fbl.mas_centerX);
        make.height.mas_equalTo(height);
        make.width.mas_equalTo(80);
    }];
    [self buildFBL];
}

@end
