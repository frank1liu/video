//
//  SNTeamRankCell.m
//  SportNews
//
//  Created by 根哥 on 2021/3/10.
//

#import "SNTeamRankCell.h"

@interface SNTeamRankCell()
@property (nonatomic, strong) UILabel           *rankLabel;
@property (nonatomic, strong) UIImageView       *teamIcon;
@property (nonatomic, strong) UILabel           *teamNameLabel;
@property (nonatomic, strong) UILabel           *victoryDefeatLabel; //胜负label
@property (nonatomic, strong) UILabel           *shenglvLabel; //胜率label

@property (nonatomic, strong) UILabel           *recentLabel; //近况label

@end

@implementation SNTeamRankCell

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
    [self.contentView addSubview:self.recentLabel];
    
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
        make.left.mas_equalTo(118.5);
        
    }];
    
    [self.shenglvLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.mas_equalTo(166);
        
    }];
    
    [self.recentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.mas_equalTo(-8.5);
        
    }];
    
    
}

- (void)configureModelData:(SNExampleBaseModel *)model{
    self.rankLabel.text = [NSString stringWithFormat:@"%ld",model.indexPath.row + 1];
    self.teamNameLabel.text = model.team_name;
    [self.teamIcon sd_setImageWithURL:[NSURL URLWithString:model.team_logo]];
    self.victoryDefeatLabel.text = model.win_lose;
    self.shenglvLabel.text = model.win_rate;
    self.recentLabel.text = model.jinkuang;

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
        _shenglvLabel.text = @"64.5%/0.0";
        _shenglvLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _shenglvLabel;
    
}

- (UILabel *)recentLabel{
    if (!_recentLabel) {
        _recentLabel = [[UILabel alloc]init];
        _recentLabel.textColor = RGB(51, 51, 51);
        _recentLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        _recentLabel.text = @"3连胜";
        _recentLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _recentLabel;
    
}

@end
