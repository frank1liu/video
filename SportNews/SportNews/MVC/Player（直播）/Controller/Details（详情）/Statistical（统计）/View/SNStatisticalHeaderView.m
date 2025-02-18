//
//  SNStatisticalHeaderView.m
//  SportNews
//
//  Created by kkk on 2021/1/26.
//

#import "SNStatisticalHeaderView.h"
#import "SportNews-Swift.h" 

@interface SNStatisticalHeaderView ()

@property (nonatomic, strong) UIView *bgView;
 
@property (nonatomic, strong) SNStatisticalHeaderContentView *contentView1;
@property (nonatomic, strong) SNStatisticalHeaderContentView *contentView2;
@property (nonatomic, strong) SNStatisticalHeaderContentView *contentView3;

@end


@implementation SNStatisticalHeaderView

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
    
    [self addSubview:self.bgView];
    
    [self.bgView addSubview:self.contentView1];
    [self.bgView addSubview:self.contentView2];
    [self.bgView addSubview:self.contentView3];
    
    
}

/// 请求球员信息mid比赛id tid主客id pid球员id
- (void)requestInfo:(NSInteger)tid model:(SNStatisticalHeaderMemberModel *)model {
    [KYRemindView show];
    [KYApiHttpTool GET:URL_PlayerInfo withParams:@{@"type":self.model.type,@"mid":@(self.statisticalModel.mid),@"playerid":@(model.playerid),@"teamtype":@(tid)}
    // 下面注释打开，这些参数去请求会有数据
//    [KYApiHttpTool GET:URL_PlayerInfo withParams:@{@"type":self.model.type,@"mid":@(3589940),@"playerid":@(12114),@"teamtype":@(2)}
               success:^(NSDictionary * _Nonnull response) {
        SNStatisticalPlayerModel *info = [SNStatisticalPlayerModel mj_objectWithKeyValues:response[@"data"]];
        [BasketballPlayerDetailVC showWithPlayerModel:info model:model]; 
    } failure:^(NSError * _Nullable error) {
        
    }];
}

- (void)setStatisticalModel:(SNStatisticalModel *)statisticalModel {
    _statisticalModel = statisticalModel;
    statisticalModel.homerank.defen.currentType = 1;
    [self.contentView1 reloadModel:statisticalModel.homerank.defen homeModel:statisticalModel.awayrank.defen];
    statisticalModel.homerank.lanban.currentType = 2;
    [self.contentView2 reloadModel:statisticalModel.homerank.lanban homeModel:statisticalModel.awayrank.lanban];
    statisticalModel.homerank.zhugong.currentType = 3;
    [self.contentView3 reloadModel:statisticalModel.homerank.zhugong homeModel:statisticalModel.awayrank.zhugong];
     
    
}

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc]initWithFrame:CGRectMake(12.5, 10, kScreenWidth-25, 267)];
        _bgView.backgroundColor = UIColor.whiteColor;
        _bgView.layer.cornerRadius = 13;
        _bgView.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.06].CGColor;
        _bgView.layer.shadowOffset = CGSizeMake(0,5);
        _bgView.layer.shadowOpacity = 0.5;
    }
    return _bgView;
}

- (SNStatisticalHeaderContentView *)contentView1 {
    if (!_contentView1) {
        _contentView1 = [[SNStatisticalHeaderContentView alloc] initWithFrame:CGRectMake(0, 0, self.bgView.width, 84)];
        _contentView1.titleLabel.text = @"得分";
        WeakSelf;
        _contentView1.tap = ^(SNStatisticalHeaderMemberModel * _Nonnull model, bool left) {
            [weakSelf requestInfo:left ? 1 : 2 model:model];
        };
    }
    return _contentView1;
}

- (SNStatisticalHeaderContentView *)contentView2 {
    if (!_contentView2) {
        _contentView2 = [[SNStatisticalHeaderContentView alloc] initWithFrame:CGRectMake(0, 84, self.bgView.width, 84)];
        _contentView2.titleLabel.text = @"篮板";
        WeakSelf;
        _contentView2.tap = ^(SNStatisticalHeaderMemberModel * _Nonnull model, bool left) {
            [weakSelf requestInfo:left ? 1 : 2 model:model];
        };
    }
    return _contentView2;
}

- (SNStatisticalHeaderContentView *)contentView3 {
    if (!_contentView3) {
        _contentView3 = [[SNStatisticalHeaderContentView alloc] initWithFrame:CGRectMake(0, 84*2, self.bgView.width, 84)];
        _contentView3.titleLabel.text = @"助攻";
        WeakSelf;
        _contentView3.tap = ^(SNStatisticalHeaderMemberModel * _Nonnull model, bool left) {
            [weakSelf requestInfo:left ? 1 : 2 model:model];
        };
    }
    return _contentView3;
}


