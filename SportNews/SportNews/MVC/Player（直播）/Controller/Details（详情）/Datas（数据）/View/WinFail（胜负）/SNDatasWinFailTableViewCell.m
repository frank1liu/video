//
//  SNDatasWinFailTableViewCell.m
//  SportNews
//
//  Created by kkk on 2021/1/30.
//

#import "SNDatasWinFailTableViewCell.h"

@interface SNDatasWinFailTableViewCell()

@property (nonatomic, strong) UIView *bgCorView;

@property (nonatomic , strong) UIView *bgBackView;

@property (nonatomic , strong) UIView *backView;

@property (nonatomic , strong) UILabel *leftLabel1;

@property (nonatomic , strong) UILabel *leftLabel2;

@property (nonatomic , strong) UILabel *leftLabel3;

@property (nonatomic , strong) UILabel *centerLabel;

@property (nonatomic , strong) UILabel *rightLabel1;

@property (nonatomic , strong) UILabel *rightLabel2;

@property (nonatomic , strong) UILabel *rightLabel3;


@end

//胜负
@implementation SNDatasWinFailTableViewCell

#pragma mark -- initialization 初始化
+ (instancetype)cellWithTableView:(UITableView *)tableView {
    
    static NSString *ID = @"SNDatasWinFailTableViewCell";
    SNDatasWinFailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[SNDatasWinFailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
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

- (void)cellIsLastOne:(BOOL)isLast {
    self.bgCorView.hidden = !isLast;
}

//添加子控件
- (void)setupSubviews{
    
    [self addSubview:self.bgCorView];
    [self addSubview:self.bgBackView];
    [self.bgBackView addSubview:self.backView];
    [self.backView addSubview:self.leftLabel1];
    [self.backView addSubview:self.leftLabel2];
    [self.backView addSubview:self.leftLabel3];
    [self.backView addSubview:self.centerLabel];
    [self.backView addSubview:self.rightLabel1];
    [self.backView addSubview:self.rightLabel2];
    [self.backView addSubview:self.rightLabel3];
    
    [self.bgCorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.left.equalTo(self).offset(12.5);
        make.right.equalTo(self).offset(-12.5);
    }];
    self.bgCorView.layer.cornerRadius = 13;
    
    [self.bgBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(self).offset(12.5);
        make.right.equalTo(self).offset(-12.5);
        make.height.mas_equalTo(40);
    }];
    
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.bgBackView);
        make.left.equalTo(self.bgBackView).offset(10);
        make.right.equalTo(self.bgBackView).offset(-10);
    }];
    self.backView.layer.cornerRadius = 5;
    
    [self.centerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.backView);
        make.width.mas_equalTo(50);
    }];
    
    CGFloat width = (kScreenWidth -45 -50)/6;
    [self.leftLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.backView);
        make.centerY.equalTo(self.backView);
        make.width.mas_equalTo(width);
    }];
    [self.leftLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftLabel1.mas_right);
        make.centerY.equalTo(self.leftLabel1);
        make.width.mas_equalTo(width);
    }];
    [self.leftLabel3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftLabel2.mas_right);
        make.centerY.equalTo(self.leftLabel1);
        make.width.mas_equalTo(width);
    }];
    
    [self.rightLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.centerLabel.mas_right);
        make.centerY.equalTo(self.leftLabel1);
        make.width.mas_equalTo(width);
    }];
    [self.rightLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.rightLabel1.mas_right);
        make.centerY.equalTo(self.leftLabel1);
        make.width.mas_equalTo(width);
    }];
    [self.rightLabel3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.rightLabel2.mas_right);
        make.centerY.equalTo(self.leftLabel1);
        make.width.mas_equalTo(width);
    }];
    
}

- (void)setDatasModel:(SNDatasModel *)datasModel {
    _datasModel = datasModel;
     
}

