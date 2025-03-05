//
//  LiveDatasViewController.m
//  SportNews
//
//  Created by kkk on 2021/1/16.
//

#import "LiveDatasViewController.h"
#import "SNDatasSimpleHeaderView.h"
#import "SNDatasHistoryTableViewCell.h"
#import "SNDatasWinFailTableViewCell.h"
#import "SNDatasScheduleTableViewCell.h"
#import "SNDatasFootPointRankTableViewCell.h"
#import "SNDatasFootHistoryTableViewCell.h"
#import "SNDatasFootScoreTableViewCell.h"
#import "SNDatasDescribeTableViewCell.h"
#import "SNDatasFootTeamTopTableViewCell.h"
#import "SNDatasScheduleTeamTopTableViewCell.h"
#import "SNDatasWinFailTeamTopTableViewCell.h"
#import "SNDatasHistoryTeamTopTableViewCell.h"
#import "SNDatasHistoryJiaoFengTopTableViewCell.h"
#import "SNDatasFootInjuryTeamTopTableViewCell.h"
#import "SNDatasFootInjuryTableViewCell.h"
#import "SNTeamCompareTableViewCell.h"
#import "SNTeamGeneralRankTableViewCell.h"

@interface LiveDatasViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, copy) void(^scrollCallback)(UIScrollView *scrollView);

@property (nonatomic, strong) UITableView *tableView;
 
@property(nonatomic, strong) SNDatasModel *datasModel;

//数据信息
@property (nonatomic, strong) NSMutableArray *datasArray;

@property(nonatomic, strong) UIView *tBackgroundView;

@property(nonatomic, strong) NSArray *sectionTitleArray;
@property(nonatomic, strong) NSArray *screenTitleArray;

@property(nonatomic, assign) BOOL isFailure;

// 历史交锋
@property(nonatomic, strong) NSArray *vsArray;
//历史交锋下面的文字
@property(nonatomic, copy) NSString *vsContent;
//是否同住客 ----- 历史交锋
@property(nonatomic, assign) BOOL isVsTongZhu;
//是否同赛事
@property(nonatomic, assign) BOOL isVsTongSai;
//足球10场 20场 篮球全场 半场 yes 就是选择的后项
@property(nonatomic, assign) BOOL isVsButtonSelect;

//主队 近期战绩
@property(nonatomic, strong) NSArray *homeArray;
//历史交锋下面的文字
@property(nonatomic, copy) NSString *homeContent;
//是否同住客 ----- 主队近期战绩
@property(nonatomic, assign) BOOL isHomeTongZhu;
//是否同赛事
@property(nonatomic, assign) BOOL isHomeTongSai;
//足球10场 20场 篮球全场 半场 yes 就是选择的后项
@property(nonatomic, assign) BOOL isHomeButtonSelect;

//客队 近期战绩
@property(nonatomic, strong) NSArray *awayArray;
//历史交锋下面的文字
@property(nonatomic, copy) NSString *awayContent;
//是否同住客 ----- 客队近期战绩
@property(nonatomic, assign) BOOL isAwayTongZhu;
//是否同赛事
@property(nonatomic, assign) BOOL isAwayTongSai;
//足球10场 20场 篮球全场 半场 yes 就是选择的后项
@property(nonatomic, assign) BOOL isAwayButtonSelect;
 
//主队伤停情况
@property(nonatomic, strong) NSArray *injuryHomeArray;
//客队伤停情况
@property(nonatomic, strong) NSArray *injuryAwayArray;

//主队近期赛程
@property(nonatomic, strong) NSArray *scheduleHomeArray;
//客队近期赛程
@property(nonatomic, strong) NSArray *scheduleAwayArray;

//半全场胜负
@property(nonatomic, strong) NSArray *wfArray;
//是否同住客 ----- WF 半全场胜负
@property(nonatomic, assign) BOOL isWFTongZhu;
//是否同赛事
@property(nonatomic, assign) BOOL isWFTongSai;
//足球10场 20场 篮球全场 半场 yes 就是选择的后项
@property(nonatomic, assign) BOOL isWFButtonSelect;

//胜分差
@property(nonatomic, strong) NSArray *shengArray;
//是否同住客 ----- 胜分差
@property(nonatomic, assign) BOOL isShengTongZhu;
//是否同赛事
@property(nonatomic, assign) BOOL isShengTongSai;
//足球10场 20场 篮球全场 半场 yes 就是选择的后项
@property(nonatomic, assign) BOOL isShengButtonSelect;

@property(nonatomic, assign) NSInteger nowSection;
@property(nonatomic, strong) UIButton *shouBtn;
@property(nonatomic, strong) UIButton *nowSelectBtn;
@property(nonatomic, strong) UIView *screenView;
@property(nonatomic, strong) UIView *contentView;

@property(nonatomic, strong) NSTimer *timer;

@property(nonatomic, assign) BOOL leaveSelf;

@end

@implementation LiveDatasViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupSubViews];
    
    [self prepareHeader];
    
}

- (void)setupSubViews {
    CGFloat height = 0;
    if (self.playStatus == PlayingStatusAnimate) {
        height = kScreenHeight-kContentHeight-41;
    }else if (self.playStatus == PlayingStatusLive) {
        height = kScreenHeight-kContentHeight-41-kBottomHeight;
    }else {
        // height = kScreenHeight-NavHeight-41;
        height = kScreenHeight-kContentHeight-41;
    }
    self.tableView.frame = CGRectMake(0, 0, kScreenWidth, height);
    [self.view addSubview:self.tableView];
    if (self.datasModel == nil) {
        self.tBackgroundView = [self setupEmptyViewWithFrame:CGRectMake(0, 110, kScreenWidth, 180) title:@"数据加载中..."];
        [self.tableView addSubview:self.tBackgroundView];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self loadDataFailure];
        });
    }else {
        [self setupDatasModel:self.datasModel];
    }
    
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

- (void)setupDatasModel:(SNDatasModel *)datasModel {
    _datasModel = datasModel;
    [self.tableView.mj_header endRefreshing];
    if (self.tBackgroundView.superview) {
        [self.tBackgroundView removeFromSuperview];
    }
    if (self.model.type.intValue == 1) {
        //顺序[@"进球分布",@"积分排名",@"历史交锋",@"近期战绩",@"伤停情况",@"近期赛程",@"半全场胜负"];
        NSMutableArray *titleArray = [NSMutableArray array];
        NSMutableArray *titleArray1 = [NSMutableArray array];
        if (self.datasModel.goal_distribution.away) {
            [titleArray addObject:@"进球分布"];
            [titleArray1 addObject:@"进球"];
        }
       
        if (self.datasModel.table.season.length >= 1) {
            [titleArray addObject:@"积分排名"];
            [titleArray1 addObject:@"积分"];
        }
        
        [self screeningVsArray:NO];
        if (self.vsArray.count > 0) {
            [titleArray addObject:@"历史交锋"];
            [titleArray1 addObject:@"交锋"];
        }
        
        [self screeningHomeArray:NO];
        if (self.homeArray.count > 0) {
            [titleArray addObject:@"近期战绩"];
            [titleArray1 addObject:@"战绩"];
        }
        
        [self screeningAwayArray:NO];
        if (self.awayArray.count > 0) {
            if (![titleArray containsObject:@"近期战绩"]) {
                [titleArray addObject:@"近期战绩"];
                [titleArray1 addObject:@"战绩"];
            }
        }
        
        self.injuryHomeArray = datasModel.injury.home;
        if (self.injuryHomeArray.count > 0) {
            [titleArray addObject:@"伤停情况"];
            [titleArray1 addObject:@"伤停"];
        }
        
        self.injuryAwayArray = datasModel.injury.away;
        if (self.injuryAwayArray.count > 0) {
            if (![titleArray containsObject:@"伤停情况"]) {
                [titleArray addObject:@"伤停情况"];
                [titleArray1 addObject:@"伤停"];
            }
        }
        if (self.datasModel.recent_match.away.count > 0 || self.datasModel.recent_match.home.count > 0) {
            self.scheduleAwayArray = self.datasModel.recent_match.away;
            self.scheduleHomeArray = self.datasModel.recent_match.home;
            [titleArray addObject:@"近期赛程"];
            [titleArray1 addObject:@"赛程"];
        }
        
        [self screeningWFArray:NO];
        if (self.wfArray.count > 0) {
            [titleArray addObject:@"半全场胜负"];
            [titleArray1 addObject:@"半全场"];
        }
        self.sectionTitleArray = titleArray;
        self.screenTitleArray = titleArray1;
         
    }else {
        //顺序[@"历史交锋",@"近期战绩",@"胜分差",@"半全场胜负"];
        NSMutableArray *titleArray = [NSMutableArray array];
        NSMutableArray *titleArray1 = [NSMutableArray array];
        
        if (datasModel.away_rank && datasModel.home_rank) {
            [titleArray addObject:@"球队概况"];
            [titleArray1 addObject:@"概况"];
        }
        if (datasModel.away_compare && datasModel.home_compare) {
            [titleArray addObject:@"场均数据对比"];
            [titleArray1 addObject:@"场均数据"];
        }
        
        [self screeningVsArray:NO];
        if (self.vsArray.count > 0) {
            [titleArray addObject:@"历史交锋"];
            [titleArray1 addObject:@"交锋"];
        }
        
        [self screeningAwayArray:NO];
        if (self.awayArray.count > 0) {
            [titleArray addObject:@"近期战绩"];
            [titleArray1 addObject:@"战绩"];
        }
        [self screeningHomeArray:NO];
        if (self.homeArray.count > 0) {
            if (![titleArray containsObject:@"近期战绩"]) {
                [titleArray addObject:@"近期战绩"];
                [titleArray1 addObject:@"战绩"];
            }
        }
        
        [self screeningWFArray:NO];
        if (self.wfArray.count > 0) {
            [titleArray addObject:@"半全场胜负"];
            [titleArray1 addObject:@"半全场"];
        }
        
        self.sectionTitleArray = titleArray;
        self.screenTitleArray = titleArray1;
        
    }
    if (self.sectionTitleArray.count == 0 && datasModel != nil) {
        self.tBackgroundView = [self setupEmptyViewWithFrame:CGRectMake(0, 110, kScreenWidth, 180) title:@"暂无数据"];
        [self.tableView addSubview:self.tBackgroundView];
    }else if (self.sectionTitleArray.count == 0 && datasModel == nil && !_isFailure) {
        self.tBackgroundView = [self setupEmptyViewWithFrame:CGRectMake(0, 110, kScreenWidth, 180) title:@"暂无数据"];
        [self.tableView addSubview:self.tBackgroundView];
    }
    if (self.screenTitleArray.count > 0) {
        [self setupScreenView];
    }
    [self.tableView reloadData];
    
}

