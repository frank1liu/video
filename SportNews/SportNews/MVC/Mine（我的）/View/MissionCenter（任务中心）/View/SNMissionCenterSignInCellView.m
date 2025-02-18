//
//  SNMissionCenterSignInCellView.m
//  SportNews
//
//  Created by kkk on 2021/5/12.
//

#import "SNMissionCenterSignInCellView.h"

@interface SNMissionCenterSignInCellView ()

@property(nonatomic, strong) UIView *backView;

@property(nonatomic, strong) UILabel *timeLabel;

@property(nonatomic, strong) UILabel *statusCountLabel;

@property(nonatomic, strong) UIImageView *iconImageView;

@end

@implementation SNMissionCenterSignInCellView


- (instancetype)initWithFrame:(CGRect)frame withTime:(NSString *)time {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubViews:time];
    }
    return self;
}

- (void)setupSubViews:(NSString *)time {
    
    [self addSubview:self.backView];
    [self.backView addSubview:self.timeLabel];
    [self.backView addSubview:self.iconImageView];
    [self.backView addSubview:self.statusCountLabel];
    
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    self.timeLabel.text = time;
    if ([time isEqualToString:@"第七天"]) {
        [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.backView).offset(7.5);
            make.left.equalTo(self.backView).offset(16.5);
        }];
        [self.statusCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.timeLabel.mas_bottom).offset(4);
            make.centerX.equalTo(self.timeLabel.mas_centerX);
        }];
        self.iconImageView.image = [UIImage imageNamed:@"音浪集合"];
        [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.bottom.equalTo(self.backView);
            make.height.equalTo(self.iconImageView.mas_width);
        }];
        
    }else {
        [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.backView).offset(7.5);
            make.centerX.equalTo(self.backView.mas_centerX);
        }];
        [self.statusCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.backView).offset(-8);
            make.centerX.equalTo(self.backView.mas_centerX);
        }];
        self.iconImageView.image = [UIImage imageNamed:@"音浪中"];
        [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.backView);
            make.height.width.mas_equalTo(27);
        }];
        
    }
}

- (void)setStyle:(NSInteger)style {
    self.timeLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    self.backView.layer.borderColor = [UIColor clearColor].CGColor;
    if (style == 0) {
        self.statusCountLabel.text = @"已领取";
        self.statusCountLabel.textColor = [UIColor colorWithHexString:@"#27C5C3"];
        self.backView.backgroundColor = RGBA(39, 197, 195, 0.1);
        self.backView.layer.borderColor = [UIColor colorWithHexString:@"#27C5C3"].CGColor;
    }else if (style == 1) {
        self.statusCountLabel.text = @"立即签到";
        self.timeLabel.textColor = [UIColor whiteColor];
        self.statusCountLabel.textColor = [UIColor whiteColor];
        self.backView.backgroundColor = [UIColor colorWithHexString:@"#27C5C3"];
    }else {//2
        self.statusCountLabel.text = @"5音浪";
        self.statusCountLabel.textColor = [UIColor colorWithHexString:@"#999999"];
        self.backView.backgroundColor = [UIColor colorWithHexString:@"#F3F7FA"];
    }
}

- (UIView *)backView {
    if (!_backView) {
        _backView = [[UIView alloc] init];
        _backView.layer.cornerRadius = 10;
        _backView.layer.borderWidth = 1;
        _backView.layer.borderColor = [UIColor clearColor].CGColor;
        _backView.backgroundColor = [UIColor colorWithHexString:@"#F3F7FA"];
    }
    return _backView;
}

- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
    }
    return _iconImageView;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = RGB(51, 51, 55);
        _timeLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightSemibold];
    }
    return _timeLabel;
}

- (UILabel *)statusCountLabel {
    if (!_statusCountLabel) {
        _statusCountLabel = [[UILabel alloc] init];
        _statusCountLabel.textColor = RGB(51, 51, 55);
        _statusCountLabel.font = [UIFont systemFontOfSize:12];
    }
    return _statusCountLabel;
}


@end
