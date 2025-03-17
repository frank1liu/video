//
//  SNExampleListViewController.m
//  SportNews
//
//  Created by kkk on 2021/3/10.
//

#import "SNExampleListViewController.h"
#import "SNExampleTopSelectView.h"
#import "SNExampleLeftTableViewCell.h"
#import "SNExampleBaseTableViewCell.h"
#import "SNTeamRankHeaderView.h"
#import "SNExampleBaseHeaderView.h"
#import "SNExampleMoreFooterView.h"
#import "SNExampleMoreListViewController.h"
#import "SNBasketTeamRankResult.h"
#import "TalkBaseViewController.h"
#import "SNUserWebViewController.h"

extern NSString *talkWebUrl;
//10+40+10
#define topHeight 60

@interface SNExampleListViewController ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>
{
    BOOL _isSelectSlide;//是点击leftTableView，还是拖拽右边的滑动视图
}
@property (nonatomic, copy) void(^scrollCallback)(UIScrollView *scrollView);

@property(nonatomic, strong) SNExampleTopSelectView *topSelectView;
@property(nonatomic, strong) SNExampleTopSelectView *switchView;
@property(nonatomic, strong) SNExampleTopSelectView *switchView1;

@property(nonatomic, strong) UIView *contentView;
@property(nonatomic, strong) UIView *tableContentView;
/* tableView */
@property (strong , nonatomic)UITableView *leftTableView;
@property (strong , nonatomic)UITableView *rightTableView;

@property (nonatomic, strong) NSMutableArray                   *dataSource;
 
@property(nonatomic, strong) NSMutableDictionary *dataDic;
@property(nonatomic, assign) SNBasketRankType rankType;     //ranktype 1球队榜 2球员榜 3伤停榜
@property (nonatomic, strong) UIView *talkBaseView;
// @property (nonatomic, strong) TalkBaseViewController *talkBaseVC;
@property (nonatomic, strong) SNUserWebViewController *talkWebVC;

@end

@implementation SNExampleListViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    if (self.playStatus == PlayingStatusLive) {
        self.talkBaseView = [[UIView alloc]initWithFrame:CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y, self.view.bounds.size.width, kScreenHeight-kContentHeight-41-kBottomHeight)];
    } else {
        self.talkBaseView = [[UIView alloc]initWithFrame:CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y, self.view.bounds.size.width, kScreenHeight-kContentHeight-41)];
    }

    self.talkBaseView.backgroundColor = UIColor.clearColor;

    // self.talkBaseVC = [[TalkBaseViewController alloc]initWithNibName:@"TalkBaseViewController" bundle:nil];

//    self.talkWebVC = [[SNUserWebViewController alloc]init];
//    self.talkWebVC.url = talkWebUrl;

    self.dataDic = [NSMutableDictionary dictionary];
    
    [self setupTopSelectView];
    
    [self getExampleData:SNBasketRankTypeTeam];
    
    [self setupSubViews];
}

- (void)showTalkBaseView {
    [self hideTalkBaseView];
    self.talkWebVC = nil;
    self.talkWebVC = [[SNUserWebViewController alloc]init];
    self.talkWebVC.url = talkWebUrl;
    [self.view addSubview:self.talkBaseView];
    self.talkBaseView.backgroundColor = UIColor.yellowColor;
    [self addChildViewController:self.talkWebVC];
    self.talkWebVC.view.frame = self.talkBaseView.bounds;
    [self.talkBaseView addSubview:self.talkWebVC.view];
    [self.view bringSubviewToFront:self.talkBaseView];
    [self.talkWebVC setWebViewSize:CGRectMake(0, 0, kScreenWidth, self.talkBaseView.frame.size.height-28.0)];
}

- (void)hideTalkBaseView {
    [self.talkWebVC willMoveToParentViewController:nil];
    [self.talkWebVC.view removeFromSuperview];
    [self.talkWebVC removeFromParentViewController];
    self.talkBaseView.backgroundColor = UIColor.clearColor;
    [self.talkBaseView removeFromSuperview];
    self.talkWebVC = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showTalkBaseView) name:@"ShowTalkBaseView" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideTalkBaseView) name:@"HideTalkBaseView" object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ShowTalkBaseView" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"HideTalkBaseView" object:nil];
}

