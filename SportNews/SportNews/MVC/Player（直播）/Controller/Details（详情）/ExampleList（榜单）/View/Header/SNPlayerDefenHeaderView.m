//
//  SNPlayerDefenHeaderView.m
//  SportNews
//
//  Created by 根哥 on 2021/3/10.
//

#import "SNPlayerDefenHeaderView.h"


@interface SNPlayerDefenHeaderView()
@property (nonatomic, strong) UILabel           *defenLabel;
@property (nonatomic, strong) UILabel           *victoryDefeatLabel; //胜负label

@property (nonatomic, strong) UILabel           *dataLabel; //近况label

@end

@implementation SNPlayerDefenHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews{
    [self.contentView addSubview:self.defenLabel];
    [self.contentView addSubview:self.victoryDefeatLabel];
    [self.contentView addSubview:self.dataLabel];
    
    self.contentView.backgroundColor = UIColor.whiteColor;
    [self.defenLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.mas_equalTo(12);
        
    }];
    
    [self.victoryDefeatLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.mas_equalTo(-88);

    }];
    
    [self.dataLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.mas_equalTo(-12);
        
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
    self.defenLabel.text = model.name;
    if (model.rankType == SNBasketRankTypePlayer ||
        model.rankType == SNBasketRankTypeDay) {
        self.victoryDefeatLabel.hidden = NO;
        self.victoryDefeatLabel.text = @"球队";
        
    }else if(model.rankType == SNBasketRankTypeInjuries){
        self.victoryDefeatLabel.hidden = NO;
        self.victoryDefeatLabel.text = @"伤停";
        self.dataLabel.text = @"最新进展";
        self.defenLabel.text =  model.team_name;
    }else{
        self.victoryDefeatLabel.hidden = YES;
        self.victoryDefeatLabel.text = @"数据";
    }
    
}

#pragma mark -- getter 懒加载
- (UILabel *)defenLabel{
    if (!_defenLabel) {
        _defenLabel = [[UILabel alloc]init];
        _defenLabel.textColor = RGB(51, 51, 51);
        _defenLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:12];
        _defenLabel.text = @"得分榜";
        _defenLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _defenLabel;
}

- (UILabel *)victoryDefeatLabel{
    if (!_victoryDefeatLabel) {
        _victoryDefeatLabel = [[UILabel alloc]init];
        _victoryDefeatLabel.textColor = RGB(51, 51, 51);
        _victoryDefeatLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:12];
        _victoryDefeatLabel.text = @"胜负";
        _victoryDefeatLabel.textAlignment = NSTextAlignmentCenter;
        _victoryDefeatLabel.hidden = YES;
    }
    return _victoryDefeatLabel;
    
}


- (UILabel *)dataLabel{
    if (!_dataLabel) {
        _dataLabel = [[UILabel alloc]init];
        _dataLabel.textColor = RGB(51, 51, 51);
        _dataLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:12];
        _dataLabel.text = @"数据";
        _dataLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _dataLabel;
    
}@end
