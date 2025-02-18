//
//  SNSquadFirstRoundCell.m
//  SportNews
//
//  Created by 根哥 on 2021/2/19.
//

#import "SNSquadFirstRoundCell.h"
#import "SNFirstRoundHeaderView.h"
#import "UIImage+Transform.h" 
#import "SNSquadModel.h"
#import "SportNews-Swift.h"
#import "SNSquadShijianCollectionViewCell.h"

@interface SNSquadFirstRoundCell()

@property (nonatomic, strong) SNFirstRoundHeaderView  *headerView;
@property (nonatomic, strong) UIImageView           *bgImageView;

@property (nonatomic, assign) cellType                 type;
@property (nonatomic, strong) NSMutableArray        *frameArray;
@property (nonatomic, strong) UIView                *bgView;

@end

@implementation SNSquadFirstRoundCell

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier cellType:(cellType )type{
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  
  if (self) {
      _type = type;
      self.backgroundColor = UIColor.clearColor;
      self.selectionStyle = 0;
      [self setupSubviews];
  }
  return self;
}

- (void)setModel:(LiveListModel *)model {
    _model = model;
    self.headerView.model = model;
    self.headerView.squadModel = self.squadModel;
    self.headerView.type = self.type == cellTypeTop? 0:1;
}

- (void)setupSubviews{
    [self.contentView addSubview:self.bgView];
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 12, 0, 12));
    }];
    
    [self.bgView addSubview:self.headerView];
    [self.bgView addSubview:self.bgImageView];
    
    
    if (self.type == cellTypeTop) {
        [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(self.bgView);
            make.height.mas_equalTo(60);
        }];
        
        [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.bgView).offset(10);
            make.right.equalTo(self.bgView).offset(-10);

            make.bottom.equalTo(self.bgView);
            make.top.equalTo(self.headerView.mas_bottom);

        }];
        
//        SNPersonalInfoView *personalInfoView = [[SNPersonalInfoView alloc]initWithFrame:CGRectMake((330-56)/2, 15, 56, 72)];
//        [self.bgImageView addSubview:personalInfoView];
//        [personalInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerX.equalTo(self.bgImageView);
//            make.top.mas_equalTo(15);
//        }];
        
        
    }else{
        [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.bgView);
            make.top.equalTo(self.bgImageView.mas_bottom).offset(-5);
            make.height.mas_equalTo(60);
        }];
        
        [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.bgView).offset(10);
            make.right.equalTo(self.bgView).offset(-10);
            make.bottom.equalTo(self.headerView.mas_top);
            make.top.equalTo(self.bgView); 
        }];
        
//        SNPersonalInfoView *personalInfoView = [[SNPersonalInfoView alloc]init];
//        [self.bgImageView addSubview:personalInfoView];
//
//        [personalInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerX.equalTo(self.bgImageView);
//            make.bottom.mas_equalTo(-15);
//        }];
    }
    
    
}

- (void)setDataSource:(NSArray<SNSquadPersonInfoModel *> *)dataSource{
    
    WeakSelf;
    [dataSource enumerateObjectsUsingBlock:^(SNSquadPersonInfoModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx > 10) {
            return;
        }
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(personalTap:)];
        [tap qmui_bindLong:obj.ids forKey:@"IDs"];
        [tap qmui_bindObject:obj.logo forKey:@"LOGO"];
        SNPersonalInfoView *personalInfoView = [[SNPersonalInfoView alloc]initWithFrame:CGRectMake((330-60)/2, 15, 60, 75)];

        [personalInfoView addGestureRecognizer:tap];
        CGFloat positionX = (SCREEN_WIDTH - 44) * (obj.x/100.0) - 60/2;
        CGFloat positionY = 423 * (obj.y/100.0) - 75/2;
        if (weakSelf.type == celltypBottom) {
            [personalInfoView persionIsTop:NO];
            positionX = (SCREEN_WIDTH - 44) * (1-obj.x/100.0) - 60/2;
            positionY = 423 * ((100-obj.y)/100.0) - 75/2;
        }else {
            [personalInfoView persionIsTop:YES];
        }
        [weakSelf.bgImageView addSubview:personalInfoView];
        [personalInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.bgImageView).offset(positionX);
            make.top.mas_equalTo(positionY);
            make.width.mas_equalTo(56);
            make.height.mas_equalTo(75);
        }];
        personalInfoView.personModel = obj;

    }];
}

