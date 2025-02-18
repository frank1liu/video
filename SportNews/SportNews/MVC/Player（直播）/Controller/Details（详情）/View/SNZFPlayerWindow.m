//
//  SNZFPlayerWindow.m
//  SportNews
//
//  Created by kkk on 2021/5/14.
//

#import "SNZFPlayerWindow.h"
#import "SuperPlayer.h" 
#import "UIView+MMLayout.h"
#import "DataReport.h"
#import "UIView+Fade.h"
#import "TXVodPlayListener.h"

#define FLOAT_VIEW_WIDTH  250
#define FLOAT_VIEW_HEIGHT 140.6

@interface SNZFPlayerWindow ()

@property (weak) UIView *origFatherView;

@property CGRect floatViewRect;

@end


@implementation SNZFPlayerWindow {
    UIView *_rootView;
    UIButton    *_closeBtn;
    UIButton    *_backBtn;
}

+ (instancetype)sharedInstance {
    static SNZFPlayerWindow *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[SNZFPlayerWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    });
    return instance;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    self.windowLevel = UIWindowLevelStatusBar - 1;
    self.rootViewController = [UIViewController new];
    self.rootViewController.view.backgroundColor = [UIColor clearColor];
    self.rootViewController.view.userInteractionEnabled = NO;
    
    _rootView = [[UIView alloc] initWithFrame:CGRectZero];
    _rootView.backgroundColor = [UIColor blackColor];
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognizer:)];
    [_rootView addGestureRecognizer:panGesture];
    
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeBtn setImage:SuperPlayerImage(@"close") forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_rootView addSubview:closeBtn];
    [closeBtn sizeToFit];
    _closeBtn = closeBtn;

    CGRect rect = CGRectMake(ScreenWidth-FLOAT_VIEW_WIDTH, ScreenHeight-FLOAT_VIEW_HEIGHT, FLOAT_VIEW_WIDTH, FLOAT_VIEW_HEIGHT);
    if (IsIPhoneX) {
        rect.origin.y -= 44;
    }
    self.floatViewRect = rect;
    self.hidden = YES;
    return self;
}


- (void)show {
    _rootView.frame = self.floatViewRect;
    [self addSubview:_rootView];
    self.hidden = NO;
    self.origFatherView = self.zfPlayer.fatherView;
    float rate = 250/kScreenWidth;
    self.zfPlayer.transform = CGAffineTransformMakeScale(rate, rate);
    [_rootView addSubview:self.zfPlayer];
    self.zfPlayer.x = 0;
    self.zfPlayer.y = 0;
    self.zfPlayer.userInteractionEnabled = NO;
    
    [_rootView bringSubviewToFront:_backBtn];
    [_rootView bringSubviewToFront:_closeBtn];
    _closeBtn.m_width(42).m_height(42).m_top(0).m_right(0);
    _isShowing = YES;
}

- (void)hide {
    self.floatViewRect = _rootView.frame;
    [_rootView removeFromSuperview];
     
    [self.origFatherView addSubview:self.zfPlayer];
    self.zfPlayer.x = 0;
    self.zfPlayer.y = 0;
    self.zfPlayer.userInteractionEnabled = YES;
    self.zfPlayer.transform = CGAffineTransformIdentity;
    self.hidden = YES;
    _isShowing = NO;
    
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    if (CGRectContainsPoint(_rootView.bounds, [_rootView convertPoint:point fromView:self])) {
        return [super pointInside:point withEvent:event];
    }
    return NO;
}

- (void)closeBtnClick:(id)sender{
    [self hide];
    [_zfPlayer stop];
    self.backController = nil;
    [SNGlobalShared invalideVideoTimer];
      
}

- (void)backBtnClick:(id)sender {
    [self hide];
    if (self.backHandler) {
        self.backHandler();
    }
}
  
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self backBtnClick:nil];
}

#pragma mark - GestureRecognizer
// 手势处理
- (void)panGestureRecognizer:(UIPanGestureRecognizer *)panGesture {
    if (UIGestureRecognizerStateBegan == panGesture.state) {
        
    }else if (UIGestureRecognizerStateChanged == panGesture.state) {
        CGPoint translation = [panGesture translationInView:self];
        CGPoint center = _rootView.center;
        center.x += translation.x;
        center.y += translation.y;
        _rootView.center = center;
        UIEdgeInsets effectiveEdgeInsets = UIEdgeInsetsZero; // 边距可以自己调
        CGFloat   leftMinX = 0.0f + effectiveEdgeInsets.left;
        CGFloat    topMinY = 0.0f + effectiveEdgeInsets.top;
        CGFloat  rightMaxX = self.bounds.size.width - _rootView.bounds.size.width + effectiveEdgeInsets.right;
        CGFloat bottomMaxY = self.bounds.size.height - _rootView.bounds.size.height + effectiveEdgeInsets.bottom;
        CGRect frame = _rootView.frame;
        frame.origin.x = frame.origin.x > rightMaxX ? rightMaxX : frame.origin.x;
        frame.origin.x = frame.origin.x < leftMinX ? leftMinX : frame.origin.x;
        frame.origin.y = frame.origin.y > bottomMaxY ? bottomMaxY : frame.origin.y;
        frame.origin.y = frame.origin.y < topMinY ? topMinY : frame.origin.y;
        _rootView.frame = frame;
        // zero
        [panGesture setTranslation:CGPointZero inView:self];
    }else if (UIGestureRecognizerStateEnded == panGesture.state) {

    }
}



@end
