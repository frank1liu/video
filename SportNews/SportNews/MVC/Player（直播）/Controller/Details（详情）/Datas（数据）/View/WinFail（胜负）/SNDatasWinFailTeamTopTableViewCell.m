//
//  SNDatasWinFailTeamTopTableViewCell.m
//  SportNews
//
//  Created by kkk on 2021/2/3.
//

#import "SNDatasWinFailTeamTopTableViewCell.h"
#import "SNDatasButtonView.h"

@interface SNDatasWinFailTeamTopTableViewCell ()

@property(nonatomic, strong) UIImageView *hIconImageView;

@property(nonatomic, strong) UILabel *hNameLabel;

@property(nonatomic, strong) UIImageView *aIconImageView;

@property(nonatomic, strong) UILabel *aNameLabel;

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UIView *backView;

@property(nonatomic, strong) SNDatasButtonView *buttonView;

//同主队
@property(nonatomic, strong) UIButton *tongZhuBtn;
//同赛事
@property(nonatomic, strong) UIButton *tongSaiBtn;

//主
@property (nonatomic, strong) UILabel *Label1;
//客
@property (nonatomic, strong) UILabel *Label2;
//总
@property (nonatomic, strong) UILabel *Label3;
//全场
@property (nonatomic, strong) UILabel *Label4;
//主
@property (nonatomic, strong) UILabel *Label5;
//客
@property (nonatomic, strong) UILabel *Label6;
//总
@property (nonatomic, strong) UILabel *Label7;

@end

@implementation SNDatasWinFailTeamTopTableViewCell


#pragma mark -- initialization 初始化
+ (instancetype)cellWithTableView:(UITableView *)tableView {
    
    static NSString *ID = @"SNDatasWinFailTeamTopTableViewCell";
    SNDatasWinFailTeamTopTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[SNDatasWinFailTeamTopTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
    
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        // 添加子控件
        self.backgroundColor = UIColor.clearColor;
        self.selectionStyle = 0;
        [self setupSubviews];
    }
    return self;
}


- (void)cellIsTopOne:(BOOL)isTop {
    self.backView.backgroundColor = isTop? UIColor.clearColor:UIColor.whiteColor;
    [self.buttonView leftText:@"10场" rightText:@"20场"];
    [self.buttonView setupCoverBtn:NO];
}

//是不是篮球的胜分差
- (void)basketWinFail:(BOOL)isWF {
    self.tongSaiBtn.hidden = isWF;
//    self.buttonView.hidden = !isWF;
    self.buttonView.hidden = YES;
    [self.buttonView leftText:@"胜" rightText:@"负"];
}

- (void)setModel:(LiveListModel *)model {
    _model = model;
    self.hNameLabel.text = model.ateam_name;
    [self.hIconImageView sd_setImageWithURL:[NSURL URLWithString:model.ateam_logo] placeholderImage:UIImageMake(@"默认头像")];
    self.aNameLabel.text = model.hteam_name;
    [self.aIconImageView sd_setImageWithURL:[NSURL URLWithString:model.hteam_logo] placeholderImage:UIImageMake(@"默认头像")];
     
}

//是否勾选了按钮
- (void)isCellSelectButton:(BOOL)isSelect {
    [self.buttonView setupCoverBtn:isSelect];
}

//是否勾选了同主客
- (void)isCellTongZhuKe:(BOOL)isSelect {
    self.tongZhuBtn.selected = isSelect;
}

//是否勾选了同赛事
- (void)isCellTongSaiShi:(BOOL)isSelect {
    self.tongSaiBtn.selected = isSelect;
}

- (void)setType:(NSInteger)type {
    _type = type;
    self.buttonView.hidden = self.type == 0? YES:NO;
}

- (void)tongZhuBtnAction:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    if (self.clickTongZhuKe) {
        self.clickTongZhuKe(sender.isSelected);
    }
}

- (void)tongSaiBtnAction:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    if (self.clickTongSaiShi) {
        self.clickTongSaiShi(sender.isSelected);
    }
}

