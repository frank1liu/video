//
//  SNFirstRoundHeaderView.m
//  SportNews
//
//  Created by 根哥 on 2021/2/19.
//

#import "SNFirstRoundHeaderView.h"

@interface SNFirstRoundHeaderView()
@property (nonatomic, strong) UIImageView       *avatar;
@property (nonatomic, strong) UILabel               *teamNameLabel;
@property (nonatomic, strong) UILabel               *coachLabel;
@property (nonatomic, strong) UILabel               *formationLabel; //阵型

@end
@implementation SNFirstRoundHeaderView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews{
    [self addSubview:self.avatar];
    [self addSubview:self.teamNameLabel];
    [self addSubview:self.coachLabel];
    [self addSubview:self.formationLabel];
    
    [self.avatar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(15);
        make.width.height.mas_equalTo(35);
    }];
    
    [self.teamNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.avatar);
        make.left.equalTo(self.avatar.mas_right).offset(10.5);
    }];
    
    
    [self.coachLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.avatar);
        make.right.equalTo(self).offset(-10.5);
    }];
    
    [self.formationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.coachLabel.mas_bottom).offset(2);
        make.right.equalTo(self.coachLabel);
    }];
}

- (void)setType:(NSInteger)type {
    if (type == 0) {
        self.teamNameLabel.text = self.model.hteam_name;
        [self.avatar sd_setImageWithURL:[NSURL URLWithString:self.model.hteam_logo] placeholderImage:UIImageMake(@"默认头像")];
        self.coachLabel.text =[NSString stringWithFormat:@"教练：%@", self.squadModel.home_manager];
        self.formationLabel.text =[NSString stringWithFormat:@"阵型：%@", self.squadModel.home_formation];
    }else {
        self.teamNameLabel.text = self.model.ateam_name;
        [self.avatar sd_setImageWithURL:[NSURL URLWithString:self.model.ateam_logo] placeholderImage:UIImageMake(@"默认头像")];
        self.coachLabel.text =[NSString stringWithFormat:@"教练：%@", self.squadModel.away_manager];
        self.formationLabel.text =[NSString stringWithFormat:@"阵型：%@", self.squadModel.away_formation];
    }
}

- (UIImageView *)avatar{
    if (!_avatar) {
        _avatar = [[UIImageView alloc]init];
        _avatar.layer.cornerRadius = 17.5;
        _avatar.layer.masksToBounds = YES;
        _avatar.backgroundColor = UIColor.greenColor;
    }
    return _avatar;
}
- (UILabel *)teamNameLabel{
    if (!_teamNameLabel) {
        _teamNameLabel = [[UILabel alloc]init];
        _teamNameLabel.textColor = RGB(51, 51, 55);
        _teamNameLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:12];
        
    }
    return _teamNameLabel;
}

- (UILabel *)coachLabel{
    if (!_coachLabel) {
        _coachLabel = [[UILabel alloc]init];
        _coachLabel.textColor = RGB(51, 51, 51);
        _coachLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        _coachLabel.text = @"教练：";
    }
    return _coachLabel;
    
}

- (UILabel *)formationLabel{
    if (!_formationLabel) {
        _formationLabel = [[UILabel alloc]init];
        _formationLabel.textColor = RGB(102, 102, 102);
        _formationLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        _formationLabel.text = @"阵型：";
    }
    return _formationLabel;
    
}
@end
