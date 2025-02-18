//
//  SNStatisticalBottomTableViewCell.m
//  SportNews
//
//  Created by kkk on 2021/1/26.
//

#import "SNStatisticalBottomTableViewCell.h"
#import "SNStatisticalProgressContentView.h"

@interface SNStatisticalBottomTableViewCell ()

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UILabel *centerLabel;
 
@property (nonatomic, strong) UILabel *leftNameLabel;
@property (nonatomic, strong) UIImageView *leftImageView;
 
@property (nonatomic, strong) UILabel *rightNameLabel;
@property (nonatomic, strong) UIImageView *rightImageView;

@property(nonatomic, strong) SNStatisticalProgressContentView *contentView1;
@property(nonatomic, strong) SNStatisticalProgressContentView *contentView2;
@property(nonatomic, strong) SNStatisticalProgressContentView *contentView3;
@property(nonatomic, strong) SNStatisticalProgressContentView *contentView4;
@property(nonatomic, strong) SNStatisticalProgressContentView *contentView5;
@property(nonatomic, strong) SNStatisticalProgressContentView *contentView6;

@end

@implementation SNStatisticalBottomTableViewCell
 
#pragma mark -- initialization 初始化
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = UIColor.clearColor;
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews{
    
    
    [self addSubview:self.bgView];
    
    [self.bgView addSubview:self.centerLabel];
    [self.bgView addSubview:self.leftNameLabel];
    [self.bgView addSubview:self.leftImageView];
    [self.bgView addSubview:self.rightNameLabel];
    [self.bgView addSubview:self.rightImageView];
    
    [self.bgView addSubview:self.contentView1];
    [self.bgView addSubview:self.contentView2];
    [self.bgView addSubview:self.contentView3];
    [self.bgView addSubview:self.contentView4];
    [self.bgView addSubview:self.contentView5];
    [self.bgView addSubview:self.contentView6];
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(self).offset(12.5);
        make.bottom.equalTo(self).offset(-10);
        make.right.equalTo(self).offset(-12.5);
    }];
     
    [self.leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.bgView).offset(15);
        make.width.height.mas_equalTo(35);
    }];
    
    [self.centerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.leftImageView.mas_centerY);
    }];
    
    
    [self.leftNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftImageView.mas_right).offset(10.5);
        make.centerY.equalTo(self.leftImageView.mas_centerY);
        make.right.equalTo(self.centerLabel.mas_left).offset(-2);
    }];
    
    [self.rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgView).offset(15);
        make.right.equalTo(self.bgView).offset(-15);
        make.width.height.mas_equalTo(35);
    }];
    
    [self.rightNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.rightImageView.mas_left).offset(-10.5);
        make.centerY.equalTo(self.rightImageView.mas_centerY);
        make.left.equalTo(self.centerLabel.mas_right).offset(2);
    }];
    
    CGFloat height = 38;
    [self.contentView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.leftImageView.mas_bottom);
        make.left.right.equalTo(self.bgView);
        make.height.mas_offset(height);
    }];
    [self.contentView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView1.mas_bottom);
        make.left.right.equalTo(self.bgView);
        make.height.mas_offset(height);
    }];
    [self.contentView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView2.mas_bottom);
        make.left.right.equalTo(self.bgView);
        make.height.mas_offset(height);
    }];
    [self.contentView4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView3.mas_bottom);
        make.left.right.equalTo(self.bgView);
        make.height.mas_offset(height);
    }];
    [self.contentView5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView4.mas_bottom);
        make.left.right.equalTo(self.bgView);
        make.height.mas_offset(height);
    }];
    [self.contentView6 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView5.mas_bottom);
        make.left.right.equalTo(self.bgView);
        make.height.mas_offset(height);
    }];
    
}

- (void)setModel:(LiveListModel *)model {
    _model = model;
    self.leftNameLabel.text = model.ateam_name;
    self.rightNameLabel.text = model.hteam_name;
    [self.leftImageView sd_setImageWithURL:[NSURL URLWithString:model.ateam_logo] placeholderImage:UIImageMake(@"默认头像") completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
    }];
    [self.rightImageView sd_setImageWithURL:[NSURL URLWithString:model.hteam_logo] placeholderImage:UIImageMake(@"默认头像") completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
    }];
}

