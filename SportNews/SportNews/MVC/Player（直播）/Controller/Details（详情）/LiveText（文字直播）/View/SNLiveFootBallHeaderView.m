//
//  SNLiveFootBallHeaderView.m
//  SportNews
//
//  Created by yang on 2021/1/19.
//

#import "SNLiveFootBallHeaderView.h"
#import "SNFootBallResult.h"

#define processW kScreenWidth-20
#define processH 35

@interface SNLiveFootBallHeaderView()

@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UIView *lineViewA;
@property (nonatomic, strong) UIView *lineViewB; 

@property (nonatomic, strong) UIImageView  *rightImageView1;
@property (nonatomic, strong) UIImageView  *rightImageView2;
@property (nonatomic, strong) UIImageView  *rightImageView3;
@property (nonatomic, strong) UIImageView  *rightImageView4;

 
@property (nonatomic, strong) UILabel *rightLabelTop1;//角球
@property (nonatomic, strong) UILabel *rightLabelTop2;//黄牌
@property (nonatomic, strong) UILabel *rightLabelTop3;//红牌
@property (nonatomic, strong) UILabel *rightLabelTop4;//半场
 
@property (nonatomic, strong) UILabel *rightLabelBottom1;//角球
@property (nonatomic, strong) UILabel *rightLabelBottom2;//黄牌
@property (nonatomic, strong) UILabel *rightLabelBottom3;//红牌
@property (nonatomic, strong) UILabel *rightLabelBottom4;//半场

@property(nonatomic, strong) SNLiveProgressContentView *contentView1;//角球
@property(nonatomic, strong) SNLiveProgressContentView *contentView2;//黄牌
@property(nonatomic, strong) SNLiveProgressContentView *contentView3;//红牌
@property(nonatomic, strong) SNLiveProgressContentView *contentView4;//射正
@property(nonatomic, strong) SNLiveProgressContentView *contentView5;//射偏
@property(nonatomic, strong) SNLiveProgressContentView *contentView6;//进攻
@property(nonatomic, strong) SNLiveProgressContentView *contentView7;//危险进攻
@property(nonatomic, strong) SNLiveProgressContentView *contentView8;//控球率

@property(nonatomic, strong) UIView *bottomView;
@property(nonatomic, strong) UIButton *moreBtn;

@end

@implementation SNLiveFootBallHeaderView

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
    
    [self addSubview:self.backView];
    [self addSubview:self.bgView];
    
    [self.bgView addSubview:self.lineViewA];
    [self.bgView addSubview:self.lineViewB];
    [self.bgView addSubview:self.teamLabelA];
    [self.bgView addSubview:self.teamLabelB];
    
    [self.bgView addSubview:self.rightImageView1];
    [self.bgView addSubview:self.rightImageView2];
    [self.bgView addSubview:self.rightImageView3];
    [self.bgView addSubview:self.rightImageView4];
    
    [self.bgView addSubview:self.rightLabelTop1];
    [self.bgView addSubview:self.rightLabelTop2];
    [self.bgView addSubview:self.rightLabelTop3];
    [self.bgView addSubview:self.rightLabelTop4];
    
    [self.bgView addSubview:self.rightLabelBottom1];
    [self.bgView addSubview:self.rightLabelBottom2];
    [self.bgView addSubview:self.rightLabelBottom3];
    [self.bgView addSubview:self.rightLabelBottom4];
    
    [self.bgView addSubview:self.contentView1];
    [self.bgView addSubview:self.contentView2];
    [self.bgView addSubview:self.contentView3];
    [self.bgView addSubview:self.contentView4];
    [self.bgView addSubview:self.contentView5];
    [self.bgView addSubview:self.contentView6];
    [self.bgView addSubview:self.contentView7];
    [self.bgView addSubview:self.contentView8];
    
    [self.bgView addSubview:self.bottomView];
    [self.bottomView addSubview:self.moreBtn];
    
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.bottom.equalTo(self).offset(-15);
        make.top.equalTo(self).offset(10);
    }];
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.bottom.equalTo(self).offset(-15);
        make.top.equalTo(self).offset(10);
    }]; 
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.bgView);
        make.height.mas_equalTo(73);
    }];
    
    [self.moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.bottomView);
        make.centerX.equalTo(self.bottomView);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(80);
    }];
    
    [self.lineViewA mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView).offset(15);
        make.top.equalTo(self.bgView).offset(37.5);
        make.width.mas_equalTo(3);
        make.height.mas_equalTo(14);
    }];
    [self.teamLabelA mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.lineViewA.mas_right).offset(5);
        make.centerY.equalTo(self.lineViewA);
    }];
     
    [self.lineViewB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView).offset(15);
        make.top.equalTo(self.lineViewA.mas_bottom).offset(5);
        make.width.mas_equalTo(3);
        make.height.mas_equalTo(14);
        
    }];
    [self.teamLabelB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.lineViewB.mas_right).offset(5);
        make.centerY.equalTo(self.lineViewB);
    }];
    
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(15, 89, kScreenWidth-30-20, 0.5)];
    lineView.backgroundColor = [UIColor colorWithHexString:@"#979797"];
    lineView.alpha = 0.2;
    [self.bgView addSubview:lineView];
    
    [self.rightImageView4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bgView).offset(-15);
        make.top.equalTo(self.bgView).offset(16.5);
        make.width.height.mas_equalTo(13.5);
    }];
    
    [self.rightImageView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.rightImageView4.mas_left).offset(-20);
        make.centerY.equalTo(self.rightImageView4.mas_centerY);
        make.width.mas_equalTo(13.7);
        make.height.mas_equalTo(15.6);
    }];
    
    [self.rightImageView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.rightImageView3.mas_left).offset(-20);
        make.centerY.equalTo(self.rightImageView4.mas_centerY);
        make.width.mas_equalTo(13.7);
        make.height.mas_equalTo(15.6);
    }];
    
    [self.rightImageView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.rightImageView2.mas_left).offset(-20);
        make.centerY.equalTo(self.rightImageView4.mas_centerY);
        make.width.mas_equalTo(15);
        make.height.mas_equalTo(13.5);
    }];
     
    [self.rightLabelTop1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.rightImageView1);
        make.centerY.equalTo(self.teamLabelA);
    }];
    [self.rightLabelTop2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.rightImageView2);
        make.centerY.equalTo(self.teamLabelA);
    }];
    [self.rightLabelTop3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.rightImageView3);
        make.centerY.equalTo(self.teamLabelA);
    }];
    [self.rightLabelTop4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.rightImageView4);
        make.centerY.equalTo(self.teamLabelA);
    }];
    
    [self.rightLabelBottom1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.rightImageView1);
        make.centerY.equalTo(self.teamLabelB);
    }];
    [self.rightLabelBottom2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.rightImageView2);
        make.centerY.equalTo(self.teamLabelB);
    }];
    [self.rightLabelBottom3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.rightImageView3);
        make.centerY.equalTo(self.teamLabelB);
    }];
    [self.rightLabelBottom4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.rightImageView4);
        make.centerY.equalTo(self.teamLabelB);
    }];
    
}


