//
//  OtherLiveListVC.m
//  SportNews
//
//  Created by yuhua on 2021/5/4.
//

#import "OtherLiveListVC.h"
#import "SNOtherLiveTopContentCollectionViewCell.h"
#import "SNOtherLiveCollectionViewCell.h"
#import "SNOtherSectionCollectionReusableView.h"
#import "SNOtherLiveModel.h"
#import "MacroOthers.h"
#import "SNPictureInPictureShare.h"
#import <Superplayer/SuperPlayer.h>
#import "OtherLiveDetailVC.h"
#import "SNZFPlayerWindow.h"

@interface OtherLiveListVC ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property(nonatomic, strong) UICollectionView *collectionView;

// 是否首次加载
@property(nonatomic, assign) bool isFirstLoad;

//数据信息
@property (nonatomic, strong) NSMutableArray *dataArrays;

@property(nonatomic, strong) NSArray *topDataArray;

@end

/* cell */
static NSString *const LiveTopCellID = @"SNOtherLiveTopContentCollectionViewCell";
static NSString *const LiveCellID = @"SNOtherLiveCollectionViewCell";

static NSString *const LiveHeaderID = @"SNOtherSectionCollectionReusableView";

@implementation OtherLiveListVC

- (void)viewDidLoad {
    NSLog(@"加载其他比赛列表界面：%@", [self.categoryModel mj_JSONString]);
    [super viewDidLoad]; 
    
    [self setupCollectionView];
    
    [self getTopDatas:YES];
}

- (void)setupCollectionView {
    
    self.isFirstLoad = true;
    self.view.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:self.collectionView];
    MJRefreshHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self reloadDatas];
    }];
    header.backgroundColor = SRGB(248);
    
    self.collectionView.mj_header = header;
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self getDatas:NO];
    }]; 
    [footer setTitle:@"我是有底线的" forState:MJRefreshStateNoMoreData];
    self.collectionView.mj_footer = footer;
    
}

- (void)reloadDatas {
    self.pn = 1;
    [self getDatas:YES];
    [self getTopDatas:YES];
}

//顶部数据
- (void)getTopDatas:(BOOL)isRefresh {
    NSLog(@"加载其他比赛数据：%@", [self.categoryModel mj_JSONString]);
    NSString *type = [self.categoryModel isKindOfClass:[LiveListCategoryModel class]] ? [NSString stringWithFormat:@"%@",self.categoryModel.type]:@"0";
    NSMutableDictionary *param = @{
        @"sporttype" : type,
        @"matchtype" : @2, //1 比赛中的列表  2  赛程列表
        @"pn" : @(1),
        @"ps" : @(20)
    }.mutableCopy;
    LoginUserModel *loginModel = [UserModelTool loginModel];
    if (loginModel) {
        [param setValue:loginModel.uid forKey:@"uid"];
        [param setValue:loginModel.token forKey:@"token"];
    }
    void (^success)(NSDictionary *) = ^(NSDictionary * _Nonnull response) { 
        NSArray *topList = [SNOtherLiveModel mj_objectArrayWithKeyValuesArray:response[@"data"][@"dataList"]];
        self.topDataArray = topList;
        [self.collectionView reloadData];
    };
    void (^ fail)(NSError *) = ^(NSError * _Nonnull error) {
        
    };
    if (self.isFirstLoad) {
        self.isFirstLoad = false;
        [KYApiHttpTool FirstGET:URL_OTHER_MATCH_LIST withParams:param success:success failure:fail];
        return;
    }
    [KYApiHttpTool GET:URL_OTHER_MATCH_LIST withParams:param success:success failure:fail];
}

//下方最新赛事
- (void)getDatas:(BOOL)isRefresh {
    NSLog(@"加载其他比赛数据：%@", [self.categoryModel mj_JSONString]);
    NSString *type = [self.categoryModel isKindOfClass:[LiveListCategoryModel class]] ? [NSString stringWithFormat:@"%@",self.categoryModel.type]:@"0";
    NSMutableDictionary *param = @{
        @"sporttype" : type,
        @"matchtype" : @1, //1 比赛中的列表  2  赛程列表
        @"pn" : @(self.pn),
        @"ps" : @(self.ps)
    }.mutableCopy;
    LoginUserModel *loginModel = [UserModelTool loginModel];
    if (loginModel) {
        [param setValue:loginModel.uid forKey:@"uid"];
        [param setValue:loginModel.token forKey:@"token"];
    }
    void (^success)(NSDictionary *) = ^(NSDictionary * _Nonnull response) {
        [[NSNotificationCenter defaultCenter] postNotificationName:ListRefreshComplete object:nil userInfo:nil];
        self.pn = [response[@"data"][@"currentPage"] integerValue] + 1;
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
        NSArray *dataList = [SNOtherLiveModel mj_objectArrayWithKeyValuesArray:response[@"data"][@"dataList"]];
        if (isRefresh) {
            [self.dataArrays removeAllObjects];
        }
        if ([response[@"data"][@"currentPage"] integerValue] == [response[@"data"][@"totalPage"] integerValue]) {
            [self.collectionView.mj_footer endRefreshingWithNoMoreData];
        }
        [self.dataArrays addObjectsFromArray:dataList];
        [self.collectionView reloadData];
        
    };
    void (^ fail)(NSError *) = ^(NSError * _Nonnull error) {
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
        [[NSNotificationCenter defaultCenter] postNotificationName:ListRefreshComplete object:nil userInfo:nil];
    };
    if (self.isFirstLoad) {
        self.isFirstLoad = false;
        [KYApiHttpTool FirstGET:URL_OTHER_MATCH_LIST withParams:param success:success failure:fail];
        return;
    }
    [KYApiHttpTool GET:URL_OTHER_MATCH_LIST withParams:param success:success failure:fail];
}

