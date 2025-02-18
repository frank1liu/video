//
//  SNTeamCompareTableViewCell.m
//  SportNews
//
//  Created by kkk on 2021/3/22.
//

#import "SNTeamCompareTableViewCell.h"
#import "SNLiveFootBallHeaderView.h"
#import "SNTeamGeneralRankTableViewCell.h"

#define processW kScreenWidth-25
#define processH 35
#define processY 60

#define compareH 35
#define compareY 243

@interface SNTeamCompareTableViewCell ()
 
@property (nonatomic, strong) UIView *bgView;


@property(nonatomic, strong) UIImageView *aIconImageView;
@property(nonatomic, strong) UILabel *aNameLabel;
 
@property(nonatomic, strong) UIImageView *hIconImageView;
@property(nonatomic, strong) UILabel *hNameLabel; 

@property(nonatomic, strong) SNDatasProgressContentView *contentView1;//得分
@property(nonatomic, strong) SNDatasProgressContentView *contentView2;//篮板
@property(nonatomic, strong) SNDatasProgressContentView *contentView3;//盖帽
@property(nonatomic, strong) SNDatasProgressContentView *contentView4;//助攻
@property(nonatomic, strong) SNDatasProgressContentView *contentView5;//抢断

@property(nonatomic, strong) SNTeamCompareView *compareView1;

@property(nonatomic, strong) SNTeamCompareView *compareView2;

@property(nonatomic, strong) SNTeamCompareView *compareView3;

@end


@implementation SNTeamCompareTableViewCell

