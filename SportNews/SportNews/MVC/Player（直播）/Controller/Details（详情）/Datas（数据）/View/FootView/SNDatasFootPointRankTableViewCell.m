//
//  SNDatasFootPointRankTableViewCell.m
//  SportNews
//
//  Created by kkk on 2021/2/2.
//

#import "SNDatasFootPointRankTableViewCell.h"

@interface SNDatasFootPointRankTableViewCell ()

@property (nonatomic, strong) UIView *bgView;

@property(nonatomic, strong) SNDatasFootPointRankContentView *hRankContentView;
@property(nonatomic, strong) UILabel *hBottomLabel;

@property(nonatomic, strong) SNDatasFootPointRankContentView *aRankContentView;
@property(nonatomic, strong) UILabel *aBottomLabel;

@end

@implementation SNDatasFootPointRankTableViewCell

#pragma mark -- initialization 初始化
+ (instancetype)cellWithTableView:(UITableView *)tableView {
    
    static NSString *ID = @"SNDatasFootPointRankTableViewCell";
    SNDatasFootPointRankTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[SNDatasFootPointRankTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
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
    [self.hRankContentView setupTeamName:model.hteam_name iconImage:model.hteam_logo];
    [self.aRankContentView setupTeamName:model.ateam_name iconImage:model.ateam_logo];
    
}

- (void)setDatasModel:(SNDatasModel *)datasModel {
    _datasModel = datasModel;
    
    //{"won":5,"position":15,"away_goals":7,"played":21,"lost":10,"pts":21,"team_id":10961,"goals":21,"drawn":6,"against":39,"diff":-18}
     
    NSMutableArray *hAll = [@[@"0",@"0",@"0",@"0",@"0/0",@"0",@"0"] mutableCopy];
    NSMutableArray *hH = [@[@"0",@"0",@"0",@"0",@"0/0",@"0",@"0"] mutableCopy];
    NSMutableArray *hA = [@[@"0",@"0",@"0",@"0",@"0/0",@"0",@"0"] mutableCopy];
    NSMutableArray *aAll = [@[@"0",@"0",@"0",@"0",@"0/0",@"0",@"0"] mutableCopy];
    NSMutableArray *aH = [@[@"0",@"0",@"0",@"0",@"0/0",@"0",@"0"] mutableCopy];
    NSMutableArray *aA = [@[@"0",@"0",@"0",@"0",@"0/0",@"0",@"0"] mutableCopy];
    
    [self buildData:hAll with:datasModel.table.data.all teamID:self.model.hteam_id];
    [self buildData:aAll with:datasModel.table.data.all teamID:self.model.ateam_id];
    [self buildData:hH with:datasModel.table.data.home teamID:self.model.hteam_id];
    [self buildData:aH with:datasModel.table.data.home teamID:self.model.ateam_id];
    [self buildData:hA with:datasModel.table.data.away teamID:self.model.hteam_id];
    [self buildData:aA with:datasModel.table.data.away teamID:self.model.ateam_id];
    
    [self.aRankContentView setupTitle:datasModel.table.event_name];
    [self.hRankContentView setupTitle:datasModel.table.event_name];
    
    [self.hRankContentView setupDatasArray:hAll zhuArray:hH keArray:hA];
    
   [self.aRankContentView setupDatasArray:aAll zhuArray:aH keArray:aA];
    
//    self.hBottomLabel.attributedText = [CommonTools setupAttributeString:@"主队 近10场 6胜4平0负 进19球 失7球，胜率60% 赢率80% 大率60%"];
//    self.aBottomLabel.attributedText = [CommonTools setupAttributeString:@"主队 近11场 21胜42平0负 进19球 失7球，胜率620% 赢率810% 大率610%"];
}

- (void)buildData:(NSMutableArray *)data with:(NSArray *)array teamID:(NSString *)teamID{
    for (NSDictionary *content in array) {
        if ([[NSString stringWithFormat:@"%ld", [(NSNumber *)content[@"team_id"] integerValue]] isEqualToString:teamID]) {
            data[0] = [NSString stringWithFormat:@"%ld", [(NSNumber *)content[@"played"] integerValue]];
            data[1] = [NSString stringWithFormat:@"%ld", [(NSNumber *)content[@"won"] integerValue]];
            data[2] = [NSString stringWithFormat:@"%ld", [(NSNumber *)content[@"drawn"] integerValue]];
            data[3] = [NSString stringWithFormat:@"%ld", [(NSNumber *)content[@"lost"] integerValue]];
            data[4] = [NSString stringWithFormat:@"%ld/%ld", [(NSNumber *)content[@"goals"] integerValue], [(NSNumber *)content[@"against"] integerValue]];
            data[5] = [NSString stringWithFormat:@"%ld", [(NSNumber *)content[@"pts"] integerValue]];
            data[6] = [NSString stringWithFormat:@"%ld", [(NSNumber *)content[@"position"] integerValue]];
        }
    }
}

//添加子控件
- (void)setupSubviews {
    
    [self addSubview:self.bgView];
    [self addSubview:self.hRankContentView];
    [self addSubview:self.hBottomLabel];
    [self addSubview:self.aRankContentView];
    [self addSubview:self.aBottomLabel];
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.left.equalTo(self).offset(12.5);
        make.right.equalTo(self).offset(-12.5);
    }];
    self.bgView.layer.cornerRadius = 13;

    [self.hRankContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.bgView);
        make.height.mas_equalTo(192);
    }];
    [self.hBottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.hRankContentView.mas_bottom).offset(12);
        make.left.equalTo(self.bgView).offset(14);
        make.right.equalTo(self.bgView).offset(-14);
        //make.height.mas_equalTo(34);
        make.height.mas_equalTo(0);
    }];
    
    [self.aRankContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.hBottomLabel.mas_bottom);
        make.left.right.equalTo(self.bgView);
        make.height.mas_equalTo(192);
    }];
    [self.aBottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.aRankContentView.mas_bottom).offset(12);
        make.left.equalTo(self.bgView).offset(14);
        make.right.equalTo(self.bgView).offset(-14);
        //make.height.mas_equalTo(34);
        make.height.mas_equalTo(0);
    }];
    
}
 
- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = UIColor.whiteColor;
    }
    return _bgView;
}

- (SNDatasFootPointRankContentView *)hRankContentView {
    if (!_hRankContentView) {
        _hRankContentView = [[SNDatasFootPointRankContentView alloc] init];
    }
    return _hRankContentView;
}

- (UILabel *)hBottomLabel {
    if (!_hBottomLabel) {
        _hBottomLabel = [[UILabel alloc] init];
        _hBottomLabel.font = [UIFont systemFontOfSize:12];
        _hBottomLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        _hBottomLabel.numberOfLines = 2;
    }
    return _hBottomLabel;
}

- (SNDatasFootPointRankContentView *)aRankContentView {
    if (!_aRankContentView) {
        _aRankContentView = [[SNDatasFootPointRankContentView alloc] init];
    }
    return _aRankContentView;
}

- (UILabel *)aBottomLabel {
    if (!_aBottomLabel) {
        _aBottomLabel = [[UILabel alloc] init];
        _aBottomLabel.font = [UIFont systemFontOfSize:12];
        _aBottomLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        _aBottomLabel.numberOfLines = 2;
    }
    return _aBottomLabel;
}

@end


@interface SNDatasFootPointRankContentView ()

@property(nonatomic, strong) UIImageView *iconImageView;
@property(nonatomic, strong) UILabel *nameLabel;
@property(nonatomic, strong) SNDatasFootPointRankView *titleRankView;
@property(nonatomic, strong) SNDatasFootPointRankView *totalRankView;
@property(nonatomic, strong) SNDatasFootPointRankView *zhuRankView;
@property(nonatomic, strong) SNDatasFootPointRankView *keRankView;

@end
 
@implementation SNDatasFootPointRankContentView

#pragma mark -- intialization 初始化
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColor.clearColor;
        [self setupSubviews];
    }
    return self;
}

- (void)setupTitle:(NSString *)title {
    self.titleRankView.firstText = title;
}

