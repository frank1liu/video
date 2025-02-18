//
//  SNDatasFootInjuryTableViewCell.m
//  SportNews
//
//  Created by kkk on 2021/2/6.
//

#import "SNDatasFootInjuryTableViewCell.h"

@interface SNDatasFootInjuryTableViewCell ()

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UIView *backView;

@property(nonatomic, strong) UIImageView *iconImageView;
//球员名字
@property(nonatomic, strong) UILabel *nameLabel;

//球员位置
@property (nonatomic, strong) UILabel *positionLabel;
//原因
@property (nonatomic, strong) UILabel *reasonLabel;

@end

@implementation SNDatasFootInjuryTableViewCell



#pragma mark -- initialization 初始化
+ (instancetype)cellWithTableView:(UITableView *)tableView {
    
    static NSString *ID = @"SNDatasFootInjuryTableViewCell";
    SNDatasFootInjuryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[SNDatasFootInjuryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID withType:0];
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

- (void)setInjuryModel:(SNDatasFootInjuryModel *)injuryModel {
    _injuryModel = injuryModel;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BaseUrl,injuryModel.logo]]];
    self.nameLabel.text = injuryModel.name;
    self.reasonLabel.text = injuryModel.reason;
    if ([injuryModel.position isEqualToString:@"F"]) {
        self.positionLabel.text = @"前锋";
    }else if ([injuryModel.position isEqualToString:@"M"]) {
        self.positionLabel.text = @"中场";
    }else if ([injuryModel.position isEqualToString:@"D"]) {
        self.positionLabel.text = @"后卫";
    }else if ([injuryModel.position isEqualToString:@"G"]) {
        self.positionLabel.text = @"守门员";
    }else {
        self.positionLabel.text = @"未知";
    }
}

- (void)cellIsLastOne:(BOOL)isLast {
    [self.backView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).offset(isLast?-10:0);
    }];
}

- (void)setupSubviews {
    
    [self.contentView addSubview:self.bgView];
    [self.contentView addSubview:self.backView];
    [self.backView addSubview:self.iconImageView];
    [self.backView addSubview:self.nameLabel];
    [self.backView addSubview:self.positionLabel];
    [self.backView addSubview:self.reasonLabel];
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.left.equalTo(self).offset(12.5);
        make.right.equalTo(self).offset(-12.5);
    }];
    self.bgView.layer.cornerRadius = 13;
    
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.left.equalTo(self).offset(12.5);
        make.right.equalTo(self).offset(-12.5);
    }];
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backView).offset(15);
        make.left.equalTo(self.backView).offset(12.5);
        make.width.height.mas_equalTo(19);
    }];
    self.iconImageView.layer.cornerRadius = 9.5;
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImageView.mas_right).offset(7.5);
        make.centerY.equalTo(self.iconImageView.mas_centerY);
    }];
    
    [self.positionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.nameLabel.mas_centerY);
        make.left.equalTo(self.backView).offset(kScreenWidth/2-12.5);
    }];
    
    [self.reasonLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.nameLabel.mas_centerY);
        make.right.equalTo(self.backView).offset(-12.5);
    }];
    
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
        _backView.backgroundColor = UIColor.whiteColor;
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

- (UILabel *)positionLabel {
    if (!_positionLabel) {
        _positionLabel = [[UILabel alloc] init];
        _positionLabel.font = [UIFont systemFontOfSize:12];
        _positionLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        _positionLabel.text = @"位置";
    }
    return _positionLabel;
}

- (UILabel *)reasonLabel {
    if (!_reasonLabel) {
        _reasonLabel = [[UILabel alloc] init];
        _reasonLabel.font = [UIFont systemFontOfSize:12];
        _reasonLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        _reasonLabel.textAlignment = NSTextAlignmentCenter;
        _reasonLabel.text = @"原因";
    }
    return _reasonLabel;
}



@end