- (void)setDataSource:(NSArray<SNFootBallStatsModel *> *)dataSource{
    WeakSelf
    [dataSource enumerateObjectsUsingBlock:^(SNFootBallStatsModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        switch (obj.type) {
            case 2: //角球
            {
                weakSelf.rightLabelTop1.text = [NSString stringWithFormat:@"%ld",obj.home];
                weakSelf.rightLabelBottom1.text = [NSString stringWithFormat:@"%ld",obj.away];
                weakSelf.contentView1.leftLabel.text = [NSString stringWithFormat:@"%ld",obj.home];
                weakSelf.contentView1.rightLabel.text = [NSString stringWithFormat:@"%ld",obj.away];
                [weakSelf.contentView1 leftProgress:obj.home rightProgress:obj.away];
            }
                break;

            case 3: //黄牌
            {
                weakSelf.rightLabelTop2.text = [NSString stringWithFormat:@"%ld",obj.home];
                weakSelf.rightLabelBottom2.text = [NSString stringWithFormat:@"%ld",obj.away];
                weakSelf.contentView2.leftLabel.text = [NSString stringWithFormat:@"%ld",obj.home];
                weakSelf.contentView2.rightLabel.text = [NSString stringWithFormat:@"%ld",obj.away];
                [weakSelf.contentView2 leftProgress:obj.home rightProgress:obj.away];
            }
                break;
                
            case 4:  //红牌
            {
                weakSelf.rightLabelTop3.text = [NSString stringWithFormat:@"%ld",obj.home];
                weakSelf.rightLabelBottom3.text = [NSString stringWithFormat:@"%ld",obj.away];
                weakSelf.contentView3.leftLabel.text = [NSString stringWithFormat:@"%ld",obj.home];
                weakSelf.contentView3.rightLabel.text = [NSString stringWithFormat:@"%ld",obj.away];
                [weakSelf.contentView3 leftProgress:obj.home rightProgress:obj.away];
            }
                break;
                
            case 13:  //半场
            {
                weakSelf.rightLabelTop4.text = [NSString stringWithFormat:@"%ld",obj.home];
                weakSelf.rightLabelBottom4.text = [NSString stringWithFormat:@"%ld",obj.away];
            }
                break;
            case 21:  //射正球门
            {
                weakSelf.contentView4.leftLabel.text = [NSString stringWithFormat:@"%ld",obj.home];
                weakSelf.contentView4.rightLabel.text = [NSString stringWithFormat:@"%ld",obj.away];
                [weakSelf.contentView4 leftProgress:obj.home rightProgress:obj.away];
            }
                break;
            case 22: //射偏球门
            {
                weakSelf.contentView5.leftLabel.text = [NSString stringWithFormat:@"%ld",obj.home];
                weakSelf.contentView5.rightLabel.text = [NSString stringWithFormat:@"%ld",obj.away];
                [weakSelf.contentView5 leftProgress:obj.home rightProgress:obj.away];

            }
                break;
            case 23: //进攻
            { 
                weakSelf.contentView6.leftLabel.text = [NSString stringWithFormat:@"%ld",obj.home];
                weakSelf.contentView6.rightLabel.text = [NSString stringWithFormat:@"%ld",obj.away];
                [weakSelf.contentView6 leftProgress:obj.home rightProgress:obj.away];
            }
                break;
            case 24:  //危险进攻
            {
                weakSelf.contentView7.leftLabel.text = [NSString stringWithFormat:@"%ld",obj.home];
                weakSelf.contentView7.rightLabel.text = [NSString stringWithFormat:@"%ld",obj.away];
                [weakSelf.contentView7 leftProgress:obj.home rightProgress:obj.away];
            }
                break;
            case 25: //控球率
            {
                weakSelf.contentView8.leftLabel.text = [NSString stringWithFormat:@"%ld",obj.home];
                weakSelf.contentView8.rightLabel.text = [NSString stringWithFormat:@"%ld",obj.away];
                [weakSelf.contentView8 leftProgress:obj.home rightProgress:obj.away];
            }
                break;
                
            default:
                break;
        }
    }];
}