//加载榜单的数据
- (void)getExampleData:(SNBasketRankType )rankType {
    self.leftTableView.contentOffset = CGPointMake(0, 0);
    self.rightTableView.contentOffset = CGPointMake(0, 0);
    self.rankType = rankType;
    NSArray *oldArray = [self.dataDic objectForKey:[NSString stringWithFormat:@"%ld-100",rankType]];
    if (oldArray.count > 0) {
        [self setupDataSource:oldArray withRankType:rankType];
        return;
    }
    //ranktype 1球队榜 2球员榜 3伤停榜
    NSDictionary *param1 = @{ 
        @"ranktype" : @(rankType)
    };
    [KYRemindView show];
    WeakSelf;
    [KYApiHttpTool GET:URL_BasketRankList withParams:param1 success:^(NSDictionary * _Nonnull response) {
        NSArray *dataArray = [SNBasketTeamRankResult mj_objectArrayWithKeyValuesArray:response[@"data"]];
        [weakSelf.dataDic setValue:dataArray forKey:[NSString stringWithFormat:@"%ld-100",rankType]];
        if (self.rankType != rankType) {
            return;
        }
        [weakSelf setupDataSource:dataArray withRankType:rankType];
    } failure:^(NSError * _Nonnull error) {
        
    }];
}

- (void)setupDataSource:(NSArray *)dataArray withRankType:(NSInteger)rankType {
    [self.dataSource removeAllObjects];
    [self.dataSource addObjectsFromArray:dataArray];
    //都要排序吧
    if (rankType == 1) {
        NSArray *resultArray = [self dataSouceHandle];
        self.dataSource = [resultArray mutableCopy];
    }
    [self.leftTableView reloadData];
    [self.rightTableView reloadData];
    if (self.dataSource.count > 0) {
        self.tableContentView.hidden = NO;
        [self.leftTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop]; 
    }
}

- (NSArray *)dataSouceHandle {
    NSMutableArray *tempArray = [NSMutableArray arrayWithCapacity:self.dataSource.count];
    WeakSelf;
    [self.dataSource enumerateObjectsUsingBlock:^(SNBasketTeamRankResult * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.name isEqualToString:@"分区排行"]) {
            NSArray *fenquArray = [weakSelf handleFenquData:obj];
            [tempArray addObjectsFromArray:fenquArray];
        }else{
            [tempArray addObject:obj];
        }
    }];
    return tempArray;
}

- (NSArray *)handleFenquData:(SNBasketTeamRankResult *)resultModel {
    NSMutableArray *tempArray = [NSMutableArray array];
    __block SNExampleBaseModel *lastModel = nil;
    __block NSMutableArray *list = [NSMutableArray array];
    [resultModel.list enumerateObjectsUsingBlock:^(SNExampleBaseModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (!lastModel) {
            [list addObject:obj];
        }else if(lastModel && ![lastModel.name isEqualToString: obj.name]){
//          NSMutableArray *list = [NSMutableArray array];
            SNBasketTeamRankResult *model = [[SNBasketTeamRankResult alloc]init];
            model.name = resultModel.name;
            model.tagName = obj.name;
            model.index = tempArray.count;
            model.list = list;
            [tempArray addObject:model];
            list = [NSMutableArray array];
            [list addObject:obj];
        }else if (lastModel && [lastModel.name isEqualToString: obj.name]) {
            [list addObject:obj];
        }
        lastModel = obj;
    }];
    return tempArray;
}