- (void)getCalendarData {
    NSLog(@"其他比赛暂时不需要日历");
}

- (void)setupSubViews {
    NSLog(@"设置其他比赛界面");
    self.navView.hidden = YES;
}

#pragma mark -- UICollectionViewDataSource && UICollectionViewDelegate
 
- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    return self.dataArrays.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *baseCell = nil;
    if (indexPath.section == 0) {
        SNOtherLiveTopContentCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:LiveTopCellID forIndexPath:indexPath]; 
        baseCell = cell;
        cell.dataArrays = self.topDataArray;
    }else {
        SNOtherLiveCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:LiveCellID forIndexPath:indexPath];
        baseCell = cell;
        if (indexPath.item % 2 == 0) {
            cell.typeLabel.backgroundColor = [UIColor colorWithHexString:@"#27C5C3"];
        }else {
            cell.typeLabel.backgroundColor = [UIColor colorWithHexString:@"#2A98D5"];
        }
        cell.isAll = [self.categoryModel isKindOfClass:[LiveListCategoryModel class]] ? NO:YES;
        cell.categoryListModelArray = self.categoryListModelArray;
        cell.model = self.dataArrays[indexPath.item]; 
    }
    return baseCell;
}
 
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    LiveListModel *listModel = [LiveListModel new];
    SNOtherLiveModel *model = self.dataArrays[indexPath.item];
    listModel.ID = @(model.ids);
    listModel.type = @3;
    listModel.hteam_name = model.hteam;
    listModel.ateam_name = model.ateam;
    listModel.matchtime = model.matchtime;
    /// 这里需要设置成0，表示比赛进行中
    listModel.status = @(0);
    listModel.hteam_name = model.hteam;
    listModel.live_type = 1;
    listModel.live_urls = model.live_urls;
    listModel.sports_type = model.sports_type;
    listModel.otherTitle = model.title;
    listModel.cname = model.cname;
    
    if (SNPictureInPictureShared.playerVc.model.ID == listModel.ID) {
        if (SNPictureInPictureShared.picController.isPictureInPictureActive) {
            [self.navigationController pushViewController:[SNPictureInPictureShare sharedInstance].playerVc animated:YES];
        }else {
            SNPictureInPictureShared.playerVc = nil;
            OtherLiveDetailVC *vc = [[OtherLiveDetailVC alloc] init];
            vc.model = listModel;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else if (ZFPlayerWindowShared.zfPlayer.model.ID.intValue == listModel.ID.intValue && ZFPlayerWindowShared.backController) {
        [self.navigationController pushViewController:ZFPlayerWindowShared.backController animated:YES];
    }else {
        OtherLiveDetailVC *vc = [[OtherLiveDetailVC alloc] init];
        vc.model = listModel;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - item宽高
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (self.topDataArray.count > 0) {
            return CGSizeMake(kScreenWidth , 100);
        }else {
            return CGSizeMake(kScreenWidth , 0.01);
        }
    }
    CGFloat w = (kScreenWidth-26-6)/2;
    return CGSizeMake(w , w*98.5/172 + 50);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionReusableView *reusableview = nil;
    if (kind == UICollectionElementKindSectionHeader) {
        if (indexPath.section == 1){
            if (self.dataArrays.count) {
                SNOtherSectionCollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:LiveHeaderID forIndexPath:indexPath];
                reusableview = headerView;
            }
        }
    }
    return reusableview;
}

#pragma mark - head宽高
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        if (self.dataArrays.count) {
            return CGSizeMake(kScreenWidth, 55);
        }
    }
    return CGSizeMake(0, 0);
}


#pragma mark - <UICollectionViewDelegateFlowLayout>
//X间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return (section == 1) ? 5 : 0;
}
//Y间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return (section == 1) ? 10 : 0;
}

//section四边间距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return (section == 1) ? UIEdgeInsetsMake(0, 13, 0, 13) : UIEdgeInsetsZero;

}


#pragma mark -- getter 懒加载
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, -5, kScreenWidth, kScreenHeight - NavHeight -40) collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        //此处只注册一个会有复用问题
        [_collectionView registerClass:[SNOtherLiveTopContentCollectionViewCell class] forCellWithReuseIdentifier:LiveTopCellID];
        [_collectionView registerNib:[UINib nibWithNibName:@"SNOtherLiveCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:LiveCellID];
          
        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([SNOtherSectionCollectionReusableView class]) bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:LiveHeaderID];
        
   }
    return _collectionView;
}

- (NSMutableArray *)dataArrays {
    if (!_dataArrays) {
        _dataArrays = [NSMutableArray array];
    }
    return _dataArrays;
}

@end