- (void)personalTap:(UITapGestureRecognizer *)tap {
    NSInteger number = [tap qmui_getBoundLongForKey:@"IDs"];
    NSString *string = [tap qmui_getBoundObjectForKey:@"LOGO"];
    [KYRemindView show]; 
    [KYApiHttpTool GET:URL_PlayerInfo withParams:@{@"type":self.model.type,@"mid":self.model.ID,@"playerid":@(number),@"teamtype":@(self.tag)} success:^(NSDictionary * _Nonnull response) {
        SNPlayerDetail *info = [SNPlayerDetail mj_objectWithKeyValues:response[@"data"]];
        info.logo = string;
        [SNPlayerDetailVC showWithModel:info];
        [KYRemindView dismiss];
    } failure:^(NSError * _Nullable error) {
        [KYRemindView showWithStatus:error.localizedDescription];
    }];
    return;
}

- (void)drawRect:(CGRect)rect {
    if (self.type == cellTypeTop) {
        [self.bgView addRoundedCorners:UIRectCornerTopLeft | UIRectCornerTopRight withRadii:CGSizeMake(13, 13)];
    }else {
        [self.bgView addRoundedCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight withRadii:CGSizeMake(13, 13)];
    }
}

#pragma mark -- getter 懒加载
- (SNFirstRoundHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[SNFirstRoundHeaderView alloc]initWithFrame:CGRectZero];
        
    }
    return _headerView;
}

- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc]init];
        _bgView.backgroundColor = UIColor.whiteColor;
    }
    return _bgView;
}

- (UIImageView *)bgImageView{
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc]init];
        _bgImageView.userInteractionEnabled = true;
        UIImage *image = [UIImage imageNamed:@"球场背景1"];
        if (self.type == celltypBottom) {
            image = [UIImage imageNamed:@"球场背景"];
        }
        _bgImageView.image = image;
        _bgImageView.contentMode = UIViewContentModeScaleAspectFill; 
    }
    return _bgImageView;
}

- (NSMutableArray *)frameArray{
    if (!_frameArray) {
        _frameArray = [NSMutableArray arrayWithCapacity:11];
        
    }
    return _frameArray;
}
@end

@interface SNPersonalInfoView()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UIImageView       *avatar;
@property(nonatomic, strong)  UIImageView       *backAvatar;
@property (nonatomic, strong) UILabel               *nameLabel;
@property (nonatomic, strong) UILabel               *scoreLabel;
@property(nonatomic, strong) UILabel *numLabel;
@property (nonatomic, strong) UIView                *bottomBgView;

@property(nonatomic, strong) UICollectionView *topCollectView;
@property(nonatomic, strong) UICollectionView *bottomCollectView;

@property(nonatomic, strong) NSArray *topArray;

@property(nonatomic, strong) NSArray *bottomArray;

@end


@implementation SNPersonalInfoView

static NSString *reuseCellId = @"reuseCellId";

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

- (instancetype)init{
    return [self initWithFrame:CGRectZero];
}

- (void)setupSubviews{
    [self addSubview:self.avatar];
    [self addSubview:self.topCollectView];
    [self addSubview:self.bottomCollectView];
    
    [self addSubview:self.numLabel];
    [self addSubview:self.bottomBgView];
 
    [self.bottomBgView addSubview:self.nameLabel];
    [self.bottomBgView addSubview:self.scoreLabel];
    
    [self.avatar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(5);
        make.centerX.equalTo(self);
        make.width.height.mas_equalTo(32);
    }];
    
    [self.topCollectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.avatar.mas_top).offset(1);
        make.left.equalTo(self.avatar.mas_right).offset(-5);
        make.width.mas_equalTo(45);
        make.height.mas_equalTo(15);
    }];
    [self.bottomCollectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topCollectView.mas_bottom);
        make.left.equalTo(self.avatar.mas_right).offset(-5);
        make.width.mas_equalTo(45);
        make.height.mas_equalTo(15);
    }];
    
    [self.numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.avatar.mas_centerX).offset(-18);
        make.centerY.equalTo(self.avatar.mas_centerY);
        make.width.height.mas_equalTo(16);
    }];
    self.numLabel.clipsToBounds = YES;
    self.numLabel.layer.cornerRadius = 8;
    self.numLabel.layer.borderWidth = 1;
      
    [self.bottomBgView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(self.avatar);
        make.top.equalTo(self.avatar.mas_bottom).offset(5);
        make.left.right.equalTo(self);
        make.bottom.equalTo(self);
    }];
     
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bottomBgView);
        make.right.left.equalTo(self.bottomBgView);
        make.height.mas_equalTo(16);
        make.width.mas_greaterThanOrEqualTo(54);
    }];
    
    [self.scoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom).offset(1.5);
        make.centerX.equalTo(self.bottomBgView);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(17);
    }];
    self.scoreLabel.clipsToBounds = YES;
    self.scoreLabel.layer.cornerRadius = 17/2;
    
}