- (void)setupSubViews {
    self.view.backgroundColor = SRGB(251);
    
    CGFloat height = 0;
    if (self.playStatus == PlayingStatusAnimate) {
        height = kScreenHeight-kContentHeight-41-topHeight;
    }else if (self.playStatus == PlayingStatusLive) {
        height = kScreenHeight-kContentHeight-41-topHeight-kBottomHeight;
    }else {
        height = kScreenHeight-NavHeight-41-topHeight;
    }
    self.contentView = [[UIView alloc] initWithFrame:CGRectMake(12.5, topHeight, kScreenWidth-25, height)];
    [self.view addSubview:self.contentView];
    [self.contentView addRoundedCorners:UIRectCornerTopLeft | UIRectCornerTopRight withRadii:CGSizeMake(13, 13)];
    
    self.tableContentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth-25, height)];
    self.tableContentView.hidden = YES;
    self.tableContentView.backgroundColor = RGBA(225, 225, 225, 0.08);
    [self.contentView addSubview:self.tableContentView];
    [self.tableContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self.contentView);
    }];
    [self.tableContentView addRoundedCorners:UIRectCornerTopLeft withRadii:CGSizeMake(13, 13)];
    
    [self.tableContentView addSubview:self.leftTableView];
    [self.leftTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.equalTo(self.tableContentView);
        make.width.mas_equalTo(70);
    }];
    [self.tableContentView addSubview:self.rightTableView];
    [self.rightTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.equalTo(self.tableContentView);
        make.left.equalTo(self.leftTableView.mas_right);
    }];
    
    SNExampleTopSelectView *switchView = [[SNExampleTopSelectView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2 - 115 - 5, 5, 115, 30)]; 
    switchView.buttonHeight = 24;
    switchView.buttonWidth = 45;
    switchView.notScroll = YES;
    switchView.marginTop = 3;
    switchView.contentViewColor = Blue_Color;
    switchView.textColor = UIColor.whiteColor;
    switchView.marginLeft = 2;
    [switchView reloadDataWithArray:@[@"常规赛",@"季后赛"]];
    self.switchView = switchView;
    switchView.hidden = YES;
    [self.contentView addSubview:switchView];
    
    SNExampleTopSelectView *switchView1 = [[SNExampleTopSelectView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2 + 5, 5, 115, 30)];
    switchView1.contentViewColor = Blue_Color;
    switchView1.textColor = UIColor.whiteColor;
    switchView1.marginLeft = 3;
    switchView1.buttonHeight = 24;
    switchView1.buttonWidth = 45;
    switchView1.notScroll = YES;
    switchView1.marginTop = 3;
    [switchView1 reloadDataWithArray:@[@"场均",@"总数"]];
    self.switchView1 = switchView1;
    switchView1.hidden = YES;
    [self.contentView addSubview:switchView1];
     
}

- (void)setupTopSelectView {
    SNExampleTopSelectView *topSelectView = [[SNExampleTopSelectView alloc] initWithFrame:CGRectMake(0, 10, kScreenWidth, 40)];
    self.topSelectView = topSelectView;
    NSArray *titleArray = @[@"球队榜",@"球员榜",@"伤停榜",@"日榜"];
    [topSelectView reloadDataWithArray:titleArray];
    WeakSelf
    topSelectView.clickWithTag = ^(NSInteger tag) {
        weakSelf.tableContentView.hidden = YES;
        [KYRemindView dismiss];
        [self relayoutSubviews:[titleArray[tag] isEqualToString:@"历史榜"]];
        SNBasketRankType rankType = tag+1;
        [weakSelf getExampleData:rankType];
    };
    
    [self.view addSubview:topSelectView];
    
  
    
}

- (void)relayoutSubviews:(BOOL)showSwitch{

    self.switchView.hidden = self.switchView1.hidden  = !showSwitch;
    CGFloat topY = showSwitch?50:0;
    [self.tableContentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(topY);
    }];
}

- (void)updateScrollViewHeight:(PlayingStatus)playStatus {
    _playStatus = playStatus;
    if (playStatus == PlayingStatusAnimate) {
        self.contentView.height = kScreenHeight-kContentHeight-41-topHeight;
    }else if (playStatus == PlayingStatusLive) {
        self.contentView.height = kScreenHeight-kContentHeight-41-topHeight-kBottomHeight;
    }else {
        self.contentView.height = kScreenHeight-NavHeight-41-topHeight;
    }
}

#pragma mark 手势,是否支持多个手手势共存
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        return YES;
    }
    return NO;
}
 
