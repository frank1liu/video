//
//  SNDatasHistoryJiaoFengTopTableViewCell.m
//  SportNews
//
//  Created by kkk on 2021/2/4.
//

#import "SNDatasHistoryJiaoFengTopTableViewCell.h"
#import "SNDatasButtonView.h" 

@interface SNDatasHistoryJiaoFengTopTableViewCell ()

@property (nonatomic, strong) UIView *backView;

@property(nonatomic, strong) SNDatasButtonView *buttonView;

@property(nonatomic, strong) UIImageView *hIconImageView;

@property(nonatomic, strong) UILabel *hShengLabel;

@property(nonatomic, strong) UILabel *hScoreLabel;

@property(nonatomic, strong) SNDatasProgressView *hProgressView;

@property(nonatomic, strong) UILabel *centerLabel;

@property(nonatomic, strong) UIImageView *aIconImageView;

@property(nonatomic, strong) UILabel *aShengLabel;

@property(nonatomic, strong) UILabel *aScoreLabel;

@property(nonatomic, strong) SNDatasProgressView *aProgressView;


//同主队
@property(nonatomic, strong) UIButton *tongZhuBtn;

//日期/赛事
@property (nonatomic, strong) UILabel *Label1;
//主队
@property (nonatomic, strong) UILabel *Label2;
//比分
@property (nonatomic, strong) UILabel *Label3;
//客队
@property (nonatomic, strong) UILabel *Label4;
//让分
@property (nonatomic, strong) UILabel *Label5;
//总分
@property (nonatomic, strong) UILabel *Label6; 

@end

@implementation SNDatasHistoryJiaoFengTopTableViewCell

#pragma mark -- initialization 初始化
+ (instancetype)cellWithTableView:(UITableView *)tableView {
    
    static NSString *ID = @"SNDatasHistoryJiaoFengTopTableViewCell";
    SNDatasHistoryJiaoFengTopTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[SNDatasHistoryJiaoFengTopTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
    
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        // 添加子控件
        self.backgroundColor = UIColor.clearColor;
        self.selectionStyle = 0;
        [self setupSubviews];
    }
    return self;
}

- (void)setModel:(LiveListModel *)model {
    _model = model;
    [self.hIconImageView sd_setImageWithURL:[NSURL URLWithString:model.ateam_logo] placeholderImage:UIImageMake(@"默认头像")];
    [self.aIconImageView sd_setImageWithURL:[NSURL URLWithString:model.hteam_logo] placeholderImage:UIImageMake(@"默认头像")];
    
    self.hShengLabel.text = @"5场";
    self.hScoreLabel.text = @"场均96.7分";
    
    self.centerLabel.text = @"共10场";
    
    self.aShengLabel.text = @"5场";
    self.aScoreLabel.text = @"场均96.7分";
    
//    [self.buttonView leftText:@"全场" rightText:@"半场"];
//    [self.buttonView setupCoverBtn:NO];
}