@end


@interface SNStatisticalHeaderContentView ()


@property (nonatomic, strong) UILabel *scoreLabel;
@property (nonatomic, strong) UILabel *numberLabel;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIImageView *leftImageView;
@property(nonatomic, strong) UIView *leftProgressView;

@property (nonatomic, strong) UILabel *scoreLabel1;
@property (nonatomic, strong) UILabel *numberLabel1;
@property (nonatomic, strong) UILabel *nameLabel1;
@property (nonatomic, strong) UIImageView *rightImageView;
@property(nonatomic, strong) UIView *rightProgressView;

@property(nonatomic, strong) SNStatisticalHeaderMemberModel *awayModel;

@property(nonatomic, strong) SNStatisticalHeaderMemberModel *homeModel;

@end


@implementation SNStatisticalHeaderContentView

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
    
    [self addSubview:self.titleLabel];
    
    [self addSubview:self.scoreLabel];
    [self addSubview:self.numberLabel];
    [self addSubview:self.nameLabel];
    [self addSubview:self.leftImageView];
    [self addSubview:self.leftProgressView];
    
    [self addSubview:self.scoreLabel1];
    [self addSubview:self.numberLabel1];
    [self addSubview:self.nameLabel1];
    [self addSubview:self.rightImageView];
    [self addSubview:self.rightProgressView];
     
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.mas_equalTo(10);
    }];
    
    [self.leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15);
        make.bottom.equalTo(self).offset(-10);
        make.width.height.mas_equalTo(35);
    }];
    
    
    [self.numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftImageView.mas_right).offset(8);
        make.bottom.equalTo(self.nameLabel.mas_top).offset(-2.5);
    }];
    
    [self.leftProgressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.titleLabel.mas_centerX).offset(-11);
        make.bottom.equalTo(self);
        make.width.mas_equalTo(12);
        make.height.mas_equalTo(35);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftImageView.mas_right).offset(8);
        make.right.equalTo(self.leftProgressView.mas_left).offset(-5);
        make.bottom.equalTo(self).offset(-10);
    }];
    
    [self.scoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.leftProgressView);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(5);
    }];
    
    [self.rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-15);
        make.bottom.equalTo(self).offset(-10);
        make.width.height.mas_equalTo(35);
    }];
     
    [self.numberLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.rightImageView.mas_left).offset(-8);
        make.bottom.equalTo(self.nameLabel1.mas_top).offset(-2.5);
    }];
    
    [self.rightProgressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftProgressView.mas_right).offset(12);
        make.bottom.equalTo(self);
        make.width.mas_equalTo(12);
        make.height.mas_equalTo(35);
    }];
    
    [self.nameLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.rightImageView.mas_left).offset(-8);
        make.left.equalTo(self.rightProgressView.mas_right).offset(5);
        make.bottom.equalTo(self).offset(-10);
    }];
    
    [self.scoreLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.rightProgressView);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(5);
    }];
     
    UITapGestureRecognizer *lt = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ltap)];
    UITapGestureRecognizer *rt = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(rtap)];
    self.leftImageView.userInteractionEnabled = true;
    self.rightImageView.userInteractionEnabled = true;
    [self.leftImageView addGestureRecognizer:lt];
    [self.rightImageView addGestureRecognizer:rt];
    
    UIView *lineView1 = [[UIView alloc] init];
    lineView1.backgroundColor = Blue_Light_Color;
    [self addSubview:lineView1];
    [lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(12.5);
        make.right.equalTo(self.leftProgressView.mas_left);
        make.bottom.equalTo(self);
        make.height.mas_equalTo(2);
    }];
    
    UIView *lineView2 = [[UIView alloc] init];
    lineView2.backgroundColor = Origin_Light_Color;
    [self addSubview:lineView2];
    [lineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.rightProgressView);
        make.right.equalTo(self).offset(-12.5);
        make.bottom.equalTo(self);
        make.height.mas_equalTo(2);
    }];
      
}

- (void)ltap {
    self.tap(self.homeModel, true);
}

- (void)rtap {
    self.tap(self.awayModel, false);
}

