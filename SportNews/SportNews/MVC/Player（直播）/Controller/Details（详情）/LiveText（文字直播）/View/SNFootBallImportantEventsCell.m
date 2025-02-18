//
//  SNFootBallImportantEventsCell.m
//  SportNews
//
//  Created by yang on 2021/1/22.
//

#import "SNFootBallImportantEventsCell.h"
#import "SNFootBallResult.h"

@interface SNFootBallImportantEventsCell()

@property (nonatomic, strong) UIView   *bgView;
@property (nonatomic, strong) UIView   *bgView1;

@property (nonatomic, strong) SNFootBallImportantTitleView           *titleView;

@property (nonatomic , strong) UIImageView  *iconImageView;
// parkingcell专用属性
@property (nonatomic, strong) UILabel           *timeLabel;
@property (nonatomic, strong) UIView            *lineView;  //
@property (nonatomic, strong) UIImageView       *bubbleImageView;  //气泡背景
@property (nonatomic, assign) FBImportantEventsCellType         cellType;
@end

@implementation SNFootBallImportantEventsCell

#pragma mark -- initialization 初始化
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier cellType:(FBImportantEventsCellType )cellType{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _cellType = cellType;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = UIColor.clearColor;
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews{
    
    [self.contentView addSubview:self.bgView];
    [self.contentView addSubview:self.bgView1];
    
    [self.contentView addSubview:self.lineView];
    [self.contentView addSubview:self.timeLabel];
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(12);
        make.right.equalTo(self.contentView).offset(-12);
        make.bottom.equalTo(self.contentView);
    }];
    
    [self.bgView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(12);
        make.right.equalTo(self.contentView).offset(-12);
        make.bottom.equalTo(self.contentView);
    }];
    self.bgView1.layer.cornerRadius = 13;
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.width.mas_equalTo(0.5);
        make.bottom.top.equalTo(self.contentView);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.height.mas_equalTo(20);
        make.width.mas_greaterThanOrEqualTo(20);
        make.top.equalTo(self.contentView).offset(18);
        
    }];
    
    
    switch (self.cellType) {
        case FBImportantEventsCellTypeHome:
        {
            [self.contentView addSubview:self.bubbleImageView];
            [self.bubbleImageView addSubview:self.titleView];
            
            [self.bubbleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(25);
                make.right.equalTo(self.timeLabel.mas_left).offset(-12.5);
                make.top.equalTo(self.contentView).offset(8);
                make.bottom.equalTo(self.contentView).offset(-8);
            }]; 
        }
            break;
        case FBImportantEventsCellTypeVisit:
        {
            [self.contentView addSubview:self.bubbleImageView];
            [self.bubbleImageView addSubview:self.titleView];
            
            [self.bubbleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self).offset(-25);
                make.left.equalTo(self.timeLabel.mas_right).offset(12.5);
                make.top.equalTo(self.contentView).offset(8);
                make.bottom.equalTo(self.contentView).offset(-8);

            }];
        }
            break;
        case FBImportantEventsCellTypeNeutral:
        {
            
        }
            break;
        case FBImportantEventsCellTypeTime:
        {
            [self.contentView addSubview:self.iconImageView];
            [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.mas_equalTo(self);
                make.width.mas_equalTo(12);
                make.height.mas_equalTo(14);
            }];
            self.iconImageView.image = [UIImage imageNamed:@"计时器"];
        }
            break;
        case FBImportantEventsCellTypeShaoZi:
        {
            [self.contentView addSubview:self.iconImageView];
            [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.mas_equalTo(self);
                make.width.mas_equalTo(13);
                make.height.mas_equalTo(14);
            }];
            self.iconImageView.image = [UIImage imageNamed:@"口哨"];
        }
            break;
    }
    
    if (self.cellType == FBImportantEventsCellTypeHome) {
        [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.bubbleImageView).offset(5);
            make.top.equalTo(self.bubbleImageView).offset(5);
            make.right.equalTo(self.bubbleImageView).offset(-15);
            make.bottom.equalTo(self.bubbleImageView).offset(-5);
        }];
    }else if (self.cellType == FBImportantEventsCellTypeVisit) {
        [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.bubbleImageView).offset(15);
            make.top.equalTo(self.bubbleImageView).offset(5);
            make.right.equalTo(self.bubbleImageView).offset(-5);
            make.bottom.equalTo(self.bubbleImageView).offset(-5);
        }];
    }
  
    
    
}

- (void)setPosition:(NSInteger)position {
    _position = position;
    if (position == 1) {//上
        [self.bgView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(13);
            make.bottom.equalTo(self.contentView);
        }];
    }else if (position == 2) {//下
        [self.bgView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView);
            make.bottom.equalTo(self.contentView).offset(-13);
        }];
    }else {//中间
        [self.bgView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView);
            make.bottom.equalTo(self.contentView);
        }];
    }
}