- (void)setVsArray:(NSArray *)vsArray {
    if (vsArray.count == 0) {
        self.hShengLabel.text = @"0胜";
        self.hScoreLabel.text = @"场均0分";
        self.hProgressView.progress = 0;
        self.centerLabel.text = @"共0场";
        self.aShengLabel.text = @"0胜";
        self.aScoreLabel.text = @"场均0分";
        self.aProgressView.progress = 0;
        return;
    }
    NSInteger count = vsArray.count;
    float __block shengLv = 0;
    float __block hTotalScore = 0;
    float __block aTotalScore = 0;
    [vsArray enumerateObjectsUsingBlock:^(SNDatasBasketHistoryRecordModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        if (obj.hScore.integerValue > obj.aScore.integerValue) {
//            shengLv += 1;
//        }
        if ([[CommonTools getScoreResult:obj.scoreQuan isHome:[self.model.hteam_name isEqualToString:obj.hName]] isEqualToString:@"赢"]) {
            shengLv += 1;
        }
        if ([obj.hName isEqualToString:self.model.hteam_name]) {
            hTotalScore = hTotalScore + obj.hScore.integerValue;
            aTotalScore = aTotalScore + obj.aScore.integerValue;
        } else {
            hTotalScore = hTotalScore + obj.aScore.integerValue;
            aTotalScore = aTotalScore + obj.hScore.integerValue;
        }
    }];
    NSString *shengSrt = [NSString stringWithFormat:@"%0.1f",(shengLv/count)*100];
    shengSrt = [shengSrt stringByAppendingString:@"%"];
    self.aShengLabel.text = [NSString stringWithFormat:@"%0.0f胜",shengLv];;
    self.aScoreLabel.text = [NSString stringWithFormat:@"场均%0.1f分",hTotalScore/count];
    self.aProgressView.progress = (float)shengLv/count;
    self.centerLabel.text = [NSString stringWithFormat:@"共%ld场",vsArray.count];
    self.hShengLabel.text = [NSString stringWithFormat:@"%0.0f胜",count-shengLv];
    self.hScoreLabel.text = [NSString stringWithFormat:@"场均%0.1f分",aTotalScore/count];
    self.hProgressView.progress = (float)(count-shengLv)/count;
    
}

//是否勾选了按钮
- (void)isCellSelectButton:(BOOL)isSelect {
    [self.buttonView setupCoverBtn:isSelect];
}

//是否勾选了同主客
- (void)isCellTongZhuKe:(BOOL)isSelect {
    self.tongZhuBtn.selected = isSelect;
}

- (void)tongZhuBtnAction:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    if (self.clickTongZhuKe) {
        self.clickTongZhuKe(sender.isSelected);
    }
}
 

- (void)setupSubviews {
     
    [self.contentView addSubview:self.backView];
    [self.backView addSubview:self.hIconImageView];
    [self.backView addSubview:self.hShengLabel];
    [self.backView addSubview:self.hScoreLabel];
    [self.backView addSubview:self.hProgressView];
    
    [self.backView addSubview:self.centerLabel];
    
    [self.backView addSubview:self.aIconImageView];
    [self.backView addSubview:self.aShengLabel];
    [self.backView addSubview:self.aScoreLabel];
    [self.backView addSubview:self.aProgressView];
    
    [self.backView addSubview:self.buttonView];
    [self.backView addSubview:self.tongZhuBtn];
    [self.backView addSubview:self.Label1];
    [self.backView addSubview:self.Label2];
    [self.backView addSubview:self.Label3];
    [self.backView addSubview:self.Label4];
    [self.backView addSubview:self.Label5];
    [self.backView addSubview:self.Label6];
      
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.left.equalTo(self).offset(12.5);
        make.right.equalTo(self).offset(-12.5);
    }];
    
    [self.hIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backView).offset(22);
        make.left.equalTo(self.backView).offset(15);
        make.width.height.mas_equalTo(35);
    }];
    
    [self.hProgressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.hIconImageView.mas_centerY);
        make.left.equalTo(self.hIconImageView.mas_right).offset(11.5);
        make.width.mas_offset((kScreenWidth-149)/2);
        make.height.mas_offset(15);
    }];
    
    [self.hShengLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.hProgressView.mas_left);
        make.bottom.equalTo(self.hProgressView.mas_top).offset(-2);
    }];
    
    [self.hScoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.hProgressView.mas_left);
        make.top.equalTo(self.hProgressView.mas_bottom).offset(2);
    }];
    
    [self.centerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.backView.mas_centerX);
        make.centerY.equalTo(self.hScoreLabel.mas_centerY);
    }];
    
    [self.aIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.hIconImageView.mas_centerY);
        make.right.equalTo(self.backView).offset(-15);
        make.width.height.mas_equalTo(35);
    }];
    
    [self.aProgressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.aIconImageView.mas_centerY);
        make.right.equalTo(self.aIconImageView.mas_left).offset(-11.5);
        make.width.mas_offset((kScreenWidth-149)/2);
        make.height.mas_offset(15);
    }];
    
    [self.aShengLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.aProgressView.mas_right);
        make.bottom.equalTo(self.aProgressView.mas_top).offset(-2);
    }];
    
    [self.aScoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.aProgressView.mas_right);
        make.top.equalTo(self.aProgressView.mas_bottom).offset(2);
    }];
    
    
    [self.Label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.backView).offset(-16);
        make.left.equalTo(self.backView).offset(15.5);
        make.width.mas_equalTo(61);
    }];
    
    [self.tongZhuBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.Label1.mas_top).offset(-10);
        make.left.equalTo(self.backView).offset(12);
        make.height.mas_equalTo(40);
    }];
     
    [self.buttonView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.tongZhuBtn.mas_centerY);
        make.right.equalTo(self.backView).offset(-12.5);
        make.width.mas_equalTo(78);
        make.height.mas_equalTo(22.5);
    }];
    
    [self.Label3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.Label1.mas_centerY);
        make.centerX.equalTo(self.backView.mas_centerX).offset(-15);
        make.width.mas_equalTo(48);
    }];
    
    [self.Label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.Label1.mas_centerY);
        make.right.equalTo(self.Label3.mas_left).offset(-7.5);
        make.left.greaterThanOrEqualTo(self.Label1.mas_right).offset(7.5);
    }];
    
    
    [self.Label6 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.Label1.mas_centerY);
        make.right.equalTo(self.backView).offset(-20);
        make.width.mas_equalTo(28);
    }];
    
    [self.Label5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.Label1.mas_centerY);
        make.right.equalTo(self.Label6.mas_left).offset(-15);
        make.width.mas_equalTo(28);
    }];
    
    [self.Label4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.Label1.mas_centerY);
        make.left.equalTo(self.Label3.mas_right).offset(7.5);
        make.right.greaterThanOrEqualTo(self.Label5.mas_left).offset(-7.5);
    }];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.backView addRoundedCorners:UIRectCornerTopLeft| UIRectCornerTopRight withRadii:CGSizeMake(13, 13)];
}
 