- (void)setStatisticalModel:(SNStatisticalModel *)statisticalModel {
    _statisticalModel = statisticalModel;
    SNStatisticalPlayerBottomModel *awayModel = statisticalModel.allDatas.lastObject;
    self.contentView1.leftLabel.text = [NSString stringWithFormat:@"%ld",awayModel.defen];
    self.contentView2.leftLabel.text = [NSString stringWithFormat:@"%ld",awayModel.lanban];
    self.contentView3.leftLabel.text = [NSString stringWithFormat:@"%ld",awayModel.zhugong];
    self.contentView4.leftLabel.text = [NSString stringWithFormat:@"%ld",awayModel.gaimao];
    self.contentView5.leftLabel.text = [NSString stringWithFormat:@"%ld",awayModel.qiangduan];
    self.contentView6.leftLabel.text = [NSString stringWithFormat:@"%ld",awayModel.shiwu];
    
    SNStatisticalPlayerBottomModel *homeModel = statisticalModel.allDatas.firstObject;
    self.contentView1.rightLabel.text = [NSString stringWithFormat:@"%ld",homeModel.defen];
    self.contentView2.rightLabel.text = [NSString stringWithFormat:@"%ld",homeModel.lanban];
    self.contentView3.rightLabel.text = [NSString stringWithFormat:@"%ld",homeModel.zhugong];
    self.contentView4.rightLabel.text = [NSString stringWithFormat:@"%ld",homeModel.gaimao];
    self.contentView5.rightLabel.text = [NSString stringWithFormat:@"%ld",homeModel.qiangduan];
    self.contentView6.rightLabel.text = [NSString stringWithFormat:@"%ld",homeModel.shiwu];
    
    [self.contentView1 leftProgress:awayModel.defen rightProgress:homeModel.defen];
    [self.contentView2 leftProgress:awayModel.lanban rightProgress:homeModel.lanban];
    [self.contentView3 leftProgress:awayModel.zhugong rightProgress:homeModel.zhugong];
    [self.contentView4 leftProgress:awayModel.gaimao rightProgress:homeModel.gaimao];
    [self.contentView5 leftProgress:awayModel.qiangduan rightProgress:homeModel.qiangduan];
    [self.contentView6 leftProgress:awayModel.shiwu rightProgress:homeModel.shiwu];
    
}

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc]initWithFrame:CGRectMake(12.5, 0, kScreenWidth-25, 200)];
        _bgView.backgroundColor = UIColor.whiteColor;
        _bgView.layer.cornerRadius = 13;
        _bgView.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.06].CGColor;
        _bgView.layer.shadowOffset = CGSizeMake(0,5);
        _bgView.layer.shadowOpacity = 0.5;
    }
    return _bgView;
}

- (UILabel *)centerLabel {
    if (!_centerLabel) {
        _centerLabel = [[UILabel alloc]init];
        _centerLabel.font = [UIFont systemFontOfSize:13 weight:UIFontWeightSemibold];
        _centerLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        _centerLabel.text = @"VS";
    }
    return _centerLabel;
}

- (UILabel *)leftNameLabel {
    if (!_leftNameLabel) {
        _leftNameLabel = [[UILabel alloc]init];
        _leftNameLabel.font = [UIFont systemFontOfSize:13 weight:UIFontWeightSemibold];
        _leftNameLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    }
    return _leftNameLabel;
}

- (UIImageView *)leftImageView {
    if (!_leftImageView) {
        _leftImageView = [[UIImageView alloc] init];
    }
    return _leftImageView;
}

- (UILabel *)rightNameLabel {
    if (!_rightNameLabel) {
        _rightNameLabel = [[UILabel alloc]init];
        _rightNameLabel.font = [UIFont systemFontOfSize:13 weight:UIFontWeightSemibold];
        _rightNameLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        _rightNameLabel.textAlignment = NSTextAlignmentRight;
    }
    return _rightNameLabel;
}

- (UIImageView *)rightImageView {
    if (!_rightImageView) {
        _rightImageView = [[UIImageView alloc] init];
    }
    return _rightImageView;
}


- (SNStatisticalProgressContentView *)contentView1 {
    if (!_contentView1) {
        _contentView1 = [[SNStatisticalProgressContentView alloc] initWithFrame:CGRectMake(0, 0, self.width, 30)];
        _contentView1.centerLabel.text = @"得分";
    }
    return _contentView1;
}

- (SNStatisticalProgressContentView *)contentView2 {
    if (!_contentView2) {
        _contentView2 = [[SNStatisticalProgressContentView alloc] initWithFrame:CGRectMake(0, 0, self.width, 30)];
        _contentView2.centerLabel.text = @"篮板";
    }
    return _contentView2;
}

- (SNStatisticalProgressContentView *)contentView3 {
    if (!_contentView3) {
        _contentView3 = [[SNStatisticalProgressContentView alloc] initWithFrame:CGRectMake(0, 0, self.width, 30)];
        _contentView3.centerLabel.text = @"助攻";
    }
    return _contentView3;
}

- (SNStatisticalProgressContentView *)contentView4 {
    if (!_contentView4) {
        _contentView4 = [[SNStatisticalProgressContentView alloc] initWithFrame:CGRectMake(0, 0, self.width, 30)];
        _contentView4.centerLabel.text = @"盖帽";
    }
    return _contentView4;
}

- (SNStatisticalProgressContentView *)contentView5 {
    if (!_contentView5) {
        _contentView5 = [[SNStatisticalProgressContentView alloc] initWithFrame:CGRectMake(0, 0, self.width, 30)];
        _contentView5.centerLabel.text = @"抢断";
    }
    return _contentView5;
}

- (SNStatisticalProgressContentView *)contentView6 {
    if (!_contentView6) {
        _contentView6 = [[SNStatisticalProgressContentView alloc] initWithFrame:CGRectMake(0, 0, self.width, 30)];
        _contentView6.centerLabel.text = @"失误";
    }
    return _contentView6;
}


@end