#pragma mark - <UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView == self.leftTableView) {
        return 1;
    }
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.leftTableView) {
        return self.dataSource.count;
    }
    SNBasketTeamRankResult *resultModel = self.dataSource[section];
    return resultModel.listCount == 0? 1 : resultModel.listCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.leftTableView) {
        SNExampleLeftTableViewCell *cell = [SNExampleLeftTableViewCell cellWithTableView:tableView];
        SNBasketTeamRankResult *resultModel = self.dataSource[indexPath.row];
        cell.selectionStyle = 0;
        cell.titleLabel.text = self.rankType == SNBasketRankTypeInjuries? resultModel.team_name :resultModel.name;
        return cell;
    }
    
    SNBasketTeamRankResult *resultModel = self.dataSource[indexPath.section];
    if (resultModel.listCount == 0) {
        static NSString *customXibCellIdentifier = @"CustomXibCellIdentifier";//建立标志符
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:customXibCellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:customXibCellIdentifier];
        }
        return cell;
    }
    resultModel.rankType = self.rankType;
    SNExampleBaseModel *model = resultModel.list[indexPath.row];
    model.indexPath = indexPath;
    model.reuseCellId = resultModel.reuseCellType;
    model.rankType = self.rankType;
    
    SNExampleBaseTableViewCell *cell = [SNExampleBaseTableViewCell cellWithTableView:tableView exampleModel:model];
    cell.backgroundColor = UIColor.clearColor;
    if (indexPath.row % 2 == 0) {
        cell.backgroundColor = UIColor.whiteColor;
    }
    [cell configureModelData:model];
    
    return cell;

}

#pragma mark - <UITableViewDelegate>
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.leftTableView) {
        SNBasketTeamRankResult *resultModel = self.dataSource[indexPath.row];
        if ([resultModel.name isEqualToString:@"分区排行"] && resultModel.index>0) {
            return 0;
        }else {
            return 42.5;
        }
    }
    SNBasketTeamRankResult *resultModel = self.dataSource[indexPath.section];
    if (resultModel.listCount == 0) {
        return 0;
    }
    if (self.rankType == SNBasketRankTypeTeam) {
        return 40;
    }
    return 55; 
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.leftTableView) {
        _isSelectSlide = YES;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"datasSectionBtnSelected" object:nil];
        [self.leftTableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            CGRect frame = [self.rightTableView rectForSection:indexPath.row];
            CGFloat cha = self.rightTableView.contentSize.height - frame.origin.y;
            if (cha > self.rightTableView.height) {
                SNBasketTeamRankResult *resultModel = self.dataSource[indexPath.row];
                if (resultModel.listCount == 0) {
                    [self.rightTableView setContentOffset:CGPointMake(0,frame.origin.y) animated:YES];
                }else {
                    [self.rightTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:indexPath.row] animated:YES scrollPosition:UITableViewScrollPositionTop];
                } 
            }else {
                CGPoint point = CGPointMake(0, self.rightTableView.contentSize.height-self.rightTableView.height+xBottomHeight);
                [self.rightTableView setContentOffset:point animated:YES];
            }
        });
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (tableView == self.leftTableView) {
        return nil;
    }
    SNBasketTeamRankResult *resultModel = self.dataSource[section];
    resultModel.rankType = self.rankType;
    SNExampleBaseHeaderView *headerView = [SNExampleBaseHeaderView headerWithTableView:tableView exampleModel:resultModel];
    headerView.backgroundColor = UIColor.whiteColor;
    headerView.model = resultModel;
    return headerView;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView == self.leftTableView) {
        return 0;
    }
    return 42.5;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (tableView == self.leftTableView) {
        return nil;
    }
    
    SNBasketTeamRankResult *resultModel = self.dataSource[section];
    if (![resultModel.reuseSectionHeaderType isEqualToString:@"SNPlayerDefenHeaderView"]) {
        return nil;
    }
    
    if (self.rankType == SNBasketRankTypeDay) {
        return nil;
    }
    
  
    SNExampleMoreFooterView *footerView = [[SNExampleMoreFooterView alloc]initWithReuseIdentifier:@"SNMoreFooter"];
    footerView.model = resultModel;
    WeakSelf
    footerView.clickedMoreBlock = ^(SNBasketTeamRankResult * _Nonnull model) {
        SNExampleMoreListViewController *moreListVc = [[SNExampleMoreListViewController alloc]init];
        moreListVc.model = model;
        [weakSelf.navigationController pushViewController:moreListVc animated:YES];
    };

    return footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (tableView == self.leftTableView) {
        return 0;
    }
    SNBasketTeamRankResult *resultModel = self.dataSource[section];
    
    if (self.rankType == SNBasketRankTypeDay) {
        return 0;
    }
    
    if (![resultModel.reuseSectionHeaderType isEqualToString:@"SNPlayerDefenHeaderView"]) {
        return 0;
    }
    
    return 42.5;
}


