//
//  SNTeamGeneralRankTableViewCell.m
//  SportNews
//
//  Created by kkk on 2021/3/22.
//

#import "SNTeamGeneralRankTableViewCell.h"

#define compareW kScreenWidth-25
#define compareH 35
#define compareY 65

@interface SNTeamGeneralRankTableViewCell ()

@property (nonatomic, strong) UIView *backView;


@property(nonatomic, strong) UIImageView *aIconImageView;
@property(nonatomic, strong) UILabel *aNameLabel;
@property(nonatomic, strong) UILabel *aRateLabel;
 
@property(nonatomic, strong) UIImageView *hIconImageView;
@property(nonatomic, strong) UILabel *hNameLabel;
@property(nonatomic, strong) UILabel *hRateLabel;


@property(nonatomic, strong) SNTeamCompareView *compareView1;
@property(nonatomic, strong) SNTeamCompareView *compareView2;
@property(nonatomic, strong) SNTeamCompareView *compareView3;
@property(nonatomic, strong) SNTeamCompareView *compareView4;
@property(nonatomic, strong) SNTeamCompareView *compareView5;
@property(nonatomic, strong) SNTeamCompareView *compareView6;

@end

@implementation SNTeamGeneralRankTableViewCell

#pragma mark -- initialization 初始化
+ (instancetype)cellWithTableView:(UITableView *)tableView {
    
    static NSString *ID = @"SNTeamGeneralRankTableViewCell";
    SNTeamGeneralRankTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[SNTeamGeneralRankTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
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
    
    self.aRateLabel.text = [NSString stringWithFormat:@"%ld胜%ld负",datasModel.away_rank.win,datasModel.away_rank.lost];
    self.hRateLabel.text = [NSString stringWithFormat:@"%ld胜%ld负",datasModel.home_rank.win,datasModel.home_rank.lost];
    
    self.compareView1.leftLabel.text = [NSString stringWithFormat:@"%@%ld",datasModel.away_rank.name, datasModel.away_rank.paiming];
    self.compareView1.rightLabel.text = [NSString stringWithFormat:@"%@%ld",datasModel.home_rank.name, datasModel.home_rank.paiming];
    
    self.compareView2.leftLabel.text = [NSString stringWithFormat:@"%@",datasModel.away_rank.shenglv];
    self.compareView2.rightLabel.text = [NSString stringWithFormat:@"%@",datasModel.home_rank.shenglv];
    
    self.compareView3.leftLabel.text = [NSString stringWithFormat:@"%@",datasModel.away_rank.jinqi_zhanji];
    self.compareView3.rightLabel.text = [NSString stringWithFormat:@"%@",datasModel.home_rank.jinqi_zhanji];
    
    self.compareView4.leftLabel.text = [NSString stringWithFormat:@"%@",datasModel.away_rank.jin10_zhanji];
    self.compareView4.rightLabel.text = [NSString stringWithFormat:@"%@",datasModel.home_rank.jin10_zhanji];
    
    self.compareView5.leftLabel.text = [NSString stringWithFormat:@"%@",datasModel.away_rank.zhuchang_zhanji];
    self.compareView5.rightLabel.text = [NSString stringWithFormat:@"%@",datasModel.home_rank.zhuchang_zhanji];
    
    self.compareView6.leftLabel.text = [NSString stringWithFormat:@"%@",datasModel.away_rank.kechang_zhanji];
    self.compareView6.rightLabel.text = [NSString stringWithFormat:@"%@",datasModel.home_rank.kechang_zhanji];
}

//添加子控件
- (void)setupSubviews {
    
    [self addSubview:self.backView];
    
    [self.backView addSubview:self.aIconImageView];
    [self.backView addSubview:self.aNameLabel];
    [self.backView addSubview:self.aRateLabel];
    [self.backView addSubview:self.hIconImageView];
    [self.backView addSubview:self.hNameLabel];
    [self.backView addSubview:self.hRateLabel];
    
    [self.backView addSubview:self.compareView1];
    [self.backView addSubview:self.compareView2];
    [self.backView addSubview:self.compareView3];
    [self.backView addSubview:self.compareView4];
    [self.backView addSubview:self.compareView5];
    [self.backView addSubview:self.compareView6];
    
    
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12.5);
        make.right.mas_equalTo(-12.5);
        make.height.mas_equalTo(280);
        make.top.equalTo(self);
    }];
    self.backView.layer.cornerRadius = 13;
     
    
    [self.aIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backView).offset(15);
        make.left.equalTo(self.backView).offset(12.5);
        make.width.height.mas_equalTo(35);
    }];
    [self.aNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backView).offset(16);
        make.left.equalTo(self.aIconImageView.mas_right).offset(6);
    }];
    [self.aRateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.aNameLabel.mas_bottom).offset(2);
        make.left.equalTo(self.aNameLabel.mas_left);
    }];
    
    
    [self.hIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backView).offset(15);
        make.right.equalTo(self.backView).offset(-12.5);
        make.width.height.mas_equalTo(35);
    }];
    [self.hNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backView).offset(16);
        make.right.equalTo(self.hIconImageView.mas_left).offset(-6);
    }];
    [self.hRateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.hNameLabel.mas_bottom).offset(2);
        make.right.equalTo(self.hNameLabel.mas_right);
    }];
    
}

