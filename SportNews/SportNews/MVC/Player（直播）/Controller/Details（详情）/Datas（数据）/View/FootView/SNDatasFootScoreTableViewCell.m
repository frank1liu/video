//
//  SNDatasFootScoreTableViewCell.m
//  SportNews
//
//  Created by kkk on 2021/2/2.
//

#import "SNDatasFootScoreTableViewCell.h"

@interface SNDatasFootScoreTableViewCell ()

@property (nonatomic, strong) UIView *bgView;

@property(nonatomic, strong) UIImageView *hIconImageView;

@property(nonatomic, strong) UILabel *hNameLabel;

@property(nonatomic, strong) UILabel *hScoreLabel;

@property(nonatomic, strong) SNDatasFootScoreView *hScoreView;

@property(nonatomic, strong) UIImageView *aIconImageView;

@property(nonatomic, strong) UILabel *aNameLabel;

@property(nonatomic, strong) UILabel *aScoreLabel;

@property(nonatomic, strong) SNDatasFootScoreView *aScoreView;
 
@property(nonatomic, strong) UILabel *lastLabel;
  
@end

@implementation SNDatasFootScoreTableViewCell

#pragma mark -- initialization 初始化
+ (instancetype)cellWithTableView:(UITableView *)tableView {
    
    static NSString *ID = @"SNDatasFootScoreTableViewCell";
    SNDatasFootScoreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[SNDatasFootScoreTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
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
 
- (void)setModel:(LiveListModel *)model {
    _model = model;
    self.hNameLabel.text = model.hteam_name;
    [self.hIconImageView sd_setImageWithURL:[NSURL URLWithString:model.hteam_logo] placeholderImage:UIImageMake(@"默认头像")];
    self.aNameLabel.text = model.ateam_name;
    [self.aIconImageView sd_setImageWithURL:[NSURL URLWithString:model.ateam_logo] placeholderImage:UIImageMake(@"默认头像")];
}

- (void)setDatasModel:(SNDatasModel *)datasModel {
    _datasModel = datasModel;
    NSMutableArray *array = [@[@"0",@"2",@"2",@"3",@"4",@"0"] mutableCopy];
    NSMutableArray *array1 = [@[@"0",@"2",@"5",@"3",@"4",@"5"] mutableCopy];
    if (((NSDictionary *)datasModel.goal_distribution.home)[@"all"][@"scored"]) {
        int index = 0;
        for (NSArray *arr in ((NSDictionary *)datasModel.goal_distribution.home)[@"all"][@"scored"]) {
            array[index] = [NSString stringWithFormat:@"%ld", [(NSNumber *)(arr.firstObject) integerValue]];
            index += 1;
        }
    }
    if (((NSDictionary *)datasModel.goal_distribution.away)[@"all"][@"scored"]) {
        int index = 0;
        for (NSArray *arr in ((NSDictionary *)datasModel.goal_distribution.away)[@"all"][@"scored"]) {
            array1[index] = [NSString stringWithFormat:@"%ld", [(NSNumber *)(arr.firstObject) integerValue]];
            index += 1;
        }
    }
    self.hScoreView.datasArray = array;
    self.aScoreView.datasArray = array1;
    
    NSNumber *sum = [array valueForKeyPath:@"@sum.floatValue"];
    NSNumber *sum1 = [array1 valueForKeyPath:@"@sum.floatValue"];
    self.hScoreLabel.text = [NSString stringWithFormat:@"%@",sum];
    self.aScoreLabel.text = [NSString stringWithFormat:@"%@",sum1];
    
    
}

- (void)setupSubviews {
    
    [self addSubview:self.bgView];
    
    [self.bgView addSubview:self.hIconImageView];
    [self.bgView addSubview:self.hNameLabel];
    [self.bgView addSubview:self.hScoreView];
    [self.bgView addSubview:self.hScoreLabel];
    
    [self.bgView addSubview:self.aIconImageView];
    [self.bgView addSubview:self.aNameLabel];
    [self.bgView addSubview:self.aScoreView];
    [self.bgView addSubview:self.aScoreLabel];
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.left.equalTo(self).offset(12.5);
        make.right.equalTo(self).offset(-12.5);
    }];
    self.bgView.layer.cornerRadius = 13;
     
    [self.hIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgView).offset(40);
        make.left.equalTo(self.bgView).offset(15);
        make.width.height.mas_equalTo(19);
    }];
     
    [self.aIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.hIconImageView.mas_bottom).offset(4.5);
        make.left.equalTo(self.bgView).offset(15);
        make.width.height.mas_equalTo(19);
    }];
     
    NSArray *timeArray = @[@" 90'",@"75  ",@"60'  ",@"45'  ",@"30' ",@"15' ",@"00' "];
    for (int i = 0; i < timeArray.count; i++) {
        UIColor *color = [UIColor colorWithHexString:@"#999999"];
        UILabel *label = [[UILabel alloc] init];
        [self addSubview:label];
        label.text = timeArray[i];
        label.textColor = color;
        label.font = [UIFont systemFontOfSize:11];
        if (i == 0) {
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.bgView).offset(-15);
                make.top.equalTo(self.bgView).offset(12);
            }];
        }else {
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.lastLabel.mas_left).offset(-10);
                make.top.equalTo(self.bgView).offset(12);
            }];
        }
        self.lastLabel = label;
    }
    
    [self.hScoreView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-20);
        make.centerY.equalTo(self.hIconImageView.mas_centerY);
        make.width.mas_equalTo(210);
        make.height.mas_equalTo(21.5);
    }];
    
    [self.aScoreView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-20);
        make.centerY.equalTo(self.aIconImageView.mas_centerY);
        make.width.mas_equalTo(210);
        make.height.mas_equalTo(21.5);
    }];
     
    [self.hScoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.hScoreView.mas_left).offset(-6);
        make.centerY.equalTo(self.hIconImageView.mas_centerY);
        make.width.mas_equalTo(20);
    }];
    
    [self.aScoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.aScoreView.mas_left).offset(-6);
        make.centerY.equalTo(self.aIconImageView.mas_centerY);
        make.width.mas_equalTo(20);
    }];
    
    [self.hNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.hIconImageView.mas_right).offset(4);
        make.right.equalTo(self.hScoreLabel.mas_left).offset(-2);
        make.centerY.equalTo(self.hIconImageView.mas_centerY);
    }];
    
    [self.aNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.aIconImageView.mas_right).offset(4);
        make.right.equalTo(self.aScoreLabel.mas_left).offset(-2);
        make.centerY.equalTo(self.aIconImageView.mas_centerY);
    }];
}


- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = UIColor.whiteColor;
    }
    return _bgView;
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

- (SNDatasFootScoreView *)hScoreView {
    if (!_hScoreView) {
        _hScoreView = [[SNDatasFootScoreView alloc] init];
        _hScoreView.normalColor = RGB(125, 220, 219);
        _hScoreView.selectColor = Blue_Color;
    }
    return _hScoreView;
}

- (UILabel *)hScoreLabel {
    if (!_hScoreLabel) {
        _hScoreLabel = [[UILabel alloc] init];
        _hScoreLabel.font = [UIFont systemFontOfSize:11];
        _hScoreLabel.textColor = Blue_Color;
    }
    return _hScoreLabel;
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

- (SNDatasFootScoreView *)aScoreView {
    if (!_aScoreView) {
        _aScoreView = [[SNDatasFootScoreView alloc] init];
        _aScoreView.normalColor = RGB(255, 181, 135);
        _aScoreView.selectColor = Origin_Color;
    }
    return _aScoreView;
}

- (UILabel *)aScoreLabel {
    if (!_aScoreLabel) {
        _aScoreLabel = [[UILabel alloc] init];
        _aScoreLabel.font = [UIFont systemFontOfSize:11];
        _aScoreLabel.textColor = Origin_Color;
    }
    return _aScoreLabel;
}
 
@end


@interface SNDatasFootScoreView ()

@property(nonatomic, strong) UIView *leftBackView;
@property(nonatomic, strong) UILabel *leftLabel1;
@property(nonatomic, strong) UILabel *leftLabel2;
@property(nonatomic, strong) UILabel *leftLabel3;

@property(nonatomic, strong) UIView *rightBackView;
@property(nonatomic, strong) UILabel *rightLabel1;
@property(nonatomic, strong) UILabel *rightLabel2;
@property(nonatomic, strong) UILabel *rightLabel3;

@property(nonatomic, strong) NSArray *labelArray;

@end



@implementation SNDatasFootScoreView


#pragma mark -- intialization 初始化
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColor.clearColor;
        [self setupSubviews];
    }
    return self;
}
 
- (void)setNormalColor:(UIColor *)normalColor {
    _normalColor = normalColor;
    self.leftBackView.backgroundColor = normalColor;
    self.rightBackView.backgroundColor = normalColor;
}

- (void)setDatasArray:(NSArray *)datasArray {
    _datasArray = datasArray;
    if (datasArray.count < self.labelArray.count) {
        return;
    }
    CGFloat maxValue = [[datasArray valueForKeyPath:@"@max.floatValue"] floatValue];
    for (int i = 0; i < datasArray.count; i++) {
        NSString *title = datasArray[i];
        UILabel *label = self.labelArray[i];
        label.backgroundColor = UIColor.clearColor;
        if (title.floatValue == maxValue) {
            label.backgroundColor = self.selectColor;
        }
        label.text = title;
    }
}