- (void)reloadModel:(SNStatisticalHeaderMemberModel *)awayModel homeModel:(SNStatisticalHeaderMemberModel *)homeModel {
    if (awayModel == nil || homeModel == nil) {
        return;
    }
    
    self.awayModel = awayModel;
    self.homeModel = homeModel;
    
    self.nameLabel.text = homeModel.name_zh;
    self.numberLabel.text = [NSString stringWithFormat:@"#%@",homeModel.qiuyi];
    [self.leftImageView sd_setImageWithURL:[NSURL URLWithString:homeModel.logo]];
    
    self.nameLabel1.text = awayModel.name_zh;
    self.numberLabel1.text = [NSString stringWithFormat:@"#%@",awayModel.qiuyi];
    [self.rightImageView sd_setImageWithURL:[NSURL URLWithString:awayModel.logo]];
    
    //1 得分  2篮板  3助攻
    NSInteger value = 0;
    NSInteger value1 = 0;
    if (awayModel.currentType == 1) {
        value = homeModel.defen;
        value1 = awayModel.defen;
    }else if (awayModel.currentType == 2) {
        value = homeModel.lanban;
        value1 = awayModel.lanban;
    }else if (awayModel.currentType == 3) {
        value = homeModel.zhugong;
        value1 = awayModel.zhugong;
    }
    
    if (value == 0 && value1 == 0) {
        self.scoreLabel.text = @"0";
        self.scoreLabel1.text = @"0";
        [self.leftProgressView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(2);
        }];
        [self.rightProgressView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(2);
        }];
        return;
    }
    
    self.scoreLabel.text = [NSString stringWithFormat:@"%@",@(value)];
    self.scoreLabel1.text = [NSString stringWithFormat:@"%@",@(value1)];
    if (value > value1) {
        [self.leftProgressView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(35);
        }];
        [self.rightProgressView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(35*value1/value < 2? 2:35*value1/value);
        }];
    }else {
        [self.leftProgressView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(35*value/value1 < 2? 2:35*value/value1);
        }];
        [self.rightProgressView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(35);
        }];
    }
    
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:12];
        _titleLabel.textColor = Blue_Color;
    }
    return _titleLabel;
}

- (UILabel *)scoreLabel {
    if (!_scoreLabel) {
        _scoreLabel = [[UILabel alloc] init];
        _scoreLabel.font = [UIFont systemFontOfSize:11];
        _scoreLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    }
    return _scoreLabel;
}

- (UILabel *)numberLabel {
    if (!_numberLabel) {
        _numberLabel = [[UILabel alloc] init];
        _numberLabel.font = [UIFont systemFontOfSize:11];
        _numberLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    }
    return _numberLabel;
}

- (UIImageView *)leftImageView {
    if (!_leftImageView) {
        _leftImageView = [[UIImageView alloc] init];
        _leftImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _leftImageView;
}
 
- (UIView *)leftProgressView {
    if (!_leftProgressView) {
        _leftProgressView = [[UIView alloc] init];
        _leftProgressView.backgroundColor = Blue_Color;
    }
    return _leftProgressView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightMedium];
        _nameLabel.textColor = [UIColor colorWithHexString:@"#000000"];
    }
    return _nameLabel;
}

- (UILabel *)scoreLabel1 {
    if (!_scoreLabel1) {
        _scoreLabel1 = [[UILabel alloc] init];
        _scoreLabel1.font = [UIFont systemFontOfSize:11];
        _scoreLabel1.textColor = [UIColor colorWithHexString:@"#999999"];
    }
    return _scoreLabel1;
}

- (UILabel *)numberLabel1 {
    if (!_numberLabel1) {
        _numberLabel1 = [[UILabel alloc]init];
        _numberLabel1.font = [UIFont systemFontOfSize:11];
        _numberLabel1.textColor = [UIColor colorWithHexString:@"#999999"];
    }
    return _numberLabel1;
}

- (UILabel *)nameLabel1 {
    if (!_nameLabel1) {
        _nameLabel1 = [[UILabel alloc]init];
        _nameLabel1.font = [UIFont systemFontOfSize:12 weight:UIFontWeightMedium];
        _nameLabel1.textColor = [UIColor colorWithHexString:@"#000000"];
        _nameLabel1.textAlignment = NSTextAlignmentRight;
    }
    return _nameLabel1;
}

- (UIImageView *)rightImageView {
    if (!_rightImageView) {
        _rightImageView = [[UIImageView alloc] init];
        _rightImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _rightImageView;
}

- (UIView *)rightProgressView {
    if (!_rightProgressView) {
        _rightProgressView = [[UIView alloc] init];
        _rightProgressView.backgroundColor = Origin_Color;
    }
    return _rightProgressView;
}


@end