- (void)hideScreenView:(BOOL)isLeave {
    if (isLeave) {
        self.screenView.alpha = 0;
    }
    self.leaveSelf = isLeave;
}

//创建下面按个点击view
- (void)setupScreenView {
    if (self.screenView) {
        [self.screenView removeFromSuperview];
        self.screenView = nil;
    }
    UIView *screenView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 35)];
    self.screenView = screenView;
    screenView.alpha = 0;
    screenView.backgroundColor = UIColor.whiteColor;
    [self.detailView addSubview:screenView];
    UIButton *shouBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 0, 25, 30)];
    [shouBtn addTarget:self action:@selector(shouBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [shouBtn setImage:[UIImage imageNamed:@"收起-1"] forState:UIControlStateNormal];
    [screenView addSubview:shouBtn];
    shouBtn.centerY = screenView.centerY;
    CGFloat width = 0;
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(40, 0, 0, 35)];
    for (int i = 0; i < self.screenTitleArray.count; i++) {
        NSString *title = self.screenTitleArray[i];
        CGFloat w = [self evaluteWidth:title] + 6;
        UIButton *contentBtn = [[UIButton alloc] initWithFrame:CGRectMake(width, 2.5, w, 30)];
        [contentView addSubview:contentBtn];
        [contentBtn addTarget:self action:@selector(scrollBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [contentBtn setTitle:title forState:UIControlStateNormal];
        [contentBtn setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
        [contentBtn setTitleColor:Blue_Color forState:UIControlStateSelected];
        contentBtn.titleLabel.font = Font(12);
        contentBtn.layer.cornerRadius = 5;
        contentBtn.clipsToBounds = YES;
        contentBtn.centerY = contentView.centerY;
        if (i == 0) {
            self.nowSelectBtn = contentBtn;
            contentBtn.selected = YES;
            contentBtn.backgroundColor = RGBA(39, 197, 195, 0.1);
        }else {
            contentBtn.backgroundColor = UIColor.clearColor;
        }
        contentBtn.tag = i;
        width += w;
    }
    [screenView addSubview:contentView];
    self.contentView = contentView;
    contentView.centerY = screenView.centerY;
    contentView.width = width;
    [screenView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.detailView);
        make.bottom.equalTo(self.detailView).offset(-(xBottomHeight+15));
        make.height.mas_equalTo(35);
        make.width.mas_equalTo(width+45);
    }];
    screenView.layer.cornerRadius = 5;
    screenView.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.06].CGColor;
    screenView.layer.shadowOffset = CGSizeMake(0,2);
    screenView.layer.shadowOpacity = 0.5;
    
    
}

- (void)scrollBtnAction:(UIButton *)sender {
    if (sender.tag == self.nowSelectBtn.tag) {
        return;
    }
    sender.selected = YES;
    sender.backgroundColor = RGBA(39, 197, 195, 0.1);
    self.nowSelectBtn.selected = NO;
    self.nowSelectBtn.backgroundColor = UIColor.clearColor;
    self.nowSelectBtn = sender;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"datasSectionBtnSelected" object:nil];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:sender.tag];
    CGRect frame = [self.tableView rectForSection:indexPath.section];
    if (sender.tag == self.screenTitleArray.count-1) {
        CGFloat cha = self.tableView.contentSize.height - frame.origin.y;
        if (cha > self.tableView.height) {
            [self.tableView setContentOffset:CGPointMake(0,frame.origin.y) animated:YES];
        }else {
            CGPoint point = CGPointMake(0, self.tableView.contentSize.height-self.tableView.height+xBottomHeight);
            [self.tableView setContentOffset:point animated:NO];
        }
    }else {
        [self.tableView setContentOffset:CGPointMake(0,frame.origin.y) animated:NO];
    } 
}

- (void)shouBtnAction:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    if (sender.isSelected) {
        sender.transform = CGAffineTransformMakeRotation(M_PI);
        [self.screenView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.detailView).offset(kScreenWidth-40);
        }];
    }else {
        sender.transform = CGAffineTransformIdentity;
        [self.screenView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.detailView).offset((kScreenWidth-self.screenView.width)/2);
        }];
    }
}

// 获取tableView最上面悬停的SectionHeaderView
- (void)getNowTopSectionView {
    if (self.leaveSelf) {
        return;
    }
    NSArray <UITableViewCell *> *cellArray = [self.tableView visibleCells];
    NSInteger nowSection = -1;
    if (cellArray) {
        UITableViewCell *cell = [cellArray firstObject];
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        nowSection = indexPath.section;
    }
    self.screenView.alpha = 1;
    if (self.nowSection == nowSection) {
        return;
    }
    self.nowSection = nowSection;
    for (int i = 0; i < self.contentView.subviews.count; i++) {
        UIButton *sender = (UIButton *)self.contentView.subviews[i];
        if (nowSection == sender.tag) {
            sender.selected = YES;
            sender.backgroundColor = RGBA(39, 197, 195, 0.1);
            self.nowSelectBtn = sender;
        }else {
            sender.selected = NO;
            sender.backgroundColor = UIColor.clearColor;
        }
    }
}