- (void)setupSubviews {
    
    [self addSubview:self.leftBackView];
    [self addSubview:self.rightBackView];
    
    [self.leftBackView addSubview:self.leftLabel1];
    [self.leftBackView addSubview:self.leftLabel2];
    [self.leftBackView addSubview:self.leftLabel3];
     
    [self.rightBackView addSubview:self.rightLabel1];
    [self.rightBackView addSubview:self.rightLabel2];
    [self.rightBackView addSubview:self.rightLabel3];
    
    
    
    [self.leftBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self);
        make.width.mas_equalTo(102);
    }];
    self.leftBackView.layer.cornerRadius = 1.5;
    
    [self.rightBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.equalTo(self);
        make.width.mas_equalTo(102);
    }];
    self.rightBackView.layer.cornerRadius = 1.5;
    
    [self.leftLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.equalTo(self.leftBackView);
        make.width.mas_equalTo(34);
    }];
    self.leftLabel1.layer.cornerRadius = 1.5;
    self.leftLabel1.clipsToBounds = YES;
    
    [self.leftLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.leftBackView);
        make.left.equalTo(self.leftLabel1.mas_right);
        make.width.mas_equalTo(34);
    }];
    self.leftLabel2.layer.cornerRadius = 1.5;
    self.leftLabel2.clipsToBounds = YES;
    
    [self.leftLabel3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.leftBackView);
        make.left.equalTo(self.leftLabel2.mas_right);
        make.width.mas_equalTo(34);
    }];
    self.leftLabel3.layer.cornerRadius = 1.5;
    self.leftLabel3.clipsToBounds = YES;
    
    [self.rightLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.equalTo(self.rightBackView);
        make.width.mas_equalTo(34);
    }];
    self.rightLabel1.layer.cornerRadius = 1.5;
    self.rightLabel1.clipsToBounds = YES;
    
    [self.rightLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.rightBackView);
        make.left.equalTo(self.rightLabel1.mas_right);
        make.width.mas_equalTo(34);
    }];
    self.rightLabel2.layer.cornerRadius = 1.5;
    self.rightLabel2.clipsToBounds = YES;
    
    [self.rightLabel3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.rightBackView);
        make.left.equalTo(self.rightLabel2.mas_right);
        make.width.mas_equalTo(34);
    }];
    self.rightLabel3.layer.cornerRadius = 1.5;
    self.rightLabel3.clipsToBounds = YES;
    
    self.labelArray = @[self.leftLabel1,self.leftLabel2,self.leftLabel3,self.rightLabel1,self.rightLabel2,self.rightLabel3];
}

- (UIView *)leftBackView {
   if (!_leftBackView) {
       _leftBackView = [[UIView alloc] init];
   }
   return _leftBackView;
}

- (UILabel *)leftLabel1 {
    if (!_leftLabel1) {
        _leftLabel1 = [[UILabel alloc] init];
        _leftLabel1.font = [UIFont systemFontOfSize:11];
        _leftLabel1.textColor = UIColor.whiteColor;
        _leftLabel1.textAlignment = NSTextAlignmentCenter;
        _leftLabel1.text = @"0";
    }
    return _leftLabel1;
}

- (UILabel *)leftLabel2 {
    if (!_leftLabel2) {
        _leftLabel2 = [[UILabel alloc] init];
        _leftLabel2.font = [UIFont systemFontOfSize:11];
        _leftLabel2.textColor = UIColor.whiteColor;
        _leftLabel2.textAlignment = NSTextAlignmentCenter;
        _leftLabel2.text = @"0";
    }
    return _leftLabel2;
}

- (UILabel *)leftLabel3 {
    if (!_leftLabel3) {
        _leftLabel3 = [[UILabel alloc] init];
        _leftLabel3.font = [UIFont systemFontOfSize:11];
        _leftLabel3.textColor = UIColor.whiteColor;
        _leftLabel3.textAlignment = NSTextAlignmentCenter;
        _leftLabel3.text = @"0";
    }
    return _leftLabel3;
}

- (UIView *)rightBackView {
   if (!_rightBackView) {
       _rightBackView = [[UIView alloc] init];
   }
   return _rightBackView;
}

- (UILabel *)rightLabel1 {
    if (!_rightLabel1) {
        _rightLabel1 = [[UILabel alloc] init];
        _rightLabel1.font = [UIFont systemFontOfSize:11];
        _rightLabel1.textColor = UIColor.whiteColor;
        _rightLabel1.textAlignment = NSTextAlignmentCenter;
        _rightLabel1.text = @"0";
    }
    return _rightLabel1;
}

- (UILabel *)rightLabel2 {
    if (!_rightLabel2) {
        _rightLabel2 = [[UILabel alloc] init];
        _rightLabel2.font = [UIFont systemFontOfSize:11];
        _rightLabel2.textColor = UIColor.whiteColor;
        _rightLabel2.textAlignment = NSTextAlignmentCenter;
        _rightLabel2.text = @"0";
    }
    return _rightLabel2;
}

- (UILabel *)rightLabel3 {
    if (!_rightLabel3) {
        _rightLabel3 = [[UILabel alloc] init];
        _rightLabel3.font = [UIFont systemFontOfSize:11];
        _rightLabel3.textColor = UIColor.whiteColor;
        _rightLabel3.textAlignment = NSTextAlignmentCenter;
        _rightLabel3.text = @"0";
    }
    return _rightLabel3;
}


@end