#pragma mark -- initialization 初始化
+ (instancetype)cellWithTableView:(UITableView *)tableView {
    
    static NSString *ID = @"SNTeamCompareTableViewCell";
    SNTeamCompareTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[SNTeamCompareTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
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
    
    [self.aIconImageView sd_setImageWithURL:[NSURL URLWithString:model.ateam_logo] placeholderImage:UIImageMake(@"默认头像")];
    self.aNameLabel.text = model.ateam_name;
    
    [self.hIconImageView sd_setImageWithURL:[NSURL URLWithString:model.hteam_logo] placeholderImage:UIImageMake(@"默认头像")];
    self.hNameLabel.text = model.hteam_name;
}

- (void)setDatasModel:(SNDatasModel *)datasModel {
    _datasModel = datasModel;
    
    NSInteger adefen = ([datasModel.away_compare.defen doubleValue] * 100);
    NSInteger hdefen = ([datasModel.home_compare.defen doubleValue] * 100);
    self.contentView1.leftLabel.text = [CommonTools decimalNumberWithDouble:[datasModel.away_compare.defen doubleValue]];
    self.contentView1.rightLabel.text = [CommonTools decimalNumberWithDouble:[datasModel.home_compare.defen doubleValue]];
    [self.contentView1 leftProgress:adefen rightProgress:hdefen];
    
    NSInteger alanban = ([datasModel.away_compare.lanban doubleValue] * 100);
    NSInteger hlanban = ([datasModel.home_compare.lanban doubleValue] * 100);
    self.contentView2.leftLabel.text = [CommonTools decimalNumberWithDouble:[datasModel.away_compare.lanban doubleValue]];
    self.contentView2.rightLabel.text = [CommonTools decimalNumberWithDouble:[datasModel.home_compare.lanban doubleValue]];
    [self.contentView2 leftProgress:alanban rightProgress:hlanban];
    
    NSInteger azhugong = ([datasModel.away_compare.zhugong doubleValue] * 100);
    NSInteger hzhugong = ([datasModel.home_compare.zhugong doubleValue] * 100);
    self.contentView3.leftLabel.text = [CommonTools decimalNumberWithDouble:[datasModel.away_compare.zhugong doubleValue]];
                                        self.contentView3.rightLabel.text = [CommonTools decimalNumberWithDouble:[datasModel.home_compare.zhugong doubleValue]];
    [self.contentView3 leftProgress:azhugong rightProgress:hzhugong];
    
    NSInteger agaimao = ([datasModel.away_compare.gaimao doubleValue] * 100);
    NSInteger hgaimao = ([datasModel.home_compare.gaimao doubleValue] * 100);
    self.contentView4.leftLabel.text = [CommonTools decimalNumberWithDouble:[datasModel.away_compare.gaimao doubleValue]];
                                        self.contentView4.rightLabel.text = [CommonTools decimalNumberWithDouble:[datasModel.home_compare.gaimao doubleValue]];
    [self.contentView4 leftProgress:agaimao rightProgress:hgaimao];
    
    NSInteger aqiangduan = ([datasModel.away_compare.qiangduan doubleValue] * 100);
    NSInteger hqiangduan = ([datasModel.home_compare.qiangduan doubleValue] * 100);
    self.contentView5.leftLabel.text = [CommonTools decimalNumberWithDouble:[datasModel.away_compare.qiangduan doubleValue]];
    self.contentView5.rightLabel.text = [CommonTools decimalNumberWithDouble:[datasModel.home_compare.qiangduan doubleValue]];
    [self.contentView5 leftProgress:aqiangduan rightProgress:hqiangduan];
    
    self.compareView1.leftLabel.text = datasModel.away_compare.toulan;
    self.compareView1.rightLabel.text = datasModel.home_compare.toulan;
    
    self.compareView2.leftLabel.text = datasModel.away_compare.sanfen;
    self.compareView2.rightLabel.text = datasModel.home_compare.sanfen;
    
    self.compareView3.leftLabel.text = datasModel.away_compare.faqiu;
    self.compareView3.rightLabel.text = datasModel.home_compare.faqiu;
}


//添加子控件
- (void)setupSubviews {
    
    [self addSubview:self.bgView];
    
    [self.bgView addSubview:self.aIconImageView];
    [self.bgView addSubview:self.aNameLabel];
    [self.bgView addSubview:self.hIconImageView];
    [self.bgView addSubview:self.hNameLabel];
    
    [self.bgView addSubview:self.contentView1];
    [self.bgView addSubview:self.contentView2];
    [self.bgView addSubview:self.contentView3];
    [self.bgView addSubview:self.contentView4];
    [self.bgView addSubview:self.contentView5];
    
    [self.bgView addSubview:self.compareView1];
    [self.bgView addSubview:self.compareView2];
    [self.bgView addSubview:self.compareView3];
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12.5);
        make.right.mas_equalTo(-12.5);
        make.height.mas_equalTo(353);
        make.top.equalTo(self);
    }];
    self.bgView.layer.cornerRadius = 13;
    
    [self.aIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgView).offset(15);
        make.left.equalTo(self.bgView).offset(12.5);
        make.width.height.mas_equalTo(35);
    }];
    [self.aNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.aIconImageView);
        make.left.equalTo(self.aIconImageView.mas_right).offset(6);
    }];
    
    
    [self.hIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgView).offset(15);
        make.right.equalTo(self.bgView).offset(-12.5);
        make.width.height.mas_equalTo(35);
    }];
    [self.hNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.hIconImageView);
        make.right.equalTo(self.hIconImageView.mas_left).offset(-6);
    }];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(17.5, CGRectGetMaxY(self.contentView5.frame)+5, kScreenWidth-60, 0.5)];
    [self.bgView addSubview:lineView];
    lineView.backgroundColor = [UIColor colorWithHexString:@"#979797"];
    lineView.alpha = 0.2;
    
    
    
}

- (UIView *)bgView {
   if (!_bgView) {
       _bgView = [[UIView alloc] init];
       _bgView.backgroundColor = UIColor.whiteColor;
   }
   return _bgView;
}

- (UIImageView *)aIconImageView {
    if (!_aIconImageView) {
        _aIconImageView = [[UIImageView alloc] init];
    }
    return _aIconImageView;
}

- (UILabel *)aNameLabel {
    if (!_aNameLabel) {
        _aNameLabel = [[UILabel alloc] init];
        _aNameLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightSemibold];
        _aNameLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    }
    return _aNameLabel;
}

- (UIImageView *)hIconImageView {
    if (!_hIconImageView) {
        _hIconImageView = [[UIImageView alloc] init];
    }
    return _hIconImageView;
}

