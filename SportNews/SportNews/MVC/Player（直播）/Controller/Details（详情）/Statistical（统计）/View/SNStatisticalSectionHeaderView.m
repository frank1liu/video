//
//  SNStatisticalSectionHeaderView.m
//  SportNews
//
//  Created by kkk on 2021/1/27.
//

#import "SNStatisticalSectionHeaderView.h"

@interface SNStatisticalSectionHeaderView ()

@property(nonatomic, strong) UIButton *leftButton;

@property(nonatomic, strong) UIButton *rightButton;

@property(nonatomic, strong) UIButton *lastButton;

@end

@implementation SNStatisticalSectionHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) { 
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    
    UIView *bgBackView = [[UIView alloc] initWithFrame:CGRectMake(12.5, 0, kScreenWidth - 25, 60)];
    bgBackView.backgroundColor = UIColor.whiteColor;
    [bgBackView addRoundedCorners:UIRectCornerTopLeft| UIRectCornerTopRight withRadii:CGSizeMake(13, 13)];
    [self addSubview:bgBackView];
     
    UIView *contentView = [[UIScrollView alloc] init];
    contentView.clipsToBounds = YES;
    [bgBackView addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(bgBackView);
        make.top.mas_equalTo(bgBackView).offset(15);
        make.left.equalTo(bgBackView).offset(12.5);
        make.height.mas_equalTo(35);
    }];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"矩形备份"]];
    [bgBackView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(contentView);
    }];
      
    CGFloat buttonW = (kScreenWidth-50)/2;
    self.leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, buttonW, 35)];
    self.leftButton.tag = 0;
    self.leftButton.layer.cornerRadius = self.leftButton.height/2;
    self.leftButton.backgroundColor = RGBA(39, 197, 195,0.1);
    self.leftButton.titleLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightSemibold];
    [self.leftButton setTitleColor:Blue_Color forState:UIControlStateNormal];
    [self.leftButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:self.leftButton];
    self.lastButton = self.leftButton;
     
    self.rightButton = [[UIButton alloc] initWithFrame:CGRectMake(buttonW, 0, buttonW, 35)];
    self.rightButton.tag = 1;
    self.rightButton.layer.cornerRadius = self.leftButton.height/2;
    self.rightButton.backgroundColor = UIColor.clearColor;
    self.rightButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.rightButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.rightButton setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
    [contentView addSubview:self.rightButton];
    
}
 

- (void)buttonClicked:(UIButton *)sender {
    if (sender.tag == self.lastButton.tag) {
        return;
    }
    self.lastButton.backgroundColor = UIColor.clearColor;
    self.lastButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.lastButton setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
    sender.backgroundColor = RGBA(39, 197, 195,0.1);
    sender.titleLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightSemibold];
    [sender setTitleColor:Blue_Color forState:UIControlStateNormal];
    
    self.lastButton = sender;
    if (self.buttonClickWithTag) {
        self.buttonClickWithTag(sender.tag);
    }
}
 
- (void)setModel:(LiveListModel *)model {
    _model = model;
    [self.leftButton setTitle:model.ateam_name forState:UIControlStateNormal];
    [self.rightButton setTitle:model.hteam_name forState:UIControlStateNormal];
}

@end
