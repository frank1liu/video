//
//  SNLiveListTopView.m
//  SportNews
//
//  Created by kkk on 2021/3/30.
//

#import "SNLiveListTopView.h"
#import "SNLiveListCollectionViewCell.h"
#import "SportNews-Swift.h"

@interface SNLiveListTopView ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property(nonatomic, strong) UIButton *calendarBtn;

@property (nonatomic, strong) UICollectionView  *collectionView;

@property (nonatomic, strong) NSArray *dataSource;  //数据源

@property (nonatomic, assign) NSInteger selected;

@property (nonatomic, strong) NSMutableDictionary *dayData;

@end

@implementation SNLiveListTopView

static NSString *reuseCellId = @"LiveListReuseCellId";

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews {
    
    [self buildDays];
    
    self.backgroundColor = UIColor.whiteColor;
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(12.5, 5, kScreenWidth-25, 30)];
    contentView.backgroundColor = [UIColor colorWithHexString:@"#FBF8FB"];
    contentView.layer.cornerRadius = 5;
    [self addSubview:contentView];
    
    [contentView addSubview:self.collectionView];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 2, 22.5, 22)];
    imageView.image = [UIImage imageNamed:@"日历-1"];
    [contentView addSubview:imageView];
    
    UIButton *calendarBtn = [[UIButton alloc] initWithFrame:CGRectMake(contentView.width-70, 0, 70, 30)];
    [calendarBtn addTarget:self action:@selector(showCalendar) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:calendarBtn];
    self.calendarBtn = calendarBtn;
    imageView.centerX = calendarBtn.centerX;

    UILabel *bottomLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 18, 20, 10)];
    bottomLabel.textColor = Blue_Color;
    bottomLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightBold];
    bottomLabel.text = @"...";
    bottomLabel.textAlignment = NSTextAlignmentCenter;
    bottomLabel.centerX = calendarBtn.centerX;
    [contentView addSubview:bottomLabel];
    [self layoutIfNeeded]; 
    self.selected = [self.dataSource indexOfObject:[LiveListCalendarVC getCurrentString]];
    if (self.selected >= 0 && self.selected < self.dataSource.count) {
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.selected inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:false];
    }
}

- (void)buildDays {
    self.dataSource = [LiveListCalendarVC getDayContent];
}

NSInteger sorted(id id1, id id2, void *context) {
    NSString *s1 = id1;
    NSString *s2 = id2;
    return [s1 compare:s2];
}

- (void)setIsHideCount:(BOOL)isHideCount {
    _isHideCount = isHideCount;
    [self.collectionView reloadData];
}

- (void)reloadDayNuber:(NSMutableDictionary *)dayData {
    self.dayData = dayData;
    self.dataSource = [self.dayData.allKeys sortedArrayUsingFunction:sorted context:nil];
    self.selected = [self.dataSource indexOfObject:[LiveListCalendarVC getCurrentString]];
    [self.collectionView reloadData];
    if (self.selected >= 0 && self.selected < self.dataSource.count) {
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.selected inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:false];
    }
}

- (void)changeChoice:(NSString *)choice {
    self.selected = [self.dataSource indexOfObject:choice];
    [self.collectionView reloadData];
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.selected inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:true];
}

- (void)changeChoiceNotAnimated:(NSString *)choice {
    self.selected = [self.dataSource indexOfObject:choice];
    [self.collectionView reloadData];
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.selected inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:false];
}
#pragma mark -- UICollectionViewDataSource && UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    SNLiveListCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseCellId forIndexPath:indexPath];
    if (indexPath.row == self.selected) {
        //选中的背景色
        cell.backgroundColor = [UIColor colorWithHexString:@"#FBF8FB"];
        cell.dateLabel.textColor = Blue_Color;
    } else {
        //其他颜色
        cell.backgroundColor = [UIColor whiteColor];
        cell.dateLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    }
    NSString *day = self.dataSource[indexPath.row];
    cell.dateLabel.text = [day substringFromIndex:5];
    cell.countLabel.text = self.dayData[day];
    [cell setupCount];
    if ([day isEqualToString: [LiveListCalendarVC getCurrentString]]) {
        cell.dateLabel.text = @"今天";
    }
    if (self.dayData[day] == nil) {
        [cell.countLabel setHidden:true];
    } else {
        [cell.countLabel setHidden:false];
    }
    cell.countLabel.hidden = self.isHideCount;
    
    return cell;

}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    self.selected = indexPath.row;
    if (self.dayData[self.dataSource[indexPath.row]] == nil) {
        [KYRemindView showWithStatus:@"当前选择日期没有比赛！"];
        return;
    }
    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:true];
    [self.collectionView reloadData];
    self.choiceItem(self.dataSource[indexPath.row]);
}


- (void)showCalendar {
    if (self.showCalendarBlock) {
        self.showCalendarBlock();
    }
}

- (UICollectionView *)collectionView{
   if (!_collectionView) {
       UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
       layout.minimumLineSpacing = 0;
       layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
       layout.itemSize = CGSizeMake(70,30);
       _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth-25-70, 30) collectionViewLayout:layout];
       _collectionView.backgroundColor = [UIColor whiteColor];
       _collectionView.contentInset = UIEdgeInsetsMake((0), 0, 0, 5);
       _collectionView.showsVerticalScrollIndicator = NO;
       _collectionView.showsHorizontalScrollIndicator = NO;
       _collectionView.dataSource = self;
       _collectionView.delegate = self;
       //此处只注册一个会有复用问题
       [_collectionView registerNib:[UINib nibWithNibName:@"SNLiveListCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:reuseCellId];
  }
   
   return _collectionView;
}


@end
