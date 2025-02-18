//
//  SNOtherLiveTopContentCollectionViewCell.m
//  SportNews
//
//  Created by kkk on 2021/5/6.
//

#import "SNOtherLiveTopContentCollectionViewCell.h"
#import "SNOtherLiveTopCollectionViewCell.h"

@interface SNOtherLiveTopContentCollectionViewCell ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property(nonatomic, strong) UICollectionView *collectionView;

@end

static NSString *const CellID = @"SNOtherLiveTopCollectionViewCell";

@implementation SNOtherLiveTopContentCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = SRGB(248);
        [self addSubview:self.collectionView];
    }
    return self;
}
 
- (void)setDataArrays:(NSArray *)dataArrays {
    _dataArrays = dataArrays;
    [self.collectionView reloadData];
}

- (NSString *)weekdayStringWithDate:(NSString *)dateStr {
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [formatter dateFromString:dateStr];
    NSDateComponents *componets = [[NSCalendar autoupdatingCurrentCalendar] components:NSCalendarUnitWeekday fromDate:date];
    NSInteger weekday = [componets weekday];
    NSArray *weekArray = @[@"周日",@"周一",@"周二",@"周三",@"周四",@"周五",@"周六"];
    NSString *weekStr = weekArray[weekday-1];
    [formatter setDateFormat:@"HH:mm"];
    NSString *timeStr = [formatter stringFromDate:date];
    return [NSString stringWithFormat:@"%@%@", weekStr, timeStr];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArrays.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    SNOtherLiveTopCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellID forIndexPath:indexPath];
    SNOtherLiveModel *model = self.dataArrays[indexPath.item];
    cell.titleLabel.text = model.cname;
    cell.timeLabel.text = [self weekdayStringWithDate:model.matchtime];
    cell.homeNameLabel.text = model.hteam;
    cell.awayNameLabel.text = model.ateam;
    return cell;
}
  
#pragma mark - item宽高
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(163 , 92.5);
}


#pragma mark - <UICollectionViewDelegateFlowLayout>
//X间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 5;
}
//Y间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 5;
}

//section四边间距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 13, 0, 13);
}


#pragma mark -- getter 懒加载
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 100) collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        //此处只注册一个会有复用问题 
        [_collectionView registerNib:[UINib nibWithNibName:@"SNOtherLiveTopCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:CellID];
   }
    return _collectionView;
}


@end