- (void)setupSubviews {
    
    [self.contentView addSubview:self.bgView];
    [self.contentView addSubview:self.backView];
    
    [self.backView addSubview:self.buttonView];
    [self.backView addSubview:self.tongZhuBtn];
    [self.backView addSubview:self.tongSaiBtn];
    
    [self.backView addSubview:self.hIconImageView];
    [self.backView addSubview:self.hNameLabel];
    [self.backView addSubview:self.aIconImageView];
    [self.backView addSubview:self.aNameLabel];
    
    [self.backView addSubview:self.Label1];
    [self.backView addSubview:self.Label2];
    [self.backView addSubview:self.Label3];
    [self.backView addSubview:self.Label4];
    [self.backView addSubview:self.Label5];
    [self.backView addSubview:self.Label6];
    [self.backView addSubview:self.Label7];
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.left.equalTo(self).offset(12.5);
        make.right.equalTo(self).offset(-12.5);
    }];
    
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.left.equalTo(self).offset(12.5);
        make.right.equalTo(self).offset(-12.5);
    }];
    
    [self.tongZhuBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backView).offset(6.5);
        make.left.equalTo(self.backView).offset(12);
        make.height.mas_equalTo(40);
    }];
    
    [self.tongSaiBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.tongZhuBtn.mas_centerY);
        make.left.equalTo(self.tongZhuBtn.mas_right).offset(10);
        make.height.mas_equalTo(40);
    }];
    
    [self.buttonView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.tongZhuBtn.mas_centerY);
        make.right.equalTo(self.backView).offset(-12.5);
        make.width.mas_equalTo(78);
        make.height.mas_equalTo(22.5);
    }];
    
   [self.hIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
       make.top.equalTo(self.tongZhuBtn.mas_bottom).offset(2);
       make.left.equalTo(self.backView).offset(12.5);
       make.width.height.mas_equalTo(19);
   }];
    
    [self.hNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.hIconImageView.mas_right).offset(4);
        make.centerY.equalTo(self.hIconImageView.mas_centerY);
    }];
    
   [self.aIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
       make.centerY.equalTo(self.hIconImageView.mas_centerY);
       make.right.equalTo(self.backView).offset(-12.5);
       make.width.height.mas_equalTo(19);
   }];
    
    [self.aNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.aIconImageView.mas_left).offset(-4);
        make.centerY.equalTo(self.aIconImageView.mas_centerY);
    }];
    
    [self.Label4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.backView.mas_centerX);
        make.bottom.equalTo(self.backView).offset(-16);
        make.width.mas_equalTo(50);
    }];
    
    CGFloat width = (kScreenWidth -45 -50)/6;
    [self.Label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.backView).offset(10);
        make.centerY.equalTo(self.Label4);
        make.width.mas_equalTo(width);
    }];
    [self.Label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.Label1.mas_right);
        make.centerY.equalTo(self.Label4);
        make.width.mas_equalTo(width);
    }];
    [self.Label3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.Label2.mas_right);
        make.centerY.equalTo(self.Label4);
        make.width.mas_equalTo(width);
    }];
    
    [self.Label5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.Label4.mas_right);
        make.centerY.equalTo(self.Label4);
        make.width.mas_equalTo(width);
    }];
    [self.Label6 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.Label5.mas_right);
        make.centerY.equalTo(self.Label4);
        make.width.mas_equalTo(width);
    }];
    [self.Label7 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.Label6.mas_right);
        make.centerY.equalTo(self.Label4);
        make.width.mas_equalTo(width);
    }];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.bgView addRoundedCorners:UIRectCornerTopLeft| UIRectCornerTopRight withRadii:CGSizeMake(13, 13)];
}


- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = UIColor.whiteColor;
    }
    return _bgView;
}

- (UIView *)backView {
    if (!_backView) {
        _backView = [[UIView alloc] init];
        _backView.backgroundColor = SRGB(248);
    }
    return _backView;
}


- (UIImageView *)hIconImageView {
    if (!_hIconImageView) {
        _hIconImageView = [[UIImageView alloc] init];
    }
    return _hIconImageView;
}

- (UILabel *)hNameLabel {
    if (!_hNameLabel) {
        _hNameLabel = [[UILabel alloc] init];
        _hNameLabel.font = [UIFont systemFontOfSize:11];
        _hNameLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    }
    return _hNameLabel;
}
  
- (UIImageView *)aIconImageView {
    if (!_aIconImageView) {
        _aIconImageView = [[UIImageView alloc] init];
    }
    return _aIconImageView;
}

- (UILabel *)aNameLabel {
    if (!_aNameLabel) {
        _aNameLabel = [[UILabel alloc] init];
        _aNameLabel.font = [UIFont systemFontOfSize:11];
        _aNameLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    }
    return _aNameLabel;
}

