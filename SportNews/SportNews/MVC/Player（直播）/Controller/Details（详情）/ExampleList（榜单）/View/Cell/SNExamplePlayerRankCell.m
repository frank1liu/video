//
//  SNExamplePlayerRankCell.m
//  SportNews
//
//  Created by 根哥 on 2021/3/10.
//

#import "SNExamplePlayerRankCell.h"

@interface SNExamplePlayerRankCell()
@property (nonatomic, strong) UILabel           *rankLabel;
@property (nonatomic, strong) UIImageView       *avatar;
@property (nonatomic, strong) UILabel           *playerNameLabel;
@property (nonatomic, strong) UILabel           *teamNameLabel; //胜负label
@property (nonatomic, strong) UILabel           *scoreLabel; //球队label

@property (nonatomic, strong) UILabel           *dataLabel; //数据label

@end

@implementation SNExamplePlayerRankCell

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
    [self.contentView addSubview:self.avatar];
    [self.contentView addSubview:self.playerNameLabel];
    [self.contentView addSubview:self.teamNameLabel];
    
    [self.contentView addSubview:self.scoreLabel];
    [self.contentView addSubview:self.dataLabel];
    
    [self.rankLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.mas_equalTo(10);
        
    }];
    
    [self.avatar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.mas_equalTo(25);
        make.size.mas_equalTo(CGSizeMake(30, 30));
        
    }];
    
    [self.playerNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.avatar);
        make.left.equalTo(self.avatar.mas_right).offset(5);
        
    }];
    
    
    [self.scoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.playerNameLabel.mas_bottom);
        make.left.equalTo(self.playerNameLabel);
    
    }];
    
    [self.teamNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.mas_equalTo(-86);
        make.width.mas_equalTo(60);
    }];
   
    
    [self.dataLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.mas_equalTo(-15);
        
    }];
    
    
}

- (void)configureModelData:(SNExampleBaseModel *)model{
    if (model.rankType == SNBasketRankTypePlayer ||
        model.rankType == SNBasketRankTypeDay) {
        self.rankLabel.text = [NSString stringWithFormat:@"%ld",model.indexPath.row + 1];
        self.playerNameLabel.text  = model.player_name;
        self.teamNameLabel.text = model.team_name;
        self.scoreLabel.text = [NSString stringWithFormat:@"%@分 %@板 %@助",[CommonTools decimalNumberWithDouble:[model.fen doubleValue]], [CommonTools decimalNumberWithDouble:[model.ban doubleValue]], [CommonTools decimalNumberWithDouble:[model.zhu doubleValue]]];
        
        [self.avatar sd_setImageWithURL:[NSURL URLWithString:model.player_logo]];
        self.dataLabel.text = [NSString stringWithFormat:@"%@", [CommonTools decimalNumberWithDouble:[model.data doubleValue]]];
        [self.avatar mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.left.mas_equalTo(25);
            make.size.mas_equalTo(CGSizeMake(30, 30));
            
        }];
        self.rankLabel.hidden = NO;
        
    }else{
        self.playerNameLabel.text  = model.name_zh;
        self.scoreLabel.text = model.team_name;

        [self.avatar sd_setImageWithURL:[NSURL URLWithString:model.logo]];
        self.teamNameLabel.text = model.reason;

        self.dataLabel.text = model.typeString;
        self.rankLabel.hidden = YES;
        [self.avatar mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.left.mas_equalTo(15);
            make.size.mas_equalTo(CGSizeMake(30, 30));
            
        }];
    }
    
    
}
#pragma mark -- getter 懒加载
- (UIImageView *)avatar{
    if (!_avatar) {
        _avatar = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"默认头像"]];
        _avatar.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _avatar;
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
- (UILabel *)playerNameLabel{
    if (!_playerNameLabel) {
        _playerNameLabel = [[UILabel alloc]init];
        _playerNameLabel.textColor = RGB(51, 51, 51);
        _playerNameLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        _playerNameLabel.text = @"莫拉塔";

    }
    return _playerNameLabel;
}

- (UILabel *)teamNameLabel{
    if (!_teamNameLabel) {
        _teamNameLabel = [[UILabel alloc]init];
        _teamNameLabel.textColor = RGB(51, 51, 51);
        _teamNameLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        _teamNameLabel.text = @"20-11";
        _teamNameLabel.textAlignment = NSTextAlignmentRight;
        _teamNameLabel.numberOfLines = 2;
    }
    return _teamNameLabel;
    
}

- (UILabel *)scoreLabel{
    if (!_scoreLabel) {
        _scoreLabel = [[UILabel alloc]init];
        _scoreLabel.textColor = RGB(153, 153, 153);
        _scoreLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:10];
        _scoreLabel.text = @"32.9分 5.4板 4.8助";
        _scoreLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _scoreLabel;
    
}

- (UILabel *)dataLabel{
    if (!_dataLabel) {
        _dataLabel = [[UILabel alloc]init];
        _dataLabel.textColor = RGB(51, 51, 51);
        _dataLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        _dataLabel.text = @"32";
        _dataLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _dataLabel;
    
}
@end