- (void)moreBtnAction {
    self.bottomView.hidden = YES;
    if (self.checkMore) {
        self.checkMore();
    }
}

#pragma mark -- getter 懒加载

- (UIView *)backView {
    if (!_backView) {
        _backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 110, 110)];
        _backView.backgroundColor = UIColor.whiteColor;
        _backView.layer.cornerRadius = 13;
        _backView.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.06].CGColor;
        _backView.layer.shadowOffset = CGSizeMake(0,5);
        _backView.layer.shadowOpacity = 0.5;
    }
    return _backView;
}

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 110, 110)];
        _bgView.backgroundColor = UIColor.whiteColor;
        _bgView.layer.cornerRadius = 13;
        _bgView.layer.masksToBounds = YES;
    }
    return _bgView;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth-20, 73)];
        // gradient
        CAGradientLayer *gl = [CAGradientLayer layer];
        gl.frame = CGRectMake(0,0,kScreenWidth-20,73);
        gl.startPoint = CGPointMake(0.5, 0);
        gl.endPoint = CGPointMake(0.5, 0.8);
        gl.colors = @[(__bridge id)[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.0].CGColor, (__bridge id)[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0].CGColor];
        gl.locations = @[@(0), @(1.0f)];
        [_bottomView.layer addSublayer:gl];
        _bottomView.layer.cornerRadius = 13;
    }
    return _bottomView;
}

- (UIButton *)moreBtn {
    if (!_moreBtn) {
        _moreBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 30)];
        [_moreBtn setTitle:@"查看更多" forState:UIControlStateNormal];
        [_moreBtn setTitleColor:Blue_Color forState:UIControlStateNormal];
        _moreBtn.titleLabel.font = Font(12);
        [_moreBtn setImage:[UIImage imageNamed:@"展开-1"] forState:UIControlStateNormal];
        _moreBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -15, 0, 0);
        _moreBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 65, 0, 0);
        [_moreBtn addTarget:self action:@selector(moreBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _moreBtn;
}

- (UIView *)lineViewA {
    if (!_lineViewA) {
        _lineViewA = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 3, 14)];
        _lineViewA.backgroundColor = Blue_Color;
        _lineViewA.layer.cornerRadius = 1.5;
    }
    return _lineViewA;
}

- (UIView *)lineViewB {
    if (!_lineViewB) {
        _lineViewB = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 3, 14)];
        _lineViewB.backgroundColor = Origin_Color;
        _lineViewB.layer.cornerRadius = 1.5;

    }
    return _lineViewB;
}

- (UILabel *)teamLabelA {
    if (!_teamLabelA) {
        _teamLabelA = [[UILabel alloc]init];
        _teamLabelA.font = [UIFont systemFontOfSize:12 weight:UIFontWeightMedium];
        _teamLabelA.textColor = RGB(51, 51, 51);
        _teamLabelA.text = @"热刺";
    }
    return _teamLabelA;
}

- (UILabel *)teamLabelB {
    if (!_teamLabelB) {
        _teamLabelB = [[UILabel alloc]init];
        _teamLabelB.font = [UIFont systemFontOfSize:12 weight:UIFontWeightMedium];
        _teamLabelB.textColor = RGB(51, 51, 51);
        _teamLabelB.text = @"曼城";

    }
    return _teamLabelB;
}