- (UILabel *)hNameLabel {
    if (!_hNameLabel) {
        _hNameLabel = [[UILabel alloc] init];
        _hNameLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightSemibold];
        _hNameLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    }
    return _hNameLabel;
}

- (SNDatasProgressContentView *)contentView1 {
    if (!_contentView1) {
        _contentView1 = [[SNDatasProgressContentView alloc] initWithFrame:CGRectMake(0, processY, processW, processH)];
        _contentView1.centerLabel.text = @"得分";
    }
    return _contentView1;
}

- (SNDatasProgressContentView *)contentView2 {
    if (!_contentView2) {
        _contentView2 = [[SNDatasProgressContentView alloc] initWithFrame:CGRectMake(0, processH+processY, processW, processH)];
        _contentView2.centerLabel.text = @"篮板";
    }
    return _contentView2;
}

- (SNDatasProgressContentView *)contentView3 {
    if (!_contentView3) {
        _contentView3 = [[SNDatasProgressContentView alloc] initWithFrame:CGRectMake(0, processH*2+processY, processW, processH)];
        _contentView3.centerLabel.text = @"盖帽";
    }
    return _contentView3;
}

- (SNDatasProgressContentView *)contentView4 {
    if (!_contentView4) {
        _contentView4 = [[SNDatasProgressContentView alloc] initWithFrame:CGRectMake(0, processH*3+processY, processW, processH)];
        _contentView4.centerLabel.text = @"助攻";
    }
    return _contentView4;
}

- (SNDatasProgressContentView *)contentView5 {
    if (!_contentView5) {
        _contentView5 = [[SNDatasProgressContentView alloc] initWithFrame:CGRectMake(0, processH*4+processY, processW, processH)];
        _contentView5.centerLabel.text = @"抢断";
    }
    return _contentView5;
}

- (SNTeamCompareView *)compareView1 {
    if (!_compareView1) {
        _compareView1 = [[SNTeamCompareView alloc] initWithFrame:CGRectMake(0, compareY, processW, compareH)];
        _compareView1.centerLabel.text = @"投篮命中率";
    }
    return _compareView1;
}
- (SNTeamCompareView *)compareView2 {
    if (!_compareView2) {
        _compareView2 = [[SNTeamCompareView alloc] initWithFrame:CGRectMake(0, compareH+compareY, processW, compareH)];
        _compareView2.centerLabel.text = @"3分球命中率";
    }
    return _compareView2;
}
- (SNTeamCompareView *)compareView3 {
    if (!_compareView3) {
        _compareView3 = [[SNTeamCompareView alloc] initWithFrame:CGRectMake(0, compareH*2+compareY, processW, compareH)];
        _compareView3.centerLabel.text = @"罚球命中率";
    }
    return _compareView3;
}


@end



@interface SNDatasProgressContentView()


@property(nonatomic, strong) SNLiveProgressView *leftProgressView;

@property(nonatomic, strong) SNLiveProgressView *rightProgressView;

@end


@implementation SNDatasProgressContentView

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
        make.width.mas_offset((kScreenWidth-200)/2);
        make.height.mas_offset(12);
    }];
    
    [self.rightProgressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self.centerLabel.mas_right).offset(8);
        make.width.mas_offset((kScreenWidth-200)/2);
        make.height.mas_offset(12);
    }];
    
    [self.leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self).offset(17.5);
    }];
    
    [self.rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self).offset(-17.5);
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
        _centerLabel.textAlignment = NSTextAlignmentCenter;
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

- (SNLiveProgressView *)leftProgressView {
    if (!_leftProgressView) {
        _leftProgressView = [[SNLiveProgressView alloc] initWithFrame:CGRectMake(0, 0, (kScreenWidth-200)/2, 12) withType:ProgressViewTypeLeft];
        _leftProgressView.progress = 0;

    }
    return _leftProgressView;
}

- (SNLiveProgressView *)rightProgressView {
    if (!_rightProgressView) {
        _rightProgressView = [[SNLiveProgressView alloc] initWithFrame:CGRectMake(0, 0, (kScreenWidth-200)/2, 12) withType:ProgressViewTypeRight];
        _rightProgressView.progress = 0;

    }
    return _rightProgressView;
}

@end
