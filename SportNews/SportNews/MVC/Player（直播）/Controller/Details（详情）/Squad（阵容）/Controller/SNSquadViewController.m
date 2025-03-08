//
//  SNSquadViewController.m
//  SportNews
//
//  Created by kkk on 2021/2/5.
//

#import "SNSquadViewController.h"
#import "SNSquadFirstRoundCell.h"
#import "SNDatasSimpleHeaderView.h"
#import "SNSquadTopTableViewCell.h"
#import "SNSquadHuanrenTableViewCell.h"
#import "SNSquadTibuTableViewCell.h"
#import "SNSquadShangtingTableViewCell.h"
#import "SNUserWebViewController.h"

extern NSString *talkWebUrl;

@interface SNSquadViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, copy) void(^scrollCallback)(UIScrollView *scrollView);

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray                   *dataSource;

@property(nonatomic, strong) SNSquadModel *squadModel;

@property(nonatomic, strong) UIView *tBackgroundView;

@property(nonatomic, assign) BOOL isFailure;

@property(nonatomic, strong) NSArray *sectionTitleArray;

@property(nonatomic, strong) UILabel *remindLabel;

@property (nonatomic , assign) NSInteger tibuCount;
@property (nonatomic, strong) UIView *talkBaseView;
@property (nonatomic, strong) SNUserWebViewController *talkWebVC;

@end

@implementation SNSquadViewController

static NSString *SNSquadFirstRoundCellId = @"SNSquadFirstRoundCell";

- (void)viewDidLoad {
    [super viewDidLoad];

    if (self.playStatus == PlayingStatusLive) {
        self.talkBaseView = [[UIView alloc]initWithFrame:CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y, self.view.bounds.size.width, kScreenHeight-kContentHeight-41-kBottomHeight)];
    } else {
        self.talkBaseView = [[UIView alloc]initWithFrame:CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y, self.view.bounds.size.width, kScreenHeight-kContentHeight-41)];
    }

    self.talkBaseView.backgroundColor = UIColor.clearColor;

    // self.talkBaseVC = [[TalkBaseViewController alloc]initWithNibName:@"TalkBaseViewController" bundle:nil];

    self.talkWebVC = [[SNUserWebViewController alloc]init];
    self.talkWebVC.url = talkWebUrl;

    [self setupSubViews];
    
    [self prepareHeader];
    
    [self getSquadData];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showTalkBaseView) name:@"ShowTalkBaseView" object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideTalkBaseView) name:@"HideTalkBaseView" object:nil];

}

- (void)showTalkBaseView {
    [self hideTalkBaseView];
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
}

//加载阵容的数据
- (void)getSquadData {
    
    NSDictionary *param1 = @{
        @"mid" : self.model.ID,
        @"type" : self.model.type,
        @"tabtype" : @5   
    };
    [KYApiHttpTool GET:URL_Detail_Tabs withParams:param1 success:^(NSDictionary * _Nonnull response) {
        SNSquadModel *squadModel = [SNSquadModel mj_objectWithKeyValues:response[@"data"]];
        self.squadModel = squadModel;
        [self.tableView.mj_header endRefreshing];
        if (self.tBackgroundView.superview) {
            [self.tBackgroundView removeFromSuperview];
        }
    } failure:^(NSError * _Nonnull error) {
        [self loadDataFailure];
    }];
}
 
- (void)setupSubViews {
    
    CGFloat height = 0;
    if (self.playStatus == PlayingStatusAnimate) {
        height = kScreenHeight-kContentHeight-41;
    }else if (self.playStatus == PlayingStatusLive) {
        height = kScreenHeight-kContentHeight-41-kBottomHeight;
    }else {
        height = kScreenHeight-NavHeight-41;
    }
    self.tableView.frame = CGRectMake(0, 0, kScreenWidth, height);
    [self.view addSubview:self.tableView];
    
    self.tBackgroundView = [self setupEmptyViewWithFrame:CGRectMake(0, 110, kScreenWidth, 180) title:@"阵容数据加载中..."];
    [self.tableView addSubview:self.tBackgroundView];
}

