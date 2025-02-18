//
//  SNShimmerLabelView.m
//  SportNews
//
//  Created by kkk on 2021/4/29.
//

#import "SNShimmerLabelView.h"

@interface SNShimmerLabelView ()

@property (strong, nonatomic) UILabel *contentLabel;
@property (strong, nonatomic) UILabel *maskLabel;
@property (strong, nonatomic) CAGradientLayer *maskLayer;
@property (assign, nonatomic) BOOL isPlaying;               // 正在播放动画 
@property (assign, nonatomic) CATransform3D startT, endT;   // 高亮移动范围 [startT, endT]
@property (strong, nonatomic) CABasicAnimation *translate;  // 位移动画
@property (strong, nonatomic) CABasicAnimation *alphaAni;   // alpha 动画

@end

@implementation SNShimmerLabelView

 
- (instancetype)init {
    if (self = [super init]) {
        [self myInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self myInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self myInit];
    }
    return self;
}

- (void)myInit {
    [self addSubview:self.contentLabel];
    [self addSubview:self.maskLabel];
    self.layer.masksToBounds = true;
    self.isPlaying = false;
    self.startT = CATransform3DIdentity;
    self.endT = CATransform3DIdentity;
    self.repeat = true;
    self.shimmerColor = [UIColor redColor];
    self.durationTime = 1;
     
}

 
- (void)layoutSubviews {
    [super layoutSubviews];
    
    // 刷新布局
    self.contentLabel.frame = self.bounds;
    self.maskLabel.frame = self.bounds;
    self.maskLayer.frame = self.bounds;
}

#pragma mark - 属性 set, get 方法

- (UILabel *)contentLabel {
    if (_contentLabel == nil) {
        _contentLabel = [[UILabel alloc] initWithFrame:self.bounds];
        _contentLabel.font = [UIFont systemFontOfSize:22 weight:UIFontWeightSemibold];
        _contentLabel.textColor = [UIColor colorWithHexString:@"#555555"];
    }
    return _contentLabel;
}

- (UILabel *)maskLabel {
    if (_maskLabel == nil) {
        _maskLabel = [[UILabel alloc] initWithFrame:self.bounds];
        _maskLabel.font = [UIFont systemFontOfSize:22 weight:UIFontWeightSemibold];
        _maskLabel.textColor = [UIColor colorWithHexString:@"#555555"];
        _maskLabel.hidden = true;
    }
    return _maskLabel;
}

- (CALayer *)maskLayer {
    if (_maskLayer == nil) {
        _maskLayer = [[CAGradientLayer alloc] init];
        _maskLayer.backgroundColor = [UIColor clearColor].CGColor;
        [self freshMaskLayer];
    }
    return _maskLayer;
}

- (void)setText:(NSString *)text {
    if (_text == text) return ;
    
    _text = text;
    self.contentLabel.text = text;
    [self update];
}

- (void)setFont:(UIFont *)font {
    if (_font == font) return ;
    
    _font = font;
    self.contentLabel.font = font;
    [self update];
}

- (void)setTextColor:(UIColor *)textColor {
    if (_textColor == textColor) return ;
    
    _textColor = textColor;
    self.contentLabel.textColor = textColor;
    [self update];
}

- (void)setAttributedText:(NSAttributedString *)attributedText {
    if (_attributedText == attributedText) return ;
    
    _attributedText = attributedText;
    self.contentLabel.attributedText = attributedText;
    [self update];
}

- (void)setNumberOfLines:(NSInteger)numberOfLines {
    if (_numberOfLines == numberOfLines) return ;
    
    _numberOfLines = numberOfLines;
    self.contentLabel.numberOfLines = numberOfLines;
    [self update];
}
 
- (void)setRepeat:(BOOL)repeat {
    if (_repeat == repeat) return ;
    
    _repeat = repeat;
    [self update];
}
 
- (void)setShimmerColor:(UIColor *)shimmerColor {
    if (_shimmerColor == shimmerColor) return ;
    
    _shimmerColor = shimmerColor;
    self.maskLabel.textColor = shimmerColor;
    [self update];
}

- (void)setDurationTime:(NSTimeInterval)durationTime {
    if (_durationTime == durationTime) return ;
    
    _durationTime = durationTime;
    [self update];
}

- (void)update {
    if (self.isPlaying) {       // 如果在播放动画，更新动画
        [self stopShimmer];
        [self startShimmer];
    }
}

// 刷新 maskLayer 属性值, transform 值
- (void)freshMaskLayer {
    _maskLayer.backgroundColor = self.shimmerColor.CGColor;
    _maskLayer.colors = nil;
    _maskLayer.locations = nil;
}

#pragma mark - 其他方法

- (void)copyLabel:(UILabel *)dLabel from:(UILabel *)sLabel {
    dLabel.attributedText = sLabel.attributedText;
    dLabel.text = sLabel.text;
    dLabel.font = sLabel.font;
    dLabel.numberOfLines = sLabel.numberOfLines;
}

- (CABasicAnimation *)translate {
    if (_translate == nil) {
        _translate = [CABasicAnimation animationWithKeyPath:@"transform"];
    }
    _translate.duration = self.durationTime;
    _translate.repeatCount = self.repeat == true ? MAXFLOAT : 0;
    _translate.autoreverses = false;
    
    return _translate;
}

- (CABasicAnimation *)alphaAni {
    if (_alphaAni == nil) {
        _alphaAni = [CABasicAnimation animationWithKeyPath:@"opacity"];
        _alphaAni.repeatCount = MAXFLOAT;
        _alphaAni.autoreverses = true;
        _alphaAni.fromValue = @(0.0);
        _alphaAni.toValue = @(1.0);
    }
    _alphaAni.duration = self.durationTime;
    
    return _alphaAni;
}

- (void)startShimmer {
    dispatch_async(dispatch_get_main_queue(), ^{
        // 切换到主线程串行队列，下面代码打包成一个事件（原子操作），加到runloop，就不用担心 isPlaying 被多个线程同时修改
        // dispatch_async() 不 strong 持有本 block，也不用担心循环引用
        if (self.isPlaying == true) return ;
        self.isPlaying = true;

        [self copyLabel:self.maskLabel from:self.contentLabel];
        self.maskLabel.hidden = false;
        [self.maskLayer removeFromSuperlayer];
        [self freshMaskLayer];
        [self.maskLabel.layer addSublayer:self.maskLayer];
        self.maskLabel.layer.mask = self.maskLayer;
        self.maskLabel.textColor = self.shimmerColor;
        
        self.maskLayer.transform = CATransform3DIdentity;
        [self.maskLayer removeAllAnimations];
        [self.maskLayer addAnimation:self.alphaAni forKey:@"start"];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self stopShimmer];
        });
    });
}

- (void)stopShimmer {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.isPlaying == false) return ;
        self.isPlaying = false;
        [self.maskLayer removeAllAnimations];
        [self.maskLayer removeFromSuperlayer];
        self.maskLabel.hidden = true;
    });
}

 
@end
