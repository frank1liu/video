//
//  SNExampleMoreListCell.m
//  SportNews
//
//  Created by 根哥 on 2021/3/15.
//

#import "SNExampleMoreListCell.h"

@interface SNExampleMoreListCell()
@property (nonatomic, strong) UILabel           *rankLabel;
@property (nonatomic, strong) UIImageView       *teamIcon;
@property (nonatomic, strong) UILabel           *teamNameLabel;

@property (nonatomic, strong) UILabel           *recentLabel; //近况label

@end

@implementation SNExampleMoreListCell

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
    
    [self.contentView addSubview:self.recentLabel];
    
    [self.rankLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self.contentView);
        make.width.mas_equalTo(40);
//        make.left.mas_equalTo(10);
        
    }];
    
    [self.teamIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.rankLabel.mas_right).offset(10);
        make.size.mas_equalTo(CGSizeMake(32, 32));
        
    }];
    
    [self.teamNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.teamIcon.mas_right).offset(10);

    }];
    
    [self.recentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.mas_equalTo(-12);
        
    }];
    
    
}


#pragma mark -- getter 懒加载
- (UIImageView *)teamIcon{
    if (!_teamIcon) {
        _teamIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"信息背景"]];
        _teamIcon.layer.cornerRadius = 16;
        _teamIcon.layer.masksToBounds = YES;
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
        _rankLabel.backgroundColor = [UIColor.lightGrayColor colorWithAlphaComponent:0.39];
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
