//
//  SNPlayerDefenCell.m
//  SportNews
//
//  Created by 根哥 on 2021/3/10.
//

#import "SNPlayerDefenCell.h"

@interface SNPlayerDefenCell()
@property (nonatomic, strong) UILabel           *rankLabel;
@property (nonatomic, strong) UIImageView       *teamIcon;
@property (nonatomic, strong) UILabel           *teamNameLabel;

@property (nonatomic, strong) UILabel           *dataLabel; //近况label

@end

@implementation SNPlayerDefenCell

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

    [self.contentView addSubview:self.dataLabel];
    
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
    
    [self.dataLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.mas_equalTo(-15);
        
    }];
    
    
}

- (void)configureModelData:(SNExampleBaseModel *)model{
    self.rankLabel.text = [NSString stringWithFormat:@"%ld",model.indexPath.row + 1];
    self.teamNameLabel.text = model.team_name;
    [self.teamIcon sd_setImageWithURL:[NSURL URLWithString:model.team_logo]];
    
    
    self.dataLabel.text = [CommonTools decimalNumberWithDouble:[model.data doubleValue]];
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

- (UILabel *)dataLabel{
    if (!_dataLabel) {
        _dataLabel = [[UILabel alloc]init];
        _dataLabel.textColor = RGB(51, 51, 51);
        _dataLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        _dataLabel.text = @"3连胜";
        _dataLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _dataLabel;
    
}

@end