- (UIImageView *)rightImageView1 {
    if (!_rightImageView1) {
        _rightImageView1 = [[UIImageView alloc] init];
        _rightImageView1.image = [UIImage imageNamed:@"角球"];
    }
    return _rightImageView1;
}

- (UIImageView *)rightImageView2 {
    if (!_rightImageView2) {
        _rightImageView2 = [[UIImageView alloc] init];
        _rightImageView2.image = [UIImage imageNamed:@"黄牌"];
    }
    return _rightImageView2;
}

- (UIImageView *)rightImageView3 {
    if (!_rightImageView3) {
        _rightImageView3 = [[UIImageView alloc] init];
        _rightImageView3.image = [UIImage imageNamed:@"红牌"];
    }
    return _rightImageView3;
}

- (UIImageView *)rightImageView4 {
    if (!_rightImageView4) {
        _rightImageView4 = [[UIImageView alloc] init];
        _rightImageView4.image = [UIImage imageNamed:@"半场"];
    }
    return _rightImageView4;
}

- (UILabel *)rightLabelTop1 {
    if (!_rightLabelTop1) {
        _rightLabelTop1 = [[UILabel alloc]init];
        _rightLabelTop1.font = [UIFont systemFontOfSize:12];
        _rightLabelTop1.textColor = RGB(51, 51, 51);
        _rightLabelTop1.text = @"0";
    }
    return _rightLabelTop1;
}

- (UILabel *)rightLabelTop2 {
    if (!_rightLabelTop2) {
        _rightLabelTop2 = [[UILabel alloc]init];
        _rightLabelTop2.font = [UIFont systemFontOfSize:12];
        _rightLabelTop2.textColor = RGB(51, 51, 51);
        _rightLabelTop2.text = @"0";
    }
    return _rightLabelTop2;
}

- (UILabel *)rightLabelTop3 {
    if (!_rightLabelTop3) {
        _rightLabelTop3 = [[UILabel alloc]init];
        _rightLabelTop3.font = [UIFont systemFontOfSize:12];
        _rightLabelTop3.textColor = RGB(51, 51, 51);
        _rightLabelTop3.text = @"0";
    }
    return _rightLabelTop3;
}

- (UILabel *)rightLabelTop4 {
    if (!_rightLabelTop4) {
        _rightLabelTop4 = [[UILabel alloc]init];
        _rightLabelTop4.font = [UIFont systemFontOfSize:12];
        _rightLabelTop4.textColor = RGB(51, 51, 51);
        _rightLabelTop4.text = @"0";
    }
    return _rightLabelTop4;
}

- (UILabel *)rightLabelBottom1 {
    if (!_rightLabelBottom1) {
        _rightLabelBottom1 = [[UILabel alloc]init];
        _rightLabelBottom1.font = [UIFont systemFontOfSize:12];
        _rightLabelBottom1.textColor = RGB(51, 51, 51);
        _rightLabelBottom1.text = @"0";
    }
    return _rightLabelBottom1;
}

- (UILabel *)rightLabelBottom2 {
    if (!_rightLabelBottom2) {
        _rightLabelBottom2 = [[UILabel alloc]init];
        _rightLabelBottom2.font = [UIFont systemFontOfSize:12];
        _rightLabelBottom2.textColor = RGB(51, 51, 51);
        _rightLabelBottom2.text = @"0";
    }
    return _rightLabelBottom2;
}

- (UILabel *)rightLabelBottom3 {
    if (!_rightLabelBottom3) {
        _rightLabelBottom3 = [[UILabel alloc]init];
        _rightLabelBottom3.font = [UIFont systemFontOfSize:12];
        _rightLabelBottom3.textColor = RGB(51, 51, 51);
        _rightLabelBottom3.text = @"0";
    }
    return _rightLabelBottom3;
}

- (UILabel *)rightLabelBottom4 {
    if (!_rightLabelBottom4) {
        _rightLabelBottom4 = [[UILabel alloc]init];
        _rightLabelBottom4.font = [UIFont systemFontOfSize:12];
        _rightLabelBottom4.textColor = RGB(51, 51, 51);
        _rightLabelBottom4.text = @"0";
    }
    return _rightLabelBottom4;
}

- (SNLiveProgressContentView *)contentView1 {
    if (!_contentView1) {
        _contentView1 = [[SNLiveProgressContentView alloc] initWithFrame:CGRectMake(0, 90.5, processW, processH)];
        _contentView1.centerLabel.text = @"角球";
    }
    return _contentView1;
}

- (SNLiveProgressContentView *)contentView2 {
    if (!_contentView2) {
        _contentView2 = [[SNLiveProgressContentView alloc] initWithFrame:CGRectMake(0, processH+90.5, processW, processH)];
        _contentView2.centerLabel.text = @"黄牌";
    }
    return _contentView2;
}