- (CGFloat)evaluteWidth:(NSString *)text {
    NSDictionary *textAtt = @{NSFontAttributeName : Font(12)};
    CGSize evaluteSize = [text boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:textAtt context:nil].size;
    CGFloat evaluteW = evaluteSize.width + 1;
    return evaluteW;
}
//过滤历史交锋
- (void)screeningVsArray:(BOOL)reload {
    if (self.model.type.integerValue == 1) {
        NSArray *vsArray = self.datasModel.history.footVs;
        NSMutableArray *mutVsArray = [NSMutableArray array];
        if (self.isVsTongZhu) {
            [vsArray enumerateObjectsUsingBlock:^(SNDatasFootHistoryRecordModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (obj.hIds.integerValue == self.model.hteam_id.integerValue) {
                    [mutVsArray addObject:obj];
                }
            }];
            vsArray = [mutVsArray copy];
        }
        
        if (self.isVsTongSai) {
            [mutVsArray removeAllObjects];
            [vsArray enumerateObjectsUsingBlock:^(SNDatasFootHistoryRecordModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (obj.cid.integerValue == self.model.cid.integerValue) {
                    [mutVsArray addObject:obj];
                }
            }];
            vsArray = [mutVsArray copy];
        }
        //这个是十场 或者二十场
        if (self.isVsButtonSelect) {
            vsArray = [vsArray subarrayWithRange:NSMakeRange(0, vsArray.count > 20? 20:vsArray.count)];
        }else {
            vsArray = [vsArray subarrayWithRange:NSMakeRange(0, vsArray.count > 10? 10:vsArray.count)];
        }
        self.vsArray = vsArray;
        NSInteger count = vsArray.count;
        NSInteger __block fuCount = 0;//负
        NSInteger __block pingCount = 0;//平
        NSInteger __block jinCount = 0;//进
        NSInteger __block shiCount = 0;//负
        float __block shengLv = 0;
        float __block yingLv = 0;
        float __block daLv = 0;
        [vsArray enumerateObjectsUsingBlock:^(SNDatasFootHistoryRecordModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.hIds.integerValue == self.model.hteam_id.integerValue) {
                jinCount += obj.hScore.integerValue;
                shiCount += obj.aScore.integerValue;
                if (obj.hScore.integerValue > obj.aScore.integerValue) {
                    shengLv += 1;
                }else if (obj.hScore.integerValue == obj.aScore.integerValue) {
                    pingCount += 1;
                }else {
                    fuCount += 1;
                }
            }else if (obj.aIds.integerValue == self.model.hteam_id.integerValue) {
                jinCount += obj.aScore.integerValue;
                shiCount += obj.hScore.integerValue;
                if (obj.aScore.integerValue > obj.hScore.integerValue) {
                    shengLv += 1;
                }else if (obj.aScore.integerValue == obj.hScore.integerValue) {
                    pingCount += 1;
                }else {
                    fuCount += 1;
                }
            }
            if ([obj.describePan containsString:@"赢"]) {
                yingLv += 1;
            }
            if ([obj.describeQiu containsString:@"大"]) {
                daLv += 1;
            }
        }];
        NSString *shengSrt = [NSString stringWithFormat:@"%0.1f",(shengLv/count)*100];
        shengSrt = [shengSrt stringByAppendingString:@"%"];
        NSString *yingStr = [NSString stringWithFormat:@"%0.1f",((float)(yingLv/count))*100];
        yingStr = [yingStr stringByAppendingString:@"%"];
        NSString *daStr = [NSString stringWithFormat:@"%0.1f",((float)(daLv/count))*100];
        daStr = [daStr stringByAppendingString:@"%"];
        if (count == 0) {
            shengSrt = @"0%";
            yingStr = @"0%";
            daStr = @"0%";
        }
        self.vsContent = [NSString stringWithFormat:@"主队 近%ld场 %0.0f胜%ld平%ld负 进%ld球 失%ld球, 胜率%@赢率%@大率%@",count,shengLv,pingCount,fuCount,jinCount,shiCount,shengSrt,yingStr,daStr];
        
    }else {
        NSArray *vsArray = self.datasModel.result.basketVs;
        NSMutableArray *mutVsArray = [NSMutableArray array];
        if (self.isVsTongZhu) {
            [vsArray enumerateObjectsUsingBlock:^(SNDatasBasketHistoryRecordModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (obj.hIds.integerValue == self.model.hteam_id.integerValue) {
                    [mutVsArray addObject:obj];
                }
            }];
            vsArray = [mutVsArray copy];
        }
        
        self.vsArray = vsArray;
        NSInteger count = vsArray.count;
        NSInteger __block dan = 0;
        NSInteger __block shuang = 0;
        float __block shengLv = 0;
        float __block yingLv = 0;
        float __block daLv = 0;
        [vsArray enumerateObjectsUsingBlock:^(SNDatasBasketHistoryRecordModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.totalScoreQuan.integerValue%2 == 0) {
                shuang += 1;
            }else {
                dan += 1;
            }
            if (obj.aIds.integerValue == self.model.ateam_id.integerValue) {
                if (obj.hScore.intValue > obj.aScore.intValue) {
                    shengLv += 1;
                }
            }
            if (obj.hIds.integerValue == self.model.ateam_id.integerValue) {
                if (obj.hScore.intValue > obj.aScore.intValue) {
                    shengLv += 1;
                }
            }
            if ([obj.describeRang containsString:@"赢"]) {
                yingLv += 1;
            }
            if ([obj.describeZong containsString:@"大"]) {
                daLv += 1;
            }
        }];
        NSString *shengSrt = [NSString stringWithFormat:@"%0.1f",(shengLv/count)*100];
        shengSrt = [shengSrt stringByAppendingString:@"%"];
        NSString *yingStr = [NSString stringWithFormat:@"%0.1f",((float)(yingLv/count))*100];
        yingStr = [yingStr stringByAppendingString:@"%"];
        NSString *daStr = [NSString stringWithFormat:@"%0.1f",((float)(daLv/count))*100];
        daStr = [daStr stringByAppendingString:@"%"];
        if (count == 0) {
            shengSrt = @"0%";
            yingStr = @"0%";
            daStr = @"0%";
        }
        self.vsContent = [NSString stringWithFormat:@"近%ld场交锋 %ld单%ld双 %@，胜率%@赢率%@大率%@",count,dan,shuang,self.model.hteam_name,shengSrt,yingStr,daStr];
         
    }
    if (reload) {
        [self.tableView reloadData];
    }
}

//过滤主队近期战绩
- (void)screeningHomeArray:(BOOL)reload {
    if (self.model.type.integerValue == 1) {
        NSArray *homeArray = self.datasModel.history.footHome;
        NSMutableArray *mutHomeArray = [NSMutableArray array];
        if (self.isHomeTongZhu) {
            [homeArray enumerateObjectsUsingBlock:^(SNDatasFootHistoryRecordModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (obj.hIds.integerValue == self.model.hteam_id.integerValue) {
                    [mutHomeArray addObject:obj];
                }
            }];
            homeArray = [mutHomeArray copy];
        }
        if (self.isHomeTongSai) {
            [mutHomeArray removeAllObjects];
            [homeArray enumerateObjectsUsingBlock:^(SNDatasFootHistoryRecordModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (obj.cid.integerValue == self.model.cid.integerValue) {
                    [mutHomeArray addObject:obj];
                }
            }];
            homeArray = [mutHomeArray copy];
        }
        //这个是十场 或者二十场
        if (self.isHomeButtonSelect) {
            homeArray = [homeArray subarrayWithRange:NSMakeRange(0, homeArray.count > 20? 20:homeArray.count)];
        }else {
            homeArray = [homeArray subarrayWithRange:NSMakeRange(0, homeArray.count > 10? 10:homeArray.count)];
        }
        self.homeArray = homeArray;
        
        NSInteger count = homeArray.count;
        NSInteger __block fuCount = 0;//负
        NSInteger __block pingCount = 0;//平
        NSInteger __block jinCount = 0;//进
        NSInteger __block shiCount = 0;//负
        float __block shengLv = 0;
        float __block yingLv = 0;
        float __block daLv = 0;
        [homeArray enumerateObjectsUsingBlock:^(SNDatasFootHistoryRecordModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.hIds.integerValue == self.model.hteam_id.integerValue) {
                jinCount += obj.hScore.integerValue;
                shiCount += obj.aScore.integerValue;
                if (obj.hScore.integerValue > obj.aScore.integerValue) {
                    shengLv += 1;
                }else if (obj.hScore.integerValue == obj.aScore.integerValue) {
                    pingCount += 1;
                }else {
                    fuCount += 1;
                }
            }else if (obj.aIds.integerValue == self.model.hteam_id.integerValue) {
                jinCount += obj.aScore.integerValue;
                shiCount += obj.hScore.integerValue;
                if (obj.aScore.integerValue > obj.hScore.integerValue) {
                    shengLv += 1;
                }else if (obj.aScore.integerValue == obj.hScore.integerValue) {
                    pingCount += 1;
                }else {
                    fuCount += 1;
                }
            }
            if ([obj.describePan containsString:@"赢"]) {
                yingLv += 1;
            }
            if ([obj.describeQiu containsString:@"大"]) {
                daLv += 1;
            }
        }];
        NSString *shengSrt = [NSString stringWithFormat:@"%0.1f",(shengLv/count)*100];
        shengSrt = [shengSrt stringByAppendingString:@"%"];
        NSString *yingStr = [NSString stringWithFormat:@"%0.1f",((float)(yingLv/count))*100];
        yingStr = [yingStr stringByAppendingString:@"%"];
        NSString *daStr = [NSString stringWithFormat:@"%0.1f",((float)(daLv/count))*100];
        daStr = [daStr stringByAppendingString:@"%"];
        self.homeContent = [NSString stringWithFormat:@"主队 近%ld场 %0.0f胜%ld平%ld负 进%ld球 失%ld球, 胜率%@赢率%@大率%@",count,shengLv,pingCount,fuCount,jinCount,shiCount,shengSrt,yingStr,daStr];
        
    }else {
        NSArray *homeArray = self.datasModel.result.basketHome;
        NSMutableArray *mutHomeArray = [NSMutableArray array];
        if (self.isHomeTongZhu) {
            [homeArray enumerateObjectsUsingBlock:^(SNDatasBasketHistoryRecordModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (obj.hIds.integerValue == self.model.hteam_id.integerValue) {
                    [mutHomeArray addObject:obj];
                }
            }];
            homeArray = [mutHomeArray copy];
        }
        
        if (self.isHomeTongSai) {
            [mutHomeArray removeAllObjects];
            [homeArray enumerateObjectsUsingBlock:^(SNDatasBasketHistoryRecordModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (obj.cid.integerValue == self.model.cid.integerValue) {
                    [mutHomeArray addObject:obj];
                }
            }];
            homeArray = [mutHomeArray copy];
        }
        self.homeArray = homeArray;
        
        NSInteger count = homeArray.count;
        NSInteger __block dan = 0;
        NSInteger __block shuang = 0;
        float __block shengLv = 0;
        float __block yingLv = 0;
        float __block daLv = 0;
        [homeArray enumerateObjectsUsingBlock:^(SNDatasBasketHistoryRecordModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.totalScoreQuan.integerValue%2 == 0) {
                shuang += 1;
            }else {
                dan += 1;
            }
            if (obj.aIds.integerValue == self.model.ateam_id.integerValue) {
                if (obj.aScore.intValue > obj.aScore.intValue) {
                    shengLv += 1;
                }
            }
            if (obj.hIds.integerValue == self.model.ateam_id.integerValue) {
                if (obj.hScore.intValue > obj.aScore.intValue) {
                    shengLv += 1;
                }
            }
            if ([obj.describeRang containsString:@"赢"]) {
                yingLv += 1;
            }
            if ([obj.describeZong containsString:@"大"]) {
                daLv += 1;
            }
        }];
        NSString *shengSrt = [NSString stringWithFormat:@"%0.1f",(shengLv/count)*100];
        shengSrt = [shengSrt stringByAppendingString:@"%"];
        NSString *yingStr = [NSString stringWithFormat:@"%0.1f",((float)(yingLv/count))*100];
        yingStr = [yingStr stringByAppendingString:@"%"];
        NSString *daStr = [NSString stringWithFormat:@"%0.1f",((float)(daLv/count))*100];
        daStr = [daStr stringByAppendingString:@"%"];
        self.homeContent = [NSString stringWithFormat:@"主队近%ld场 %0.0f胜%0.0f负 %ld单%ld双 %@，胜率%@赢率%@大率%@",count,shengLv,count-shengLv,dan,shuang,self.model.hteam_name,shengSrt,yingStr,daStr];
    }
    
    if (reload) {
        [self.tableView reloadData];
    }
}

