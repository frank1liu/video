//
//  CustomAlertView.m
//  CustomAlertView
//
//  Created by lanshang on 21/4/15.
//  Copyright © 2021年 kiss. All rights reserved.
//

#import "CustomAlertView.h"

#define ALERTVIEWWIDTH  280*SCREEN_RATE

#define margin  10

@interface CustomAlertView ()

@property (nonatomic, strong) UIView *backGroundView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *detailLabel;
@property (nonatomic, strong) UIButton *canleButton;
@property (nonatomic, strong) UIButton *otherButton;

@end

@implementation CustomAlertView

- (instancetype)initWithFrame:(CGRect)frame WithTitle:(NSString *)title Detail:(NSString *)detail CancelTitle:(NSString *)cancelTitel OtherTitle:(NSString *)otherTitle IsOneBtn:(BOOL)isOneBtn {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        [self createUIWithTitle:title Detail:detail CancelTitle:cancelTitel OtherTitle:otherTitle IsOneBtn:isOneBtn];
    }
    return self;
}

- (void)createUIWithTitle:(NSString *)title Detail:(NSString *)detail CancelTitle:(NSString *)cancelTitel OtherTitle:(NSString *)otherTitle IsOneBtn:(BOOL)isOneBtn {
    CGFloat selfH = 0;
    self.backGroundView = [[UIView alloc]init];
    self.backGroundView.center = self.center;
    self.backGroundView.backgroundColor = [UIColor whiteColor];
    self.backGroundView.layer.cornerRadius = 8;
    [self addSubview:self.backGroundView];
    
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.textColor = SRGB(51);
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.text = title;
    self.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    CGFloat titleHeight = [self getHeightWithTitle:title andFont:self.titleLabel.font];
    self.titleLabel.frame = CGRectMake(20, 24, ALERTVIEWWIDTH-20*2, titleHeight);
    self.titleLabel.numberOfLines = 0;
    [self.backGroundView addSubview:self.titleLabel];
    
    selfH += 24+titleHeight;
    CGFloat detailHeight = [self getHeightWithTitle:detail andFont:[UIFont systemFontOfSize:14]];
    if (detail) {
        selfH += 10;
        UIScrollView *scrollView = [[UIScrollView alloc] init];
        [self.backGroundView addSubview:scrollView];
        
        self.detailLabel = [[UILabel alloc]init];
        self.detailLabel.textColor = RGB(120, 120, 120);
        self.detailLabel.textAlignment = NSTextAlignmentCenter;
        self.detailLabel.numberOfLines = 0;
        self.detailLabel.text = detail;
        CGFloat scrollHeight = detailHeight;
        if (detailHeight > (350 *SCREEN_RATE)) {
            detailHeight = 350 *SCREEN_RATE;
        }
        self.detailLabel.font = [UIFont systemFontOfSize:14];
        self.detailLabel.frame = CGRectMake(0,0, ALERTVIEWWIDTH-20*2, scrollHeight);
        self.detailLabel.tag = 306;
        self.detailLabel.userInteractionEnabled = YES;
        [scrollView addSubview:self.detailLabel];
        scrollView.frame = CGRectMake(20,selfH, ALERTVIEWWIDTH-20*2, detailHeight);
        scrollView.contentSize = CGSizeMake(0,scrollHeight);
        selfH += detailHeight + 24;
    }else {
        selfH += 14;
    }
    
    UIView *liveView = [[UIView alloc]initWithFrame:CGRectMake(0, selfH, ALERTVIEWWIDTH, 0.5)];
    liveView.backgroundColor = RGBA(151, 151, 151, 0.2);
    [self.backGroundView addSubview:liveView];
        
    selfH += 5;
    CGFloat w = 90;
    CGFloat H = 35;
    if (isOneBtn) {
        self.otherButton = [UIButton  buttonWithType:UIButtonTypeCustom];
        self.otherButton.frame = CGRectMake(0, selfH, ALERTVIEWWIDTH, H);
        [self.otherButton setTitle:otherTitle forState:UIControlStateNormal];
        self.otherButton.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
        [self.otherButton setTitleColor:Blue_Color forState:UIControlStateNormal];
        self.otherButton.tag = 309;
        [self.otherButton addTarget:self action:@selector(clickToUseDelegate:) forControlEvents:UIControlEventTouchUpInside];
        [self.backGroundView addSubview:self.otherButton];
    }else {
        self.canleButton = [UIButton  buttonWithType:UIButtonTypeCustom];
        self.canleButton.frame = CGRectMake((ALERTVIEWWIDTH/2 - w)/2, selfH, w, H);
        [self.canleButton setTitle:cancelTitel forState:UIControlStateNormal];
        self.canleButton.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
        [self.canleButton setTitleColor:SRGB(153) forState:UIControlStateNormal];
        self.canleButton.tag = 308;
        [self.canleButton addTarget:self action:@selector(clickToUseDelegate:) forControlEvents:UIControlEventTouchUpInside];
        [self.backGroundView addSubview: self.canleButton];
        
        UIView *liveView1 = [[UIView alloc]initWithFrame:CGRectMake(ALERTVIEWWIDTH/2, selfH-5, 0.5, H+10)];
        liveView1.backgroundColor = RGBA(151, 151, 151, 0.3);
        [self.backGroundView addSubview:liveView1];
        
        self.otherButton = [UIButton  buttonWithType:UIButtonTypeCustom];
        self.otherButton.frame = CGRectMake((ALERTVIEWWIDTH/2 - w)/2 + ALERTVIEWWIDTH/2, selfH, w, H);
        [self.otherButton setTitle:otherTitle forState:UIControlStateNormal];
        self.otherButton.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
        [self.otherButton setTitleColor:Blue_Color forState:UIControlStateNormal];
        self.otherButton.tag = 309;
        [self.otherButton addTarget:self action:@selector(clickToUseDelegate:) forControlEvents:UIControlEventTouchUpInside];
        [self.backGroundView addSubview:self.otherButton];
    }
    selfH += H+5;
    self.backGroundView.bounds = CGRectMake(0, 0, ALERTVIEWWIDTH,selfH);
    [self shakeToShow:self.backGroundView];
    
}

- (void)setIsLeft:(BOOL)isLeft {
    _isLeft = isLeft;
    if (isLeft) {
        self.detailLabel.textAlignment = NSTextAlignmentLeft;
    }else {
        self.detailLabel.textAlignment = NSTextAlignmentCenter;
    }
}

//动态计算高度
- (CGFloat)getHeightWithTitle:(NSString *)title andFont:(UIFont *)fontsize {
    CGFloat height = [title boundingRectWithSize:CGSizeMake(ALERTVIEWWIDTH-40, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:fontsize} context:nil].size.height;
    return height;
}

//显示提示框的动画
- (void) shakeToShow:(UIView*)aView {
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.35;
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    [aView.layer addAnimation:animation forKey:nil];
}

//点击(取消,确定)按钮调用方法
-(void)clickToUseDelegate:(UIButton *)button {
    if (button.tag == 308) {
        [self removeFromSuperview];
        return;
    }
    if (!self.isQiangzhi) {
        [self removeFromSuperview];
    }
    if (self.otherBtnBlock) {
        self.otherBtnBlock(button.tag);
    }
}
  
@end

