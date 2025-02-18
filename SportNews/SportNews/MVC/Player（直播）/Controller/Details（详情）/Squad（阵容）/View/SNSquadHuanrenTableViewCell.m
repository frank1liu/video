//
//  SNSquadHuanrenTableViewCell.m
//  SportNews
//
//  Created by K哥 on 2021/2/26.
//

#import "SNSquadHuanrenTableViewCell.h"
#import "SNSquadShijianCollectionViewCell.h"

@interface SNSquadHuanrenTableViewCell ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property(nonatomic, strong) UICollectionView *leftCollectionView;

@property(nonatomic, strong) NSArray *left_shijianArray;
@property(nonatomic, strong) NSArray *right_shijianArray;

@property(nonatomic, strong) UICollectionView *rightCollectionView;

@end

@implementation SNSquadHuanrenTableViewCell

static NSString *reuseCellId = @"reuseCellId";


- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.hIconImageView.layer.cornerRadius = self.hIconImageView.height/2;
    self.aIconImageView.layer.cornerRadius = self.aIconImageView.height/2;
    
    self.hNumLabel.clipsToBounds = YES;
    self.hNumLabel.layer.cornerRadius = 8;
    self.hNumLabel.layer.borderWidth = 1;
    
    self.aNumLabel.clipsToBounds = YES;
    self.aNumLabel.layer.cornerRadius = 8;
    self.aNumLabel.layer.borderWidth = 1;
    
    self.hScoreLabel.clipsToBounds = YES;
    self.hScoreLabel.layer.cornerRadius = 6;
    self.aScoreLabel.clipsToBounds = YES;
    self.aScoreLabel.layer.cornerRadius = 6;
    
    [self addSubview:self.leftCollectionView];
    [self.leftCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.hNameLabel.mas_bottom).offset(5);
        make.left.equalTo(self.hIconImageView.mas_right).offset(10);
        make.width.mas_equalTo(90);
        make.height.mas_equalTo(15);
    }];
    
    [self addSubview:self.rightCollectionView];
    [self.rightCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.aNameLabel.mas_bottom).offset(5);
        make.left.equalTo(self.aIconImageView.mas_right).offset(10);
        make.width.mas_equalTo(90);
        make.height.mas_equalTo(15);
    }];
    
}

- (void)setPersonModel:(SNSquadPersonInfoModel *)personModel {
    _personModel = personModel;
    self.hNameLabel.text = personModel.in_name;
    [self.hIconImageView sd_setImageWithURL:[NSURL URLWithString:personModel.in_logo] placeholderImage:UIImageMake(@"默认头像")];
    
    self.aNameLabel.text = personModel.out_name;
    [self.aIconImageView sd_setImageWithURL:[NSURL URLWithString:personModel.out_logo] placeholderImage:UIImageMake(@"默认头像")];
    
    if ([CommonTools isBlankString:personModel.in_shirt_number] || [personModel.in_shirt_number isEqualToString:@"0"]) {
        self.hNumLabel.text = @"-";
    }else {
        self.hNumLabel.text = personModel.in_shirt_number;
    }
    if ([CommonTools isBlankString:personModel.in_rating]||personModel.in_rating.floatValue == 0) {
        self.hScoreLabel.hidden = YES;
    }else {
        self.hScoreLabel.text = personModel.in_rating;
    }
    self.timeLabel.text = [NSString stringWithFormat:@"%@'", personModel.minute];
    
    if (personModel.in_rating.floatValue > 8) {
        self.hScoreLabel.backgroundColor = [UIColor colorWithHexString:@"#E4644D"];
    }else if (personModel.in_rating.floatValue > 7) {
        self.hScoreLabel.backgroundColor = [UIColor colorWithHexString:@"#F08745"];
    }else {
        self.hScoreLabel.backgroundColor = [UIColor colorWithHexString:@"#9CE560"];
    }
    
    if ([CommonTools isBlankString:personModel.out_shirt_number] || [personModel.out_shirt_number isEqualToString:@"0"]) {
        self.aNumLabel.text = @"-";
    }else {
        self.aNumLabel.text = personModel.out_shirt_number;
    }
    
    if ([CommonTools isBlankString:personModel.out_rating]||personModel.out_rating.floatValue == 0) {
        self.aScoreLabel.hidden = YES;
    }else {
        self.aScoreLabel.text = personModel.out_rating;
    }
    
    if (personModel.out_rating.floatValue > 8) {
        self.aScoreLabel.backgroundColor = [UIColor colorWithHexString:@"#E4644D"];
    }else if (personModel.out_rating.floatValue > 7) {
        self.aScoreLabel.backgroundColor = [UIColor colorWithHexString:@"#F08745"];
    }else {
        self.aScoreLabel.backgroundColor = [UIColor colorWithHexString:@"#9CE560"];
    }
    [self setupNumLabelWidth];
    NSMutableArray *left_shijianArray = [NSMutableArray array];
    NSMutableArray *right_shijianArray = [NSMutableArray array];

    [personModel.shijian enumerateObjectsUsingBlock:^(SNSquadShijianModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.type != 9 && obj.typeImage.length > 0) {
            if (obj.type == 1 &&(obj.zhugong1_id == obj.player_id || obj.zhugong2_id == obj.player_id)) {
                obj.type = 31;
            }
            if (obj.out_player_id == obj.player_id) {
                [left_shijianArray addObject:obj];
            }else{
                [right_shijianArray addObject:obj];
            }
        }
    }];
    self.left_shijianArray = left_shijianArray;
    self.right_shijianArray = right_shijianArray;
    
    if (left_shijianArray.count > 0) {
        [self.leftCollectionView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo((15*left_shijianArray.count));
        }];
        [self.leftCollectionView reloadData];

    }else{
        [self.rightCollectionView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo((15*left_shijianArray.count));
        }];
        [self.rightCollectionView reloadData];

    }
    [self cellIsHomeTeam:!personModel.isaway_type];
}

