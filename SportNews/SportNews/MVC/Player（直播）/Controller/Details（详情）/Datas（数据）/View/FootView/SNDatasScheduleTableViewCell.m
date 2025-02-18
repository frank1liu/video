//
//  SNDatasScheduleTableViewCell.m
//  SportNews
//
//  Created by kkk on 2021/1/30.
//

#import "SNDatasScheduleTableViewCell.h"

@interface SNDatasScheduleTableViewCell ()

@property (nonatomic, strong) UIView *bgCorView;

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UIView *backView;

@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, strong) UILabel *typeLabel;

@property (nonatomic, strong) UILabel *hNameLabel;

@property (nonatomic, strong) UILabel *scoreLabel;

@property (nonatomic, strong) UILabel *aNameLabel;

@property (nonatomic, strong) UILabel *jianDayLabel;

@property(nonatomic, assign) BOOL isBen;

@end

@implementation SNDatasScheduleTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

#pragma mark -- initialization 初始化
+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"SNDatasScheduleTableViewCell";
    SNDatasScheduleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[SNDatasScheduleTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
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


- (void)isDoubleCell:(BOOL)doubleCell {
    self.backView.backgroundColor = doubleCell? SRGB(248):UIColor.whiteColor;
}

- (void)isBenChangeGame:(BOOL)isBen {
    _isBen = isBen;
    self.timeLabel.textColor = isBen? Blue_Color:[UIColor colorWithHexString:@"#333333"];
    self.hNameLabel.textColor = isBen? Blue_Color:[UIColor colorWithHexString:@"#333333"];
    self.aNameLabel.textColor = isBen? Blue_Color:[UIColor colorWithHexString:@"#333333"];
    self.typeLabel.textColor = isBen? Blue_Color:[UIColor colorWithHexString:@"#333333"];
    self.jianDayLabel.textColor = isBen? Blue_Color:[UIColor colorWithHexString:@"#333333"];
}

- (void)cellIsLastOne:(BOOL)isLast {  
    self.bgCorView.hidden = !isLast;
}


//添加子控件
- (void)setupSubviews{
    
    [self addSubview:self.bgCorView];
    [self addSubview:self.bgView];
    [self addSubview:self.backView];
    [self.backView addSubview:self.timeLabel];
    [self.backView addSubview:self.typeLabel];
    [self.backView addSubview:self.hNameLabel];
    [self.backView addSubview:self.scoreLabel];
    [self.backView addSubview:self.aNameLabel];
    [self.backView addSubview:self.jianDayLabel];
    
    [self.bgCorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.left.equalTo(self).offset(12.5);
        make.right.equalTo(self).offset(-12.5);
    }];
    self.bgCorView.layer.cornerRadius = 13;
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(self).offset(12.5);
        make.right.equalTo(self).offset(-12.5);
        make.height.mas_equalTo(51);
    }];
    self.backView.layer.cornerRadius = 5;
      
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(self).offset(22.5);
        make.right.equalTo(self).offset(-22.5);
        make.height.mas_equalTo(51);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backView).offset(10);
        make.left.equalTo(self.backView).offset(5.5);
        make.width.mas_equalTo(61);
    }];
    
    [self.typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.timeLabel.mas_bottom).offset(4.5);
        make.left.equalTo(self.backView).offset(5.5);
        make.width.mas_equalTo(61);
    }];
    
    [self.scoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.backView.mas_centerY);
        make.centerX.equalTo(self.backView.mas_centerX).offset(13);
        make.width.mas_equalTo(25);
    }];
    
    [self.jianDayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.backView.mas_centerY);
        make.right.equalTo(self.backView).offset(-10);
        make.width.mas_equalTo(25);
    }];
    
    [self.hNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.backView.mas_centerY);
        make.left.equalTo(self.timeLabel.mas_right).offset(5.5);
        make.right.equalTo(self.scoreLabel.mas_left).offset(-5);
    }];
    
    [self.aNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.backView.mas_centerY);
        make.left.equalTo(self.scoreLabel.mas_right).offset(5.5);
        make.right.equalTo(self.jianDayLabel.mas_left).offset(-5);
    }];
    
}
 
- (UIView *)bgCorView {
    if (!_bgCorView) {
        _bgCorView = [[UIView alloc] init];
        _bgCorView.backgroundColor = UIColor.whiteColor;
        _bgCorView.hidden = YES;
    }
    return _bgCorView;
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

- (void)reloadData:(NSArray *)arr {
    if (arr.count > 5) {
        self.timeLabel.text = arr[0];
        self.typeLabel.text = arr[1];
        self.hNameLabel.text = arr[2];
        self.scoreLabel.text = arr[3];
        self.aNameLabel.text = arr[4];
        self.jianDayLabel.text = arr[5];
    }
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = [UIFont systemFontOfSize:11];
        _timeLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        _timeLabel.text = @"2020/10/20";
    }
    return _timeLabel;
}

- (UILabel *)typeLabel {
    if (!_typeLabel) {
        _typeLabel = [[UILabel alloc] init];
        _typeLabel.font = [UIFont systemFontOfSize:12];
        _typeLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        _typeLabel.textAlignment = NSTextAlignmentCenter;
        _typeLabel.text = @"英超";
    }
    return _typeLabel;
}

- (UILabel *)hNameLabel {
    if (!_hNameLabel) {
        _hNameLabel = [[UILabel alloc] init];
        _hNameLabel.font = [UIFont systemFontOfSize:12];
        _hNameLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        _hNameLabel.textAlignment = NSTextAlignmentRight;
        _hNameLabel.numberOfLines = 2;
        _hNameLabel.text = @"托特纳姆热刺";
    }
    return _hNameLabel;
}

- (UILabel *)scoreLabel {
    if (!_scoreLabel) {
        _scoreLabel = [[UILabel alloc] init];
        _scoreLabel.font = [UIFont systemFontOfSize:12];
        _scoreLabel.textColor = Blue_Color;
        _scoreLabel.textAlignment = NSTextAlignmentCenter;
        _scoreLabel.text = @"2-2";
    }
    return _scoreLabel;
}

- (UILabel *)aNameLabel {
    if (!_aNameLabel) {
        _aNameLabel = [[UILabel alloc] init];
        _aNameLabel.font = [UIFont systemFontOfSize:12];
        _aNameLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        _aNameLabel.textAlignment = NSTextAlignmentLeft;
        _aNameLabel.numberOfLines = 2;
        _aNameLabel.text = @"曼彻斯特联";
    }
    return _aNameLabel;
}

- (UILabel *)jianDayLabel {
    if (!_jianDayLabel) {
        _jianDayLabel = [[UILabel alloc] init];
        _jianDayLabel.font = [UIFont systemFontOfSize:11];
        _jianDayLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        _jianDayLabel.textAlignment = NSTextAlignmentCenter;
        _jianDayLabel.text = @"51天";
    }
    return _jianDayLabel;
}


@end
