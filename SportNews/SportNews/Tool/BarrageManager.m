//
//  BarrageManager.m
//  SportNews
//
//  Created by yuhua on 2021/5/9.
//

#import "BarrageManager.h"
#import <BarrageRenderer/BarrageRenderer.h>

@interface BarrageManager()

@property (nonatomic, strong) BarrageRenderer *render;

@property (nonatomic, assign) BOOL stop;

@end

/// 弹幕管理
@implementation BarrageManager

+ (instancetype)shareManager {
    static BarrageManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[BarrageManager alloc] init];
        manager.stop = NO;
    });
    return manager;
}

- (void)buildBarrageTo:(UIView *)superView {
    if (self.render) {
        [self.render.view setNeedsLayout];
        return;
    }
    if (superView.frame.size.width == 0 || superView.frame.size.height == 0) {
        return;
    }
    self.render = [BarrageRenderer new];
    self.render.smoothness = 1.0f;
    [superView addSubview:self.render.view];
    self.render.canvasMargin = UIEdgeInsetsMake(20, 0, self.render.view.height/2, 0);
    self.render.view.userInteractionEnabled = NO;
    [self.render start];
    [superView bringSubviewToFront:self.render.view];
}

- (void)stopBarrage:(BOOL)stop {
    self.stop = stop;
    if (stop) {
        [self.render stop];
        [self.render removePresentSpritesWithName:nil];
    } else {
        [self.render start];
    }
    [self saveDanMu:!stop];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"BarrageStatusDidChange" object:@(stop)];
}

- (void)clearBarrage { 
    [self.render removePresentSpritesWithName:nil];
}

- (UIView *)getBarrageView {
    return self.render.view;
}

- (void)removeBarrage {
    [self.render.view removeFromSuperview];
    [self.render stop];
    self.render = nil;
}

- (void)addAttrBarrage:(NSAttributedString *)content delay:(CGFloat)delay {
    NSString *danmu = [self getDanMu];
    /// 如果danmu == no，表示关闭了弹幕
    /// 如果danmu == nil，由于添加之前判断了是否是在竖屏状态并且是否开启弹幕，所以能进这里的都是能发出去的弹幕。
    if ([danmu isEqualToString:@"no"]) {
        return;
    }
    if (self.render == nil || self.stop) {
        return;
    }
    [self.render.view.superview bringSubviewToFront:self.render.view];
    BarrageDescriptor *descriptor = [BarrageDescriptor new];
    descriptor.spriteName = NSStringFromClass([BarrageWalkTextSprite class]);
    /// 展示时间
    if (UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) {
        descriptor.params[@"speed"] = @120;
    }else {
        descriptor.params[@"speed"] = @75;
    }
    /// 弹幕载体
    descriptor.params[@"viewClassName"] = NSStringFromClass([UILabel class]);
    /// 弹幕内容
    descriptor.params[@"attributedText"] = content;
    /// 延时
    descriptor.params[@"delay"] = @(delay);
    [self.render receive:descriptor];
}

- (void)saveDanMu:(BOOL)open {
    NSString *result = open ? @"on" : @"off";
    [[NSUserDefaults standardUserDefaults] setObject:result forKey:@"DanMu"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)getDanMu {
    return [[NSUserDefaults standardUserDefaults] stringForKey:@"DanMu"];
}

@end
