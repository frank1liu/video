//
//  SNExampleMoreFooterView.m
//  SportNews
//
//  Created by 根哥 on 2021/3/15.
//

#import "SNExampleMoreFooterView.h"

@interface SNExampleMoreFooterView()
@property (nonatomic, strong) UIButton           *moreButton; //更多按钮
@property (nonatomic, strong) UILabel            *titleLabel;          // 标题label

@end


@implementation SNExampleMoreFooterView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
//        self.backgroundColor = UIColor.whiteColor;
        self.contentView.backgroundColor = UIColor.whiteColor;
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews{
    [self.contentView addSubview:self.moreButton];
    [self.contentView addSubview:self.titleLabel];

    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
    [self.moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(65, 28));
    }];
   
    
    
}

- (void)setModel:(SNBasketTeamRankResult *)model{
    [super setModel:model];
    if (model.rankType == SNBasketRankTypeInjuries && !model.injuryList.count) {
        self.titleLabel.hidden = NO;
        self.moreButton.hidden = YES;
    }else{
        self.titleLabel.hidden = YES;
        self.moreButton.hidden = NO;
    }
}


- (void)clickedMoreButton{
    if (self.clickedMoreBlock) {
        self.clickedMoreBlock(self.model);
    }
}
#pragma mark -- getter 懒加载
- (UIButton *)moreButton{
    if (!_moreButton) {
        _moreButton = [[UIButton alloc]init];
        _moreButton.titleLabel.textColor = RGB(153, 153, 153);
        [_moreButton setTitle:@"查看全部" forState:UIControlStateNormal];
        [_moreButton setTitleColor:RGB(153, 153, 153) forState:UIControlStateNormal];
        [_moreButton setImage:[UIImage imageNamed:@"enter"] forState:UIControlStateNormal];
        _moreButton.imageEdgeInsets = UIEdgeInsetsMake(8, 50, 8, -50);
        _moreButton.titleEdgeInsets = UIEdgeInsetsMake(0, -18, 0, 8);
//        _moreButton.backgroundColor = UIColor.greenColor;
//        _moreButton.imageView.backgroundColor = [UIColor redColor];
        [_moreButton addTarget:self action:@selector(clickedMoreButton) forControlEvents:UIControlEventTouchUpInside];
        _moreButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:12];
    }
    return _moreButton;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        _titleLabel.text = @"暂无伤停球员";
        _titleLabel.textColor = RGB(153, 153, 153);
        _titleLabel.hidden = YES;
    }
    return _titleLabel;
}
@end