- (void)setModel:(SNFootBallIncidentsModel *)model{
    _model =  model;
    if (![model isKindOfClass:[SNFootBallIncidentsModel class]]) {
        return;
    }
    if (model.type.intValue == 1) {
        self.timeLabel.text = model.time;
    }else if (model.type.intValue == 11) {
        if (self.resultFootObj.score.count > 3) {
            //主队的
            NSArray *zhuArray = self.resultFootObj.score[2];
            NSArray *keArray = self.resultFootObj.score[3];
            if (zhuArray.count > 0 && keArray.count > 0) {
                NSNumber *score = zhuArray[0];
                NSNumber *kScore = keArray[0];
                self.timeLabel.text = [NSString stringWithFormat:@"中场 %@-%@    ",score,kScore];
            }
        }
    }else if (model.type.intValue == 12) {
        if (self.resultFootObj.score.count > 3) {
            //主队的
            NSArray *zhuArray = self.resultFootObj.score[2];
            NSArray *keArray = self.resultFootObj.score[3];
            if (zhuArray.count > 0 && keArray.count > 0) {
                NSNumber *score = zhuArray[0];
                NSNumber *kScore = keArray[0];
                self.timeLabel.text = [NSString stringWithFormat:@"结束 %@-%@    ",score,kScore];
            }
        }
    }else {
        if ([model.typeStr isEqualToString:@"信息"]) {
            self.timeLabel.text = [NSString stringWithFormat:@"%@",model.time];
        }else {
            self.timeLabel.text = [NSString stringWithFormat:@" %@   ",model.typeStr];
        }
    }
    
    if (self.cellType == FBImportantEventsCellTypeHome || self.cellType == FBImportantEventsCellTypeVisit) {
        self.titleView.model = model;
    }
    
    self.timeLabel.hidden = NO;
    self.lineView.hidden = NO;
    if (self.cellType == FBImportantEventsCellTypeShaoZi || self.cellType == FBImportantEventsCellTypeTime) {
        self.timeLabel.hidden = YES;
        self.lineView.hidden = YES;
    }
}

#pragma mark -- getter 懒加载

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

- (SNFootBallImportantTitleView *)titleView{
    if (!_titleView) {
        _titleView = [[SNFootBallImportantTitleView alloc]initWithFrame:CGRectMake(0, 0, 0, 0) cellType:self.cellType];
    }
    return _titleView;
}

- (UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(200-10, 15, 20, 20)];
        _timeLabel.text = @"12";
        _timeLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:11];
        _timeLabel.backgroundColor = RGB(39, 197, 195);
        _timeLabel.layer.cornerRadius = 10;
        _timeLabel.layer.masksToBounds = YES;
        _timeLabel.textColor  = [UIColor whiteColor];
        _timeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _timeLabel;
}

- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc]initWithFrame:CGRectMake(200, 0, 0.5, 44)];
        _lineView.backgroundColor = RGB(39, 197, 195);

    }
    return _lineView;
}

- (UIImageView *)bubbleImageView{
    if (!_bubbleImageView) {
        
        UIImage *bubble = [UIImage imageNamed:@"paopaoYou"];
        if (self.cellType == 1) {
            bubble = [UIImage imageNamed:@"paopaoZuo"];
        }
        CGFloat left_right = bubble.size.width/2.0;
        CGFloat top_bottom = bubble.size.height/1.2;
        bubble = [bubble resizableImageWithCapInsets:UIEdgeInsetsMake(top_bottom, left_right, top_bottom, left_right) resizingMode:UIImageResizingModeStretch];
        _bubbleImageView = [[UIImageView alloc] initWithImage:bubble];
        _bubbleImageView.backgroundColor = UIColor.clearColor;
        _bubbleImageView.layer.cornerRadius = 5;
    }
    return _bubbleImageView;
}

- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 14, 14)];
    }
    return _iconImageView;
}

@end


static NSString *reuseIndentifier = @"reuseIndentifier";

@interface SNFootBallImportantTitleView ()<UITableViewDelegate, UITableViewDataSource>
 
@property(nonatomic, strong) UITableView *tableView;

@property (nonatomic, assign) FBImportantEventsCellType         cellType;

@end

@implementation SNFootBallImportantTitleView