- (UIButton *)tongZhuBtn {
    if (!_tongZhuBtn) {
        _tongZhuBtn = [[UIButton alloc] init];
        [_tongZhuBtn setTitle:@" 同主客" forState:UIControlStateNormal];
        [_tongZhuBtn setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
        _tongZhuBtn.titleLabel.font = [UIFont systemFontOfSize:11];
        [_tongZhuBtn setImage:[UIImage imageNamed:@"未选"] forState:UIControlStateNormal];
        [_tongZhuBtn setImage:[UIImage imageNamed:@"选择"] forState:UIControlStateSelected];
        [_tongZhuBtn addTarget:self action:@selector(tongZhuBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _tongZhuBtn;
}

- (UIButton *)tongSaiBtn {
    if (!_tongSaiBtn) {
        _tongSaiBtn = [[UIButton alloc] init];
        [_tongSaiBtn setTitle:@" 同赛事" forState:UIControlStateNormal];
        [_tongSaiBtn setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
        _tongSaiBtn.titleLabel.font = [UIFont systemFontOfSize:11];
        [_tongSaiBtn setImage:[UIImage imageNamed:@"未选"] forState:UIControlStateNormal];
        [_tongSaiBtn setImage:[UIImage imageNamed:@"选择"] forState:UIControlStateSelected];
        [_tongSaiBtn addTarget:self action:@selector(tongSaiBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _tongSaiBtn;
}

- (SNDatasButtonView *)buttonView {
    if (!_buttonView) {
        _buttonView = [[SNDatasButtonView alloc] initWithFrame:CGRectMake(0, 0, 78, 22.5)];
        WeakSelf
        _buttonView.selectBlock = ^(BOOL isSelect) {
            if (weakSelf.clickButtonView) {
                weakSelf.clickButtonView(isSelect);
            } 
        };
    }
    return _buttonView;
}

- (void)reloadTitle:(NSArray *)arr {
    NSInteger h1 = 0;
    NSInteger h2 = 0;
    NSInteger h3 = 0;
    NSInteger a1 = 0;
    NSInteger a2 = 0;
    NSInteger a3 = 0;
    for (NSArray *content in arr) {
        if (content.count > 6) {
            h1 += ((NSNumber *)content[0]).integerValue;
            h2 += ((NSNumber *)content[1]).integerValue;
            h3 += ((NSNumber *)content[2]).integerValue;
            a1 += ((NSNumber *)content[4]).integerValue;
            a2 += ((NSNumber *)content[5]).integerValue;
            a3 += ((NSNumber *)content[6]).integerValue;
        }
    }
    self.Label1.text = [NSString stringWithFormat:@"主(%ld)", h1];
    self.Label2.text = [NSString stringWithFormat:@"客(%ld)", h2];
    self.Label3.text = [NSString stringWithFormat:@"总(%ld)", h3];
    self.Label5.text = [NSString stringWithFormat:@"主(%ld)", a1];
    self.Label6.text = [NSString stringWithFormat:@"客(%ld)", a2];
    self.Label7.text = [NSString stringWithFormat:@"总(%ld)", a3];
}

- (UILabel *)Label1 {
    if (!_Label1) {
        _Label1 = [[UILabel alloc] init];
        _Label1.font = [UIFont systemFontOfSize:12];
        _Label1.textColor = [UIColor colorWithHexString:@"#999999"];
        _Label1.textAlignment = NSTextAlignmentCenter;
        _Label1.text = @"主";
    }
    return _Label1;
}

- (UILabel *)Label2 {
    if (!_Label2) {
        _Label2 = [[UILabel alloc] init];
        _Label2.font = [UIFont systemFontOfSize:12];
        _Label2.textColor = [UIColor colorWithHexString:@"#999999"];
        _Label2.textAlignment = NSTextAlignmentCenter;
        _Label2.text = @"客";
    }
    return _Label2;
}

- (UILabel *)Label3 {
    if (!_Label3) {
        _Label3 = [[UILabel alloc] init];
        _Label3.font = [UIFont systemFontOfSize:12];
        _Label3.textColor = [UIColor colorWithHexString:@"#999999"];
        _Label3.textAlignment = NSTextAlignmentCenter;
        _Label3.text = @"总";
    }
    return _Label3;
}

- (UILabel *)Label4 {
    if (!_Label4) {
        _Label4 = [[UILabel alloc] init];
        _Label4.font = [UIFont systemFontOfSize:12];
        _Label4.textColor = [UIColor colorWithHexString:@"#999999"];
        _Label4.textAlignment = NSTextAlignmentCenter;
        _Label4.text = @"全场";
    }
    return _Label4;
}

- (UILabel *)Label5 {
    if (!_Label5) {
        _Label5 = [[UILabel alloc] init];
        _Label5.font = [UIFont systemFontOfSize:12];
        _Label5.textColor = [UIColor colorWithHexString:@"#999999"];
        _Label5.textAlignment = NSTextAlignmentCenter;
        _Label5.text = @"主";
    }
    return _Label5;
}

- (UILabel *)Label6 {
    if (!_Label6) {
        _Label6 = [[UILabel alloc] init];
        _Label6.font = [UIFont systemFontOfSize:12];
        _Label6.textColor = [UIColor colorWithHexString:@"#999999"];
        _Label6.textAlignment = NSTextAlignmentCenter;
        _Label6.text = @"客";
    }
    return _Label6;
}

- (UILabel *)Label7 {
    if (!_Label7) {
        _Label7 = [[UILabel alloc] init];
        _Label7.font = [UIFont systemFontOfSize:12];
        _Label7.textColor = [UIColor colorWithHexString:@"#999999"];
        _Label7.textAlignment = NSTextAlignmentCenter;
        _Label7.text = @"总";
    }
    return _Label7;
}

@end
