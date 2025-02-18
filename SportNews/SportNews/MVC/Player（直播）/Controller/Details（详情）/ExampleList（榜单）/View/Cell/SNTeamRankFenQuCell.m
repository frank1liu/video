//
//  SNTeamRankFenQuCell.m
//  SportNews
//
//  Created by 根哥 on 2021/3/11.
//

#import "SNTeamRankFenQuCell.h"

@interface SNTeamRankFenQuCell()
@property (nonatomic, strong) UILabel           *rankLabel;
@property (nonatomic, strong) UIImageView       *teamIcon;
@property (nonatomic, strong) UILabel           *teamNameLabel;
@property (nonatomic, strong) UILabel           *victoryDefeatLabel; //胜负label
@property (nonatomic, strong) UILabel           *shenglvLabel; //胜率label

@property (nonatomic, strong) UILabel           *fenquLabel1; //近况label
@property (nonatomic, strong) UILabel           *fenquLabel2; //近况label

@end

@implementation SNTeamRankFenQuCell

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier {
  
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  
  if (self) {
      [self setupSubviews];
  }
  return self;
}

- (void)setupSubviews{
    [self.contentView addSubview:self.rankLabel];
    [self.contentView addSubview:self.teamIcon];
    [self.contentView addSubview:self.teamNameLabel];
    [self.contentView addSubview:self.victoryDefeatLabel];
    
    [self.contentView addSubview:self.shenglvLabel];
    [self.contentView addSubview:self.fenquLabel1];
    [self.contentView addSubview:self.fenquLabel2];

    [self.rankLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.mas_equalTo(10);
        
    }];
    
    [self.teamIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.mas_equalTo(25);
        make.size.mas_equalTo(CGSizeMake(16.8, 16.8));
        
    }];
    
    [self.teamNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.mas_equalTo(47.5);
        
    }];
    
    [self.victoryDefeatLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.mas_equalTo(106);
        
    }];
    
    [self.shenglvLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
//        make.right.equalTo(self.fenquLabel1.mas_left).offset(-25);
        make.left.mas_equalTo(155);

    }];
    
    [self.fenquLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.mas_equalTo(-66);
    }];
    
    [self.fenquLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.mas_equalTo(-9.5);
        
    }];
    
    
}

- (void)configureModelData:(SNExampleBaseModel *)model{
    self.rankLabel.text = [NSString stringWithFormat:@"%ld",model.indexPath.row + 1];
    self.teamNameLabel.text = model.team_name;
    [self.teamIcon sd_setImageWithURL:[NSURL URLWithString:model.team_logo]];
    
    self.victoryDefeatLabel.text = model.win_lose;
    self.shenglvLabel.text = model.win_cha;
    self.fenquLabel1.text = model.conference;
    self.fenquLabel2.text = model.division;

//    self.teamNameLabel.text = model.teamName;
//    [self.teamIcon sd_setImageWithURL:[NSURL URLWithString:model.teamIcon]];
    
}
#pragma mark -- getter 懒加载
- (UIImageView *)teamIcon{
    if (!_teamIcon) {
        _teamIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"默认头像"]];
    }
    return _teamIcon;
}


- (UILabel *)rankLabel{
    if (!_rankLabel) {
        _rankLabel = [[UILabel alloc]init];
        _rankLabel.textColor = RGB(51, 51, 51);
        _rankLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        _rankLabel.text = @"1";
        _rankLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _rankLabel;
}
- (UILabel *)teamNameLabel{
    if (!_teamNameLabel) {
        _teamNameLabel = [[UILabel alloc]init];
        _teamNameLabel.textColor = RGB(51, 51, 51);
        _teamNameLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        _teamNameLabel.text = @"火箭";

    }
    return _teamNameLabel;
}

- (UILabel *)victoryDefeatLabel{
    if (!_victoryDefeatLabel) {
        _victoryDefeatLabel = [[UILabel alloc]init];
        _victoryDefeatLabel.textColor = RGB(51, 51, 51);
        _victoryDefeatLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        _victoryDefeatLabel.text = @"20-11";
        _victoryDefeatLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _victoryDefeatLabel;
    
}

- (UILabel *)shenglvLabel{
    if (!_shenglvLabel) {
        _shenglvLabel = [[UILabel alloc]init];
        _shenglvLabel.textColor = RGB(51, 51, 51);
        _shenglvLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        _shenglvLabel.text = @"6.0";
        _shenglvLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _shenglvLabel;
    
}

- (UILabel *)fenquLabel1{
    if (!_fenquLabel1) {
        _fenquLabel1 = [[UILabel alloc]init];
        _fenquLabel1.textColor = RGB(51, 51, 51);
        _fenquLabel1.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        _fenquLabel1.text = @"12-14";
        _fenquLabel1.textAlignment = NSTextAlignmentCenter;
    }
    return _fenquLabel1;
    
}

- (UILabel *)fenquLabel2{
    if (!_fenquLabel2) {
        _fenquLabel2 = [[UILabel alloc]init];
        _fenquLabel2.textColor = RGB(51, 51, 51);
        _fenquLabel2.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        _fenquLabel2.text = @"11-8";
        _fenquLabel2.textAlignment = NSTextAlignmentCenter;
    }
    return _fenquLabel2;
    
}
@end
