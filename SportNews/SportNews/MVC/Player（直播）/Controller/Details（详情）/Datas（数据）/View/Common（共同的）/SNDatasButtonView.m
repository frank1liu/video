//
//  SNDatasButtonView.m
//  SportNews
//
//  Created by kkk on 2021/2/2.
//

#import "SNDatasButtonView.h"

@interface SNDatasButtonView ()

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UILabel *leftLabel;

@property (nonatomic, strong) UILabel *rightLabel;

@property (nonatomic, strong) UIButton *coverBtn;

@end

@implementation SNDatasButtonView

 
#pragma mark -- intialization 初始化
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithHexString:@"#27C5C3"];
        self.layer.cornerRadius = frame.size.height/2;
        [self setupSubviews];
    }
    return self;
}

- (void)leftText:(NSString *)leftStr rightText:(NSString *)rightStr {
    self.leftLabel.text = leftStr;
    self.rightLabel.text = rightStr;
}

- (void)coverBtnAciton:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    if (sender.selected) {
        [UIView animateWithDuration:0.35 animations:^{
            self.leftLabel.textColor = UIColor.whiteColor;
            self.rightLabel.textColor = Blue_Color;
            [self.bgView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self).offset((self.width/2+2.5));
            }];
            [self layoutIfNeeded];
        }];
    }else {
        [UIView animateWithDuration:0.35 animations:^{
            self.leftLabel.textColor = Blue_Color;
            self.rightLabel.textColor = UIColor.whiteColor;
            [self.bgView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self).offset(2.5);
            }];
            [self layoutIfNeeded];
        }];
    }
    
    if (self.selectBlock) {
        self.selectBlock(sender.isSelected);
    }
}

- (void)setupCoverBtn:(BOOL)select {
    self.coverBtn.selected = select;
    if (select) {
        self.leftLabel.textColor = UIColor.whiteColor;
        self.rightLabel.textColor = Blue_Color;
        [self.bgView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset((self.width/2+2.5));
        }];
    }else {
        self.leftLabel.textColor = Blue_Color;
        self.rightLabel.textColor = UIColor.whiteColor;
        [self.bgView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(2.5);
        }];
    }
}

- (void)setupSubviews {
    
    [self addSubview:self.bgView];
    [self addSubview:self.leftLabel];
    [self addSubview:self.rightLabel];
    [self addSubview:self.coverBtn];
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(2.5);
        make.top.equalTo(self).offset(2);
        make.bottom.equalTo(self).offset(-2);
        make.width.mas_equalTo(self.width/2-5);
    }];
    self.bgView.clipsToBounds = YES;
    self.bgView.layer.cornerRadius = (self.height-4)/2;
    
    [self.leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.left.equalTo(self).offset(3.5);
        make.width.mas_equalTo(self.width/2-7);
    }];
    
    [self.rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.left.equalTo(self).offset(self.width/2+3.5);
        make.width.mas_equalTo(self.width/2-7);
    }];
    
    [self.coverBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
}

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = UIColor.whiteColor;
    }
    return _bgView;
}

- (UILabel *)leftLabel {
    if (!_leftLabel) {
        _leftLabel = [[UILabel alloc] init];
        _leftLabel.font = [UIFont systemFontOfSize:11];
        _leftLabel.textAlignment = NSTextAlignmentCenter;
        _leftLabel.textColor = Blue_Color;
    }
    return _leftLabel;
}

- (UILabel *)rightLabel {
    if (!_rightLabel) {
        _rightLabel = [[UILabel alloc] init];
        _rightLabel.font = [UIFont systemFontOfSize:11];
        _rightLabel.textAlignment = NSTextAlignmentCenter;
        _rightLabel.textColor = UIColor.whiteColor;
    }
    return _rightLabel;
}

- (UIButton *)coverBtn {
    if (!_coverBtn) {
        _coverBtn = [[UIButton alloc] init];
        [_coverBtn addTarget:self action:@selector(coverBtnAciton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _coverBtn;
}



@end