- (UIView *)backView {
    if (!_backView) {
        _backView = [[UIView alloc] init];
        _backView.backgroundColor = UIColor.whiteColor;
    }
    return _backView;
}

- (UIImageView *)hIconImageView {
    if (!_hIconImageView) {
        _hIconImageView = [[UIImageView alloc] init];
    }
    return _hIconImageView;
}

- (UILabel *)hShengLabel {
    if (!_hShengLabel) {
        _hShengLabel = [[UILabel alloc] init];
        _hShengLabel.font = [UIFont systemFontOfSize:12];
        _hShengLabel.textColor = Blue_Color;
    }
    return _hShengLabel;
}

- (UILabel *)hScoreLabel {
    if (!_hScoreLabel) {
        _hScoreLabel = [[UILabel alloc] init];
        _hScoreLabel.font = [UIFont systemFontOfSize:12];
        _hScoreLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    }
    return _hScoreLabel;
}
 
- (SNDatasProgressView *)hProgressView {
    if (!_hProgressView) {
        _hProgressView = [[SNDatasProgressView alloc] initWithFrame:CGRectMake(0, 0, (kScreenWidth-149)/2, 15) withType:DatasProgressViewTypeLeft];
        _hProgressView.progress = 0.5;
    }
    return _hProgressView;
}

- (UILabel *)centerLabel {
    if (!_centerLabel) {
        _centerLabel = [[UILabel alloc] init];
        _centerLabel.font = [UIFont systemFontOfSize:11];
        _centerLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    }
    return _centerLabel;
}
 
- (UIImageView *)aIconImageView {
    if (!_aIconImageView) {
        _aIconImageView = [[UIImageView alloc] init];
    }
    return _aIconImageView;
}

- (UILabel *)aShengLabel {
    if (!_aShengLabel) {
        _aShengLabel = [[UILabel alloc] init];
        _aShengLabel.font = [UIFont systemFontOfSize:12];
        _aShengLabel.textColor = Blue_Color;
    }
    return _aShengLabel;
}

- (UILabel *)aScoreLabel {
    if (!_aScoreLabel) {
        _aScoreLabel = [[UILabel alloc] init];
        _aScoreLabel.font = [UIFont systemFontOfSize:12];
        _aScoreLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    }
    return _aScoreLabel;
}
 
- (SNDatasProgressView *)aProgressView {
    if (!_aProgressView) {
        _aProgressView = [[SNDatasProgressView alloc] initWithFrame:CGRectMake(0, 0, (kScreenWidth-149)/2, 15) withType:DatasProgressViewTypeRight];
        _aProgressView.progress = 0.5;
    }
    return _aProgressView;
}