- (SNLiveProgressContentView *)contentView3 {
    if (!_contentView3) {
        _contentView3 = [[SNLiveProgressContentView alloc] initWithFrame:CGRectMake(0, processH*2+90.5, processW, processH)];
        _contentView3.centerLabel.text = @"红牌";
    }
    return _contentView3;
}

- (SNLiveProgressContentView *)contentView4 {
    if (!_contentView4) {
        _contentView4 = [[SNLiveProgressContentView alloc] initWithFrame:CGRectMake(0, processH*3+90.5, processW, processH)];
        _contentView4.centerLabel.text = @"射正";
    }
    return _contentView4;
}

- (SNLiveProgressContentView *)contentView5 {
    if (!_contentView5) {
        _contentView5 = [[SNLiveProgressContentView alloc] initWithFrame:CGRectMake(0, processH*4+90.5, processW, processH)];
        _contentView5.centerLabel.text = @"射偏";
    }
    return _contentView5;
}

- (SNLiveProgressContentView *)contentView6 {
    if (!_contentView6) {
        _contentView6 = [[SNLiveProgressContentView alloc] initWithFrame:CGRectMake(0, processH*5+90.5, processW, processH)];
        _contentView6.centerLabel.text = @"进攻";
    }
    return _contentView6;
}

- (SNLiveProgressContentView *)contentView7 {
    if (!_contentView7) {
        _contentView7 = [[SNLiveProgressContentView alloc] initWithFrame:CGRectMake(0, processH*6+90.5, processW, processH)];
        _contentView7.centerLabel.text = @"危险进攻";
    }
    return _contentView7;
}

- (SNLiveProgressContentView *)contentView8 {
    if (!_contentView8) {
        _contentView8 = [[SNLiveProgressContentView alloc] initWithFrame:CGRectMake(0, processH*7+90.5, processW, processH)];
        _contentView8.centerLabel.text = @"控球率";
    }
    return _contentView8;
}
 

@end


@interface SNLiveProgressContentView()


@property(nonatomic, strong) SNLiveProgressView *leftProgressView;

@property(nonatomic, strong) SNLiveProgressView *rightProgressView;

@end


@implementation SNLiveProgressContentView

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
        make.width.mas_equalTo(55);
    }];
    
    [self.leftProgressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self.centerLabel.mas_left).offset(-8);
        make.width.mas_offset((kScreenWidth-180)/2);
        make.height.mas_offset(12);
    }];
    
    [self.rightProgressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self.centerLabel.mas_right).offset(8);
        make.width.mas_offset((kScreenWidth-180)/2);
        make.height.mas_offset(12);
    }];
    
    [self.leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self.leftProgressView.mas_left).offset(-10);
    }];
    
    [self.rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self.rightProgressView.mas_right).offset(10);
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
        _leftLabel.font = [UIFont systemFontOfSize:13 weight:UIFontWeightMedium];
        _leftLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    }
    return _leftLabel;
}

- (UILabel *)centerLabel {
    if (!_centerLabel) {
        _centerLabel = [[UILabel alloc] init];
        _centerLabel.font = [UIFont systemFontOfSize:13];
        _centerLabel.textAlignment = NSTextAlignmentCenter;
        _centerLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    }
    return _centerLabel;
}

- (UILabel *)rightLabel {
    if (!_rightLabel) {
        _rightLabel = [[UILabel alloc] init];
        _rightLabel.font = [UIFont systemFontOfSize:13 weight:UIFontWeightMedium];
        _rightLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    }
    return _rightLabel;
}

- (SNLiveProgressView *)leftProgressView {
    if (!_leftProgressView) {
        _leftProgressView = [[SNLiveProgressView alloc] initWithFrame:CGRectMake(0, 0, (kScreenWidth-180)/2, 12) withType:ProgressViewTypeLeft];
        _leftProgressView.progress = 0;

    }
    return _leftProgressView;
}

- (SNLiveProgressView *)rightProgressView {
    if (!_rightProgressView) {
        _rightProgressView = [[SNLiveProgressView alloc] initWithFrame:CGRectMake(0, 0, (kScreenWidth-180)/2, 12) withType:ProgressViewTypeRight];
        _rightProgressView.progress = 0;

    }
    return _rightProgressView;
}

@end


@interface SNLiveProgressView()

@property (nonatomic, strong) UIView *trackView;

@property (nonatomic, strong) UIView *progressView;

@property(nonatomic, assign) ProgressViewType type;

@end


@implementation SNLiveProgressView

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
            make.top.left.bottom.equalTo(self);
            make.width.mas_equalTo(1);
        }];
    }else {
        self.trackView.backgroundColor = Origin_Light_Color;
        self.progressView.backgroundColor = Origin_Color;
        [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.bottom.equalTo(self);
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
    }
    return _trackView;
}

- (UIView *)progressView {
    if (!_progressView) {
        _progressView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, self.height)];
    }
    return _progressView;
}
 
@end




@interface SNCircleProgressView()