- (instancetype)initWithFrame:(CGRect)frame cellType:(FBImportantEventsCellType )cellType{
    self = [super initWithFrame:frame];
    if (self) {
        _cellType = cellType;
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews{
    [self addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
   
    
}
#pragma mark -- configureData
- (void)setModel:(SNFootBallIncidentsModel *)model{
    _model =  model;
    if (![model isKindOfClass:[SNFootBallIncidentsModel class]]) {
        return;
    }
    [self.tableView reloadData];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    CGFloat count = 1;
    //事件发生方，0-中立 1-主队 2-客队
    if (self.model.position.integerValue != 0) {
        if (![CommonTools isBlankString:self.model.player_name]) {
            if (![CommonTools isBlankString:self.model.assist1_id]) {
                count += 1;
            }
            if (![CommonTools isBlankString:self.model.assist2_id]) {
                count += 1;
            }
        }else if (![CommonTools isBlankString:self.model.in_player_name]&&![CommonTools isBlankString:self.model.out_player_name]) {
            count += 1;
        }
    }
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FBImportantEventsCellType cellType = [self.model.position integerValue];
    SNFootBallImportantEventsSubCell *cell = [[SNFootBallImportantEventsSubCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIndentifier cellType:cellType indexPathRow:indexPath.row];
    cell.model = self.model;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 30;
}

#pragma mark -- getter 懒加载
- (UITableView *)tableView {
    
    if (!_tableView) {
        //44是page的高度
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor =UIColor.clearColor;
        _tableView.separatorStyle = 0;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        //设置自动计算行号模式
        _tableView.rowHeight = UITableViewAutomaticDimension;
        //设置预估行高
        _tableView.estimatedRowHeight = 30;
        _tableView.showsVerticalScrollIndicator = NO;
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _tableView;
}


@end


@interface SNFootBallImportantEventsSubCell ()

@property (nonatomic , strong) UILabel      *titleLabel;
@property (nonatomic , strong) UIImageView  *iconImageView;
 
@property(nonatomic, assign) NSInteger row;
@property (nonatomic, assign) FBImportantEventsCellType         cellType;

@end

@implementation SNFootBallImportantEventsSubCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier cellType:(FBImportantEventsCellType )cellType indexPathRow:(NSInteger)row {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _cellType = cellType;
        _row = row;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = UIColor.clearColor;
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews{
     
    [self addSubview:self.titleLabel];
    [self addSubview:self.iconImageView];
     
    
    if (self.cellType == FBImportantEventsCellTypeHome) {
        [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self);
            make.centerY.mas_equalTo(self.mas_centerY);
            make.width.height.mas_equalTo(14);
        }];
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.iconImageView.mas_left).offset(-5);
            make.left.equalTo(self);
            make.centerY.mas_equalTo(self);
        }];
    }else if(self.cellType == FBImportantEventsCellTypeVisit){
        [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.centerY.mas_equalTo(self);
            make.width.height.mas_equalTo(14);
        }];
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.iconImageView.mas_right).offset(5);
            make.right.equalTo(self);
            make.centerY.mas_equalTo(self);
        }];
    }
   
    
}
#pragma mark -- configureData
- (void)setModel:(SNFootBallIncidentsModel *)model{
    _model =  model;
    if (![model isKindOfClass:[SNFootBallIncidentsModel class]]) {
        return;
    }
    
    self.iconImageView.hidden = NO;
    if ([model.position isEqualToString:@"1"]) {
        self.titleLabel.textAlignment = NSTextAlignmentRight;
    }else {
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
    }
    if (![CommonTools isBlankString:model.player_name]) {
        if (_row == 0) {
            if (model.type.intValue == 1) {
                self.titleLabel.text = [NSString stringWithFormat:@"(%@-%@)%@",model.home_score,model.away_score,model.player_name];
            }else {
                self.titleLabel.text = model.player_name;
            }
            if (model.iconImageStr.length > 0) {
                self.iconImageView.image = [UIImage imageNamed:model.iconImageStr];
            } 
        }
        if (![CommonTools isBlankString:model.assist1_id]||![CommonTools isBlankString:model.assist1_name]) {
            if (_row == 1) {
                self.titleLabel.text = model.assist1_name;
                self.iconImageView.image = [UIImage imageNamed:@"助攻"];
            }
        }
        if (![CommonTools isBlankString:model.assist2_id]||![CommonTools isBlankString:model.assist2_name]) {
            if (_row == 2) {
                self.titleLabel.text = model.assist2_name;
                self.iconImageView.image = [UIImage imageNamed:@"助攻"];
            }
        }
    }else if ([CommonTools isBlankString:model.in_player_name] && model.type.intValue == 1) {
        if (_row == 0) {
            self.titleLabel.text = [NSString stringWithFormat:@"%@-%@",model.home_score,model.away_score];
            self.iconImageView.image = [UIImage imageNamed:model.iconImageStr];
        }
    }else if (![CommonTools isBlankString:model.in_player_name]&&![CommonTools isBlankString:model.out_player_name]) {
        
        if (_row == 0) {
            self.titleLabel.text = model.in_player_name;
            self.iconImageView.image = [UIImage imageNamed:@"向上"];
        }else {
            self.titleLabel.text = model.out_player_name;
            self.iconImageView.image = [UIImage imageNamed:@"向下"];
        }
    }
    
    
}

#pragma mark -- getter 懒加载
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.numberOfLines = 0;
        _titleLabel.textColor = RGB(51, 51, 51);
        _titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];

    }
    return _titleLabel;
}

- (UIImageView *)iconImageView{
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 14, 14)];
    }
    return _iconImageView;
}
 

@end


@interface SNFootBallImportantEventsCenterImageCell ()
 
@property (nonatomic , strong) UIImageView  *iconImageView;

@end

@implementation SNFootBallImportantEventsCenterImageCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier imageName:(NSString *)imageName {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = UIColor.clearColor;
        [self setupSubviews:imageName];
    }
    return self;
}

- (void)setupSubviews:(NSString *)imageName{
     
    [self addSubview:self.iconImageView];
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.width.height.mas_equalTo(14);
    }];
    self.iconImageView.image = [UIImage imageNamed:imageName];
}
  
- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 14, 14)];
    }
    return _iconImageView;
}
 

@end
