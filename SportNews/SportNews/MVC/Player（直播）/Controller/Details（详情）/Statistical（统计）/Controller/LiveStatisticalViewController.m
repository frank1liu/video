//
//  LiveStatisticalViewController.m
//  SportNews
//
//  Created by kkk on 2021/1/21.
//

#import "LiveStatisticalViewController.h"
#import "SNStatisticalHeaderView.h"
#import "SNStatisticalBottomTableViewCell.h"
#import "SNStatisticalPlayerDataCell.h"
#import "SNStatisticalSectionHeaderView.h"

@interface LiveStatisticalViewController ()<UITableViewDelegate,UITableViewDataSource>
 
@property (nonatomic, copy) void(^scrollCallback)(UIScrollView *scrollView);

@property (nonatomic, strong) SNStatisticalHeaderView *headerView;

@property (nonatomic, strong)SNStatisticalSectionHeaderView *sectionHeader;

@property(nonatomic, strong) SNStatisticalModel *statisticalModel;

@property (nonatomic, assign) NSInteger section;

@property (nonatomic, strong) UITableView *tableView;
 
@property(nonatomic, strong) UIView *tBackgroundView;

@property(nonatomic, assign) BOOL isFailure;

@end

@implementation LiveStatisticalViewController
static NSString *reuseIndentifier = @"SNStatisticalBottomTableViewCell";
static NSString *reuseStatisticalPlayerDataCell = @"reuseStatisticalPlayerDataCell";



- (void)viewDidLoad {
    [super viewDidLoad];
      
    [self setupSubViews];
      
    [self prepareHeader];
     
}


- (void)setupSubViews {
    
    self.section = 0;
    CGFloat height = 0;
    if (self.playStatus == PlayingStatusAnimate) {
        height = kScreenHeight-kContentHeight-41;
    }else if (self.playStatus == PlayingStatusLive) {
        height = kScreenHeight-kContentHeight-41-kBottomHeight;
    }else {
        height = kScreenHeight-NavHeight-41;
    }
    self.tableView.frame = CGRectMake(0, 0, kScreenWidth, height);
    self.tableView.backgroundColor = SRGB(250);
    [self.view addSubview:self.tableView];
    self.headerView.statisticalModel = self.statisticalModel;
    self.headerView.model = self.model;
    self.tableView.tableHeaderView = self.headerView;
    
    if (self.statisticalModel == nil) {
        self.tBackgroundView = [self setupEmptyViewWithFrame:CGRectMake(0, 110, kScreenWidth, 180) title:@"统计数据加载中..."];
        [self.tableView addSubview:self.tBackgroundView];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self loadDataFailure];
        });
    }
    
}

- (UIView *)setupEmptyViewWithFrame:(CGRect)bounds title:(NSString *)title {
    if (self.tBackgroundView.superview) {
        [self.tBackgroundView removeFromSuperview];
    }
    UIView *backView = [[UIView alloc] initWithFrame:bounds];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 201, 134.5)];
    [backView addSubview:imageView];
    imageView.image = [UIImage imageNamed:@"暂无比赛"];
    imageView.centerX = backView.centerX;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(imageView.frame)+5, kScreenWidth, 25)];
    label.text = title;
    label.font = [UIFont fontWithName:@"PingFangSC-Regular" size: 14];
    label.textColor = SRGB(102);
    label.textAlignment = NSTextAlignmentCenter;
    [backView addSubview:label];
    if ([title containsString:@"加载失败"]) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(reloadDatas)];
        [backView addGestureRecognizer:tap];
    }
    return backView;
}

- (void)prepareHeader {
    MJRefreshNormalHeader *Header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(reloadDatas)];
    Header.lastUpdatedTimeLabel.hidden = YES;
    self.tableView.mj_header = Header;
    [self.tableView.mj_header endRefreshing];
     
}

- (void)reloadDatas {
    if (self.reloadDataBlock) {
        self.reloadDataBlock();
    }
}

- (void)setupStatisticalModel:(SNStatisticalModel *)statisticalModel {
    self.statisticalModel = statisticalModel;
    self.statisticalModel.mid = self.model.ID.integerValue;
    if (self.tBackgroundView.superview) {
        [self.tBackgroundView removeFromSuperview];
    }
    if (statisticalModel) {
        if (statisticalModel.awayrank != nil && statisticalModel.homerank != nil) {
            self.headerView.statisticalModel = statisticalModel;
            self.headerView.model = self.model;
            self.headerView.hidden = NO;
            self.tableView.tableHeaderView = self.headerView;
        }else {
            self.tableView.tableHeaderView = nil;
        }
        if (statisticalModel.awayrank == nil && statisticalModel.homerank == nil && statisticalModel.allDatas == nil && statisticalModel.players == nil) {
            self.tBackgroundView = [self setupEmptyViewWithFrame:CGRectMake(0, 110, kScreenWidth, 180) title:@"暂无统计数据"];
            [self.tableView addSubview:self.tBackgroundView];
        }
        [self.tableView reloadData];
    }else {
        self.tBackgroundView = [self setupEmptyViewWithFrame:CGRectMake(0, 110, kScreenWidth, 180) title:@"暂无统计数据"];
        [self.tableView addSubview:self.tBackgroundView];
    }
    [self.tableView.mj_header endRefreshing];
}