@property (nonatomic, strong) UILabel               *leftLabel;
@property (nonatomic, strong) UILabel               *rightLabel;
@property (nonatomic, strong) SNCircleProgress      *circleProgress;

@property(nonatomic, assign) BOOL isFirst;

@end

@implementation SNCircleProgressView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews{
    [self addSubview:self.titleLabel];
    [self addSubview:self.leftLabel];
    [self addSubview:self.rightLabel];
    [self addSubview:self.circleProgress];
    
    self.isFirst = YES;
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.mas_equalTo(15);
    }];
    [self.circleProgress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.titleLabel);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
        make.width.height.mas_equalTo(42);
    }];
    
    [self.leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.circleProgress.mas_left).offset(-5);
        make.centerY.equalTo(self.circleProgress);
        
    }];
    [self.rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.circleProgress.mas_right).offset(5);
        make.centerY.equalTo(self.circleProgress);
    }];
    
    
}

- (void)setStatsModel:(SNFootBallStatsModel *)statsModel {
    self.titleLabel.text = statsModel.typeName;
    self.leftLabel.text = [NSString stringWithFormat:@"%ld",(long)statsModel.home];
    self.rightLabel.text = [NSString stringWithFormat:@"%ld",(long)statsModel.away];
    float score = 0;
    if (statsModel.home + statsModel.away > 0) {
        score = (float)statsModel.home/(statsModel.away + statsModel.home);
    }
    [self.circleProgress setProgress:score animated:self.isFirst];
    self.isFirst = NO;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.font = [UIFont systemFontOfSize:12];
        _titleLabel.textColor = RGB(51, 51, 51);
    }
    return _titleLabel;
}

- (UILabel *)leftLabel {
    if (!_leftLabel) {
        _leftLabel = [[UILabel alloc]init];
        _leftLabel.font = [UIFont systemFontOfSize:12];
        _leftLabel.textColor = RGB(51, 51, 51);
        _leftLabel.text = @"0";

    }
    return _leftLabel;
}

- (UILabel *)rightLabel {
    if (!_rightLabel) {
        _rightLabel = [[UILabel alloc]init];
        _rightLabel.font = [UIFont systemFontOfSize:12];
        _rightLabel.textColor = RGB(51, 51, 51);
        _rightLabel.text = @"0";

    }
    return _rightLabel;
}

- (SNCircleProgress *)circleProgress {
    if (!_circleProgress) {
        _circleProgress = [[SNCircleProgress alloc]initWithFrame:CGRectMake(0, 0, 40, 40) trackWidth:5];
        _circleProgress.progressBgColor = RGB(229, 229, 229);
        _circleProgress.progressColor = yellow_Color;
        _circleProgress.progress = 0;
    }
    return _circleProgress;
}

@end

@interface SNShootRightMissView()



@end