#pragma mark - JXPagerViewListViewDelegate

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    _isSelectSlide = NO;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat y = scrollView.contentOffset.y;
    if (y > 0) {
        self.scrollCallback(scrollView);
    }
    if (scrollView == self.rightTableView) {
        NSArray *itemArray = self.rightTableView.indexPathsForVisibleRows;
//        NSLog(@"yxy == %lf",y);
        if (itemArray.count > 0) {
            //1:找到indexPath
            NSMutableArray *sectionArray = [NSMutableArray array];
            for (NSIndexPath *indexPath in itemArray) {
                [sectionArray addObject:[NSString stringWithFormat:@"%ld",(long)(indexPath.section)]];
            }
            //2:可见的第一个section位置 判断最小的section 就是需要滚动的
            NSInteger section  = [[sectionArray valueForKeyPath:@"@min.integerValue"] integerValue] ;
            if (!_isSelectSlide) {
                SNBasketTeamRankResult *resultModel = self.dataSource[section];
                if ([resultModel.name isEqualToString:@"分区排行"] && resultModel.index>0) {
                    section = section - resultModel.index;
                }
                //只有拖拽的时候，才执行该方法
                [self.leftTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:section inSection:0] animated:NO scrollPosition:UITableViewScrollPositionMiddle];
            }
        }
    }
}

- (UIScrollView *)listScrollView {
    return self.leftTableView;
}

- (void)listViewDidScrollCallback:(void (^)(UIScrollView *))callback {
    self.scrollCallback = callback;
}

- (UIView *)listView {
    return self.view;
}

- (UITableView *)leftTableView {
    if (!_leftTableView) {
        //44是page的高度
        _leftTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _leftTableView.contentInset = UIEdgeInsetsMake(0, 0, xBottomHeight, 0);
        _leftTableView.backgroundColor = SRGB(241);
        _leftTableView.separatorStyle = 0;
        _leftTableView.delegate = self;
        _leftTableView.dataSource = self;
        //设置自动计算行号模式
        _leftTableView.rowHeight = UITableViewAutomaticDimension;
        [_leftTableView registerNib:[UINib nibWithNibName:@"SNExampleLeftTableViewCell" bundle:nil] forCellReuseIdentifier:@"SNExampleLeftTableViewCell"];
        //设置预估行高
        _leftTableView.estimatedRowHeight = 200;
        _leftTableView.showsVerticalScrollIndicator = NO;
        if (@available(iOS 11.0, *)) {
            _leftTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        
    }
    return _leftTableView;
}

- (UITableView *)rightTableView {
    if (!_rightTableView) {
        //44是page的高度
        _rightTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _rightTableView.contentInset = UIEdgeInsetsMake(0, 0, xBottomHeight, 0);
        _rightTableView.backgroundColor = UIColor.clearColor;
        _rightTableView.separatorStyle = 0;
        _rightTableView.delegate = self;
        _rightTableView.dataSource = self;
        //设置自动计算行号模式
        _rightTableView.rowHeight = UITableViewAutomaticDimension;
        [_rightTableView registerNib:[UINib nibWithNibName:@"SNExampleLeftTableViewCell" bundle:nil] forCellReuseIdentifier:@"SNExampleLeftTableViewCell"];
        //设置预估行高
        _rightTableView.estimatedRowHeight = 200;
        _rightTableView.showsVerticalScrollIndicator = NO;
        if (@available(iOS 11.0, *)) {
            _rightTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        
    }
    return _rightTableView;
}

- (NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

@end
