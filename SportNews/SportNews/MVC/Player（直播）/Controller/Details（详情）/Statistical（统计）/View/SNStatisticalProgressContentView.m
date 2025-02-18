//
//  SNStatisticalProgressContentView.m
//  SportNews
//
//  Created by kkk on 2021/1/26.
//

#import "SNStatisticalProgressContentView.h"

@interface SNStatisticalProgressContentView ()

@property(nonatomic, strong) SNStatisticalProgressView *leftProgressView;

@property(nonatomic, strong) SNStatisticalProgressView *rightProgressView;

@end

@implementation SNStatisticalProgressContentView

#pragma mark -- intialization 初始化
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColor.clearColor;
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews{
    
    
    [self addSubview:self.leftLabel];
    [self addSubview:self.centerLabel];
    [self addSubview:self.rightLabel];
    [self addSubview:self.leftProgressView];
    [self addSubview:self.rightProgressView];
    
    [self.centerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];
    
    [self.leftProgressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self.centerLabel.mas_left).offset(-15);
        make.width.mas_offset((kScreenWidth-150)/2);
        make.height.mas_offset(12);
    }];
    
    [self.rightProgressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self.centerLabel.mas_right).offset(15);
        make.width.mas_offset((kScreenWidth-150)/2);
        make.height.mas_offset(12);
    }];
    
    [self.leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self.leftProgressView.mas_left).offset(-7.5);
    }];
    
    [self.rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self.rightProgressView.mas_right).offset(7.5);
    }];
    
}
 
- (void)leftProgress:(NSInteger)progressL rightProgress:(NSInteger)progressR {
 
    float pL = 0;
    float pR = 0;
    if (progressL + progressR > 0) {
        pL = (float)progressL/(progressL + progressR);
        pR = (float)progressR/(progressL + progressR);
    }
    self.leftProgressView.progress = pL;
    self.rightProgressView.progress = pR;
     
}

- (UILabel *)leftLabel {
    if (!_leftLabel) {
        _leftLabel = [[UILabel alloc] init];
        _leftLabel.font = [UIFont systemFontOfSize:12];
        _leftLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    }
    return _leftLabel;
}

- (UILabel *)centerLabel {
    if (!_centerLabel) {
        _centerLabel = [[UILabel alloc] init];
        _centerLabel.font = [UIFont systemFontOfSize:12];
        _centerLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    }
    return _centerLabel;
}

- (UILabel *)rightLabel {
    if (!_rightLabel) {
        _rightLabel = [[UILabel alloc] init];
        _rightLabel.font = [UIFont systemFontOfSize:12];
        _rightLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    }
    return _rightLabel;
}

- (SNStatisticalProgressView *)leftProgressView {
    if (!_leftProgressView) {
        _leftProgressView = [[SNStatisticalProgressView alloc] initWithFrame:CGRectMake(0, 0, (kScreenWidth-150)/2, 12) withType:ProgressViewTypeLeft];
        _leftProgressView.progress = 0.5;

    }
    return _leftProgressView;
}

- (SNStatisticalProgressView *)rightProgressView {
    if (!_rightProgressView) {
        _rightProgressView = [[SNStatisticalProgressView alloc] initWithFrame:CGRectMake(0, 0, (kScreenWidth-150)/2, 12) withType:ProgressViewTypeRight];
        _rightProgressView.progress = 0.7;

    }
    return _rightProgressView;
}


@end


@interface SNStatisticalProgressView ()

@property (nonatomic, strong) UIView *trackView;

@property (nonatomic, strong) UIView *progressView;

@property(nonatomic, assign) ProgressViewType type;
@end

@implementation SNStatisticalProgressView

 
#pragma mark -- intialization 初始化
- (instancetype)initWithFrame:(CGRect)frame withType:(ProgressViewType)type {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColor.clearColor;
        _type = type;
        [self setupSubviews];
    }
    return self;
}


- (void)setupSubviews{
    
    [self addSubview:self.trackView];
    [self addSubview:self.progressView];
    
    [self.trackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    if (self.type == ProgressViewTypeLeft) {
        self.trackView.backgroundColor = Blue_Light_Color;
        self.progressView.backgroundColor = Blue_Color;
        [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.bottom.equalTo(self);
            make.width.mas_equalTo(1);
        }];
    }else {
        self.trackView.backgroundColor = Origin_Light_Color;
        self.progressView.backgroundColor = Origin_Color;
        [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.equalTo(self);
            make.width.mas_equalTo(1);
        }];
    }
}

- (void)setProgress:(CGFloat)progress {
    [self.progressView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo((self.width*progress > 1?self.width*progress:1));
    }];
}

- (UIView *)trackView {
    if (!_trackView) {
        _trackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.width, self.height)];
        _trackView.backgroundColor = [UIColor colorWithHexString:@"#F0F0F0"];
    }
    return _trackView;
}

- (UIView *)progressView {
    if (!_progressView) {
        _progressView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, self.height)];
        _progressView.backgroundColor = Blue_Color; 
    }
    return _progressView;
}
 

@end
