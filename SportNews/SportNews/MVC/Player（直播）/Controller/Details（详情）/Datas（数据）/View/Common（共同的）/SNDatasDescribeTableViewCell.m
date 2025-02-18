//
//  SNDatasDescribeTableViewCell.m
//  SportNews
//
//  Created by kkk on 2021/2/3.
//

#import "SNDatasDescribeTableViewCell.h"

@interface SNDatasDescribeTableViewCell ()

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UIView *bgView1;
 
@property(nonatomic, strong) UILabel *contentLabel;

@end

@implementation SNDatasDescribeTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    
    static NSString *ID = @"SNDatasDescribeTableViewCell";
    SNDatasDescribeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[SNDatasDescribeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
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

- (void)setContentStr:(NSString *)contentStr {
    _contentStr = contentStr;
    self.contentLabel.attributedText = [CommonTools setupAttributeString:contentStr];
}
 
- (void)setRecentResult:(NSMutableAttributedString *)attr {
    self.contentLabel.attributedText = attr;
}

- (void)cellIsLastOne:(BOOL)isLast {
    self.bgView.hidden = isLast;
}

//添加子控件
- (void)setupSubviews {
    
    [self addSubview:self.bgView1];
    [self addSubview:self.bgView];
    [self addSubview:self.contentLabel];
     
    [self.bgView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.left.equalTo(self).offset(12.5);
        make.right.equalTo(self).offset(-12.5);
    }];
     
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.left.equalTo(self).offset(12.5);
        make.right.equalTo(self).offset(-12.5);
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(12.5);
        make.left.equalTo(self.bgView).offset(12.5);
        make.right.equalTo(self.bgView).offset(-12.5);
        make.height.mas_equalTo(34);
    }];
     
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.bgView1 addRoundedCorners:UIRectCornerBottomLeft| UIRectCornerBottomRight withRadii:CGSizeMake(13, 13)];
}

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = UIColor.whiteColor;
    }
    return _bgView;
}

- (UIView *)bgView1 {
    if (!_bgView1) {
        _bgView1 = [[UIView alloc] init];
        _bgView1.backgroundColor = UIColor.whiteColor;
    }
    return _bgView1;
}

- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.font = [UIFont systemFontOfSize:12];
        _contentLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        _contentLabel.numberOfLines = 2;
    }
    return _contentLabel;
}

@end