//切换球队
- (void)sectionChangedWithTag:(NSInteger)tag {
    if (self.section == tag) {
        return;
    }
    self.section = tag;
    [self.tableView reloadData];
}

- (void)reloadData {
    self.tBackgroundView = [self setupEmptyViewWithFrame:CGRectMake(0, 110, kScreenWidth, 180) title:@"统计数据加载中..."];
    [self.tableView addSubview:self.tBackgroundView];
    [self reloadDatas];
}

- (void)updateScrollViewHeight:(PlayingStatus)playStatus {
    _playStatus = playStatus;
   if (playStatus == PlayingStatusAnimate) {
       self.tableView.height = kScreenHeight-kContentHeight-41;
   }else if (playStatus == PlayingStatusLive) {
       self.tableView.height = kScreenHeight-kContentHeight-41-kBottomHeight;
   }else {
       self.tableView.height = kScreenHeight-NavHeight-41;
   }
}

- (void)loadDataFailure {
    self.isFailure = YES;
    [self.tableView.mj_header endRefreshing];
    if (self.tBackgroundView.superview) {
        [self.tBackgroundView removeFromSuperview];
    }
    if (self.statisticalModel == nil) {
        self.tBackgroundView = [self setupEmptyViewWithFrame:CGRectMake(0, 110, kScreenWidth, 180) title:@"加载失败，点击重新加载"];
        [self.tableView addSubview:self.tBackgroundView];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.statisticalModel) {
        NSInteger count = 0;
        if (self.statisticalModel.players != nil) {
            count += 1;
        }
        if (self.statisticalModel.allDatas != nil) {
            count += 1;
        }
        return count;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        SNStatisticalPlayerDataCell *cell = [[SNStatisticalPlayerDataCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseStatisticalPlayerDataCell];
        cell.section = self.section;
        cell.statisticalModel = self.statisticalModel;
         
        return cell;
    }
    SNStatisticalBottomTableViewCell *cell = [[SNStatisticalBottomTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIndentifier];
    cell.model = self.model;
    cell.statisticalModel = self.statisticalModel;
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        //23+40+count*40
        NSInteger count = self.section == 0? self.statisticalModel.awayPlayers.count: self.statisticalModel.homePlayers.count;
        CGFloat height = self.section == 0? count*40+23+40: count*40+23+40;
        return height;
    }
    return 288;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return self.sectionHeader;
    }
    return  nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 60;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
}

#pragma mark - JXCategoryListContentViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat y = scrollView.contentOffset.y;
    if (y > 0) {
        self.scrollCallback(scrollView);
    }
}
 
- (UIScrollView *)listScrollView {
    return self.tableView;
}

- (void)listViewDidScrollCallback:(void (^)(UIScrollView *))callback {
    self.scrollCallback = callback;
}

- (UIView *)listView {
    return self.view;
}

- (UITableView *)tableView {
    
    if (!_tableView) {
        //44是page的高度
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.backgroundColor =UIColor.clearColor;
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, xBottomHeight + 10, 0);
        _tableView.separatorStyle = 0;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        //设置自动计算行号模式
        _tableView.rowHeight = UITableViewAutomaticDimension;
        //设置预估行高
        _tableView.estimatedRowHeight = 200;
        [_tableView registerClass:[SNStatisticalPlayerDataCell class] forCellReuseIdentifier:reuseStatisticalPlayerDataCell];
        _tableView.showsVerticalScrollIndicator = NO;
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _tableView;
}

- (SNStatisticalHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[SNStatisticalHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 287)];
        _headerView.hidden = YES;
    }
    return _headerView;
}

- (SNStatisticalSectionHeaderView *)sectionHeader {
    if (!_sectionHeader) {
        _sectionHeader = [[SNStatisticalSectionHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 60)];
        _sectionHeader.model = self.model;
        WeakSelf
        _sectionHeader.buttonClickWithTag = ^(NSInteger tag) {
            [weakSelf sectionChangedWithTag:tag];
        };
    }
    return _sectionHeader;
}
 

@end