- (UIView *)backView {
   if (!_backView) {
       _backView = [[UIView alloc] init];
       _backView.backgroundColor = UIColor.whiteColor;
   }
   return _backView;
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
- (UILabel *)aRateLabel {
    if (!_aRateLabel) {
        _aRateLabel = [[UILabel alloc] init];
        _aRateLabel.font = [UIFont systemFontOfSize:11];
        _aRateLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    }
    return _aRateLabel;
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
- (UILabel *)hRateLabel {
    if (!_hRateLabel) {
        _hRateLabel = [[UILabel alloc] init];
        _hRateLabel.font = [UIFont systemFontOfSize:11];
        _hRateLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    }
    return _hRateLabel;
}

- (SNTeamCompareView *)compareView1 {
    if (!_compareView1) {
        _compareView1 = [[SNTeamCompareView alloc] initWithFrame:CGRectMake(0, compareY, compareW, compareH)];
        _compareView1.leftLabel.textColor = Blue_Color;
        _compareView1.rightLabel.textColor = Origin_Color;
        _compareView1.centerLabel.text = @"排名";
    }
    return _compareView1;
}

- (SNTeamCompareView *)compareView2 {
    if (!_compareView2) {
        _compareView2 = [[SNTeamCompareView alloc] initWithFrame:CGRectMake(0, compareH+compareY, compareW, compareH)];
        _compareView2.leftLabel.textColor = Blue_Color;
        _compareView2.rightLabel.textColor = Origin_Color;
        _compareView2.centerLabel.text = @"胜率";
    }
    return _compareView2;
}

- (SNTeamCompareView *)compareView3 {
    if (!_compareView3) {
        _compareView3 = [[SNTeamCompareView alloc] initWithFrame:CGRectMake(0, compareH*2+compareY, compareW, compareH)];
        _compareView3.leftLabel.textColor = Blue_Color;
        _compareView3.rightLabel.textColor = Origin_Color;
        _compareView3.centerLabel.text = @"连续战绩";
    }
    return _compareView3;
}

- (SNTeamCompareView *)compareView4 {
    if (!_compareView4) {
        _compareView4 = [[SNTeamCompareView alloc] initWithFrame:CGRectMake(0, compareH*3+compareY, compareW, compareH)];
        _compareView4.leftLabel.textColor = Blue_Color;
        _compareView4.rightLabel.textColor = Origin_Color;
        _compareView4.centerLabel.text = @"近10场战绩";
    }
    return _compareView4;
}

- (SNTeamCompareView *)compareView5 {
    if (!_compareView5) {
        _compareView5 = [[SNTeamCompareView alloc] initWithFrame:CGRectMake(0, compareH*4+compareY, compareW, compareH)];
        _compareView5.leftLabel.textColor = Blue_Color;
        _compareView5.rightLabel.textColor = Origin_Color;
        _compareView5.centerLabel.text = @"主场战绩";
    }
    return _compareView5;
}

- (SNTeamCompareView *)compareView6 {
    if (!_compareView6) {
        _compareView6 = [[SNTeamCompareView alloc] initWithFrame:CGRectMake(0, compareH*5+compareY, compareW, compareH)];
        _compareView6.leftLabel.textColor = Blue_Color;
        _compareView6.rightLabel.textColor = Origin_Color;
        _compareView6.centerLabel.text = @"客场战绩";
    }
    return _compareView6;
}


@end


@interface SNTeamCompareView ()
 

@end

@implementation SNTeamCompareView

#pragma mark -- intialization 初始化
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColor.clearColor;
        [self setupSubviews];
    }
    return self;
}
  
- (void)setupSubviews {
    
    [self addSubview:self.leftLabel];
    [self addSubview:self.centerLabel];
    [self addSubview:self.rightLabel];
    
    [self.centerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self); 
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


@end