- (void)prepareHeader {
    MJRefreshNormalHeader *Header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(reloadDatas)];
    Header.lastUpdatedTimeLabel.hidden = YES;
    self.tableView.mj_header = Header;
    [self.tableView.mj_header endRefreshing];
}

- (void)reloadDatas {
    [self getSquadData];
}

- (void)setSquadModel:(SNSquadModel *)squadModel {
    _squadModel = squadModel;
    //@"首发阵容" 本场换人 本场替补 伤停信息
    NSMutableArray *titleArray = [NSMutableArray array];
    if (squadModel.home_zhengxing.count && squadModel.away_zhengxing.count) {
        NSMutableArray *tempArray = [NSMutableArray arrayWithCapacity:2];
        [tempArray addObject:squadModel.home_zhengxing];
        [tempArray addObject:squadModel.away_zhengxing];
        [self.dataSource addObject:tempArray];
        [titleArray addObject:@"首发阵容"];
    }
    
    //本场换人
    if (squadModel.home_huanren.count > 0) {
        [titleArray addObject:@"本场换人"];
    }
    if (squadModel.away_huanren.count > 0) {
        if (![titleArray containsObject:@"本场换人"]) {
            [titleArray addObject:@"本场换人"];
        }
    }
    
    //本场替补
    if (squadModel.home_tibu.count > 0) {
        [titleArray addObject:@"本场替补"];
    }
    if (squadModel.away_tibu.count > 0) {
        if (![titleArray containsObject:@"本场替补"]) {
            [titleArray addObject:@"本场替补"];
        }
    }
    //等到最大的那个
    self.tibuCount = MAX(squadModel.home_tibu.count, squadModel.away_tibu.count);
    
    //伤停信息
    if (squadModel.home_injury.count > 0) {
        [titleArray addObject:@"伤停信息"];
    }
    if (squadModel.away_injury.count > 0) {
        if (![titleArray containsObject:@"伤停信息"]) {
            [titleArray addObject:@"伤停信息"];
        }
    }
    
    self.sectionTitleArray = titleArray;
    [self.tableView reloadData];
    
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
    if (self.squadModel == nil) {
        self.tBackgroundView = [self setupEmptyViewWithFrame:CGRectMake(0, 110, kScreenWidth, 180) title:@"加载失败，点击重新加载"];
        [self.tableView addSubview:self.tBackgroundView];
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
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(reloadData)];
        [backView addGestureRecognizer:tap];
    }
    return backView;
}