- (void)cellIsHomeTeam:(BOOL)home {
    if (home) {
        self.hNumLabel.textColor = UIColor.whiteColor;
        self.hNumLabel.backgroundColor = [UIColor colorWithHexString:@"#313131"];
        self.hNumLabel.layer.borderColor = [UIColor clearColor].CGColor;
        self.aNumLabel.textColor = UIColor.whiteColor;
        self.aNumLabel.backgroundColor = [UIColor colorWithHexString:@"#313131"];
        self.aNumLabel.layer.borderColor = [UIColor clearColor].CGColor;
    }else {
        self.hNumLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        self.hNumLabel.backgroundColor = [UIColor clearColor];
        self.hNumLabel.layer.borderColor = [UIColor colorWithHexString:@"#979797"].CGColor;
        self.aNumLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        self.aNumLabel.backgroundColor = [UIColor clearColor];
        self.aNumLabel.layer.borderColor = [UIColor colorWithHexString:@"#979797"].CGColor;
    }
}

- (void)setupNumLabelWidth {
    
    CGFloat hW = [self evaluteWidth:self.hNumLabel] + 4;
    if (hW < 16) {
        hW = 16;
    }
    self.hNumWidth.constant = hW;
    
    CGFloat aW = [self evaluteWidth:self.aNumLabel] + 4;
    if (aW < 16) {
        aW = 16;
    }
    self.aNumWidth.constant = aW;
    
}

- (void)cellIsLastOne:(BOOL)last {
    if (last) {
        self.backView.backgroundColor = UIColor.clearColor;
    }else {
        self.backView.backgroundColor = UIColor.whiteColor;
    }
}

#pragma mark -- UICollectionViewDataSource && UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (self.leftCollectionView == collectionView) {
        return self.left_shijianArray.count;

    }else{
        return self.right_shijianArray.count;

    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    SNSquadShijianCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseCellId forIndexPath:indexPath];
    cell.iconImageView.hidden = NO;
    cell.timeLabel.hidden = YES;
    SNSquadShijianModel *model;
    if (self.leftCollectionView == collectionView) {
        model = self.left_shijianArray[indexPath.item];

    }else{
        model = self.right_shijianArray[indexPath.item];
    }
    
    cell.iconImageView.image = [UIImage imageNamed:model.typeImage];
    
    return cell;

}

#pragma mark -- getter 懒加载
- (UICollectionView *)leftCollectionView{
    if (!_leftCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.itemSize = CGSizeMake(15,15);
        layout.minimumLineSpacing = 0;
        _leftCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, 90, 15) collectionViewLayout:layout];
        _leftCollectionView.backgroundColor = [UIColor clearColor];
        _leftCollectionView.showsVerticalScrollIndicator = NO;
        _leftCollectionView.showsHorizontalScrollIndicator = NO;
        _leftCollectionView.dataSource = self;
        _leftCollectionView.delegate = self;
        //此处只注册一个会有复用问题
        [_leftCollectionView registerNib:[UINib nibWithNibName:@"SNSquadShijianCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:reuseCellId];
   }
    
    return _leftCollectionView;
}

- (UICollectionView *)rightCollectionView{
    if (!_rightCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.itemSize = CGSizeMake(15,15);
        layout.minimumLineSpacing = 0;
        _rightCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, 90, 15) collectionViewLayout:layout];
        _rightCollectionView.backgroundColor = [UIColor clearColor];
        _rightCollectionView.showsVerticalScrollIndicator = NO;
        _rightCollectionView.showsHorizontalScrollIndicator = NO;
        _rightCollectionView.dataSource = self;
        _rightCollectionView.delegate = self;
        //此处只注册一个会有复用问题
        [_rightCollectionView registerNib:[UINib nibWithNibName:@"SNSquadShijianCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:reuseCellId];
   }
    
    return _rightCollectionView;
}



- (void)drawRect:(CGRect)rect {
    [self.corBackView addRoundedCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight withRadii:CGSizeMake(13, 13)];
}

@end