- (void)persionIsTop:(BOOL)isTop {
    if (isTop) {
        self.numLabel.textColor = UIColor.whiteColor;
        self.numLabel.backgroundColor = [UIColor colorWithHexString:@"#313131"];
        self.numLabel.layer.borderColor = [UIColor clearColor].CGColor;
    }else {
        self.numLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        self.numLabel.backgroundColor = [UIColor whiteColor];
        self.numLabel.layer.borderColor = [UIColor colorWithHexString:@"#979797"].CGColor;
    }
}

- (void)setPersonModel:(SNSquadPersonInfoModel *)personModel{
    self.nameLabel.text = personModel.name;
    [self.avatar sd_setImageWithURL:[NSURL URLWithString:personModel.logo] placeholderImage:UIImageMake(@"默认头像")]; 
    if ([CommonTools isBlankString:personModel.rating]) {
        self.scoreLabel.hidden = YES;
    }else {
        self.scoreLabel.text = personModel.rating;
    }
    
    if (personModel.rating.floatValue == 0) {
        self.scoreLabel.hidden = YES;
    }
    
    if ([CommonTools isBlankString:personModel.shirt_number]||[personModel.shirt_number isEqualToString:@"0"]) {
        self.numLabel.text = @"-";
    }else {
        self.numLabel.text = personModel.shirt_number; 
    }
    CGFloat W = [self evaluteWidth:self.numLabel] + 4;
    if (W < 16) {
        W = 16;
    }
    [self.numLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(W);
    }];
    if (personModel.rating.floatValue > 8) {
        self.scoreLabel.backgroundColor = [UIColor colorWithHexString:@"#E4644D"];
    }else if (personModel.rating.floatValue > 7) {
        self.scoreLabel.backgroundColor = [UIColor colorWithHexString:@"#F08745"];
    }else {
        self.scoreLabel.backgroundColor = [UIColor colorWithHexString:@"#9CE560"];
    }
    
    NSMutableArray *topArray = [NSMutableArray array];
    NSMutableArray *bottomArray = [NSMutableArray array];
    [personModel.shijian enumerateObjectsUsingBlock:^(SNSquadShijianModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.type == 1 &&(obj.zhugong1_id == obj.player_id || obj.zhugong2_id == obj.player_id)) {
            obj.type = 31;
        }
        if (obj.type == 2 || obj.type == 3 || obj.type == 9 || obj.type == 15) {
            [topArray addObject:obj];
            if (obj.type == 9) {
                SNSquadShijianModel *model = [[SNSquadShijianModel alloc] init];
                model.time = obj.time;
                model.type = obj.type;
                model.showTime = YES;
                [topArray addObject:model];
            }
        }
        if (obj.type == 1 || obj.type == 17 || obj.type == 29 || obj.type == 31 ) {
            [bottomArray addObject:obj];
        }
            
    }];
     
    self.topArray = topArray;
    self.bottomArray = bottomArray;
    if (topArray.count > 0) {
        [self.topCollectView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo((15*topArray.count));
        }];
    }
    [self.topCollectView reloadData];
    if (bottomArray.count > 0) {
        [self.bottomCollectView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo((15*bottomArray.count));
        }];
    }
    [self.bottomCollectView reloadData];
    
}
 
