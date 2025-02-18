//
//  SNDatasHistoryTeamTopTableViewCell.m
//  SportNews
//
//  Created by kkk on 2021/2/3.
//

#import "SNDatasHistoryTeamTopTableViewCell.h"
#import "SNDatasButtonView.h"

@interface SNDatasHistoryTeamTopTableViewCell ()

@property(nonatomic, strong) UIImageView *iconImageView;

@property(nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UIView *backView;

@property(nonatomic, strong) SNDatasButtonView *buttonView;

//同主队
@property(nonatomic, strong) UIButton *tongZhuBtn;
//同赛事
@property(nonatomic, strong) UIButton *tongSaiBtn;

//日期/赛事
@property (nonatomic, strong) UILabel *Label1;
//主队
@property (nonatomic, strong) UILabel *Label2;
//比分
@property (nonatomic, strong) UILabel *Label3;
//客队
@property (nonatomic, strong) UILabel *Label4;
//让分
@property (nonatomic, strong) UILabel *Label5;
//总分
@property (nonatomic, strong) UILabel *Label6; 

@end

@implementation SNDatasHistoryTeamTopTableViewCell


#pragma mark -- initialization 初始化
+ (instancetype)cellWithTableView:(UITableView *)tableView {
   
   static NSString *ID = @"SNDatasHistoryTeamTopTableViewCell";
    SNDatasHistoryTeamTopTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
   if (cell == nil) {
       cell = [[SNDatasHistoryTeamTopTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
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

- (void)cellIsTopOne:(BOOL)isTop {
   self.backView.backgroundColor = isTop? UIColor.clearColor:UIColor.whiteColor;
//   [self.buttonView leftText:@"全场" rightText:@"半场"];
//   [self.buttonView setupCoverBtn:NO];
}

- (void)setupTeamName:(NSString *)teamName iconImage:(NSString *)iconStr {
   self.nameLabel.text = teamName;
   [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:iconStr] placeholderImage:UIImageMake(@"默认头像")];
}

- (void)setType:(NSInteger)type {
   _type = type;
   self.iconImageView.hidden = self.type == 0? YES:NO;
   self.nameLabel.hidden = self.type == 0? YES:NO;
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
   [self.backView addSubview:self.iconImageView];
   [self.backView addSubview:self.nameLabel];
   [self.backView addSubview:self.buttonView];
   [self.backView addSubview:self.tongZhuBtn];
   [self.backView addSubview:self.tongSaiBtn];
   [self.backView addSubview:self.Label1];
   [self.backView addSubview:self.Label2];
   [self.backView addSubview:self.Label3];
   [self.backView addSubview:self.Label4];
   [self.backView addSubview:self.Label5];
   [self.backView addSubview:self.Label6];
   
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
   
   [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
       make.top.left.equalTo(self.backView).offset(12);
       make.width.height.mas_equalTo(19);
   }];
   
   [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       make.left.equalTo(self.iconImageView.mas_right).offset(4);
       make.centerY.equalTo(self.iconImageView.mas_centerY);
   }];
   
   [self.Label1 mas_makeConstraints:^(MASConstraintMaker *make) {
       make.bottom.equalTo(self.backView).offset(-16);
       make.left.equalTo(self.backView).offset(15.5);
       make.width.mas_equalTo(62);
   }];
   
   [self.tongZhuBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       make.bottom.equalTo(self.Label1.mas_top).offset(-10);
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
   
   [self.Label3 mas_makeConstraints:^(MASConstraintMaker *make) {
       make.centerY.equalTo(self.Label1.mas_centerY);
       make.centerX.equalTo(self.backView.mas_centerX).offset(-15);
       make.width.mas_equalTo(48);
   }];
   
   [self.Label2 mas_makeConstraints:^(MASConstraintMaker *make) {
       make.centerY.equalTo(self.Label1.mas_centerY);
       make.right.equalTo(self.Label3.mas_left).offset(-7.5);
       make.left.greaterThanOrEqualTo(self.Label1.mas_right).offset(7.5);
   }];
    
   
   [self.Label6 mas_makeConstraints:^(MASConstraintMaker *make) {
       make.centerY.equalTo(self.Label1.mas_centerY);
       make.right.equalTo(self.backView).offset(-20);
       make.width.mas_equalTo(28);
   }];
   
   [self.Label5 mas_makeConstraints:^(MASConstraintMaker *make) {
       make.centerY.equalTo(self.Label1.mas_centerY);
       make.right.equalTo(self.Label6.mas_left).offset(-15);
       make.width.mas_equalTo(35);
   }];
    
   [self.Label4 mas_makeConstraints:^(MASConstraintMaker *make) {
       make.centerY.equalTo(self.Label1.mas_centerY);
       make.left.equalTo(self.Label3.mas_right).offset(7.5);
       make.right.greaterThanOrEqualTo(self.Label5.mas_left).offset(-7.5);
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

- (UIImageView *)iconImageView {
   if (!_iconImageView) {
       _iconImageView = [[UIImageView alloc] init];
   }
   return _iconImageView;
}

- (UILabel *)nameLabel {
   if (!_nameLabel) {
       _nameLabel = [[UILabel alloc] init];
       _nameLabel.font = [UIFont systemFontOfSize:12];
       _nameLabel.textColor = [UIColor colorWithHexString:@"#333333"];
   }
   return _nameLabel;
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
       _buttonView.hidden = YES;
       WeakSelf
       _buttonView.selectBlock = ^(BOOL isSelect) {
           if (weakSelf.clickButtonView) {
               weakSelf.clickButtonView(isSelect);
           }
       };
   }
   return _buttonView;
}

- (UILabel *)Label1 {
   if (!_Label1) {
       _Label1 = [[UILabel alloc] init];
       _Label1.font = [UIFont systemFontOfSize:12];
       _Label1.textColor = [UIColor colorWithHexString:@"#999999"];
       _Label1.text = @"日期/赛事";
   }
   return _Label1;
}

- (UILabel *)Label2 {
   if (!_Label2) {
       _Label2 = [[UILabel alloc] init];
       _Label2.font = [UIFont systemFontOfSize:12];
       _Label2.textColor = [UIColor colorWithHexString:@"#999999"];
       _Label2.text = @"主队";
   }
   return _Label2;
}

- (UILabel *)Label3 {
   if (!_Label3) {
       _Label3 = [[UILabel alloc] init];
       _Label3.font = [UIFont systemFontOfSize:12];
       _Label3.textColor = [UIColor colorWithHexString:@"#999999"];
       _Label3.textAlignment = NSTextAlignmentCenter;
       _Label3.text = @"比分";
   }
   return _Label3;
}

- (UILabel *)Label4 {
   if (!_Label4) {
       _Label4 = [[UILabel alloc] init];
       _Label4.font = [UIFont systemFontOfSize:12];
       _Label4.textColor = [UIColor colorWithHexString:@"#999999"];
       _Label4.text = @"客队";
   }
   return _Label4;
}

- (UILabel *)Label5 {
   if (!_Label5) {
       _Label5 = [[UILabel alloc] init];
       _Label5.font = [UIFont systemFontOfSize:12];
       _Label5.textColor = [UIColor colorWithHexString:@"#999999"];
       _Label5.textAlignment = NSTextAlignmentCenter;
       _Label5.text = @"让分";
   }
   return _Label5;
}

- (UILabel *)Label6 {
   if (!_Label6) {
       _Label6 = [[UILabel alloc] init];
       _Label6.font = [UIFont systemFontOfSize:12];
       _Label6.textColor = [UIColor colorWithHexString:@"#999999"];
       _Label6.textAlignment = NSTextAlignmentCenter;
       _Label6.text = @"总分";
   }
   return _Label6;
}

 

@end
