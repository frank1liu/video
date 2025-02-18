//
//  SNFenQuRankHeaderView.m
//  SportNews
//
//  Created by 根哥 on 2021/3/10.
//

#import "SNFenQuRankHeaderView.h"

@interface SNFenQuRankHeaderView()
@property (nonatomic, strong) UILabel           *rankLabel;
@property (nonatomic, strong) UILabel           *victoryDefeatLabel; //胜负label
@property (nonatomic, strong) UILabel           *shenglvLabel; //胜率label

@property (nonatomic, strong) UILabel           *fenquVictoryLabel; //近况label
@property (nonatomic, strong) UILabel           *fenquVictoryLabel1; //近况label

@end

@implementation SNFenQuRankHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews{
    [self.contentView addSubview:self.rankLabel];
    [self.contentView addSubview:self.victoryDefeatLabel];
    
    [self.contentView addSubview:self.shenglvLabel];
    [self.contentView addSubview:self.fenquVictoryLabel];
    [self.contentView addSubview:self.fenquVictoryLabel1];

    self.contentView.backgroundColor = UIColor.whiteColor;
    
    [self.rankLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.mas_equalTo(12);
        
    }];
    
    [self.victoryDefeatLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.mas_equalTo(106);
        
    }];
    
    [self.shenglvLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView); 
        make.left.mas_equalTo(150);
    }];
    
    [self.fenquVictoryLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.mas_equalTo(-66);
        
    }];
    [self.fenquVictoryLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.mas_equalTo(-9.5);
        
    }];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor colorWithHexString:@"#979797"];
    lineView.alpha = 0.1;
    [self.contentView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.contentView);
        make.height.mas_equalTo(0.5);
    }];
    
}

- (void)setModel:(SNBasketTeamRankResult *)model{
    self.rankLabel.text = model.tagName;
    
}
#pragma mark -- getter 懒加载
- (UILabel *)rankLabel{
    if (!_rankLabel) {
        _rankLabel = [[UILabel alloc]init];
        _rankLabel.textColor = RGB(51, 51, 51);
        _rankLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:12];
        _rankLabel.text = @"东部排行";
        _rankLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _rankLabel;
}

- (UILabel *)victoryDefeatLabel{
    if (!_victoryDefeatLabel) {
        _victoryDefeatLabel = [[UILabel alloc]init];
        _victoryDefeatLabel.textColor = RGB(51, 51, 51);
        _victoryDefeatLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:12];
        _victoryDefeatLabel.text = @"胜负";
        _victoryDefeatLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _victoryDefeatLabel;
    
}

- (UILabel *)shenglvLabel{
    if (!_shenglvLabel) {
        _shenglvLabel = [[UILabel alloc]init];
        _shenglvLabel.textColor = RGB(51, 51, 51);
        _shenglvLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:12];
        _shenglvLabel.text = @"胜差";
        _shenglvLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _shenglvLabel;
    
}

- (UILabel *)fenquVictoryLabel{
    if (!_fenquVictoryLabel) {
        _fenquVictoryLabel = [[UILabel alloc]init];
        _fenquVictoryLabel.textColor = RGB(51, 51, 51);
        _fenquVictoryLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:12];
        _fenquVictoryLabel.text = @"分区\n胜-负";
        _fenquVictoryLabel.numberOfLines = 2;
        _fenquVictoryLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _fenquVictoryLabel;
    
}

- (UILabel *)fenquVictoryLabel1{
    if (!_fenquVictoryLabel1) {
        _fenquVictoryLabel1 = [[UILabel alloc]init];
        _fenquVictoryLabel1.textColor = RGB(51, 51, 51);
        _fenquVictoryLabel1.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:12];
        _fenquVictoryLabel1.text = @"分区\n胜-负";
        _fenquVictoryLabel1.numberOfLines = 2;
        _fenquVictoryLabel1.textAlignment = NSTextAlignmentCenter;
    }
    return _fenquVictoryLabel1;
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