- (void)reloadData {
    self.tBackgroundView = [self setupEmptyViewWithFrame:CGRectMake(0, 110, kScreenWidth, 180) title:@"阵容数据加载中..."];
    [self.tableView addSubview:self.tBackgroundView];
    [self getSquadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sectionTitleArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSString *titleStr = [self.sectionTitleArray objectAtIndex:section];
    if ([titleStr isEqualToString:@"首发阵容"]) {
        return 2;
    }else if ([titleStr isEqualToString:@"本场换人"]) {
        NSInteger count = 1;
        if (self.squadModel.home_huanren.count > 0) {
            count = self.squadModel.home_huanren.count + count;
        }
        if (self.squadModel.away_huanren.count > 0) {
            count = 1 + count;
            count = self.squadModel.away_huanren.count + count;
        }
        return count;
    }else if ([titleStr isEqualToString:@"本场替补"]) {
        return self.tibuCount+1;
    }else if ([titleStr isEqualToString:@"伤停信息"]) {
        NSInteger count = 1;
        if (self.squadModel.home_injury.count > 0) {
            count = self.squadModel.home_injury.count + count;
        }
        if (self.squadModel.away_injury.count > 0) {
            count = 1 + count;
            count = self.squadModel.away_injury.count + count;
        }
        return count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *titleStr = [self.sectionTitleArray objectAtIndex:indexPath.section];
    if ([titleStr isEqualToString:@"首发阵容"]) {
        SNSquadFirstRoundCell *cell = [[SNSquadFirstRoundCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SNSquadFirstRoundCellId cellType:indexPath.row];
        cell.tag = indexPath.row + 1;
        NSArray *tempArray = [self.dataSource objectAtIndex:indexPath.section][indexPath.row];
        cell.squadModel = self.squadModel;
        cell.model = self.model;
        cell.dataSource = tempArray;
        return cell;
    }else if ([titleStr isEqualToString:@"本场换人"]) {
        if (indexPath.row == 0 || indexPath.row == self.squadModel.home_huanren.count+1) {
            //第一行 //中间那个
            SNSquadTopTableViewCell *cell = [SNSquadTopTableViewCell cellWithTableView:tableView];
            cell.selectionStyle = 0;
            cell.isTop = indexPath.row == 0? YES:NO;
            if (self.squadModel.home_huanren.count == 0) {
                cell.isTop = YES;
            }
            cell.model = self.model;
            [cell cellIsTiBu:NO];
            return cell; 
        }
        
        SNSquadHuanrenTableViewCell *cell = [SNSquadHuanrenTableViewCell cellWithTableView:tableView];
        cell.selectionStyle = 0;
        if (indexPath.row <= self.squadModel.home_huanren.count + 1) {
            //赋值 主队
            SNSquadPersonInfoModel *personModel = self.squadModel.home_huanren[indexPath.row-1];
            personModel.isaway_type = NO;
            cell.personModel = personModel;
//            [cell cellIsHomeTeam:YES];
        }else {
            NSInteger index = self.squadModel.home_huanren.count + 2;
            SNSquadPersonInfoModel *personModel = self.squadModel.away_huanren[indexPath.row-index];
            personModel.isaway_type = YES;
            cell.personModel = personModel;
//            [cell cellIsHomeTeam:NO];
        }
        
        if (indexPath.row == self.squadModel.home_huanren.count+self.squadModel.away_huanren.count+1) {
            [cell cellIsLastOne:YES];
        }else {
            [cell cellIsLastOne:NO];
        }
        
        return cell;
        
    }else if ([titleStr isEqualToString:@"本场替补"]) {
        if (indexPath.row == 0) {
            //第一行
            SNSquadTopTableViewCell *cell = [SNSquadTopTableViewCell cellWithTableView:tableView];
            cell.selectionStyle = 0;
            cell.model = self.model;
            cell.isTop = YES;
            [cell cellIsTiBu:YES];
            return cell;
        }
        
        SNSquadTibuTableViewCell *cell = [SNSquadTibuTableViewCell cellWithTableView:tableView];
        cell.selectionStyle = 0;
        if (indexPath.row <= self.squadModel.home_tibu.count) {
            [cell hideHomeSubView:NO];
            cell.hPersonModel = self.squadModel.home_tibu[indexPath.row-1];
        }else {
            [cell hideHomeSubView:YES];
        }
        if (indexPath.row <= self.squadModel.away_tibu.count) {
            [cell hideAwaySubView:NO];
            cell.aPersonModel = self.squadModel.away_tibu[indexPath.row-1];
        }else {
            [cell hideAwaySubView:YES];
        }
        if (indexPath.row == self.tibuCount) {
            [cell cellIsLastOne:YES];
        }else {
            [cell cellIsLastOne:NO];
        }
        
        return cell;
         
    }else if ([titleStr isEqualToString:@"伤停信息"]) {
        if (indexPath.row == 0 || indexPath.row == self.squadModel.home_injury.count+1) {
            //第一行 //中间那个
            SNSquadTopTableViewCell *cell = [SNSquadTopTableViewCell cellWithTableView:tableView];
            cell.selectionStyle = 0;
            cell.isTop = indexPath.row == 0? YES:NO;
            if (self.squadModel.home_injury.count == 0) {
                cell.isTop = YES;
            }
            cell.model = self.model;
            [cell cellIsTiBu:NO];
            return cell;
        }
        
        SNSquadShangtingTableViewCell *cell = [SNSquadShangtingTableViewCell cellWithTableView:tableView];
        cell.selectionStyle = 0;
        if (indexPath.row <= self.squadModel.home_injury.count + 1) {
            //赋值 主队
            cell.personModel = self.squadModel.home_injury[indexPath.row-1];
            [cell cellIsHomeTeam:YES];
        }else {
            NSInteger index = self.squadModel.home_injury.count + 2;
            cell.personModel = self.squadModel.away_injury[indexPath.row-index];
            [cell cellIsHomeTeam:NO];
        }
        if (indexPath.row == self.squadModel.home_injury.count+self.squadModel.away_injury.count+1) {
            [cell cellIsLastOne:YES];
        }else {
            [cell cellIsLastOne:NO];
        }
        
        return cell;
        
    }
    return [[UITableViewCell alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *titleStr = [self.sectionTitleArray objectAtIndex:indexPath.section];
    if ([titleStr isEqualToString:@"首发阵容"]) {
        return SCREEN_WIDTH*483/375;
    }else if ([titleStr isEqualToString:@"本场换人"]) {
        if (indexPath.row == 0) {
            //第一行top
            if (self.squadModel.home_huanren.count == 0) {
                return 0;
            }
            return 60;
        }else if (indexPath.row == self.squadModel.home_huanren.count+1) {
            //客队的第一行top
            return 60;
        }else if (indexPath.row == self.squadModel.home_huanren.count+self.squadModel.away_huanren.count+1) {
            //最后一行
            return 74;
        }
        return 64;
    }else if ([titleStr isEqualToString:@"本场替补"]) {
        if (indexPath.row == 0) {
            //第一行
            return 60;
        }
        if (indexPath.row == self.tibuCount) {
            //最后一行
            return 74;
        }
        return 64;
    }else if ([titleStr isEqualToString:@"伤停信息"]) {
        if (indexPath.row == 0) {
            //第一行top
            if (self.squadModel.home_injury.count == 0) {
                return 0;
            }
            return 60;
        }else if (indexPath.row == self.squadModel.home_injury.count+1) {
            //客队的第一行top
            return 60;
        }else if (indexPath.row == self.squadModel.home_injury.count+self.squadModel.away_injury.count+1) {
            //最后一行
            return 67;
        }
        return 57;
    }
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    SNDatasSimpleHeaderView *headerView = [[SNDatasSimpleHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 46)];
    headerView.titleLabel.text = self.sectionTitleArray[section];
    headerView.subTitleLabel.hidden = YES;
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 46;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

}

#pragma mark - JXPagerViewListViewDelegate
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

- (NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (UITableView *)tableView {
    
    if (!_tableView) {
        //44是page的高度
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, xBottomHeight, 0);
        _tableView.backgroundColor = SRGB(248);
        _tableView.separatorStyle = 0;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        //设置自动计算行号模式
        _tableView.rowHeight = UITableViewAutomaticDimension;
        [_tableView registerNib:[UINib nibWithNibName:@"SNSquadTopTableViewCell" bundle:nil] forCellReuseIdentifier:@"SNSquadTopTableViewCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"SNSquadHuanrenTableViewCell" bundle:nil] forCellReuseIdentifier:@"SNSquadHuanrenTableViewCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"SNSquadTibuTableViewCell" bundle:nil] forCellReuseIdentifier:@"SNSquadTibuTableViewCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"SNSquadShangtingTableViewCell" bundle:nil] forCellReuseIdentifier:@"SNSquadShangtingTableViewCell"];
        //设置预估行高
        _tableView.estimatedRowHeight = 200;
        _tableView.showsVerticalScrollIndicator = NO; 
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _tableView;
}




@end
