//
//  SNVSFloatView.m
//  SportNews
//
//  Created by kkk on 2021/3/26.
//

#import "SNVSFloatView.h"
#import "SNLiveDetailVSCollectionViewCell.h"

#import "LiveListModel.h"

@interface SNVSFloatView()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView  *collectionView;
@property (nonatomic, strong) UIButton          *closeBtn;  //关闭按钮

@end
@implementation SNVSFloatView
static NSString *reuseCellId = @"reuseCellId";

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColor.whiteColor;
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews{
    
    self.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.06].CGColor;
    self.layer.shadowOffset = CGSizeMake(1,3);
    self.layer.shadowOpacity = 0.5;
    
    [self addSubview:self.closeBtn];
    [self addSubview:self.collectionView];
    
}

- (void)closeAction{
    if (self.closeBlock) {
        self.closeBlock();
    }
}

- (void)setDataSource:(NSArray *)dataSource{
    _dataSource = dataSource;
    CGFloat height = dataSource.count > 3? 120:60;
    self.collectionView.height = height;
    self.closeBtn.height = height;
    [self.collectionView reloadData];
}
#pragma mark -- UICollectionViewDataSource && UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
   
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    SNLiveDetailVSCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseCellId forIndexPath:indexPath];
    LiveListModel *model = self.dataSource[indexPath.item];
    cell.model = model;
    cell.horLineView.hidden = YES;
    cell.verLineView.hidden = NO;
    if (self.dataSource.count <= 3) {
        cell.verLineBottom.constant = 9.5;
    }else {
        if (indexPath.item < 3) {
            cell.horLineView.hidden = NO;
        }
        cell.verLineBottom.constant = 0;
        
    }
    if (indexPath.item < 3) {
        cell.verLineTop.constant = 9.5;
    }else {
        cell.verLineTop.constant = 0;
    }
    if (indexPath.item % 3 == 0) {
        cell.horLineLeft.constant = 9.5;
    }else {
        cell.horLineLeft.constant = 0;
    }
    if (indexPath.item == 2 || indexPath.item == 5) {
        cell.verLineView.hidden = YES;
    }
    return cell;

}
 
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    LiveListModel *model = self.dataSource[indexPath.row];
    if (self.clickedItemBlock) {
        self.clickedItemBlock(model);
    }
}

#pragma mark -- getter 懒加载
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.itemSize = CGSizeMake((kScreenWidth-22)/3,60);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(16, 0, kScreenWidth-16-5, self.height) collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
//        _collectionView.contentInset = UIEdgeInsetsMake((0), 0, (5), 0);
//        _collectionView.allowsMultipleSelection = YES;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        //此处只注册一个会有复用问题
        [_collectionView registerNib:[UINib nibWithNibName:@"SNLiveDetailVSCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:reuseCellId];
   }
    
    return _collectionView;
}

- (UIButton *)closeBtn{
    if (!_closeBtn) {
        _closeBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 16, self.height)];
        [_closeBtn setImage:[UIImage imageNamed:@"enter"] forState:UIControlStateNormal];
        _closeBtn.backgroundColor = RGB(223, 222, 229);
        [_closeBtn addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeBtn;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
