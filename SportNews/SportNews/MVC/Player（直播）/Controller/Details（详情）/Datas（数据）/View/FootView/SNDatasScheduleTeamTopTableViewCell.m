//
//  SNDatasScheduleTeamTopTableViewCell.m
//  SportNews
//
//  Created by kkk on 2021/2/3.
//

#import "SNDatasScheduleTeamTopTableViewCell.h"

@interface SNDatasScheduleTeamTopTableViewCell ()

@property(nonatomic, strong) UIImageView *iconImageView;

@property(nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UIView *backColorView;

@property (nonatomic, strong) UIView *backView;


//日期/赛事
@property (nonatomic, strong) UILabel *Label1;
//主队
@property (nonatomic, strong) UILabel *Label2;
//客队
@property (nonatomic, strong) UILabel *Label3;
//相隔
@property (nonatomic, strong) UILabel *Label4;

@end

@implementation SNDatasScheduleTeamTopTableViewCell

#pragma mark -- initialization 初始化
+ (instancetype)cellWithTableView:(UITableView *)tableView {
    
    static NSString *ID = @"SNDatasScheduleTeamTopTableViewCell";
    SNDatasScheduleTeamTopTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[SNDatasScheduleTeamTopTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID withType:0];
    }
    return cell;
    
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withType:(NSInteger)type {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        // 添加子控件
        self.backgroundColor = UIColor.clearColor;
        self.selectionStyle = 0;
        [self setupSubviews];
    }
    return self;
}


- (void)cellIsTopOne:(BOOL)isTop {
    [self.backColorView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(isTop?13:0);
    }];
}

- (void)setupTeamName:(NSString *)teamName iconImage:(NSString *)iconStr {
    self.nameLabel.text = teamName;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:iconStr] placeholderImage:UIImageMake(@"默认头像")];
}

- (void)setupSubviews {
    
    [self.contentView addSubview:self.bgView];
    [self.contentView addSubview:self.backColorView];
    [self.contentView addSubview:self.backView];
    [self.backView addSubview:self.iconImageView];
    [self.backView addSubview:self.nameLabel];
    [self.backView addSubview:self.Label1];
    [self.backView addSubview:self.Label2];
    [self.backView addSubview:self.Label3];
    [self.backView addSubview:self.Label4];
    
    UIView *lineView = [[UIView alloc] init];
    [self.backView addSubview:lineView];
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.left.equalTo(self).offset(12.5);
        make.right.equalTo(self).offset(-12.5);
    }];
    self.bgView.layer.cornerRadius = 13;
    
    [self.backColorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.left.equalTo(self).offset(12.5);
        make.right.equalTo(self).offset(-12.5);
    }];
    
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.left.equalTo(self).offset(12.5);
        make.right.equalTo(self).offset(-12.5);
    }];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.backView.mas_centerY);
        make.centerX.equalTo(self.backView.mas_centerX).offset(13);
        make.width.mas_equalTo(25);
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
        make.width.mas_equalTo(61);
    }];
    
    [self.Label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.Label1.mas_centerY);
        make.right.equalTo(lineView.mas_left).offset(-5.5);
    }];
    
    [self.Label3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.Label1.mas_centerY);
        make.left.equalTo(lineView.mas_right).offset(5.5);
    }];
    
    [self.Label4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.Label1.mas_centerY);
        make.right.equalTo(self.backView).offset(-20);
        make.width.mas_equalTo(25);
    }];
}

- (void)layoutSubviews {
    [super layoutSubviews];
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
        _backView.backgroundColor = UIColor.clearColor;
    }
    return _backView;
}

- (UIView *)backColorView {
    if (!_backColorView) {
        _backColorView = [[UIView alloc] init];
        _backColorView.backgroundColor = UIColor.whiteColor;
    }
    return _backColorView;
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
        _Label3.text = @"客队";
    }
    return _Label3;
}

- (UILabel *)Label4 {
    if (!_Label4) {
        _Label4 = [[UILabel alloc] init];
        _Label4.font = [UIFont systemFontOfSize:12];
        _Label4.textColor = [UIColor colorWithHexString:@"#999999"];
        _Label4.text = @"相隔";
    }
    return _Label4;
}


@end
