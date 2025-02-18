//
//  BaseNavView.m
//  ScenicNav
//
//  Created by laoK on 2019/1/12.
//  Copyright © 2019 xhkj. All rights reserved.
//

#import "BaseNavView.h"

@interface BaseNavView()

@property (nonatomic , strong) UIView *lineView;

@end
@implementation BaseNavView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, kScreenWidth, NavHeight);
        self.backgroundColor = VCBackgroundColor;
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews {
    
    [self addSubview:self.backImageView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.leftImageView];
    [self addSubview:self.rightImageView];
    [self addSubview:self.lineView];
    [self addSubview:self.leftButton];
    [self addSubview:self.rightButton];
    
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self);
        make.bottom.mas_equalTo(self);
        make.height.mas_equalTo(@0.5);
    }];
    
    [_leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(10);
        make.bottom.mas_equalTo(self).offset(-10);
        make.width.height.mas_equalTo(@25);
    }];
    
    [_rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self).offset(-15);
        make.centerY.mas_equalTo(self.leftImageView.mas_centerY);
        make.width.height.mas_equalTo(@25);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.leftImageView.mas_right).offset(30);
        make.centerX.mas_equalTo(self);
        make.bottom.mas_equalTo(self).offset(-5);
        make.height.mas_equalTo(@40);
    }];
    
    [_backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.left.bottom.equalTo(self);
    }];
    
}

- (void)leftItemWithImageName:(nullable NSString *)imageName leftTitle:(nullable NSString *)title size:(CGSize )size target:(id)target action:(SEL)action{
    if (imageName) {
        self.leftImageView.image = [UIImage imageNamed:imageName];
    }
    if (title) {
        [self.leftButton setTitle:title forState:UIControlStateNormal];
        [self.leftButton setTitleColor:commonTextColor forState:UIControlStateNormal];
        self.leftButton.titleLabel.font = Font(15);
    }
    
    [self.leftImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(size);
    }];
    // 监听按钮点击
    [self.leftButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [self.leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(10);
        make.bottom.mas_equalTo(self).offset(-5);
        make.width.height.mas_equalTo(@40);
    }];
    
}

- (void)rightItemWithImageName:(nullable NSString *)imageName rightTitle:(nullable NSString *)title size:(CGSize )size target:(id)target action:(SEL)action {

    if (imageName) {
        self.rightImageView.image = [UIImage imageNamed:imageName];
    }
    if (title) {
        [self.rightButton setTitle:title forState:UIControlStateNormal];
        [self.rightButton setTitleColor:commonTextColor forState:UIControlStateNormal];
        self.rightButton.titleLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightSemibold];

    }
    [self.rightImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(size);
    }];
    // 监听按钮点击
    [self.rightButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [self.rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self).offset(-10);
        make.bottom.mas_equalTo(self).offset(-5);
        make.height.mas_equalTo(@40);
        if (!title) {
            make.width.mas_equalTo(@40);
        }
    }];
    
    
}

/*
 *set方法
 */
- (void)setHiddenLineView:(BOOL)hiddenLineView {
    self.lineView.hidden = hiddenLineView;
}
- (void)setHiddenBackImage:(BOOL)hiddenBackImage {
    self.backImageView.hidden = hiddenBackImage;
}
- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLabel.text = title;
}
- (void)setTitleColor:(UIColor *)titleColor {
    self.titleLabel.textColor = titleColor;
}
- (void)setRightTitle:(NSString *)rightTitle {
    __block CGFloat w = [self evaluteSize:rightTitle];
    [self.rightButton setTitle:rightTitle forState:UIControlStateNormal];
    [self.rightButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(w);
    }];
    
}
- (void)setHiddenLeft:(BOOL)hiddenLeft {
    self.leftButton.hidden = hiddenLeft;
    self.leftImageView.hidden = hiddenLeft;
}

- (void)setCurrentStyle:(NavStateStyle)currentStyle {
    if (currentStyle == NavStateStyleLight) {
        self.titleLabel.textColor = UIColor.whiteColor;
        self.leftImageView.image = [UIImage imageNamed:@"返回白"];
        self.leftImageView.contentMode = 1;
        [self.rightButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    }
}
- (CGFloat)evaluteSize:(NSString *)text {
    
    NSDictionary *textAtt = @{NSFontAttributeName : Font(15)};
    CGSize evaluteLabelSize = [text boundingRectWithSize:CGSizeMake(kScreenWidth -30 -16, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:textAtt context:nil].size;
    CGFloat evaluteLabelSizeW = evaluteLabelSize.width + 2;
    return evaluteLabelSizeW;
}


/*
 *懒加载
 */

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = lineViewColor;
    }
    return _lineView;
}
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightSemibold];
        _titleLabel.textAlignment = NSTextAlignmentCenter; 
        _titleLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    }
    
    return _titleLabel;
}
- (UIImageView *)leftImageView {
    if (!_leftImageView) {
        _leftImageView = [[UIImageView alloc] init];
    }
    return _leftImageView;
}
- (UIImageView *)rightImageView {
    if (!_rightImageView) {
        _rightImageView = [[UIImageView alloc] init];
    }
    return _rightImageView;
}
- (UIImageView *)backImageView {
    if (!_backImageView) {
        _backImageView = [[UIImageView alloc] init];
        _backImageView.hidden = YES;
    }
    return _backImageView;
}
- (UIButton *)leftButton {
    if (!_leftButton) {
        _leftButton = [[UIButton alloc] init];
        _leftButton.backgroundColor = UIColor.clearColor;
    }
    return _leftButton;
}
- (UIButton *)rightButton {
    if (!_rightButton) {
        _rightButton = [[UIButton alloc] init];
        _rightButton.backgroundColor = UIColor.clearColor;
        [_rightButton setTitleColor:commonTextColor forState:UIControlStateNormal];
    }
    return _rightButton;
}
@end