#pragma mark -- UICollectionViewDataSource && UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (collectionView == self.topCollectView) {
        return self.topArray.count;
    }
    return self.bottomArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    SNSquadShijianCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseCellId forIndexPath:indexPath];
    cell.iconImageView.hidden = NO;
    cell.timeLabel.hidden = YES;
    if (self.topCollectView == collectionView) {
        SNSquadShijianModel *model = self.topArray[indexPath.item];
        cell.iconImageView.image = [UIImage imageNamed:model.typeImage];
        if (model.showTime) {
            cell.timeLabel.text = [NSString stringWithFormat:@"%@’",model.time];
            cell.timeLabel.hidden = NO;
            cell.iconImageView.hidden = YES;
        }
    }else {
        SNSquadShijianModel *model = self.bottomArray[indexPath.item];
        cell.iconImageView.image = [UIImage imageNamed:model.typeImage];
    }
    return cell;

}


- (CGFloat)evaluteWidth:(UILabel *)label {
    NSDictionary *textAtt = @{NSFontAttributeName : label.font};
    CGSize evaluteLabelSize = [label.text boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:textAtt context:nil].size;
    CGFloat evaluteLabelSizeW = evaluteLabelSize.width + 1;
    return evaluteLabelSizeW;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
}
#pragma mark -- getter 懒加载
- (UIImageView *)avatar{
    if (!_avatar) {
        _avatar = [[UIImageView alloc]init];
        _avatar.layer.cornerRadius = 16;
        _avatar.layer.masksToBounds = YES;
        _avatar.backgroundColor = [UIColor whiteColor];
    }
    return _avatar;
}

- (UIImageView *)backAvatar{
    if (!_backAvatar) {
        _backAvatar = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"信息背景"]];
    }
    return _backAvatar;
}


- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.textColor = UIColor.whiteColor;
        _nameLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:11];
        _nameLabel.text = @"姆巴佩";
        _nameLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _nameLabel;
}
- (UILabel *)numLabel{
    if (!_numLabel) {
        _numLabel = [[UILabel alloc]init];
        _numLabel.textColor = UIColor.whiteColor;
        _numLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:11]; 
        _numLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _numLabel;
}

- (UILabel *)scoreLabel{
    if (!_scoreLabel) {
        _scoreLabel = [[UILabel alloc]init];
        _scoreLabel.textColor = UIColor.whiteColor;
        _scoreLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:10];
        _scoreLabel.text = @"9.0";
        _scoreLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _scoreLabel;
    
}

- (UIView *)bottomBgView{
    if (!_bottomBgView) {
        _bottomBgView = [[UIView alloc]init];
        _bottomBgView.layer.cornerRadius = 5;
        
    }
    return _bottomBgView;
    
}

#pragma mark -- getter 懒加载
- (UICollectionView *)topCollectView{
    if (!_topCollectView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.itemSize = CGSizeMake(15,15);
        layout.minimumLineSpacing = 0;
        _topCollectView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, 45, 15) collectionViewLayout:layout];
        _topCollectView.backgroundColor = [UIColor clearColor];
        _topCollectView.showsVerticalScrollIndicator = NO;
        _topCollectView.showsHorizontalScrollIndicator = NO;
        _topCollectView.dataSource = self;
        _topCollectView.delegate = self;
        //此处只注册一个会有复用问题
        [_topCollectView registerNib:[UINib nibWithNibName:@"SNSquadShijianCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:reuseCellId];
   }
    
    return _topCollectView;
}

- (UICollectionView *)bottomCollectView{
    if (!_bottomCollectView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.itemSize = CGSizeMake(15,15);
        layout.minimumLineSpacing = 0;
        _bottomCollectView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, 45, 15) collectionViewLayout:layout];
        _bottomCollectView.backgroundColor = [UIColor clearColor];
        _bottomCollectView.showsVerticalScrollIndicator = NO;
        _bottomCollectView.showsHorizontalScrollIndicator = NO;
        _bottomCollectView.dataSource = self;
        _bottomCollectView.delegate = self;
        //此处只注册一个会有复用问题
        [_bottomCollectView registerNib:[UINib nibWithNibName:@"SNSquadShijianCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:reuseCellId];
   }
    
    return _bottomCollectView;
}

@end