- (void)setupSubviews{
    
    [self addSubview:self.iconImageView];
    [self addSubview:self.nameLabel];
    [self addSubview:self.titleRankView];
    [self addSubview:self.totalRankView];
    [self addSubview:self.zhuRankView];
    [self addSubview:self.keRankView];
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self).offset(12);
        make.width.height.mas_equalTo(19);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImageView.mas_right).offset(4);
        make.centerY.equalTo(self.iconImageView.mas_centerY);
    }];
    
    [self.titleRankView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconImageView.mas_bottom);
        make.left.right.equalTo(self);
        make.height.mas_equalTo(40);
    }];
    
    [self.totalRankView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleRankView.mas_bottom);
        make.left.right.equalTo(self);
        make.height.mas_equalTo(40);
    }];
    
    [self.zhuRankView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.totalRankView.mas_bottom);
        make.left.right.equalTo(self);
        make.height.mas_equalTo(40);
    }];
    
    [self.keRankView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.zhuRankView.mas_bottom);
        make.left.right.equalTo(self);
        make.height.mas_equalTo(40);
    }];
    
}

- (void)setupTeamName:(NSString *)teamName iconImage:(NSString *)iconStr {
    self.nameLabel.text = teamName;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:iconStr] placeholderImage:UIImageMake(@"默认头像")];
}

- (void)setupDatasArray:(NSArray *)zongArray zhuArray:(NSArray *)zhuArray keArray:(NSArray *)keArray {
    self.totalRankView.datasArray = zongArray;
    self.zhuRankView.datasArray = zhuArray;
    self.keRankView.datasArray = keArray;
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

- (SNDatasFootPointRankView *)titleRankView {
    if (!_titleRankView) {
        _titleRankView = [[SNDatasFootPointRankView alloc] init];
        [_titleRankView isDoubleCell:NO];
        _titleRankView.datasArray = @[@"赛",@"胜",@"平",@"负",@"进/失",@"积分",@"排名"];
    }
    return _titleRankView;
}

- (SNDatasFootPointRankView *)totalRankView {
    if (!_totalRankView) {
        _totalRankView = [[SNDatasFootPointRankView alloc] init];
        [_totalRankView isDoubleCell:YES];
        _totalRankView.firstText = @"总";
    }
    return _totalRankView;
}

- (SNDatasFootPointRankView *)zhuRankView {
    if (!_zhuRankView) {
        _zhuRankView = [[SNDatasFootPointRankView alloc] init];
        [_zhuRankView isDoubleCell:NO];
        _zhuRankView.firstText = @"主";
    }
    return _zhuRankView;
}

- (SNDatasFootPointRankView *)keRankView {
    if (!_keRankView) {
        _keRankView = [[SNDatasFootPointRankView alloc] init];
        [_keRankView isDoubleCell:YES];
        _keRankView.firstText = @"客";
    }
    return _keRankView;
}
 

@end


@interface SNDatasFootPointRankView ()

@property (nonatomic, strong) UIView *backView;

//标题
@property (nonatomic, strong) UILabel *Label1;
//赛
@property (nonatomic, strong) UILabel *Label2;
//胜
@property (nonatomic, strong) UILabel *Label3;
//平
@property (nonatomic, strong) UILabel *Label4;
//负
@property (nonatomic, strong) UILabel *Label5;
//进失
@property (nonatomic, strong) UILabel *Label6;
//积分
@property (nonatomic, strong) UILabel *Label7;
//排名
@property (nonatomic, strong) UILabel *Label8;


@end



@implementation SNDatasFootPointRankView


#pragma mark -- intialization 初始化
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColor.clearColor;
        [self setupSubviews];
    }
    return self;
}

- (void)isDoubleCell:(BOOL)doubleCell {
    self.backView.backgroundColor = doubleCell? SRGB(248):UIColor.whiteColor;
}

- (void)setFirstText:(NSString *)firstText {
    self.Label1.text = firstText;
}
- (void)setDatasArray:(NSArray *)datasArray {
    if (datasArray.count == 7) {
        self.Label2.text = datasArray[0];
        self.Label3.text = datasArray[1];
        self.Label4.text = datasArray[2];
        self.Label5.text = datasArray[3];
        self.Label6.text = datasArray[4];
        self.Label7.text = datasArray[5];
        self.Label8.text = datasArray[6];
    }
}