//过滤客队近期战绩
- (void)screeningAwayArray:(BOOL)reload {
     
    if (self.model.type.integerValue == 1) {
        NSArray *awayArray = self.datasModel.history.footAway;
        NSMutableArray *mutAwayArray = [NSMutableArray array];
        if (self.isAwayTongZhu) {
            [awayArray enumerateObjectsUsingBlock:^(SNDatasFootHistoryRecordModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (obj.aIds.integerValue == self.model.ateam_id.integerValue) {
                    [mutAwayArray addObject:obj];
                }
            }];
            awayArray = [mutAwayArray copy];
        }
        
        if (self.isAwayTongSai) {
            [mutAwayArray removeAllObjects];
            [awayArray enumerateObjectsUsingBlock:^(SNDatasFootHistoryRecordModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (obj.cid.integerValue == self.model.cid.integerValue) {
                    [mutAwayArray addObject:obj];
                }
            }];
            awayArray = mutAwayArray;
        }
        //这个是十场 或者二十场
        if (self.isAwayButtonSelect) {
            awayArray = [awayArray subarrayWithRange:NSMakeRange(0, awayArray.count > 20? 20:awayArray.count)];
        }else {
            awayArray = [awayArray subarrayWithRange:NSMakeRange(0, awayArray.count > 10? 10:awayArray.count)];
        }
        self.awayArray = awayArray;
        
        NSInteger count = awayArray.count;
        NSInteger __block fuCount = 0;//负
        NSInteger __block pingCount = 0;//平
        NSInteger __block jinCount = 0;//进
        NSInteger __block shiCount = 0;//负
        float __block shengLv = 0;
        float __block yingLv = 0;
        float __block daLv = 0;
        [awayArray enumerateObjectsUsingBlock:^(SNDatasFootHistoryRecordModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.hIds.integerValue == self.model.ateam_id.integerValue) {
                jinCount += obj.hScore.integerValue;
                shiCount += obj.aScore.integerValue;
                if (obj.hScore.integerValue > obj.aScore.integerValue) {
                    shengLv += 1;
                }else if (obj.hScore.integerValue == obj.aScore.integerValue) {
                    pingCount += 1;
                }else {
                    fuCount += 1;
                }
            }else if (obj.aIds.integerValue == self.model.ateam_id.integerValue) {
                jinCount += obj.aScore.integerValue;
                shiCount += obj.hScore.integerValue;
                if (obj.aScore.integerValue > obj.hScore.integerValue) {
                    shengLv += 1;
                }else if (obj.aScore.integerValue == obj.hScore.integerValue) {
                    pingCount += 1;
                }else {
                    fuCount += 1;
                }
            }
            if ([obj.describePan containsString:@"赢"]) {
                yingLv += 1;
            }
            if ([obj.describeQiu containsString:@"大"]) {
                daLv += 1;
            }
        }];
        NSString *shengSrt = [NSString stringWithFormat:@"%0.1f",(shengLv/count)*100];
        shengSrt = [shengSrt stringByAppendingString:@"%"];
        NSString *yingStr = [NSString stringWithFormat:@"%0.1f",((float)(yingLv/count))*100];
        yingStr = [yingStr stringByAppendingString:@"%"];
        NSString *daStr = [NSString stringWithFormat:@"%0.1f",((float)(daLv/count))*100];
        daStr = [daStr stringByAppendingString:@"%"];
        self.awayContent = [NSString stringWithFormat:@"客队 近%ld场 %0.0f胜%ld平%ld负 进%ld球 失%ld球, 胜率%@赢率%@大率%@",count,shengLv,pingCount,fuCount,jinCount,shiCount,shengSrt,yingStr,daStr];
        
        
    }else {
        NSArray *awayArray = self.datasModel.result.basketAway;
        NSMutableArray *mutAwayArray = [NSMutableArray array];
        if (self.isAwayTongZhu) {
            [awayArray enumerateObjectsUsingBlock:^(SNDatasBasketHistoryRecordModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (obj.aIds.integerValue == self.model.ateam_id.integerValue) {
                    [mutAwayArray addObject:obj];
                }
            }];
            awayArray = [mutAwayArray copy];
        }
        if (self.isAwayTongSai) {
            [mutAwayArray removeAllObjects];
            [awayArray enumerateObjectsUsingBlock:^(SNDatasBasketHistoryRecordModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (obj.cid.integerValue == self.model.cid.integerValue) {
                    [mutAwayArray addObject:obj];
                }
            }];
            awayArray = mutAwayArray;
        }
        self.awayArray = awayArray;
        
        NSInteger count = awayArray.count;
        NSInteger __block dan = 0;
        NSInteger __block shuang = 0;
        float __block shengLv = 0;
        float __block yingLv = 0;
        float __block daLv = 0;
        [awayArray enumerateObjectsUsingBlock:^(SNDatasBasketHistoryRecordModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.totalScoreQuan.integerValue%2 == 0) {
                shuang += 1;
            }else {
                dan += 1;
            }
            if (obj.aScore.integerValue > obj.hScore.integerValue) {
                shengLv += 1;
            }
            if ([obj.describeRang containsString:@"赢"]) {
                yingLv += 1;
            }
            if ([obj.describeZong containsString:@"大"]) {
                daLv += 1;
            }
        }];
        NSString *shengSrt = [NSString stringWithFormat:@"%0.1f",(shengLv/count)*100];
        shengSrt = [shengSrt stringByAppendingString:@"%"];
        NSString *yingStr = [NSString stringWithFormat:@"%0.1f",((float)(yingLv/count))*100];
        yingStr = [yingStr stringByAppendingString:@"%"];
        NSString *daStr = [NSString stringWithFormat:@"%0.1f",((float)(daLv/count))*100];
        daStr = [daStr stringByAppendingString:@"%"];
        self.awayContent = [NSString stringWithFormat:@"客队近%ld场 %0.0f胜%0.0f负 %ld单%ld双 %@，胜率%@赢率%@大率%@",count,shengLv,count-shengLv,dan,shuang,self.model.hteam_name,shengSrt,yingStr,daStr];
    }
    if (reload) {
        [self.tableView reloadData];
    }
}