@implementation SNShootRightMissView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    //射正
    [self addSubview:self.titleLabel];
    [self addSubview:self.leftLabel];
    [self addSubview:self.leftImageView1];
    [self addSubview:self.leftImageView2];
    [self addSubview:self.leftImageView3];
    [self addSubview:self.rightLabel];
    [self addSubview:self.rightImageView1];
    [self addSubview:self.rightImageView2];
    [self addSubview:self.rightImageView3];
    [self addSubview:self.leftProgressView];
    [self addSubview:self.rightProgressView];
    
    //射偏
    [self addSubview:self.missTitleLabel];
    [self addSubview:self.leftLabel1];
    [self addSubview:self.leftLabel2];
    [self addSubview:self.leftLabel3];
    [self addSubview:self.leftLabel4];
    [self addSubview:self.rightLabel1];
    [self addSubview:self.rightLabel2];
    [self addSubview:self.rightLabel3];
    [self addSubview:self.rightLabel4];
    [self addSubview:self.missLeftProgressView];
    [self addSubview:self.missRightProgressView];
    
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.mas_equalTo(0);
    }];
    [self.leftProgressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.titleLabel).offset(-72/2 - 2);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(4);
        make.width.mas_equalTo(72);
        make.height.mas_equalTo(5);
    }];
    
    [self.rightProgressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.titleLabel).offset(72/2 + 2);
        make.centerY.equalTo(self.leftProgressView);
        make.width.mas_equalTo(72);
        make.height.mas_equalTo(5);
    }];
    
    
    [self.leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.leftProgressView.mas_left).offset(-15);
        make.bottom.equalTo(self.leftProgressView.mas_bottom).offset(2);
        
    }];
    
    [self.leftImageView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.leftLabel.mas_left).offset(-7.5);
        make.centerY.equalTo(self.leftLabel.mas_centerY);
    }];
    [self.leftImageView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.leftImageView1.mas_left).offset(-6.5);
        make.centerY.equalTo(self.leftLabel.mas_centerY);
    }];
    [self.leftImageView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.leftImageView2.mas_left).offset(-6.5);
        make.centerY.equalTo(self.leftLabel);
    }];
    
    [self.rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.rightProgressView.mas_right).offset(15);
        make.bottom.equalTo(self.leftProgressView.mas_bottom).offset(2);
    }];
    [self.rightImageView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.rightLabel.mas_right).offset(7.5);
        make.centerY.equalTo(self.rightLabel);
    }];
    [self.rightImageView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.rightImageView1.mas_right).offset(6.5);
        make.centerY.equalTo(self.rightLabel);
    }];
    [self.rightImageView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.rightImageView2.mas_right).offset(6.5);
        make.centerY.equalTo(self.rightLabel);
    }];
    
    //射偏了
    [self.missTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.mas_equalTo(45);
    }];
    [self.missLeftProgressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.missTitleLabel).offset(-72/2 - 2);
        make.top.equalTo(self.missTitleLabel.mas_bottom).offset(4);
        make.width.mas_equalTo(72);
        make.height.mas_equalTo(5);
    }];
    
    [self.missRightProgressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.missTitleLabel).offset(72/2 + 2);
        make.top.equalTo(self.missTitleLabel.mas_bottom).offset(4);
        make.width.mas_equalTo(72);
        make.height.mas_equalTo(5);
    }];
    
    
    [self.leftLabel4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.leftLabel);
        make.bottom.equalTo(self.missLeftProgressView.mas_bottom).offset(2);
    }];
    
    [self.leftLabel3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.leftImageView1);
        make.centerY.equalTo(self.leftLabel4);
        
    }];
    
    [self.leftLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.leftImageView2);
        make.centerY.equalTo(self.leftLabel4);
    }];
    
    [self.leftLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.leftImageView3);
        make.centerY.equalTo(self.leftLabel4);
    }];
    
    
    [self.rightLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.rightLabel);
        make.bottom.equalTo(self.missRightProgressView.mas_bottom).offset(2);
    }];
    
    [self.rightLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.rightImageView1);
        make.centerY.equalTo(self.rightLabel1);
    }];

    [self.rightLabel3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.rightImageView2);
        make.centerY.equalTo(self.rightLabel1);
    }];
    
    [self.rightLabel4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.rightImageView3);
        make.centerY.equalTo(self.rightLabel1);
    }];
    
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.font = [UIFont systemFontOfSize:12];
        _titleLabel.textColor = RGB(51, 51, 51);
        _titleLabel.text = @"射正球门";
    }
    return _titleLabel;
}

- (UILabel *)leftLabel {
    if (!_leftLabel) {
        _leftLabel = [[UILabel alloc]init];
        _leftLabel.font = [UIFont systemFontOfSize:12];
        _leftLabel.textColor = RGB(51, 51, 51);
        _leftLabel.text = @"0";

    }
    return _leftLabel;
}

- (UIImageView *)leftImageView1 {
    if (!_leftImageView1) {
        _leftImageView1 = [[UIImageView alloc] init];
        _leftImageView1.image = [UIImage imageNamed:@"黄牌"];
    }
    return _leftImageView1;
}

- (UIImageView *)leftImageView2 {
    if (!_leftImageView2) {
        _leftImageView2 = [[UIImageView alloc] init];
        _leftImageView2.image = [UIImage imageNamed:@"红牌"];
    }
    return _leftImageView2;
}
- (UIImageView *)leftImageView3 {
    if (!_leftImageView3) {
        _leftImageView3 = [[UIImageView alloc] init];
        _leftImageView3.image = [UIImage imageNamed:@"角球"];
    }
    return _leftImageView3;
}

- (UILabel *)rightLabel{
    if (!_rightLabel) {
        _rightLabel = [[UILabel alloc]init];
        _rightLabel.font = [UIFont systemFontOfSize:12];
        _rightLabel.textColor = RGB(51, 51, 51);
        _rightLabel.text = @"0";

    }
    return _rightLabel;
}

- (UIImageView *)rightImageView1 {
    if (!_rightImageView1) {
        _rightImageView1 = [[UIImageView alloc] init];
        _rightImageView1.image = [UIImage imageNamed:@"黄牌"];
    }
    return _rightImageView1;
}

- (UIImageView *)rightImageView2 {
    if (!_rightImageView2) {
        _rightImageView2 = [[UIImageView alloc] init];
        _rightImageView2.image = [UIImage imageNamed:@"红牌"];
    }
    return _rightImageView2;
}
- (UIImageView *)rightImageView3 {
    if (!_rightImageView3) {
        _rightImageView3 = [[UIImageView alloc] init];
        _rightImageView3.image = [UIImage imageNamed:@"角球"];
    }
    return _rightImageView3;
}