- (void)showContentWithDatas:(NSArray *)contents {
    self.leftLabel1.text = [NSString stringWithFormat:@"%@", contents[0]];
    self.leftLabel2.text = [NSString stringWithFormat:@"%@", contents[1]];
    self.leftLabel3.text = [NSString stringWithFormat:@"%@", contents[2]];
    self.centerLabel.text = contents[3];
    self.rightLabel1.text = [NSString stringWithFormat:@"%@", contents[4]];
    self.rightLabel2.text = [NSString stringWithFormat:@"%@", contents[5]];
    self.rightLabel3.text = [NSString stringWithFormat:@"%@", contents[6]];
}

- (UIView *)bgCorView {
    if (!_bgCorView) {
        _bgCorView = [[UIView alloc] init];
        _bgCorView.backgroundColor = UIColor.whiteColor;
        _bgCorView.hidden = YES;
    }
    return _bgCorView;
}

- (UIView *)bgBackView {
    if (!_bgBackView) {
        _bgBackView = [[UIView alloc] init];
        _bgBackView.backgroundColor = UIColor.whiteColor;
    }
    return _bgBackView;
}

- (UIView *)backView {
    if (!_backView) {
        _backView = [[UIView alloc] init];
        _backView.backgroundColor = SRGB(248);
    }
    return _backView;
}

- (UILabel *)leftLabel1 {
    if (!_leftLabel1) {
        _leftLabel1 = [[UILabel alloc] init];
        _leftLabel1.font = [UIFont systemFontOfSize:12];
        _leftLabel1.textColor =[UIColor colorWithHexString:@"#666666"];
        _leftLabel1.textAlignment = NSTextAlignmentCenter;
        _leftLabel1.text = @"1";
    }
    return _leftLabel1;
}

- (UILabel *)leftLabel2 {
    if (!_leftLabel2) {
        _leftLabel2 = [[UILabel alloc] init];
        _leftLabel2.font = [UIFont systemFontOfSize:12];
        _leftLabel2.textColor =[UIColor colorWithHexString:@"#666666"];
        _leftLabel2.textAlignment = NSTextAlignmentCenter;
        _leftLabel2.text = @"2";
    }
    return _leftLabel2;
}

- (UILabel *)leftLabel3 {
    if (!_leftLabel3) {
        _leftLabel3 = [[UILabel alloc] init];
        _leftLabel3.font = [UIFont systemFontOfSize:12];
        _leftLabel3.textColor =[UIColor colorWithHexString:@"#666666"];
        _leftLabel3.textAlignment = NSTextAlignmentCenter;
        _leftLabel3.text = @"3";
    }
    return _leftLabel3;
}

- (UILabel *)centerLabel {
    if (!_centerLabel) {
        _centerLabel = [[UILabel alloc] init];
        _centerLabel.font = [UIFont systemFontOfSize:12];
        _centerLabel.textColor =[UIColor colorWithHexString:@"#666666"];
        _centerLabel.textAlignment = NSTextAlignmentCenter;
        _centerLabel.text = @"106-210";
    }
    return _centerLabel;
}

- (UILabel *)rightLabel1 {
    if (!_rightLabel1) {
        _rightLabel1 = [[UILabel alloc] init];
        _rightLabel1.font = [UIFont systemFontOfSize:12];
        _rightLabel1.textColor =[UIColor colorWithHexString:@"#666666"];
        _rightLabel1.textAlignment = NSTextAlignmentCenter;
        _rightLabel1.text = @"5";
    }
    return _rightLabel1;
}

- (UILabel *)rightLabel2 {
    if (!_rightLabel2) {
        _rightLabel2 = [[UILabel alloc] init];
        _rightLabel2.font = [UIFont systemFontOfSize:12];
        _rightLabel2.textColor =[UIColor colorWithHexString:@"#666666"];
        _rightLabel2.textAlignment = NSTextAlignmentCenter;
        _rightLabel2.text = @"6";
    }
    return _rightLabel2;
}

- (UILabel *)rightLabel3 {
    if (!_rightLabel3) {
        _rightLabel3 = [[UILabel alloc] init];
        _rightLabel3.font = [UIFont systemFontOfSize:12];
        _rightLabel3.textColor =[UIColor colorWithHexString:@"#666666"];
        _rightLabel3.textAlignment = NSTextAlignmentCenter;
        _rightLabel3.text = @"7";
    }
    return _rightLabel3;
}
 
@end