//过滤半全场胜负
- (void)screeningWFArray:(BOOL)reload {
    if (self.model.type.integerValue == 1) {
        NSArray *homeArray = self.datasModel.history.footHome;
        NSMutableArray *mutHomeArray = [NSMutableArray array];
        if (self.isWFTongZhu) {
            [homeArray enumerateObjectsUsingBlock:^(SNDatasFootHistoryRecordModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (obj.hIds.integerValue == self.model.hteam_id.integerValue) {
                    [mutHomeArray addObject:obj];
                }
            }];
            homeArray = [mutHomeArray copy];
        }
        if (self.isWFTongSai) {
            [mutHomeArray removeAllObjects];
            [homeArray enumerateObjectsUsingBlock:^(SNDatasFootHistoryRecordModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (obj.cid.integerValue == self.model.cid.integerValue) {
                    [mutHomeArray addObject:obj];
                }
            }];
            homeArray = [mutHomeArray copy];
        }
        //足球
        NSArray *arr = @[
            @[],
            [@[@0,@0,@0,@"胜胜",@0,@0,@0] mutableCopy],
            [@[@0,@0,@0,@"胜平",@0,@0,@0] mutableCopy],
            [@[@0,@0,@0,@"胜负",@0,@0,@0] mutableCopy],
            [@[@0,@0,@0,@"平胜",@0,@0,@0] mutableCopy],
            [@[@0,@0,@0,@"平平",@0,@0,@0] mutableCopy],
            [@[@0,@0,@0,@"平负",@0,@0,@0] mutableCopy],
            [@[@0,@0,@0,@"负胜",@0,@0,@0] mutableCopy],
            [@[@0,@0,@0,@"负平",@0,@0,@0] mutableCopy],
            [@[@0,@0,@0,@"负负",@0,@0,@0] mutableCopy]
            ];
        [homeArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            SNDatasFootHistoryRecordModel *model = obj;
            NSString *homeName = self.model.hteam_name;
            NSString *result = [CommonTools getScoreResult:model.scoreQuan isHome:[model.hName isEqualToString:homeName]];
            NSString *halfResult = [CommonTools getScoreResult:model.scoreBan isHome:[model.hName isEqualToString:homeName]];
            [self compareFoot:result halfResult:halfResult arr:arr add:0 home:[model.hName isEqualToString:homeName]];
        }];
        
        NSArray *awayArray = self.datasModel.history.footAway;
        NSMutableArray *mutAwayArray = [NSMutableArray array];
        if (self.isWFTongZhu) {
            [awayArray enumerateObjectsUsingBlock:^(SNDatasFootHistoryRecordModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (obj.aIds.integerValue == self.model.ateam_id.integerValue) {
                    [mutAwayArray addObject:obj];
                }
            }];
            awayArray = [mutAwayArray copy];
        }
        
        if (self.isWFTongSai) {
            [mutAwayArray removeAllObjects];
            [awayArray enumerateObjectsUsingBlock:^(SNDatasFootHistoryRecordModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (obj.cid.integerValue == self.model.cid.integerValue) {
                    [mutAwayArray addObject:obj];
                }
            }];
            awayArray = mutAwayArray;
        }
         
        [awayArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            SNDatasFootHistoryRecordModel *model = obj;
            NSString *homeName = self.model.ateam_name;
            NSString *result = [CommonTools getScoreResult:model.scoreQuan isHome:[model.hName isEqualToString:homeName]];
            NSString *halfResult = [CommonTools getScoreResult:model.scoreBan isHome:[model.hName isEqualToString:homeName]];
            [self compareFoot:result halfResult:halfResult arr:arr add:4 home:[model.hName isEqualToString:homeName]];
        }];
        self.wfArray = arr;
        
    }else {
        NSArray *arr = @[
            @[],
            [@[@0,@0,@0,@"胜胜",@0,@0,@0] mutableCopy],
            [@[@0,@0,@0,@"胜负",@0,@0,@0] mutableCopy],
            [@[@0,@0,@0,@"平胜",@0,@0,@0] mutableCopy],
            [@[@0,@0,@0,@"平负",@0,@0,@0] mutableCopy],
            [@[@0,@0,@0,@"负胜",@0,@0,@0] mutableCopy],
            [@[@0,@0,@0,@"负负",@0,@0,@0] mutableCopy]
            ];
        //篮球 主队显示在右边
        NSArray *awayArray = self.datasModel.result.basketAway;
        NSMutableArray *mutAwayArray = [NSMutableArray array];
        if (self.isWFTongZhu) {
            [awayArray enumerateObjectsUsingBlock:^(SNDatasBasketHistoryRecordModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (obj.aIds.integerValue == self.model.ateam_id.integerValue) {
                    [mutAwayArray addObject:obj];
                }
            }];
            awayArray = [mutAwayArray copy];
        }
        
        if (self.isWFTongSai) {
            [mutAwayArray removeAllObjects];
            [awayArray enumerateObjectsUsingBlock:^(SNDatasBasketHistoryRecordModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (obj.cid.integerValue == self.model.cid.integerValue) {
                    [mutAwayArray addObject:obj];
                }
            }];
            awayArray = [mutAwayArray copy];
        }
        [awayArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            SNDatasBasketHistoryRecordModel *model = obj;
            NSString *awayName = self.model.ateam_name;
            NSString *result = [CommonTools getScoreResult:model.scoreQuan isHome:[model.hName isEqualToString:awayName]];
            NSString *halfResult = [CommonTools getScoreResult:model.scoreBan isHome:[model.hName isEqualToString:awayName]];
            [self compare:result halfResult:halfResult arr:arr add:0 home:[model.hName isEqualToString:awayName]];
        }];
        
        NSArray *homeArray = self.datasModel.result.basketHome;
        NSMutableArray *mutHomeArray = [NSMutableArray array];
        if (self.isWFTongZhu) {
            [homeArray enumerateObjectsUsingBlock:^(SNDatasBasketHistoryRecordModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (obj.hIds.integerValue == self.model.hteam_id.integerValue) {
                    [mutHomeArray addObject:obj];
                }
            }];
            homeArray = [mutHomeArray copy];
        }
        if (self.isWFTongSai) {
            [mutHomeArray removeAllObjects];
            [homeArray enumerateObjectsUsingBlock:^(SNDatasBasketHistoryRecordModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (obj.cid.integerValue == self.model.cid.integerValue) {
                    [mutHomeArray addObject:obj];
                }
            }];
            homeArray = mutHomeArray;
        }
        
        [homeArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            SNDatasBasketHistoryRecordModel *model = obj;
            NSString *homeName = self.model.hteam_name;
            NSString *result = [CommonTools getScoreResult:model.scoreQuan isHome:[model.hName isEqualToString:homeName]];
            NSString *halfResult = [CommonTools getScoreResult:model.scoreBan isHome:[model.hName isEqualToString:homeName]];
            [self compare:result halfResult:halfResult arr:arr add:4 home:[model.hName isEqualToString:homeName]];
        }];
        self.wfArray = arr;
    }
    if (reload) {
        [self.tableView reloadData];
    }
}

//过滤胜分差
- (void)screeningShengArray:(BOOL)reload {
    
    if (reload) {
        [self.tableView reloadData];
    }
}

- (void)compare:(NSString *)result halfResult:(NSString *)halfResult arr:(NSArray *)arr add:(NSInteger)add home:(BOOL)home {
    NSInteger more = home ? 0 : 1;
    if ([result isEqualToString:@"输"]) {
        if ([halfResult isEqualToString:@"输"]) {
            arr[6][0+add+more] = @([(NSNumber *)(arr[6][0+add+more]) integerValue] + 1);
            arr[6][2+add] = @([(NSNumber *)(arr[6][2+add]) integerValue] + 1);
        } else if ([halfResult isEqualToString:@"赢"]) {
            arr[2][0+add+more] = @([(NSNumber *)(arr[2][0+add+more]) integerValue] + 1);
            arr[2][2+add] = @([(NSNumber *)(arr[2][2+add]) integerValue] + 1);
        } else {
            arr[4][0+add+more] = @([(NSNumber *)(arr[4][0+add+more]) integerValue] + 1);
            arr[4][2+add] = @([(NSNumber *)(arr[4][2+add]) integerValue] + 1);
        }
    } else if ([result isEqualToString:@"赢"]) {
        if ([halfResult isEqualToString:@"输"]) {
            arr[5][0+add+more] = @([(NSNumber *)(arr[5][0+add+more]) integerValue] + 1);
            arr[5][2+add] = @([(NSNumber *)(arr[5][2+add]) integerValue] + 1);
        } else if ([halfResult isEqualToString:@"赢"]) {
            arr[1][0+add+more] = @([(NSNumber *)(arr[1][0+add+more]) integerValue] + 1);
            arr[1][2+add] = @([(NSNumber *)(arr[1][2+add]) integerValue] + 1);
        } else {
            arr[3][0+add+more] = @([(NSNumber *)(arr[3][0+add+more]) integerValue] + 1);
            arr[3][2+add] = @([(NSNumber *)(arr[3][2+add]) integerValue] + 1);
        }
    }
}