- (UIProgressView *)leftProgressView {
    if (!_leftProgressView) {
        _leftProgressView = [[UIProgressView alloc]initWithFrame:CGRectMake(0, 0, 71, 3)];
        _leftProgressView.trackTintColor = RGB(240, 240, 240);
        _leftProgressView.progressTintColor = yellow_Color;
        _leftProgressView.progress = 0;
        _leftProgressView.transform = CGAffineTransformMakeRotation(M_PI);
    }
    return _leftProgressView;
}

- (UIProgressView *)rightProgressView {
    if (!_rightProgressView) {
        _rightProgressView = [[UIProgressView alloc]initWithFrame:CGRectMake(0, 0, 71, 3)];
        _rightProgressView.trackTintColor = RGB(240, 240, 240);
        _rightProgressView.progressTintColor = Blue_Color;
        _rightProgressView.progress = 0;
    }
    return _rightProgressView;
}

- (UILabel *)missTitleLabel {
    if (!_missTitleLabel) {
        _missTitleLabel = [[UILabel alloc]init];
        _missTitleLabel.font = [UIFont systemFontOfSize:12];
        _missTitleLabel.textColor = RGB(51, 51, 51);
        _missTitleLabel.text = @"射偏球门";
    }
    return _missTitleLabel;
}

- (UILabel *)leftLabel1 {
    if (!_leftLabel1) {
        _leftLabel1 = [[UILabel alloc]init];
        _leftLabel1.font = [UIFont systemFontOfSize:12];
        _leftLabel1.textColor = RGB(51, 51, 51);
        _leftLabel1.text = @"0";

    }
    return _leftLabel1;
}

- (UILabel *)leftLabel2 {
    if (!_leftLabel2) {
        _leftLabel2 = [[UILabel alloc]init];
        _leftLabel2.font = [UIFont systemFontOfSize:12];
        _leftLabel2.textColor = RGB(51, 51, 51);
        _leftLabel2.text = @"0";

    }
    return _leftLabel2;
}

- (UILabel *)leftLabel3 {
    if (!_leftLabel3) {
        _leftLabel3 = [[UILabel alloc]init];
        _leftLabel3.font = [UIFont systemFontOfSize:12];
        _leftLabel3.textColor = RGB(51, 51, 51);
        _leftLabel3.text = @"0";
    }
    return _leftLabel3;
}

- (UILabel *)leftLabel4 {
    if (!_leftLabel4) {
        _leftLabel4 = [[UILabel alloc]init];
        _leftLabel4.font = [UIFont systemFontOfSize:12];
        _leftLabel4.textColor = RGB(51, 51, 51);
        _leftLabel4.text = @"0";
    }
    return _leftLabel4;
}

- (UILabel *)rightLabel1 {
    if (!_rightLabel1) {
        _rightLabel1 = [[UILabel alloc]init];
        _rightLabel1.font = [UIFont systemFontOfSize:12];
        _rightLabel1.textColor = RGB(51, 51, 51);
        _rightLabel1.text = @"0";

    }
    return _rightLabel1;
}

- (UILabel *)rightLabel2 {
    if (!_rightLabel2) {
        _rightLabel2 = [[UILabel alloc]init];
        _rightLabel2.font = [UIFont systemFontOfSize:12];
        _rightLabel2.textColor = RGB(51, 51, 51);
        _rightLabel2.text = @"0";

    }
    return _rightLabel2;
}

- (UILabel *)rightLabel3 {
    if (!_rightLabel3) {
        _rightLabel3 = [[UILabel alloc]init];
        _rightLabel3.font = [UIFont systemFontOfSize:12];
        _rightLabel3.textColor = RGB(51, 51, 51);
        _rightLabel3.text = @"0";
    }
    return _rightLabel3;
}

- (UILabel *)rightLabel4 {
    if (!_rightLabel4) {
        _rightLabel4 = [[UILabel alloc]init];
        _rightLabel4.font = [UIFont systemFontOfSize:12];
        _rightLabel4.textColor = RGB(51, 51, 51);
        _rightLabel4.text = @"0";
    }
    return _rightLabel4;
}

- (UIProgressView *)missLeftProgressView {
    if (!_missLeftProgressView) {
        _missLeftProgressView = [[UIProgressView alloc]initWithFrame:CGRectMake(0, 0, 71, 3)];
        _missLeftProgressView.trackTintColor = RGB(240, 240, 240);
        _missLeftProgressView.progressTintColor = yellow_Color;
        _missLeftProgressView.progress = 0;
        _missLeftProgressView.transform = CGAffineTransformMakeRotation(M_PI);
    }
    return _missLeftProgressView;
}

- (UIProgressView *)missRightProgressView{
    if (!_missRightProgressView) {
        _missRightProgressView = [[UIProgressView alloc]initWithFrame:CGRectMake(0, 0, 71, 3)];
        _missRightProgressView.trackTintColor = RGB(240, 240, 240);
        _missRightProgressView.progressTintColor = Blue_Color;
        _missRightProgressView.progress = 0;
    }
    return _missRightProgressView;
}

@end


