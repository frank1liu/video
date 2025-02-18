//
//  SNDatasSimpleHeaderView.m
//  SportNews
//
//  Created by kkk on 2021/2/2.
//

#import "SNDatasSimpleHeaderView.h"

 

@implementation SNDatasSimpleHeaderView

  
#pragma mark -- intialization 初始化
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = SRGB(248);
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews{
    
    UIView *lineView = [[UIView alloc] init];
    [self addSubview:lineView];
    lineView.backgroundColor = Blue_Color;
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(12.5);
        make.centerY.equalTo(self);
        make.width.mas_equalTo(3);
        make.height.mas_equalTo(16);
    }];
    lineView.layer.cornerRadius = 1.5;
    
    
    [self addSubview:self.titleLabel];
    [self addSubview:self.subTitleLabel];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self).offset(19.5);
    }];
    [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self.titleLabel.mas_right).offset(5);
    }];
    
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightSemibold];
        _titleLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        _titleLabel.text = @"进球分布";
    }
    return _titleLabel;
}

- (UILabel *)subTitleLabel {
    if (!_subTitleLabel) {
        _subTitleLabel = [[UILabel alloc] init];
        _subTitleLabel.font = [UIFont systemFontOfSize:11];
        _subTitleLabel.textColor = [UIColor colorWithHexString:@"#999999"];
        _subTitleLabel.text = @"（本赛季同赛事进球分布）";
        _subTitleLabel.hidden = YES;
    }
    return _subTitleLabel;
}

@end