- (void)setupSubviews {
    
    [self addSubview:self.backView];
    [self addSubview:self.Label1];
    [self addSubview:self.Label2];
    [self addSubview:self.Label3];
    [self addSubview:self.Label4];
    [self addSubview:self.Label5];
    [self addSubview:self.Label6];
    [self addSubview:self.Label7];
    [self addSubview:self.Label8];
    
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.left.equalTo(self).offset(10);
        make.right.equalTo(self).offset(-10);
    }];
    self.backView.layer.cornerRadius = 5;
    
    [self.Label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.backView.mas_centerY);
        make.left.equalTo(self.backView).offset(10);
    }];
    
    //63 左边 32右边 15是进/失要比其他的宽这么多
    CGFloat width = (kScreenWidth -65 -25 -20)/7;
    [self.Label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.backView.mas_centerY);
        make.left.equalTo(self.backView).offset(53);
        make.width.mas_equalTo(width);
    }];
    [self.Label3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.backView.mas_centerY);
        make.left.equalTo(self.Label2.mas_right);
        make.width.mas_equalTo(width);
    }];
    [self.Label4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.backView.mas_centerY);
        make.left.equalTo(self.Label3.mas_right);
        make.width.mas_equalTo(width);
    }];
    [self.Label5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.backView.mas_centerY);
        make.left.equalTo(self.Label4.mas_right);
        make.width.mas_equalTo(width);
    }];
    [self.Label6 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.backView.mas_centerY);
        make.left.equalTo(self.Label5.mas_right);
        make.width.mas_equalTo(width+15);
    }];
    [self.Label7 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.backView.mas_centerY);
        make.left.equalTo(self.Label6.mas_right);
        make.width.mas_equalTo(width);
    }];
    [self.Label8 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.backView.mas_centerY);
        make.left.equalTo(self.Label7.mas_right);
        make.width.mas_equalTo(width);
    }];
    
}

- (UIView *)backView {
   if (!_backView) {
       _backView = [[UIView alloc] init];
       _backView.backgroundColor = SRGB(248);
   }
   return _backView;
}

- (UILabel *)Label1 {
    if (!_Label1) {
        _Label1 = [[UILabel alloc] init];
        _Label1.font = [UIFont systemFontOfSize:12];
        _Label1.textColor = [UIColor colorWithHexString:@"#999999"];
    }
    return _Label1;
}

- (UILabel *)Label2 {
    if (!_Label2) {
        _Label2 = [[UILabel alloc] init];
        _Label2.font = [UIFont systemFontOfSize:12];
        _Label2.textColor = [UIColor colorWithHexString:@"#999999"];
        _Label2.textAlignment = NSTextAlignmentCenter;
    }
    return _Label2;
}

- (UILabel *)Label3 {
    if (!_Label3) {
        _Label3 = [[UILabel alloc] init];
        _Label3.font = [UIFont systemFontOfSize:12];
        _Label3.textColor = [UIColor colorWithHexString:@"#999999"];
        _Label3.textAlignment = NSTextAlignmentCenter;
    }
    return _Label3;
}

- (UILabel *)Label4 {
    if (!_Label4) {
        _Label4 = [[UILabel alloc] init];
        _Label4.font = [UIFont systemFontOfSize:12];
        _Label4.textColor = [UIColor colorWithHexString:@"#999999"];
        _Label4.textAlignment = NSTextAlignmentCenter;
    }
    return _Label4;
}

- (UILabel *)Label5 {
    if (!_Label5) {
        _Label5 = [[UILabel alloc] init];
        _Label5.font = [UIFont systemFontOfSize:12];
        _Label5.textColor = [UIColor colorWithHexString:@"#999999"];
        _Label5.textAlignment = NSTextAlignmentCenter;
    }
    return _Label5;
}

- (UILabel *)Label6 {
    if (!_Label6) {
        _Label6 = [[UILabel alloc] init];
        _Label6.font = [UIFont systemFontOfSize:12];
        _Label6.textColor = [UIColor colorWithHexString:@"#999999"];
        _Label6.textAlignment = NSTextAlignmentCenter;
    }
    return _Label6;
}

- (UILabel *)Label7 {
    if (!_Label7) {
        _Label7 = [[UILabel alloc] init];
        _Label7.font = [UIFont systemFontOfSize:12];
        _Label7.textColor = [UIColor colorWithHexString:@"#999999"];
        _Label7.textAlignment = NSTextAlignmentCenter;
    }
    return _Label7;
}

- (UILabel *)Label8 {
    if (!_Label8) {
        _Label8 = [[UILabel alloc] init];
        _Label8.font = [UIFont systemFontOfSize:12];
        _Label8.textColor = Blue_Color;
        _Label8.textAlignment = NSTextAlignmentCenter;
    }
    return _Label8;
}



@end