- (UIButton *)tongZhuBtn {
    if (!_tongZhuBtn) {
        _tongZhuBtn = [[UIButton alloc] init];
        [_tongZhuBtn setTitle:@" 同主客" forState:UIControlStateNormal];
        [_tongZhuBtn setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
        _tongZhuBtn.titleLabel.font = [UIFont systemFontOfSize:11];
        [_tongZhuBtn setImage:[UIImage imageNamed:@"未选"] forState:UIControlStateNormal];
        [_tongZhuBtn setImage:[UIImage imageNamed:@"选择"] forState:UIControlStateSelected];
        [_tongZhuBtn addTarget:self action:@selector(tongZhuBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _tongZhuBtn;
}
 
- (SNDatasButtonView *)buttonView {
    if (!_buttonView) {
        _buttonView = [[SNDatasButtonView alloc] initWithFrame:CGRectMake(0, 0, 78, 22.5)];
        _buttonView.hidden = YES;
        WeakSelf
        _buttonView.selectBlock = ^(BOOL isSelect) {
            if (weakSelf.clickButtonView) {
                weakSelf.clickButtonView(isSelect);
            }
        };
    }
    return _buttonView;
}

- (UILabel *)Label1 {
    if (!_Label1) {
        _Label1 = [[UILabel alloc] init];
        _Label1.font = [UIFont systemFontOfSize:12];
        _Label1.textColor = [UIColor colorWithHexString:@"#999999"];
        _Label1.text = @"日期/赛事";
    }
    return _Label1;
}

- (UILabel *)Label2 {
    if (!_Label2) {
        _Label2 = [[UILabel alloc] init];
        _Label2.font = [UIFont systemFontOfSize:12];
        _Label2.textColor = [UIColor colorWithHexString:@"#999999"];
        _Label2.text = @"客队";
    }
    return _Label2;
}

- (UILabel *)Label3 {
    if (!_Label3) {
        _Label3 = [[UILabel alloc] init];
        _Label3.font = [UIFont systemFontOfSize:12];
        _Label3.textColor = [UIColor colorWithHexString:@"#999999"];
        _Label3.textAlignment = NSTextAlignmentCenter;
        _Label3.text = @"比分";
    }
    return _Label3;
}

- (UILabel *)Label4 {
    if (!_Label4) {
        _Label4 = [[UILabel alloc] init];
        _Label4.font = [UIFont systemFontOfSize:12];
        _Label4.textColor = [UIColor colorWithHexString:@"#999999"];
        _Label4.text = @"主队";
    }
    return _Label4;
}

- (UILabel *)Label5 {
    if (!_Label5) {
        _Label5 = [[UILabel alloc] init];
        _Label5.font = [UIFont systemFontOfSize:12];
        _Label5.textColor = [UIColor colorWithHexString:@"#999999"];
        _Label5.textAlignment = NSTextAlignmentCenter;
        _Label5.text = @"让分";
    }
    return _Label5;
}

- (UILabel *)Label6 {
    if (!_Label6) {
        _Label6 = [[UILabel alloc] init];
        _Label6.font = [UIFont systemFontOfSize:12];
        _Label6.textColor = [UIColor colorWithHexString:@"#999999"];
        _Label6.textAlignment = NSTextAlignmentCenter;
        _Label6.text = @"总分";
    }
    return _Label6;
}




@end


@interface SNDatasProgressView ()

@property (nonatomic, strong) UIView *trackView;

@property (nonatomic, strong) UIView *progressView;

@property(nonatomic, assign) DatasProgressViewType type;

@end

@implementation SNDatasProgressView


#pragma mark -- intialization 初始化
- (instancetype)initWithFrame:(CGRect)frame withType:(DatasProgressViewType)type {
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
    
    if (self.type == DatasProgressViewTypeLeft) {
        self.progressView.backgroundColor = Blue_Color;
        self.trackView.backgroundColor = Blue_Light_Color;
        [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.equalTo(self);
            make.width.mas_equalTo(1);
        }];
    }else {
        self.progressView.backgroundColor = Origin_Color;
        self.trackView.backgroundColor = Origin_Light_Color;
        [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.bottom.equalTo(self);
            make.width.mas_equalTo(1);
        }];
    }
}

- (void)setProgress:(CGFloat)progress {
    [self.progressView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(self.width*progress);
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