- (void)compareFoot:(NSString *)result halfResult:(NSString *)halfResult arr:(NSArray *)arr add:(NSInteger)add home:(BOOL)home {
    NSInteger more = home ? 0 : 1;
    if ([result isEqualToString:@"输"]) {
        if ([halfResult isEqualToString:@"输"]) {
            arr[9][0+add+more] = @([(NSNumber *)(arr[9][0+add+more]) integerValue] + 1);
            arr[9][2+add] = @([(NSNumber *)(arr[9][2+add]) integerValue] + 1);
        } else if ([halfResult isEqualToString:@"赢"]) {
            arr[3][0+add+more] = @([(NSNumber *)(arr[3][0+add+more]) integerValue] + 1);
            arr[3][2+add] = @([(NSNumber *)(arr[3][2+add]) integerValue] + 1);
        } else {
            arr[6][0+add+more] = @([(NSNumber *)(arr[6][0+add+more]) integerValue] + 1);
            arr[6][2+add] = @([(NSNumber *)(arr[6][2+add]) integerValue] + 1);
        }
    } else if ([result isEqualToString:@"赢"]) {
        if ([halfResult isEqualToString:@"输"]) {
            arr[7][0+add+more] = @([(NSNumber *)(arr[7][0+add+more]) integerValue] + 1);
            arr[7][2+add] = @([(NSNumber *)(arr[7][2+add]) integerValue] + 1);
        } else if ([halfResult isEqualToString:@"赢"]) {
            arr[1][0+add+more] = @([(NSNumber *)(arr[1][0+add+more]) integerValue] + 1);
            arr[1][2+add] = @([(NSNumber *)(arr[1][2+add]) integerValue] + 1);
        } else {
            arr[4][0+add+more] = @([(NSNumber *)(arr[4][0+add+more]) integerValue] + 1);
            arr[4][2+add] = @([(NSNumber *)(arr[4][2+add]) integerValue] + 1);
        }
    } else if ([result isEqualToString:@"平"]) {
        if ([halfResult isEqualToString:@"输"]) {
            arr[8][0+add+more] = @([(NSNumber *)(arr[8][0+add+more]) integerValue] + 1);
            arr[8][2+add] = @([(NSNumber *)(arr[8][2+add]) integerValue] + 1);
        } else if ([halfResult isEqualToString:@"赢"]) {
            arr[2][0+add+more] = @([(NSNumber *)(arr[2][0+add+more]) integerValue] + 1);
            arr[2][2+add] = @([(NSNumber *)(arr[2][2+add]) integerValue] + 1);
        } else {
            arr[5][0+add+more] = @([(NSNumber *)(arr[5][0+add+more]) integerValue] + 1);
            arr[5][2+add] = @([(NSNumber *)(arr[5][2+add]) integerValue] + 1);
        }
    }
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
    if (self.datasModel == nil) {
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
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(reloadDatas)];
        [backView addGestureRecognizer:tap];
    }
    return backView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sectionTitleArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSString *sectionTitle = self.sectionTitleArray[section];
    if ([sectionTitle isEqualToString:@"进球分布"]) {
        return 1;
    }else if ([sectionTitle isEqualToString:@"积分排名"]) {
        return 1;
    }else if ([sectionTitle isEqualToString:@"球队概况"]) {
        return 1;
    }else if ([sectionTitle isEqualToString:@"场均数据对比"]) {
        return 1;
    }else if ([sectionTitle isEqualToString:@"历史交锋"]) {
        return self.vsArray.count+2;
    }else if ([sectionTitle isEqualToString:@"近期战绩"]) {
        if (self.model.type.intValue == 1) {
            NSInteger count = 2;
            if (self.homeArray.count > 0) {
                count = self.homeArray.count + count;
            }
            count = 2 + count;
            if (self.awayArray.count > 0) {
                count = self.awayArray.count + count;
            }
            return count;
        }else {
            NSInteger count = 2;
            if (self.awayArray.count > 0) {
                count = self.awayArray.count + count;
            }
            count = 2 + count;
            if (self.homeArray.count > 0) {
                count = self.homeArray.count + count;
            }
            return count;
        }
    }else if ([sectionTitle isEqualToString:@"伤停情况"]) {
        NSInteger count = 1;
        if (self.injuryHomeArray.count > 0) {
            count = self.injuryHomeArray.count + count;
        }
        if (self.injuryAwayArray.count > 0) {
            count = 1 + count;
            count = self.injuryAwayArray.count + count;
        }
        return count;
    }else if ([sectionTitle isEqualToString:@"近期赛程"]) {
        NSInteger count = 1;
        if (self.scheduleHomeArray.count > 0) {
            count = self.scheduleHomeArray.count + count;
        }
        count = 1 + count;
        if (self.scheduleAwayArray.count > 0) {
            count = self.scheduleAwayArray.count + count;
        }
        return count;
    }else if ([sectionTitle isEqualToString:@"半全场胜负"]) {
        return self.wfArray.count > 0? self.wfArray.count:0;
    }
    //胜分差
    return self.shengArray.count > 0? self.shengArray.count+2:0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *sectionTitle = self.sectionTitleArray[indexPath.section];
    if ([sectionTitle isEqualToString:@"进球分布"]) {
        SNDatasFootScoreTableViewCell *cell = [SNDatasFootScoreTableViewCell cellWithTableView:tableView];
        cell.model = self.model;
        cell.datasModel = self.datasModel;
        return cell;
        
    }else if ([sectionTitle isEqualToString:@"球队概况"]) {
        SNTeamGeneralRankTableViewCell *cell = [SNTeamGeneralRankTableViewCell cellWithTableView:tableView];
        cell.model = self.model;
        cell.datasModel = self.datasModel;
        return cell;
    }else if ([sectionTitle isEqualToString:@"场均数据对比"]) {
        SNTeamCompareTableViewCell *cell = [SNTeamCompareTableViewCell cellWithTableView:tableView];
        cell.model = self.model;
        cell.datasModel = self.datasModel;
        return cell;
        
    }else if ([sectionTitle isEqualToString:@"积分排名"]) {
        SNDatasFootPointRankTableViewCell *cell = [SNDatasFootPointRankTableViewCell cellWithTableView:tableView];
        cell.model = self.model;
        cell.datasModel = self.datasModel;
        return cell;
    }else if ([sectionTitle isEqualToString:@"历史交锋"]) {
        if (self.model.type.intValue == 1) {
            //第一行
            if (indexPath.row == 0) {
                SNDatasFootTeamTopTableViewCell *cell = [SNDatasFootTeamTopTableViewCell cellWithTableView:tableView];
                cell.type = 0;
                WeakSelf
                cell.clickTongZhuKe = ^(BOOL isSelect) {
                    weakSelf.isVsTongZhu = isSelect;
                    [weakSelf screeningVsArray:YES];
                };
                cell.clickTongSaiShi = ^(BOOL isSelect) {
                    weakSelf.isVsTongSai = isSelect;
                    [weakSelf screeningVsArray:YES];
                };
                cell.clickButtonView = ^(BOOL isSelect) {
                    weakSelf.isVsButtonSelect = isSelect;
                    [weakSelf screeningVsArray:YES];
                };
                [cell isCellTongZhuKe:self.isVsTongZhu];
                [cell isCellTongSaiShi:self.isVsTongSai];
                [cell isCellSelectButton:self.isVsButtonSelect];
                [cell cellIsTopOne:YES];
                return cell;
            }
            //最后一行
            if (indexPath.row == self.vsArray.count+1) {
                SNDatasDescribeTableViewCell *cell = [SNDatasDescribeTableViewCell cellWithTableView:tableView];
                [cell cellIsLastOne:YES];
                cell.contentStr = self.vsContent;
                return cell;
            }
            SNDatasFootHistoryTableViewCell *cell = [SNDatasFootHistoryTableViewCell cellWithTableView:tableView];
            cell.selectionStyle = 0;
            cell.backView.backgroundColor = (indexPath.row+1)%2 == 0? SRGB(248):UIColor.whiteColor;
            cell.model = self.model;
            SNDatasFootHistoryRecordModel *footModel = self.vsArray[indexPath.row - 1];
            cell.footModel = footModel;
            return cell;
            
        }else {
            //第一行
            if (indexPath.row == 0) {
                SNDatasHistoryJiaoFengTopTableViewCell *cell = [SNDatasHistoryJiaoFengTopTableViewCell cellWithTableView:tableView];
                cell.model = self.model;
                cell.vsArray = self.vsArray;
                [cell isCellTongZhuKe:self.isVsTongZhu];
                [cell isCellSelectButton:self.isVsButtonSelect];
                WeakSelf
                cell.clickTongZhuKe = ^(BOOL isSelect) {
                    weakSelf.isVsTongZhu = isSelect;
                    [weakSelf screeningVsArray:YES];
                };
                cell.clickButtonView = ^(BOOL isSelect) {
                    weakSelf.isVsButtonSelect = isSelect;
                    [weakSelf screeningVsArray:YES];
                };
                return cell;
            }
            //最后一行
            if (indexPath.row == self.vsArray.count+1) {
                SNDatasDescribeTableViewCell *cell = [SNDatasDescribeTableViewCell cellWithTableView:tableView];
                [cell cellIsLastOne:YES];
//                cell.contentStr = self.vsContent;
                [cell setRecentResult:[SNDatasBasketHistoryRecordModel getRecentResultsString:self.vsArray isHome:true homeName:self.model.hteam_name isHistory:true]];
                return cell;
            }
            SNDatasHistoryTableViewCell *cell = [SNDatasHistoryTableViewCell cellWithTableView:tableView];
            cell.selectionStyle = 0;
            cell.backView.backgroundColor = (indexPath.row+1)%2 == 0? SRGB(248):UIColor.whiteColor;
            cell.model = self.model;
            SNDatasBasketHistoryRecordModel *vsModel = self.vsArray[indexPath.row - 1];
            // 让分结果有问题，与web不一致，自己计算结果
//            [basketModel reviseDescribeRang:self.model.hteam_name];
            cell.vsModel = vsModel;
            return cell;
        }
    }else if ([sectionTitle isEqualToString:@"近期战绩"]) {
        if (self.model.type.intValue == 1) {
            //第一行
            if (indexPath.row == 0) {
                SNDatasFootTeamTopTableViewCell *cell = [SNDatasFootTeamTopTableViewCell cellWithTableView:tableView];
                cell.type = 1;
                [cell cellIsTopOne:YES];
                [cell setupTeamName:self.model.hteam_name iconImage:self.model.hteam_logo];
                [cell isCellTongZhuKe:self.isHomeTongZhu];
                [cell isCellTongSaiShi:self.isHomeTongSai];
                [cell isCellSelectButton:self.isHomeButtonSelect];
                WeakSelf
                cell.clickTongZhuKe = ^(BOOL isSelect) {
                    weakSelf.isHomeTongZhu = isSelect;
                    [weakSelf screeningHomeArray:YES];
                };
                cell.clickTongSaiShi = ^(BOOL isSelect) {
                    weakSelf.isHomeTongSai = isSelect;
                    [weakSelf screeningHomeArray:YES];
                };
                cell.clickButtonView = ^(BOOL isSelect) {
                    weakSelf.isHomeButtonSelect = isSelect;
                    [weakSelf screeningHomeArray:YES];
                };
                return cell;
            }
            
            //主队最后一行
            if (indexPath.row == self.homeArray.count+1) {
                SNDatasDescribeTableViewCell *cell = [SNDatasDescribeTableViewCell cellWithTableView:tableView];
                [cell cellIsLastOne:NO];
                if (self.homeArray.count == 0) {
                    [cell cellIsLastOne:YES];
                }
                cell.contentStr = self.homeContent;
                return cell;
            }
            
            //客队的第一行
            if (indexPath.row == self.homeArray.count+2) {
                SNDatasFootTeamTopTableViewCell *cell = [SNDatasFootTeamTopTableViewCell cellWithTableView:tableView];
                cell.type = 1;
                [cell cellIsTopOne:NO];
                [cell setupTeamName:self.model.ateam_name iconImage:self.model.ateam_logo];
                [cell isCellTongZhuKe:self.isAwayTongZhu];
                [cell isCellTongSaiShi:self.isAwayTongSai];
                [cell isCellSelectButton:self.isAwayButtonSelect];
                WeakSelf
                cell.clickTongZhuKe = ^(BOOL isSelect) {
                    weakSelf.isAwayTongZhu = isSelect;
                    [weakSelf screeningAwayArray:YES];
                };
                cell.clickTongSaiShi = ^(BOOL isSelect) {
                    weakSelf.isAwayTongSai = isSelect;
                    [weakSelf screeningAwayArray:YES];
                };
                cell.clickButtonView = ^(BOOL isSelect) {
                    weakSelf.isAwayButtonSelect = isSelect;
                    [weakSelf screeningAwayArray:YES];
                };
                return cell;
            }
            //最后一行
            if (indexPath.row == self.homeArray.count+self.awayArray.count+3) {
                SNDatasDescribeTableViewCell *cell = [SNDatasDescribeTableViewCell cellWithTableView:tableView];
                [cell cellIsLastOne:YES];
                cell.contentStr = self.awayContent;
                return cell;
            }
            SNDatasFootHistoryTableViewCell *cell = [SNDatasFootHistoryTableViewCell cellWithTableView:tableView];
            cell.selectionStyle = 0;
            cell.model = self.model;
            if (indexPath.row > 0 && indexPath.row < self.homeArray.count+2) {
                cell.backView.backgroundColor = (indexPath.row+1)%2 == 0? SRGB(248):UIColor.whiteColor;
                SNDatasFootHistoryRecordModel *vsModel = self.homeArray[indexPath.row - 1];
                cell.vsModel = vsModel;
            }else {
                NSInteger count = indexPath.row - self.homeArray.count-2-1;
                cell.backView.backgroundColor = (count)%2 == 0? SRGB(248):UIColor.whiteColor;
                SNDatasFootHistoryRecordModel *vsModel = self.awayArray[count];
                cell.vsModel = vsModel;
            }
            return cell;
        }else {
            //客第一行
            if (indexPath.row == 0) {
                SNDatasHistoryTeamTopTableViewCell *cell = [SNDatasHistoryTeamTopTableViewCell cellWithTableView:tableView];
                cell.type = 1;
                [cell cellIsTopOne:YES];
                [cell setupTeamName:self.model.ateam_name iconImage:self.model.ateam_logo];
                
                [cell isCellTongZhuKe:self.isAwayTongZhu];
                [cell isCellTongSaiShi:self.isAwayTongSai];
                [cell isCellSelectButton:self.isAwayButtonSelect];
                WeakSelf
                cell.clickTongZhuKe = ^(BOOL isSelect) {
                    weakSelf.isAwayTongZhu = isSelect;
                    [weakSelf screeningAwayArray:YES];
                };
                cell.clickTongSaiShi = ^(BOOL isSelect) {
                    weakSelf.isAwayTongSai = isSelect;
                    [weakSelf screeningAwayArray:YES];
                };
                cell.clickButtonView = ^(BOOL isSelect) {
                    weakSelf.isAwayButtonSelect = isSelect;
                    [weakSelf screeningAwayArray:YES];
                };
                return cell;
            }
            //客队最后一行
            if (indexPath.row == self.awayArray.count+1) {
                SNDatasDescribeTableViewCell *cell = [SNDatasDescribeTableViewCell cellWithTableView:tableView];
                [cell cellIsLastOne:NO];
                if (self.awayArray.count == 0) {
                    [cell cellIsLastOne:YES];
                }
//                cell.contentStr = self.homeContent;
                [cell setRecentResult:[SNDatasBasketHistoryRecordModel getRecentResultsString:self.awayArray isHome:false homeName:self.model.ateam_name isHistory:false]];
                return cell;
            }
            
            //主队的第一行
            if (indexPath.row == self.awayArray.count+2) {
                SNDatasHistoryTeamTopTableViewCell *cell = [SNDatasHistoryTeamTopTableViewCell cellWithTableView:tableView];
                cell.type = 1;
                [cell cellIsTopOne:NO];
                [cell setupTeamName:self.model.hteam_name iconImage:self.model.hteam_logo];
                
                [cell isCellTongZhuKe:self.isHomeTongZhu];
                [cell isCellTongSaiShi:self.isHomeTongSai];
                [cell isCellSelectButton:self.isHomeButtonSelect];
                WeakSelf
                cell.clickTongZhuKe = ^(BOOL isSelect) {
                    weakSelf.isHomeTongZhu = isSelect;
                    [weakSelf screeningHomeArray:YES];
                };
                cell.clickTongSaiShi = ^(BOOL isSelect) {
                    weakSelf.isHomeTongSai = isSelect;
                    [weakSelf screeningHomeArray:YES];
                };
                cell.clickButtonView = ^(BOOL isSelect) {
                    weakSelf.isHomeButtonSelect = isSelect;
                    [weakSelf screeningHomeArray:YES];
                };
                
                return cell;
            }
            //主队最后一行
            if (indexPath.row == self.homeArray.count+self.awayArray.count+3) {
                SNDatasDescribeTableViewCell *cell = [SNDatasDescribeTableViewCell cellWithTableView:tableView];
                [cell cellIsLastOne:YES]; 
//                cell.contentStr = self.awayContent;
                [cell setRecentResult:[SNDatasBasketHistoryRecordModel getRecentResultsString:self.homeArray isHome:true homeName:self.model.hteam_name isHistory:false]];
                return cell;
            }
            SNDatasHistoryTableViewCell *cell = [SNDatasHistoryTableViewCell cellWithTableView:tableView];
            cell.selectionStyle = 0;
            cell.model = self.model;
            if (indexPath.row > 0 && indexPath.row < self.awayArray.count+2) {
                cell.isZhudui = NO;
                cell.backView.backgroundColor = (indexPath.row+1)%2 == 0? SRGB(248):UIColor.whiteColor;
                SNDatasBasketHistoryRecordModel *basketModel = self.awayArray[indexPath.row - 1];
                // 让分结果有问题，与web不一致，自己计算结果
//                [basketModel reviseDescribeRang:self.model.hteam_name];
                
                cell.basketModel = basketModel;
            }else {
                cell.isZhudui = YES;
                NSInteger count = indexPath.row - self.awayArray.count-2-1;
                cell.backView.backgroundColor = (count)%2 == 0? SRGB(248):UIColor.whiteColor;
                SNDatasBasketHistoryRecordModel *basketModel = self.homeArray[count];
                // 让分结果有问题，与web不一致，自己计算结果
//                [basketModel reviseDescribeRang:self.model.ateam_name];
                
                cell.basketModel = basketModel;
            }
            return cell;
        }
    }else if ([sectionTitle isEqualToString:@"伤停情况"]) {
        //第一行
        if (indexPath.row == 0) {
            SNDatasFootInjuryTeamTopTableViewCell *cell = [SNDatasFootInjuryTeamTopTableViewCell  cellWithTableView:tableView];
            [cell cellIsTopOne:YES];
            [cell setupTeamName:self.model.hteam_name iconImage:self.model.hteam_logo];
            cell.contentView.hidden = NO;
            if (self.injuryHomeArray.count == 0) {
                cell.contentView.hidden = YES;
            }
            return cell;
        }
        //中间那个
        if (indexPath.row == self.injuryHomeArray.count+1) {
            SNDatasFootInjuryTeamTopTableViewCell *cell = [SNDatasFootInjuryTeamTopTableViewCell  cellWithTableView:tableView];
            if (self.injuryHomeArray.count == 0) {
                [cell cellIsTopOne:YES];
            }else {
                [cell cellIsTopOne:NO];
            }
            [cell setupTeamName:self.model.ateam_name iconImage:self.model.ateam_logo];
            cell.contentView.hidden = NO;
            if (self.injuryAwayArray.count == 0) {
                cell.contentView.hidden = YES;
            }
            return cell;
        }
        SNDatasFootInjuryTableViewCell *cell = [SNDatasFootInjuryTableViewCell cellWithTableView:tableView];
        if (self.injuryAwayArray.count > 0) {
            [cell cellIsLastOne:indexPath.row == self.injuryHomeArray.count+self.injuryAwayArray.count+1? YES:NO];
        }else {
            [cell cellIsLastOne:indexPath.row == self.injuryHomeArray.count? YES:NO];
        }
        
        if (indexPath.row > 0 && indexPath.row < self.injuryHomeArray.count+1) {
            SNDatasFootInjuryModel *injuryModel = self.injuryHomeArray[indexPath.row - 1];
            cell.injuryModel = injuryModel;
        }else {
            NSInteger count = indexPath.row - self.injuryHomeArray.count-2;
            SNDatasFootInjuryModel *injuryModel = self.injuryAwayArray[count];
            cell.injuryModel = injuryModel;
        }
        
        return cell;

    }else if ([sectionTitle isEqualToString:@"近期赛程"]) {
        //第一行
        if (indexPath.row == 0) {
            SNDatasScheduleTeamTopTableViewCell *cell = [SNDatasScheduleTeamTopTableViewCell  cellWithTableView:tableView];
            [cell cellIsTopOne:YES];
            [cell setupTeamName:self.model.hteam_name iconImage:self.model.hteam_logo];
            return cell;
        }
        //中间那个
        if (indexPath.row == self.scheduleHomeArray.count+1) {
            SNDatasScheduleTeamTopTableViewCell *cell = [SNDatasScheduleTeamTopTableViewCell  cellWithTableView:tableView];
            [cell cellIsTopOne:NO]; 
            [cell setupTeamName:self.model.ateam_name iconImage:self.model.ateam_logo];
            return cell;
        }
        
        SNDatasScheduleTableViewCell *cell = [SNDatasScheduleTableViewCell cellWithTableView:tableView];
        [cell isBenChangeGame:indexPath.row == 18?YES:NO];
        [cell cellIsLastOne:indexPath.row == self.scheduleHomeArray.count+self.scheduleAwayArray.count+1? YES:NO];
        
        if (indexPath.row > 0 && indexPath.row < self.scheduleHomeArray.count+2) {
            [cell isDoubleCell: (indexPath.row+1)%2 == 0? YES:NO];
        }else {
            [cell isDoubleCell: (indexPath.row-self.scheduleHomeArray.count-2)%2 == 0? YES:NO];
        }
        
        if (indexPath.row <= self.scheduleHomeArray.count + 1) {
            [cell reloadData:self.scheduleHomeArray[indexPath.row - 1]];
        } else {
            [cell reloadData:self.scheduleAwayArray[indexPath.row - self.scheduleHomeArray.count - 2]];
        }
        
        return cell;

    }else if ([sectionTitle isEqualToString:@"半全场胜负"]) {
        //第一行
        if (indexPath.row == 0) {
            SNDatasWinFailTeamTopTableViewCell *cell = [SNDatasWinFailTeamTopTableViewCell  cellWithTableView:tableView];
            [cell cellIsTopOne:YES];
            cell.model = self.model;
            if (self.model.type.intValue == 2) {
                [cell basketWinFail:NO];
            }
            [cell isCellTongZhuKe:self.isWFTongZhu];
            [cell isCellTongSaiShi:self.isWFTongSai];
            [cell isCellSelectButton:self.isWFButtonSelect];
            WeakSelf
            cell.clickTongZhuKe = ^(BOOL isSelect) {
                weakSelf.isWFTongZhu = isSelect;
                [weakSelf screeningWFArray:YES];
            };
            cell.clickTongSaiShi = ^(BOOL isSelect) {
                weakSelf.isWFTongSai = isSelect;
                [weakSelf screeningWFArray:YES];
            };
            cell.clickButtonView = ^(BOOL isSelect) {
                weakSelf.isWFButtonSelect = isSelect;
                [weakSelf screeningWFArray:YES];
            };
            [cell reloadTitle:self.wfArray];
            return cell;
        }
        SNDatasWinFailTableViewCell *cell = [SNDatasWinFailTableViewCell cellWithTableView:tableView];
        [cell showContentWithDatas:self.wfArray[indexPath.row]];
        [cell isDoubleCell: (indexPath.row+1)%2 == 0? YES:NO];
        [cell cellIsLastOne:(indexPath.row == self.wfArray.count-1)? YES:NO];
        return cell;
    }
    
    //胜分差 只有篮球有
    //第一行
    if (indexPath.row == 0) {
        SNDatasWinFailTeamTopTableViewCell *cell = [SNDatasWinFailTeamTopTableViewCell  cellWithTableView:tableView];
        [cell cellIsTopOne:YES];
        cell.model = self.model;
        if (self.model.type.intValue == 2) {
            [cell basketWinFail:YES];
        }
        [cell isCellTongZhuKe:self.isShengTongZhu];
        [cell isCellTongSaiShi:self.isShengTongSai];
        [cell isCellSelectButton:self.isShengButtonSelect];
        WeakSelf
        cell.clickTongZhuKe = ^(BOOL isSelect) {
            weakSelf.isShengTongZhu = isSelect;
            [weakSelf screeningShengArray:YES];
        };
        cell.clickTongSaiShi = ^(BOOL isSelect) {
            weakSelf.isShengTongSai = isSelect;
            [weakSelf screeningShengArray:YES];
        };
        cell.clickButtonView = ^(BOOL isSelect) {
            weakSelf.isShengButtonSelect = isSelect;
            [weakSelf screeningShengArray:YES];
        };
        
        return cell;
    }else if (indexPath.row == self.shengArray.count+1) {
        //最后一行
        SNDatasDescribeTableViewCell *cell = [SNDatasDescribeTableViewCell cellWithTableView:tableView];
        [cell cellIsLastOne:YES];
        cell.contentStr = @"PS：当前赛季的所有比赛";
        return cell;
    }
    
    SNDatasWinFailTableViewCell *cell = [SNDatasWinFailTableViewCell cellWithTableView:tableView];
    [cell isDoubleCell:(indexPath.row+1)%2 == 0? YES:NO];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *sectionTitle = self.sectionTitleArray[indexPath.section];
    if ([sectionTitle isEqualToString:@"进球分布"]) {
        return 95;
    }else if ([sectionTitle isEqualToString:@"球队概况"]) {
        return 280;
    }else if ([sectionTitle isEqualToString:@"场均数据对比"]) {
        return 353;
    }else if ([sectionTitle isEqualToString:@"积分排名"]) {
        return 410;
    }else if ([sectionTitle isEqualToString:@"历史交锋"]) {
        //self.datasModel.historyModel.vs.count+1
        if (self.model.type.intValue == 1) {
            if (indexPath.row == 0) {//主队第一行
                return 88;
            }
            if (indexPath.row == self.vsArray.count+1) {
                //主队最后一行
                return 61;
            }
        }else {
            if (indexPath.row == 0) {//客队第一行
                return 154;
            }
            if (indexPath.row == self.vsArray.count+1) {
                //客队最后一行
                return 61;
            }
        }
        return 51;
    }else if ([sectionTitle isEqualToString:@"近期战绩"]) {
        if (self.model.type.intValue == 1) {
            if (indexPath.row == 0) {//第一行
                return 116;
            }else if (indexPath.row == self.homeArray.count+1) {//主队最后一行
                return 61;
            }else if (indexPath.row == self.homeArray.count+2) {//客队的第一行
                return 116;
            }else if (indexPath.row == self.homeArray.count+self.awayArray.count+3) {//最后一行
                return 61;
            }
            return 51;
        }else {
            if (indexPath.row == 0) {//第一行
                return 116;
            }else if (indexPath.row == self.awayArray.count+1) {//客队最后一行
                return 61;
            }else if (indexPath.row == self.awayArray.count+2) {//主队的第一行
                return 116;
            }else if (indexPath.row == self.homeArray.count+self.awayArray.count+3) {//最后一行
                return 61;
            }
            return 51;
        }
    }else if ([sectionTitle isEqualToString:@"伤停情况"]) {
        if (indexPath.row == 0) {//第一行
            if (self.injuryHomeArray.count == 0) {
                return 0;
            }
            return 66.5;
        }else if (indexPath.row == self.injuryHomeArray.count) {//主队的最后一行
            if (self.injuryAwayArray.count == 0) {
                return 61;
            }
        }else if (indexPath.row == self.injuryHomeArray.count+1) {//客队的第一行
            if (self.injuryAwayArray.count == 0) {
                return 0;
            }
            return 66.5;
        }else if (indexPath.row == self.injuryHomeArray.count+self.injuryAwayArray.count+1) {//最后一行
            return 61;
        }
        return 51;
    }else if ([sectionTitle isEqualToString:@"近期赛程"]) {
        if (indexPath.row == 0) {//第一行
            if (self.scheduleHomeArray.count == 0) {
                return 0;
            }
            return 76.5;
        }else if (indexPath.row == self.scheduleHomeArray.count+1) {//客队的第一行
            return 74;
        }else if (indexPath.row == self.scheduleHomeArray.count+self.scheduleAwayArray.count+1) {//最后一行
            return 61;
        }
        return 51;
    }else if ([sectionTitle isEqualToString:@"半全场胜负"]) {
        if (indexPath.row == 0) {
            return 111.5;
        }else if (indexPath.row == self.wfArray.count-1) {//最后一行
            return 51;
        }
        return 40;
    }
    //胜分差
    if (indexPath.row == 0) {//第一行
        return 111.5;
    }else if (indexPath.row == self.shengArray.count+1) {//最后一行
        return 55;
    }
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSString *sectionTitle = self.sectionTitleArray[section];
    SNDatasSimpleHeaderView *headerView = [[SNDatasSimpleHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 46)];
    headerView.titleLabel.text = sectionTitle;
    headerView.subTitleLabel.hidden = [sectionTitle isEqualToString:@"进球分布"]? NO:YES;
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 46;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
}

- (void)delayMethod {
    [UIView animateWithDuration:0.35 animations:^{
        self.screenView.alpha =0;
    }];
}

#pragma mark - JXPagerViewListViewDelegate
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!self.timer) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(delayMethod) userInfo:nil repeats:NO];
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    if (!self.timer) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(delayMethod) userInfo:nil repeats:NO];
    }
}
 
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat y = scrollView.contentOffset.y;
    if (y > 0) {
        self.scrollCallback(scrollView);
        [self getNowTopSectionView];
        if (self.timer) {
            [self.timer invalidate];
            self.timer = nil;
        }
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
        _tableView.backgroundColor = SRGB(248);
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, xBottomHeight, 0);
        _tableView.separatorStyle = 0;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        //设置自动计算行号模式
        _tableView.rowHeight = UITableViewAutomaticDimension;
        [_tableView registerNib:[UINib nibWithNibName:@"SNDatasHistoryTableViewCell" bundle:nil] forCellReuseIdentifier:@"SNDatasHistoryTableViewCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"SNDatasFootHistoryTableViewCell" bundle:nil] forCellReuseIdentifier:@"SNDatasFootHistoryTableViewCell"]; 
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
