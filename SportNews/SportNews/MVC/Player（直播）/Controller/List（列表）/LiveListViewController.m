//
//  LiveListViewController.m
//  SportNews
//
//  Created by K哥 on 2021/1/9.
//

#import "LiveListViewController.h"
#import "LXCalender.h"
#import "LiveListModel.h"
#import "LiveDetailController.h"
#import "LiveListTableViewCell.h"
#import "SNPictureInPictureShare.h"
#import <Superplayer/SuperPlayer.h>
#import "SportNews-Swift.h"
#import "HomeWSManager.h"
#import "SNSquadModel.h"
#import "SNLiveListCollectionViewCell.h"
#import "SNLiveListTopView.h"
#import "LiveListTheEndTableViewCell.h"
#import "HomeWSManager.h"
#import "SNZFPlayerWindow.h"

NSInteger gCategoryType = 0;

@interface LiveListViewController ()

@property (nonatomic,strong) LXCalendarView *calenderView;

@property(nonatomic, assign) BOOL isHot;

//直播类型：0 动画直播 1 视频直播 2 动画+视频直播
@property(nonatomic, assign) NSInteger live_type;

@property (nonatomic , strong) NSArray *topListArray;
@property (nonatomic , strong) NSArray *noTopListArray;


/// 列表展示类型，0比分 1指数
@property(nonatomic, assign) NSInteger listType;

/// 日历数据
@property(nonatomic, strong) NSMutableDictionary *calendarData;

/// 定时器，定时刷新界面
@property(nonatomic, strong) NSTimer *timer;

/// 当前日历选择日期
@property(nonatomic, strong) NSString *calendarChoice;
/// 开始时间
@property(nonatomic, strong) NSString *startTimeChoice;

@property(nonatomic, strong) UIView *qiehuanBackView;

@property(nonatomic, strong) UIButton *scoreBtn;

@property(nonatomic, strong) UIButton *zhishuBtn;

@property(nonatomic, strong) UIButton *todayBtn;

@property(nonatomic, strong) SNLiveListTopView *topView;

//0今天 1过去了  2未来
@property(nonatomic, assign) NSInteger timeStatus;

// 是否首次加载
@property(nonatomic, assign) bool isFirstLoad;

@property(nonatomic, copy) NSString *token;

// 今天是否还有比赛
@property(nonatomic, assign) bool isTodayHaveMatch;

//是否正在删除比赛
@property(nonatomic, assign) bool isDeletList;

@property(nonatomic, strong) UIView *emptyBackView;
@property(nonatomic, strong) UIImageView *emptyImageView;
@property(nonatomic, strong) UILabel *emptyLabel;
@property (nonatomic, strong) NSMutableArray *originalDatasArray;

@end

@implementation LiveListViewController


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self getCalendarData];
    WeakSelf;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:3 repeats:true block:^(NSTimer * _Nonnull timer) {
        if (!self.isDeletList) {
            [weakSelf.tableView reloadData];
        }
    }];
    if (![CommonTools isBlankString:self.token]) {
        [HomeWSManager instance].type = self.type;
        [[HomeWSManager instance] SRWebSocketOpenWithURLString:[NSString stringWithFormat:@"%@?token=%@",ListSocketUrl,self.token]];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    CellModel.showID = -1;
    [CellModel.moreView setHidden:YES];
    [super viewWillDisappear:animated];
    [self.timer invalidate];
    self.timer = nil;
}

- (void)refreshTableView {
    [self.tableView reloadData];
}

- (instancetype)initWithCategoryModel:(LiveListCategoryModel *)model type:(NSInteger)type isHot:(BOOL)isHot {
    self = [super init];
    if (self) {
        _ps = 20;
        _pn = 1;
        _categoryModel = model;
        _type = type;
        _isHot = isHot;
        _startTime = @"";
    }
    return self;
}

- (NSMutableArray *)originalDatasArray {
    if (!_originalDatasArray) {
        _originalDatasArray = [NSMutableArray array];
    }
    return _originalDatasArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.isTodayHaveMatch = true;
    SNGlobalShared.isAppOpened = YES;
    self.timeStatus = 0;

    [self setupSubViews];

    self.isFirstLoad = true;
    [KYRemindView show];
    [self getDatas:YES];

    [self setupParams];

    [self setupEmptyView];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(topMatch:) name:@"TopMatch" object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UnTopMatch:) name:@"UnTopMatch" object:nil];
}


- (void)setupParams {
    /// 添加监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterApp) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeType:) name:ChangeShowType object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteFinishList) name:RecieveFinishListData object:nil];

    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    LiveListModel *listModel = appDelegate.listModel;
    if (listModel && listModel.comeFromNotice) {
        [appDelegate jumpToDetailVc:listModel];
    }
}


- (void)setupSubViews {
    self.navView.hidden = YES;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"LiveListTableViewCell" bundle:nil] forCellReuseIdentifier:@"LiveListTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"LiveListTheEndTableViewCell" bundle:nil] forCellReuseIdentifier:@"LiveListTheEndTableViewCell"];
    self.tableView.frame = self.view.frame;
    self.tableView.backgroundColor = SRGB(250);
    self.tableView.y = 40;
    self.tableView.height = kScreenHeight-NavHeight-30-40;

    MJRefreshHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        self.pn = 1;
//        [self getDatas:YES];
        if (![CommonTools isBlankString:self.startTimeChoice]) {
            self.startTime = self.startTimeChoice;
//            [self reloadDatas];
            self.pn = 1;
            // self.calendarChoice = nil;
            // self.startTimeChoice = nil;
            [[HomeWSManager instance] cleaDatas];
            [self getDatas:YES];
        } else {
            [self reloadDatas];
        }
    }];

    self.tableView.mj_header = header;
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self getDatas:NO];
    }];
    self.tableView.mj_footer = footer;
    [self.view addSubview:self.tableView];

    [self setupQiehuan];

    [self setupTopView];

}


- (void)setupTopView {
    self.topView = [[SNLiveListTopView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
    [self.topView changeChoiceNotAnimated:[LiveListCalendarVC getCurrentString]];
    if (![self.categoryModel isKindOfClass:[LiveListCategoryModel class]]) {
        self.topView.isHideCount = YES;
    }
    WeakSelf
    self.topView.showCalendarBlock = ^{
        [weakSelf showCalendar];
    };
    self.topView.choiceItem = ^(NSString * _Nonnull choice) {
        weakSelf.calendarChoice = choice;
        weakSelf.startTimeChoice = choice;
        weakSelf.pn = 1;
        [KYRemindView show];
        [weakSelf getDatas:YES];
    };
    self.topView.reloadTop = ^{
        LiveListModel *model;
        if (weakSelf.noTopListArray.count >= 1) {
            model = [weakSelf.noTopListArray firstObject];
        } else {
            model = [[weakSelf.datasArray firstObject] firstObject];
        }
        if (model != nil && model.matchtime != nil && model.matchtime.length > 10) {
            [weakSelf.topView changeChoice:[model.matchtime substringToIndex:10]];
            self->_calendarChoice = [model.matchtime substringToIndex:10];
        }
    };
    [self.view addSubview:self.topView];
}

//下面的切换
- (void)setupQiehuan {
    // int y = kScreenHeight-63-xBottomHeight;
    // UIButton *todayBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, kScreenHeight-60-xBottomHeight- (NavHeight+35)-20-30+54, 75.5, 30)];
    UIButton *todayBtn;
    if (self.type == 3) {
        todayBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, kScreenHeight-60-xBottomHeight- (NavHeight+35)-20-30+54+38, 75.5, 30)];
    } else {
        todayBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, kScreenHeight-60-xBottomHeight- (NavHeight+35)-20-30+54, 75.5, 30)];
    }
    todayBtn.titleLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightSemibold];
    [todayBtn setTitle:@" 今天" forState:UIControlStateNormal];
    [todayBtn setTitle:@" 今天" forState:UIControlStateSelected];
    [todayBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [todayBtn setTitleColor:UIColor.whiteColor forState:UIControlStateSelected];
    [todayBtn setImage:[UIImage imageNamed:@"上箭头"] forState:UIControlStateNormal];
    [todayBtn setImage:[UIImage imageNamed:@"下箭头"] forState:UIControlStateSelected];
    [todayBtn addTarget:self action:@selector(todayBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    todayBtn.backgroundColor = RGBA(39, 197, 195, 0.8);
    todayBtn.layer.cornerRadius = 15;
    [self.view addSubview:todayBtn];
    todayBtn.centerX = self.view.centerX;
    todayBtn.hidden = YES;
    self.todayBtn = todayBtn;

    UIView *qiehuanBackView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight-60-xBottomHeight- (NavHeight+35), 142, 36)];
    self.qiehuanBackView = qiehuanBackView;
    qiehuanBackView.backgroundColor = [UIColor whiteColor];
    qiehuanBackView.layer.cornerRadius = 18;
    qiehuanBackView.layer.borderColor = RGBA(0, 0, 0, 0.1).CGColor;
    qiehuanBackView.layer.borderWidth = 0.5;
    qiehuanBackView.centerX = self.view.centerX;
    [self.view addSubview:qiehuanBackView];

    UIButton *scoreBtn = [[UIButton alloc] initWithFrame:CGRectMake(3, 3, 68, 30)];
    scoreBtn.titleLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightSemibold];
    [scoreBtn setTitle:@" 比分" forState:UIControlStateNormal];
    [scoreBtn setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
    [scoreBtn setTitleColor:Blue_Color forState:UIControlStateSelected];
    [scoreBtn setImage:[UIImage imageNamed:@"比分未选"] forState:UIControlStateNormal];
    [scoreBtn setImage:[UIImage imageNamed:@"比分选中"] forState:UIControlStateSelected];
    [scoreBtn addTarget:self action:@selector(scoreBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [scoreBtn setBackgroundImage:[UIImage imageNamed:@"矩形-1"] forState:UIControlStateSelected];
    scoreBtn.selected = YES;
    [qiehuanBackView addSubview:scoreBtn];
    self.scoreBtn = scoreBtn;


    UIButton *zhishuBtn = [[UIButton alloc] initWithFrame:CGRectMake(142 -3 - 68, 3, 68, 30)];
    zhishuBtn.titleLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightSemibold];
    [zhishuBtn setTitle:@" 指数" forState:UIControlStateNormal];
    [zhishuBtn setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
    [zhishuBtn setTitleColor:Blue_Color forState:UIControlStateSelected];
    [zhishuBtn setImage:[UIImage imageNamed:@"指数未选"] forState:UIControlStateNormal];
    [zhishuBtn setImage:[UIImage imageNamed:@"指数选中"] forState:UIControlStateSelected];
    [zhishuBtn setBackgroundImage:[UIImage imageNamed:@"矩形-1"] forState:UIControlStateSelected];
    [zhishuBtn addTarget:self action:@selector(zhishuBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [qiehuanBackView addSubview:zhishuBtn];
    self.zhishuBtn = zhishuBtn;
}

- (void)todayBtnAction:(UIButton *)sender {
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2] atScrollPosition:UITableViewScrollPositionTop animated:false];
    /// 如果今天没有比赛了，指定刷新今天日期的数据
    if (!self.isTodayHaveMatch) {
        self.calendarChoice = [LiveListCalendarVC getCurrentString];
        self.startTimeChoice = self.calendarChoice;
        [KYRemindView show];
        self.pn = 1;
        [self getDatas:YES];
        return;
    }
    if (self.timeStatus == 0) {
        /// 除了全部分类 点击今天 需要加载今天所有的
        if ([self.categoryModel isKindOfClass:[LiveListCategoryModel class]]) {
            self.calendarChoice = [LiveListCalendarVC getCurrentString];
            self.startTimeChoice = self.calendarChoice;
            [KYRemindView show];
            self.pn = 1;
            [self getDatas:YES];
        } else {
            if (self.noTopListArray.count > 0 || self.topListArray.count > 0) {
                //如果有这两个数据 直接滚到 最上面
                [self.tableView setContentOffset:CGPointZero animated:YES];
            }else {
                //没有的话 点击需要滚动到 今天开赛的时候的cell
                NSArray *dataList = self.datasArray.firstObject;
                if (dataList.count > 0) {
                    NSInteger __block index = 0;
                    [dataList enumerateObjectsUsingBlock:^(LiveListModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        if (obj.status.intValue < 2) {
                            index = idx;
                            *stop = YES;
                        }
                    }];
                    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:2] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
                }
            }
            self.todayBtn.hidden = true;
            self.qiehuanBackView.hidden = NO;
        }

    }else if (self.timeStatus == 1) {
        //再过去点击今天就是刷新
        [KYRemindView show];
        self.startTime = @"";
        [self reloadDatas];
    }else {
        //在未来也是刷新
        [KYRemindView show];
        self.startTime = @"";
        [self reloadDatas];
    }
}

- (void)scoreBtnAction:(UIButton *)sender {
    self.scoreBtn.selected = YES;
    self.zhishuBtn.selected = NO;
    // 比分
    self.listType = 0;
    [self.tableView reloadData];
}

- (void)zhishuBtnAction:(UIButton *)sender {
    self.scoreBtn.selected = NO;
    self.zhishuBtn.selected = YES;
    // 指数
    self.listType = 1;
    [self.tableView reloadData];
}


- (void)changeType:(NSNotification *)notification {
    NSString *type = notification.object;
    if ([type isEqualToString:@"0"]) {
        // 比分
        self.listType = 0;
    } else if ([type isEqualToString:@"1"]) {
        // 指数
        self.listType = 1;
    }
    [self.tableView reloadData];
}

- (void)enterApp {
    [self.tableView reloadData];
    NSString *currentString = [LiveListCalendarVC getCurrentString];
    if (self.datasArray.count > 0) {
        if ([CommonTools isBlankString:self.startTimeChoice]) {
            [self reloadDatas];
        }else if ([self.startTimeChoice isEqualToString: currentString]) {
            self.pn = 1;
            [self getDatas:YES];
        }else if (![self.startTimeChoice isEqualToString: currentString]) {
//            self.pn = 1;
            self.startTime = @"";
//            [self getDatas:YES];
            [self reloadDatas];
        }
    }
}

//列表删除已完成的数据
- (void)deleteFinishList {
    NSArray *finishList = [HomeWSManager instance].finishiIdArray;
    if (finishList.count > 0) {
        self.isDeletList = YES;
        NSMutableArray *topList = [NSMutableArray array];
        for (LiveListModel *listModel in self.topListArray) {
            if (![finishList containsObject:[listModel.ID stringValue]]) {
                [topList addObject:listModel];
            }
        }

        NSMutableArray *noTopList = [NSMutableArray array];
        for (LiveListModel *listModel in self.noTopListArray) {
            if (![finishList containsObject:[listModel.ID stringValue]]) {
                [noTopList addObject:listModel];
            }
        }

        NSMutableArray *dataList = [NSMutableArray array];
        for (NSArray *listArray in self.datasArray) {
            NSMutableArray *sectionList = [NSMutableArray array];
            for (LiveListModel *listModel in listArray) {
                if (![finishList containsObject:[listModel.ID stringValue]]) {
                    [sectionList addObject:listModel];
                }
            }
            if (sectionList.count > 0) {
                [dataList addObject:sectionList];
            }
        }
        self.noTopListArray = noTopList;
        self.topListArray = topList;
        self.datasArray = dataList;
        [self.tableView reloadData];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.isDeletList = NO;
        });
    }
}

- (void)reloadDatas {
    self.pn = 1;
    self.calendarChoice = nil;
    self.startTimeChoice = nil;
    [[HomeWSManager instance] cleaDatas];
    [self getDatas:YES];
}

- (void)reloadDatasFromOutside {
    self.startTime = self.startTimeChoice;
    self.pn = 1;
    [[HomeWSManager instance] cleaDatas];
    [self getDatas:YES];
}

- (void)getCalendarData {
    if (self.calendarData == nil) {
        NSString *type = [self.categoryModel isKindOfClass:[LiveListCategoryModel class]] ? [NSString stringWithFormat:@"%@",self.categoryModel.type]:[NSString stringWithFormat:@"%d",4];
        NSNumber *cid = [self.categoryModel isKindOfClass:[LiveListCategoryModel class]] ? self.categoryModel.ID : @(0);
        [KYApiHttpTool GET:URL_CALENDAR_DATA withParams:@{@"cid":cid, @"type":type} success:^(NSDictionary * _Nonnull response) {
            NSArray *data = response[@"data"];
            self.calendarData = [NSMutableDictionary new];
            for (NSDictionary *dic in data) {
                self.calendarData[(NSString *)dic[@"matchdate"]] = ((NSNumber *)dic[@"totalmatch"]).stringValue;
            }
            [self.topView reloadDayNuber:self.calendarData];
        }failure:^(NSError * _Nullable error) {

        }];
    }
}

- (NSString *)getTodayString {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *date = [NSDate date];

    NSInteger year = [calendar component:NSCalendarUnitYear fromDate:date];
    NSInteger month = [calendar component:NSCalendarUnitMonth fromDate:date];
    NSInteger day = [calendar component:NSCalendarUnitDay fromDate:date];

    NSString *dateString = [NSString stringWithFormat:@"%04ld-%02ld-%02ld", year, month, day];

    return  dateString;
}

- (void)getDatas:(BOOL)isRefresh {

    NSString *type = [self.categoryModel isKindOfClass:[LiveListCategoryModel class]] ? [NSString stringWithFormat:@"%@",self.categoryModel.type]:[NSString stringWithFormat:@"%ld",(long)self.type];
    NSNumber *cid = [self.categoryModel isKindOfClass:[LiveListCategoryModel class]] ? self.categoryModel.ID : @(0);
    NSNumber *ishot = self.isHot ? @(1) : @(-1);
    NSString *pn = [NSString stringWithFormat:@"%ld", (long)self.pn];
    NSString *ps = [NSString stringWithFormat:@"%ld", (long)self.ps];
    if ([self.calendarChoice isEqualToString:[LiveListCalendarVC getCurrentString]] && [self.categoryModel isKindOfClass:[LiveListCategoryModel class]]) {
        ps = @"100";
    }
    NSMutableDictionary *param = nil;
    gCategoryType = type.integerValue;

    if ([type intValue] == 3) {
        param = @{
            @"type" : @"4",
            @"cid" : cid,
            @"ishot" : @"1",
            @"pn" : pn,
            @"ps" : ps,
            @"pid" : @"4",
            @"isfanye" : @"1",
            @"status" : @"2",
            @"zhuboType" : @"0",
            @"starttime" : [self.startTime isEqualToString:@""] ? [self getTodayString] : self.startTime,
            @"zoneId" : @"Asia/Taipei",
            @"langtype" : @"zh",
            @"isnew" : @"1"
        }.mutableCopy;
    } else {
        param = @{
            @"isfanye" : @"1",
            @"type" : [type intValue] == -1 ? @"0" : type,
            @"cid" : cid,
            @"ishot" : ishot,
            @"pn" : pn,
            @"ps" : ps,
            @"pid" : @"4",
            @"starttime" :  [self.startTime isEqualToString:@""] ? [self getTodayString] : self.startTime,
            @"zoneId" : @"Asia/Taipei",
            @"langtype" : @"zh",
            @"zhuboType" : [type intValue] == -1 ? @"1" : @"0"  // 只有熱門-全部才要設為1
        }.mutableCopy;
    }

    /// 如果用日历选择过日期
    if (self.startTimeChoice != nil && self.startTimeChoice.length > 0) {
        [param setValue:self.startTimeChoice forKey:@"starttime"];
    }else {
        if ([self.categoryModel isKindOfClass:[LiveListCategoryModel class]]) {
            [param setValue:[LiveListCalendarVC getCurrentString] forKey:@"starttime"];
        }
    }
    LoginUserModel *loginModel = [UserModelTool loginModel];
    if (loginModel) {
        [param setValue:loginModel.uid forKey:@"uid"];
        [param setValue:loginModel.token forKey:@"token"];
    }
    void (^success)(NSDictionary *) = ^(NSDictionary * _Nonnull response) {

        id dic = response[@"data"];
        if (dic == nil || [dic isKindOfClass:[NSNull class]]) {
            return;
        }
        //=0是用来审核的
        self.tableView.backgroundView = nil;
        self.live_type = [response[@"data"][@"live_type"] integerValue];
        self.live_type = 0;
        [[NSUserDefaults standardUserDefaults] setInteger:self.live_type forKey:@"zhiyoudonghuazhibo"];
        self.token = response[@"data"][@"token"];
        [HomeWSManager instance].type = self.type;
        [[HomeWSManager instance] SRWebSocketOpenWithURLString:[NSString stringWithFormat:@"%@?token=%@",ListSocketUrl,self.token]];

        NSArray *topList = [LiveListModel mj_objectArrayWithKeyValuesArray:response[@"data"][@"topList"]];
        [topList enumerateObjectsUsingBlock:^(LiveListModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.listType = 1;
        }];

        [[NSNotificationCenter defaultCenter] postNotificationName:ListRefreshComplete object:nil userInfo:nil];
        NSArray *notopList = [LiveListModel mj_objectArrayWithKeyValuesArray:response[@"data"][@"notopList"]];
        NSArray *tmpList = [LiveListModel mj_objectArrayWithKeyValuesArray:response[@"data"][@"dataList"]];
        LiveListModel *model = tmpList.firstObject;
        NSLog(@"======%@",model.matchtime);

        // NSArray *dataList = [NSArray arrayWithObjects:topList, notopList, tmpList, nil];
        NSMutableArray *dataList = [NSMutableArray arrayWithArray:topList];
        [dataList addObjectsFromArray:notopList];
        [dataList addObjectsFromArray:tmpList];

        if (isRefresh) {
            // self.topListArray = [self sortDataListAgain2:topList];
            // self.noTopListArray = [self sortDataListAgain2:notopList];
            [self.datasArray removeAllObjects];
            [self.tableView reloadData];
            //子分类
            if ([self.categoryModel isKindOfClass:[LiveListCategoryModel class]]) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    if ([CommonTools isBlankString:self.calendarChoice]) {
                        if (self.noTopListArray.count > 0 || self.topListArray.count > 0) {
                            //如果有这两个数据 直接滚到 最上面
                            [self.tableView setContentOffset:CGPointZero animated:YES];
                        }else {
                            //没有的话 点击需要滚动到 今天开赛的时候的cell
                            NSArray *dataList = self.datasArray.firstObject;
                            if (dataList.count > 0) {
                                NSInteger __block index = -1;
                                [dataList enumerateObjectsUsingBlock:^(LiveListModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                    if (obj.status.intValue < 2) {
                                        index = idx;
                                        *stop = YES;
                                    }
                                }];
                                if (index == -1) {
                                    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:3] atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
                                }else {
                                    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:2] atScrollPosition:UITableViewScrollPositionMiddle animated:NO];}
                            }
                        }
                    }
                });
            }else {
                self.tableView.contentOffset = CGPointZero;
            }
        }
        [self sortDataList:dataList];
        [self.originalDatasArray removeAllObjects];
        [self originalSortDataList:dataList];
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        self.pn = [response[@"data"][@"currentPage"] integerValue] + 1;
        self.startTime = response[@"data"][@"starttime"];
        if (self.pn == [response[@"data"][@"totalPage"] integerValue]) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        if (self.pn == 1) {
            LiveListModel *model;
            if (self.topListArray.count >= 1) {
                model = [self.topListArray firstObject];
            }else if (self.noTopListArray.count >= 1) {
                model = [self.noTopListArray firstObject];
            }else {
                model = [[self.datasArray firstObject] firstObject];
            }
            if (model != nil && model.matchtime != nil && model.matchtime.length > 10) {
                [self.topView changeChoiceNotAnimated:[model.matchtime substringToIndex:10]];
            }
        }

        /// 如果没有选择日期--说明是刷新数据    并且是第一页数据
        if ((self.calendarChoice == nil || self.calendarChoice.length <= 0) && self.pn == 1) {
            /// 如果两个热门都是空
            if (self.noTopListArray.count <= 0 && self.topListArray.count <= 0) {
                NSArray *dataList = self.datasArray.firstObject;
                LiveListModel *model = dataList.firstObject;
                if (model != nil && model.matchtime != nil && model.matchtime.length > 10 &&
                    /// 第一个比赛日期和当前日期不一致
                    ![[LiveListCalendarVC getCurrentString] isEqualToString:[model.matchtime substringToIndex:10]]
                    ) {
                    self.isTodayHaveMatch = false;
                } else {
                    self.isTodayHaveMatch = true;
                }
            } else {
                self.isTodayHaveMatch = true;
            }
        }
        // self.pn++;
    };
    void (^ fail)(NSError *) = ^(NSError * _Nonnull error) {
        [[NSNotificationCenter defaultCenter] postNotificationName:ListRefreshComplete object:nil userInfo:nil];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        NSInteger codeint = error.code;
        self.tableView.backgroundView = self.emptyBackView;
        if (codeint == (-999)) {
            self.emptyImageView.image = [UIImage imageNamed:@"暂无网络"];
            self.emptyLabel.text = @"网络不好，请刷新重试";
        }else if (codeint == (-1001)) {
            self.emptyImageView.image = [UIImage imageNamed:@"暂无网络"];
            self.emptyLabel.text = @"网络不好，请刷新重试";
        }else if (codeint == (-1009)) {
            self.emptyImageView.image = [UIImage imageNamed:@"暂无网络"];
            self.emptyLabel.text = @"网络不好，请刷新重试";
        }else {
            //判断系统错误
            self.emptyImageView.image = [UIImage imageNamed:@"服务器维护中"];
            self.emptyLabel.text = @"服务器维护或网络异常，下拉刷新尝试";
        }
    };
    if (self.isFirstLoad) {
        self.isFirstLoad = false;
        [KYApiHttpTool FirstGET:URL_MATCH_LIST withParams:param success:success failure:fail];
        return;
    }
    [KYApiHttpTool GET:URL_MATCH_LIST withParams:param success:success failure:fail];
}

- (void)sortDataList:(NSArray *)dataList {
    NSMutableArray *timeArray = [NSMutableArray array];
    [dataList enumerateObjectsUsingBlock:^(LiveListModel *listModel, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *timeStr = [listModel.matchtime substringToIndex:10];
        if (![timeArray containsObject:timeStr]) {
            [timeArray addObject:timeStr];
        }
    }];
    NSMutableArray *dataArray = [NSMutableArray array];
    for (int i = 0; i < timeArray.count; i++) {
        NSMutableArray *sectionArray = [NSMutableArray array];
        NSString *time = timeArray[i];
        [dataList enumerateObjectsUsingBlock:^(LiveListModel *listModel, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *timeStr = [listModel.matchtime substringToIndex:10];
            if ([time isEqualToString:timeStr]) {
                [sectionArray addObject:listModel];
            }
        }];
        [dataArray addObject:sectionArray];
    }
    if (self.datasArray.count > 0 && dataArray.count > 0) {
        NSArray *firstArray = dataArray.firstObject;
        NSArray *lastArray = self.datasArray.lastObject;
        LiveListModel *firstModel = firstArray.firstObject;
        LiveListModel *lastModel = lastArray.lastObject;
        NSString *timef = [firstModel.matchtime substringToIndex:10];
        NSString *timel = [lastModel.matchtime  substringToIndex:10];
        if ([timef isEqualToString:timel]) {
            NSMutableArray *heArray = [NSMutableArray arrayWithArray:lastArray];
            [heArray addObjectsFromArray:firstArray];
            [self.datasArray removeLastObject];
            [dataArray removeObjectAtIndex:0];
            [self.datasArray addObject:heArray];
        }
    }
    NSUserDefaults *df = [NSUserDefaults standardUserDefaults];
    if ([df objectForKey:@"TopModel"] == nil) {
        [self.datasArray addObjectsFromArray:[self sortDataListAgain:dataArray]];
    } else {
        [self.datasArray addObjectsFromArray:[self sortDataListAgainWithTopMatch:dataArray]];
    }
}

- (void)originalSortDataList:(NSArray *)dataList {
    NSMutableArray *timeArray = [NSMutableArray array];
    [dataList enumerateObjectsUsingBlock:^(LiveListModel *listModel, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *timeStr = [listModel.matchtime substringToIndex:10];
        if (![timeArray containsObject:timeStr]) {
            [timeArray addObject:timeStr];
        }
    }];
    NSMutableArray *dataArray = [NSMutableArray array];
    for (int i = 0; i < timeArray.count; i++) {
        NSMutableArray *sectionArray = [NSMutableArray array];
        NSString *time = timeArray[i];
        [dataList enumerateObjectsUsingBlock:^(LiveListModel *listModel, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *timeStr = [listModel.matchtime substringToIndex:10];
            if ([time isEqualToString:timeStr]) {
                [sectionArray addObject:listModel];
            }
        }];
        [dataArray addObject:sectionArray];
    }
    if (self.originalDatasArray.count > 0 && dataArray.count > 0) {
        NSArray *firstArray = dataArray.firstObject;
        NSArray *lastArray = self.originalDatasArray.lastObject;
        LiveListModel *firstModel = firstArray.firstObject;
        LiveListModel *lastModel = lastArray.lastObject;
        NSString *timef = [firstModel.matchtime substringToIndex:10];
        NSString *timel = [lastModel.matchtime  substringToIndex:10];
        if ([timef isEqualToString:timel]) {
            NSMutableArray *heArray = [NSMutableArray arrayWithArray:lastArray];
            [heArray addObjectsFromArray:firstArray];
            [self.originalDatasArray removeLastObject];
            [dataArray removeObjectAtIndex:0];
            [self.originalDatasArray addObject:heArray];
        }
    }
    [self.originalDatasArray addObjectsFromArray:[self sortDataListAgain:dataArray]];
}

- (void)originalSortDataList2:(NSArray *)dataList {
    NSMutableArray *dataNewAry = [NSMutableArray new];
    [dataNewAry addObjectsFromArray:[self sortDataListAgainWithTopMatch:dataList]];
    [self.datasArray[0] removeAllObjects];
    [self.datasArray removeAllObjects];
    self.datasArray = [NSMutableArray arrayWithArray:dataNewAry];
}

//
- (NSMutableArray *)sortDataListAgain:(NSArray *)dataArray {
    NSMutableArray *ary1 = [NSMutableArray new];
    NSMutableArray *ary2 = [NSMutableArray new];
    NSMutableArray *rcAry = [NSMutableArray new];
    NSMutableArray *dataList = [NSMutableArray new];
    if (dataArray.count == 0) {
        return (NSMutableArray *)dataArray;
    }

    for (LiveListModel *model in dataArray[0]) {
        if (model.is_zd == 1) {
            [ary1 addObject:model];
        } else {
            [ary2 addObject:model];
        }
    }

    NSArray *sorted = [ary1 sortedArrayUsingComparator:^(id obj1, id obj2){
        LiveListModel *s1 = obj1;
        LiveListModel *s2 = obj2;

        if ([s1.zd_level intValue] > [s2.zd_level intValue]) {
            return (NSComparisonResult)NSOrderedAscending;
        } else if ([s1.zd_level intValue] < [s2.zd_level intValue]) {
            return (NSComparisonResult)NSOrderedDescending;
        }

        return NSOrderedSame;
    }];

    [rcAry addObjectsFromArray:sorted];
    [rcAry addObjectsFromArray:ary2];
    [dataList addObject:rcAry];
    return  dataList;
}

- (NSMutableArray *)sortDataListAgainWithTopMatch:(NSArray *)dataArray {
    NSMutableArray *ary1 = [NSMutableArray new];
    NSMutableArray *ary2 = [NSMutableArray new];
    NSMutableArray *rcAry = [NSMutableArray new];
    NSMutableArray *topMatchList = nil;
    NSMutableArray *dataList = [NSMutableArray new];
    if (dataArray.count == 0) {
        return (NSMutableArray *)dataArray;
    }

    for (LiveListModel *model in dataArray[0]) {
        if (model.is_zd == 1) {
            [ary1 addObject:model];
        } else {
            [ary2 addObject:model];
        }
    }

    NSArray *sorted = [ary1 sortedArrayUsingComparator:^(id obj1, id obj2){
        LiveListModel *s1 = obj1;
        LiveListModel *s2 = obj2;

        if ([s1.zd_level intValue] > [s2.zd_level intValue]) {
            return (NSComparisonResult)NSOrderedAscending;
        } else if ([s1.zd_level intValue] < [s2.zd_level intValue]) {
            return (NSComparisonResult)NSOrderedDescending;
        }

        return NSOrderedSame;
    }];

    topMatchList = [[NSUserDefaults standardUserDefaults]objectForKey:@"TopModel"];
    if (topMatchList == nil) {
        [rcAry addObjectsFromArray:sorted];
        [rcAry addObjectsFromArray:ary2];
        [dataList addObject:rcAry];
        return  dataList;
    } else {
        NSMutableArray *rc = [NSMutableArray new];
        [rcAry addObjectsFromArray:sorted];
        [rcAry addObjectsFromArray:ary2];
        NSMutableArray *matchedList = [NSMutableArray new];
        NSMutableArray *nonMatchedList = [NSMutableArray new];
        for (LiveListModel *model in rcAry) {
            BOOL flag = NO;
            model.isTop = NO;
            for (NSDictionary *d in topMatchList) {
                if ([d[@"ID"] intValue] == [model.ID intValue]) {
                    model.isTop = YES;
                    flag = YES;
                    break;
                }
            }
            if (flag) {
                [matchedList insertObject:model atIndex:0];
            } else {
                [nonMatchedList addObject:model];
            }
        }
        [rc addObjectsFromArray:matchedList];
        [rc addObjectsFromArray:nonMatchedList];
        [dataList addObject:rc];
        return  dataList;
    }
}

- (NSMutableArray *)sortDataListAgain2:(NSArray *)dataArray {
    NSMutableArray *ary1 = [NSMutableArray new];
    NSMutableArray *ary2 = [NSMutableArray new];
    NSMutableArray *rcAry = [NSMutableArray new];
    if (dataArray.count == 0) {
        return (NSMutableArray *)dataArray;
    }

    for (LiveListModel *model in dataArray) {
        if (model.is_zd == 1) {
            [ary1 addObject:model];
        } else {
            [ary2 addObject:model];
        }
    }

    NSArray *sorted = [ary1 sortedArrayUsingComparator:^(id obj1, id obj2){
        LiveListModel *s1 = obj1;
        LiveListModel *s2 = obj2;

        if ([s1.zd_level intValue] < [s2.zd_level intValue]) {
            return (NSComparisonResult)NSOrderedDescending;
        }

        return NSOrderedSame;
    }];

    [rcAry addObjectsFromArray:sorted];
    [rcAry addObjectsFromArray:ary2];
    return  rcAry;
}

- (void)setupEmptyView {
    UIView *backView = [[UIView alloc] initWithFrame:self.tableView.bounds];
    self.emptyBackView = backView;
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 223, 187)];
    self.emptyImageView = imageView;
    [backView addSubview:imageView];
    imageView.image = [UIImage imageNamed:@"暂无比赛"];
    imageView.centerX = backView.centerX;
    imageView.centerY = (kScreenHeight - NavHeight -187 - 44)/2;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(imageView.frame)+5, kScreenWidth, 25)];
    self.emptyLabel = label;
    label.font = [UIFont fontWithName:@"PingFangSC-Regular" size: 14];
    label.textColor = SRGB(102);
    label.textAlignment = NSTextAlignmentCenter;
    [backView addSubview:label];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.datasArray.count+2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.topListArray.count;
    }else if (section == 1) {
        return self.noTopListArray.count;
    }else {
        NSArray *modelsArray = self.datasArray[section-2];
        return modelsArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WeakSelf;
    LiveListModel *listModel;
    if (indexPath.section == 0) {
        listModel = self.topListArray[indexPath.row];
    }else if (indexPath.section == 1) {
        listModel = self.noTopListArray[indexPath.row];
    }else {
        NSArray *modelsArray = self.datasArray[indexPath.section-2];
        listModel = modelsArray[indexPath.row];
    }
    listModel.live_type = self.live_type;
    [self reloadListModel:listModel];
    // 当 type = 3 的时候 status = 1 是未开赛 = 2 是比赛中 = 3 是完场
    if (listModel.type.intValue == 3 && listModel.status.intValue == 3 && self.timeStatus < 2) {//过去了 和今天完结的
        LiveListTheEndTableViewCell *cell = [LiveListTheEndTableViewCell cellWithTableView:tableView];
        cell.selectionStyle = 0;
        [cell setModel:listModel];
        return cell;
    }
    // 当 type = 1 or 2 的时候 0 开赛中  1 未开赛  2 比赛结束
    if ((listModel.type.intValue == 1 || listModel.type.intValue == 2) && listModel.status.intValue == 2 && self.timeStatus < 2) {//过去了 和今天完结的
        LiveListTheEndTableViewCell *cell = [LiveListTheEndTableViewCell cellWithTableView:tableView];
        cell.selectionStyle = 0;
        [cell setModel:listModel];
        return cell;
    }

    // 好像沒用到
    if (self.listType == 1) {
        if (listModel.type.intValue == 1) {
            /// 足球
            LiveListExponentFootballCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ExponentFootballCell"];
            if (cell == nil) {
                cell = [[LiveListExponentFootballCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ExponentFootballCell"];
            }
            cell.videoShow.tap = ^(NSInteger index) {
                if (index < listModel.live_urls.count) {
                    listModel.selectCartoonModel = listModel.live_urls[index];
                }else {
                    listModel.selectCartoonModel = listModel.live_cartoon_url.firstObject;
                }
                [weakSelf didSelectItem:listModel];
            };
            [cell reloadCellWithModel:[self changeLiveListModelToCellModel:listModel]];
            return cell;
        }
        // 好像沒用到
        else if (listModel.type.intValue == 2) {
            /// 篮球
            LiveListExponentBasketballCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ExponentBasketballCell"];
            if (cell == nil) {
                cell = [[LiveListExponentBasketballCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ExponentBasketballCell"];
            }
            cell.videoShow.tap = ^(NSInteger index) {
                if (index < listModel.live_urls.count) {
                    listModel.selectCartoonModel = listModel.live_urls[index];
                }else {
                    listModel.selectCartoonModel = listModel.live_cartoon_url.firstObject;
                }
                [weakSelf didSelectItem:listModel];
            };
            [cell reloadCellWithModel:[self changeLiveListModelToCellModel:listModel]];
            return cell;
        }
    }
    LiveListTableViewCell *cell = [LiveListTableViewCell cellWithTableView:tableView];
    cell.selectionStyle = 0;
    cell.currentRow = indexPath.row;
    [cell setModel:listModel];
    cell.resolutionBtnClicked = ^(LiveCartoonModel *cartoonModel) {
        listModel.selectCartoonModel = cartoonModel;
        [weakSelf didSelectItem:listModel];
    };
    return cell;
}

- (void)topMatch:(NSNotification *)noti {
    NSDictionary *dict = noti.object;
    LiveListModel *model = dict[@"Model"];

    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    dic[@"type"] = model.type;       // NSNumber 型態
    dic[@"ID"]  = model.ID;          // NSNumber 型態

    NSUserDefaults *df = [NSUserDefaults standardUserDefaults];
    if ([df objectForKey:@"TopModel"] == nil) {
        NSMutableArray *ary = [[NSMutableArray alloc]init];
        [ary addObject:dic];
        [df setObject:ary forKey:@"TopModel"];
    } else {
        NSArray *ary = [df objectForKey:@"TopModel"];
        NSMutableArray *rc = [NSMutableArray new];
        [rc addObjectsFromArray:ary];
        [rc addObject:dic];
        [df setObject:rc forKey:@"TopModel"];
    }
    NSMutableArray *dataList = [NSMutableArray arrayWithArray:self.datasArray[0]];
    [self.datasArray[0] removeAllObjects];
    [self.datasArray removeAllObjects];
    [self sortDataList:dataList];
    [self.tableView reloadData];
}

- (void)UnTopMatch:(NSNotification *)noti {
    NSDictionary *dict = noti.object;
    LiveListModel *model = dict[@"Model"];

    NSUserDefaults *df = [NSUserDefaults standardUserDefaults];
    if ([df objectForKey:@"TopModel"] == nil) {
        return;
    } else {
        NSArray *ary = [df objectForKey:@"TopModel"];
        NSMutableArray *rc = [NSMutableArray new];
        [rc addObjectsFromArray:ary];
        for (NSInteger i = rc.count - 1; i>=0; i--) {
            NSDictionary *d = rc[i];
            if (model.ID.intValue == [d[@"ID"] intValue]) {
                model.isTop = NO;
                [rc removeObjectAtIndex:i];
            }
        }
        if (rc.count == 0) {
            model.isTop = NO;
            [df removeObjectForKey:@"TopModel"];
        } else {
            [df setObject:rc forKey:@"TopModel"];
        }
    }
    NSMutableArray *dataList = [NSMutableArray arrayWithArray:self.originalDatasArray];
    [self originalSortDataList2:dataList];
    [self.tableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        if (self.topListArray.count == 0) {
            return 0;
        }
    }else if (section == 1) {
        if (self.noTopListArray.count == 0) {
            return 0;
        }
//        /// 去掉顶部日期显示
//        return 0;
    }else {
        for (int i=0; i<self.noTopListArray.count; i++) {
            LiveListModel *model = self.noTopListArray[i];
            if (model.type.intValue == 3 && model.status.intValue == 2) {
                return 0;
            }
        }
        if (self.datasArray.count == 0) {
            return 0;
        }
//        /// 去掉顶部日期显示
//        if (self.noTopListArray.count == 0 && section == 2) {
//            return 0;
//        }
    }
    return 0;
    // return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    if (section == 0) {
        if (self.topListArray.count > 0) {
            return [self setupSectionHeaderView:@"热门赛事"];
        }
    }else if (section == 1) {
        if (self.noTopListArray.count > 0) {
            LiveListModel *listModel = self.noTopListArray.firstObject;
            NSString *week = [self getCurrentTimeAndWeekDay:listModel.matchtime];
            return [self setupSectionHeaderView:week];
        }
    }else {
        for (int i=0; i<self.noTopListArray.count; i++) {
            LiveListModel *model = self.noTopListArray[i];
            if (model.type.intValue == 3 && model.status.intValue == 2) {
                return nil;
            }
        }
        if (self.datasArray.count > 0) {
            NSArray *modelsArray = self.datasArray[section-2];
            LiveListModel *listModel = modelsArray.firstObject;
            NSString *week = [self getCurrentTimeAndWeekDay:listModel.matchtime];
            return [self setupSectionHeaderView:week];
        }
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    LiveListModel *listModel;
    if (indexPath.section == 0) {
        listModel = self.topListArray[indexPath.row];
    }else if (indexPath.section == 1) {
        listModel = self.noTopListArray[indexPath.row];
    }else {
        NSArray *modelsArray = self.datasArray[indexPath.section-2];
        listModel = modelsArray[indexPath.row];
    }
    if (listModel.type.intValue == 3) {
        return 103;
    }
    if (listModel.status.intValue > 1 && self.timeStatus < 2) {
        return 80;
    }
    if (self.listType == 0) {
        return 103 + (listModel.contentHeight > 0? listModel.contentHeight-30:0);
    }else {
        return 103;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    LiveListModel *listModel;
    // NSLog(@"[Adam]topListArray:%@", [_topListArray mj_JSONString]);
    if (indexPath.section == 0) {
        listModel = self.topListArray[indexPath.row];
    }else if (indexPath.section == 1) {
        listModel = self.noTopListArray[indexPath.row];
    }else {
        NSArray *modelsArray = self.datasArray[indexPath.section-2];
        listModel = modelsArray[indexPath.row];
    }
    listModel.selectCartoonModel = nil;
    [self didSelectItem:listModel];
}

- (void)didSelectItem:(LiveListModel *)listModel {
    listModel.live_type = self.live_type;
    if (SNPictureInPictureShared.playerVc.model.ID == listModel.ID) {
        if (SNPictureInPictureShared.picController.isPictureInPictureActive) {
            [self.navigationController pushViewController:[SNPictureInPictureShare sharedInstance].playerVc animated:YES];
        }else {
            SNPictureInPictureShared.playerVc = nil;
            LiveDetailController *vc = [[LiveDetailController alloc] init];
            vc.model = listModel;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else if (ZFPlayerWindowShared.zfPlayer.model.ID.intValue == listModel.ID.intValue && ZFPlayerWindowShared.backController) {
        [self.navigationController pushViewController:ZFPlayerWindowShared.backController animated:YES];
    }else {
        LiveDetailController *vc = [[LiveDetailController alloc] init];
        vc.model = listModel;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (UIView *)listView {
    return self.view;
}

- (void)reloadListModel:(LiveListModel *)model {
    model.isNew = NO;
    model.isT1New = NO;
    model.isT2New = NO;
    NSArray *arr = [[HomeWSManager instance] getInfo:[NSString stringWithFormat:@"%d-%d", model.type.intValue, model.ID.intValue]];
    if (model.type.intValue == 1) {
        if (arr.count >= 11) {
            // 足球
            // 状态
            NSInteger status = ((NSString *)arr[2]).integerValue;
            model.status_up = status;
            // 比分
            NSString *score = arr[4];
            NSArray *scores = [score componentsSeparatedByString:@"-"];
            NSArray *scores1 = [model.score componentsSeparatedByString:@"-"];
            if ([scores.firstObject integerValue] > [scores1.firstObject integerValue] || [scores.lastObject integerValue] > [scores1.lastObject integerValue]) {
                model.score = score;
            }
            if ([scores.firstObject integerValue] > [scores1.firstObject integerValue] || [scores.lastObject integerValue] > [scores1.lastObject integerValue]) {
                model.isNew = YES;
            }
            if ([scores.firstObject integerValue] > [scores1.firstObject integerValue]) {
                model.isT1New = YES;
            }
            if ([scores.lastObject integerValue] > [scores1.lastObject integerValue]) {
                model.isT2New = YES;
            }
            // 节数
            NSString *status_up_name = arr[3];
            model.status_up_name = status_up_name;
            // 半场比分

            // 角球
            NSString *jiaoqiu = arr[6];
            model.jiaoqiu = jiaoqiu;
            // 进行时间
            NSString *time = arr[7];
            if ([time integerValue] > [model.time integerValue]) {
                model.time = time;
            }
        }
    } else if (model.type.intValue == 2) {
        if (arr.count >= 10) {
            // 篮球
            // 状态
            NSInteger status = ((NSString *)arr[2]).integerValue;
            model.status_up = status;
            // 节数
            NSString *status_up_name = arr[3];
            model.status_up_name = status_up_name;
            // 比分
            NSString *score = arr[4];
            NSArray *scores = [score componentsSeparatedByString:@"-"];
            NSArray *scores1 = [model.score componentsSeparatedByString:@"-"];
            if ([scores.firstObject integerValue] >= [scores1.lastObject integerValue] && [scores.lastObject integerValue] >= [scores1.firstObject integerValue]) {
                /// 篮球，比分反过来
                model.score = [NSString stringWithFormat:@"%@-%@",scores.lastObject, scores.firstObject];
            }
            if ([scores.firstObject integerValue] > [scores1.lastObject integerValue] || [scores.lastObject integerValue] > [scores1.firstObject integerValue]) {
                model.isNew = YES;
            }
            if ([scores.firstObject integerValue] > [scores1.lastObject integerValue]) {
                model.isT1New = YES;
            }
            if ([scores.lastObject integerValue] > [scores1.firstObject integerValue]) {
                model.isT2New = YES;
            }
            // 剩余时间
            NSString *time = arr[5];
            NSInteger time1 = [[time stringByReplacingOccurrencesOfString:@":" withString:@""] integerValue];
            NSInteger time2 = [[model.time stringByReplacingOccurrencesOfString:@":" withString:@""] integerValue];
            if (time1 < time2) {
                model.time = time;
            }

            NSString *homeScore= arr[8];
            if (![homeScore isEqualToString:@"no"]) {
                NSArray *home_score_xiaojie = [homeScore componentsSeparatedByString:@","];
                model.home_score_xiaojie = home_score_xiaojie;
            }

            NSString *awayScore = arr[9];
            if (![awayScore isEqualToString:@"no"]) {
                NSArray *away_score_xiaojie = [awayScore componentsSeparatedByString:@","];
                model.away_score_xiaojie = away_score_xiaojie;
            }
        }
    }
}

- (CellModel *)changeLiveListModelToCellModel:(LiveListModel *) model {
    NSString *time;
    if (model.matchtime.length >= 16) {
        time = [model.matchtime substringWithRange:NSMakeRange(11, 5)];
    }else {
        time = model.matchtime;
    }
    NSArray *scores = [model.score componentsSeparatedByString:@"-"];
    if (model.type.intValue == 2) {
        /// 篮球，比分反过来
        scores = @[scores.lastObject, scores.firstObject];
    }
    NSString *t1name = model.ateam_name;
    NSString *t2name = model.hteam_name;
    NSString *t1url = model.ateam_logo;
    NSString *t2url = model.hteam_logo;
    NSString *clogo = model.clogo;

    if (model.type.intValue == 1) {
        /// 足球，队伍反过来
        t2name = model.ateam_name;
        t1name = model.hteam_name;
        t2url = model.ateam_logo;
        t1url = model.hteam_logo;
    }
    /// 整理视频信息
    NSMutableArray *videos = [NSMutableArray new];
    if (model.live_urls.count > 0) {
        for (LiveCartoonModel *cartModel in model.live_urls) {
            if ([cartModel.name isEqualToString:@"中文高清"] || cartModel.index == 1) {
                [videos addObject:@[cartModel.name, [NSString stringWithFormat:@"%ld", cartModel.status], [NSString stringWithFormat:@"%ld", cartModel.index]]];
            }else if ([cartModel.name isEqualToString:@"高清"] || cartModel.index == 2) {
                [videos addObject:@[cartModel.name, [NSString stringWithFormat:@"%ld", cartModel.status], [NSString stringWithFormat:@"%ld", cartModel.index]]];
            }else if ([cartModel.name isEqualToString:@"标清"] || cartModel.index == 4) {
                [videos addObject:@[cartModel.name, [NSString stringWithFormat:@"%ld", cartModel.status], [NSString stringWithFormat:@"%ld", cartModel.index]]];
            }
            if (cartModel.index == 0 && cartModel.url.length > 0) {
                [videos addObject:@[cartModel.name, [NSString stringWithFormat:@"%ld", cartModel.status], [NSString stringWithFormat:@"%ld", cartModel.index]]];
            }
        }
    }
    if (model.live_cartoon_url.count > 0) {
        LiveCartoonModel *cartModel = model.live_cartoon_url.firstObject;
        NSString *status = @"0";
        if (model.status.integerValue == 0) {
            status = @"1";
        }
        [videos addObject:@[cartModel.name, status, @"10"]];
    }
    NSArray *arr = [[HomeWSManager instance] getInfo:[NSString stringWithFormat:@"%d-%d", model.type.intValue, model.ID.intValue]];
    /// 篮球：运动类型~ 比赛ID   ~比赛状态~比赛状态名称~比赛比分~当前小节剩余时间~亚指
    ///         2~     3584929~      8~          第四节~           70-84~          00:00~       no~    0~     18,20,20,26,0~   16,20,16,18,0
    /// 足球：运动类型 ~比赛ID    ~比赛状态 ~比赛状态名称 ~比赛比分 ~半场比分 ~角球  ~比赛进行时间  ~亚指          ~欧指         ~大小
    /// 后对应颜色：0黑色 1绿色 2红色
    NSArray *a1 = @[@"", @"", @"", @"0", @"0", @"0"];
    NSArray *a2 = @[@"", @"", @"", @"0", @"0", @"0"];
    NSArray *a3 = @[@"", @"", @"", @"0", @"0", @"0"];
    NSString *f1 = @"";
    NSString *f2 = @"";
    if (model.type.intValue == 1) {
        /// 足球
        if (arr.count >= 11) {
//            NSLog(@"从ws读取数据");
            NSString *s1 = arr[8];
            NSString *s2 = arr[9];
            NSString *s3 = arr[10];
            if (![s1 isEqualToString:@"no"]) {
                NSArray *temp = [s1 componentsSeparatedByString:@","];
                if (temp.count >= 3) {
                    a1 = @[temp[0], temp[1], temp[2], @"0", @"0", @"0"];
                }
            } else {
                NSArray *query1 = [model.yazhi_jishi componentsSeparatedByString:@","];
                if (query1.count >= 3) {
                    a1 = @[query1[0], query1[1], query1[2], @"0", @"0", @"0"];
                }
            }
            if (![s2 isEqualToString:@"no"]) {
                NSArray *temp = [s2 componentsSeparatedByString:@","];
                if (temp.count >= 3) {
                    a2 = @[temp[0], temp[1], temp[2], @"0", @"0", @"0"];
                }
            } else {
                NSArray *query2 = [model.ouzhi_jishi componentsSeparatedByString:@","];
                if (query2.count >= 3) {
                    a2 = @[query2[0], query2[1], query2[2], @"0", @"0", @"0"];
                }
            }
            if (![s3 isEqualToString:@"no"]) {
                NSArray *temp = [s3 componentsSeparatedByString:@","];
                if (temp.count >= 3) {
                    a3 = @[temp[0], temp[1], temp[2], @"0", @"0", @"0"];
                }
            } else {
                NSArray *query3 = [model.daxiao_jishi componentsSeparatedByString:@","];
                if (query3.count >= 3) {
                    a3 = @[query3[0], query3[1], query3[2], @"0", @"0", @"0"];
                }
            }
        } else {
//            NSLog(@"从接口读取数据");
            NSArray *query1 = [model.yazhi_jishi componentsSeparatedByString:@","];
            NSArray *query2 = [model.ouzhi_jishi componentsSeparatedByString:@","];
            NSArray *query3 = [model.daxiao_jishi componentsSeparatedByString:@","];
            if (query1.count >= 3) {
                a1 = @[query1[0], query1[1], query1[2], @"0", @"0", @"0"];
            }
            if (query2.count >= 3) {
                a2 = @[query2[0], query2[1], query2[2], @"0", @"0", @"0"];
            }
            if (query3.count >= 3) {
                a3 = @[query3[0], query3[1], query3[2], @"0", @"0", @"0"];
            }
        }
    } else {
        /// 篮球
        if (arr.count >= 7) {
            NSString *number = arr[6];
            if ([number isEqualToString:@"封"]) {
                f1 = @"封";
                f2 = @"封";
            } else {
                double value = [number doubleValue];
                if (value < 0) {
                    f2 = @"";
                    f1 = [NSString stringWithFormat:@"%0.1f", -value];
                } else {
                    f2 = [NSString stringWithFormat:@"%0.1f", value];
                    f1 = @"";
                }
            }
        }else {
            if ([CommonTools isBlankString:model.yazhi_jishi]) {
                if (model.status.intValue == 0) {
                    f1 = @"封";
                    f2 = @"封";
                }
            } else {
                double value = [model.yazhi_jishi doubleValue];
                if (value < 0) {
                    f2 = @"";
                    f1 = [NSString stringWithFormat:@"%0.1f", -value];
                } else {
                    f2 = [NSString stringWithFormat:@"%0.1f", value];
                    f1 = @"";
                }
            }
        }
    }
    if ([f1 isEqualToString:@""] && [f2 isEqualToString:@""]) {
        if (model.status.intValue == 0) {
            f1 = @"封";
            f2 = @"封";
        }
    }

    NSString *aScore1 = @"";
    NSString *aScore2 = @"";
    NSString *aScore3 = @"";
    NSString *aScore4 = @"";
    NSString *aScore5 = @"";
    if (model.away_score_xiaojie.count == 5) {
        aScore1 = [self check0:[NSString stringWithFormat:@"%ld", ((NSNumber *)model.away_score_xiaojie[0]).integerValue]];
        aScore2 = [self check0:[NSString stringWithFormat:@"%ld", ((NSNumber *)model.away_score_xiaojie[1]).integerValue]];
        aScore3 = [self check0:[NSString stringWithFormat:@"%ld", ((NSNumber *)model.away_score_xiaojie[2]).integerValue]];
        aScore4 = [self check0:[NSString stringWithFormat:@"%ld", ((NSNumber *)model.away_score_xiaojie[3]).integerValue]];
        aScore5 = [self check0:[NSString stringWithFormat:@"%ld", ((NSNumber *)model.away_score_xiaojie[4]).integerValue]];
    }
    NSString *hScore1 = @"";
    NSString *hScore2 = @"";
    NSString *hScore3 = @"";
    NSString *hScore4 = @"";
    NSString *hScore5 = @"";
    if (model.home_score_xiaojie.count == 5) {
        hScore1 = [self check0:[NSString stringWithFormat:@"%ld", ((NSNumber *)model.home_score_xiaojie[0]).integerValue]];
        hScore2 = [self check0:[NSString stringWithFormat:@"%ld", ((NSNumber *)model.home_score_xiaojie[1]).integerValue]];
        hScore3 = [self check0:[NSString stringWithFormat:@"%ld", ((NSNumber *)model.home_score_xiaojie[2]).integerValue]];
        hScore4 = [self check0:[NSString stringWithFormat:@"%ld", ((NSNumber *)model.home_score_xiaojie[3]).integerValue]];
        hScore5 = [self check0:[NSString stringWithFormat:@"%ld", ((NSNumber *)model.home_score_xiaojie[4]).integerValue]];
    }

    return [[CellModel alloc] initWithName:[NSString stringWithFormat:@"%@ %@ %@",model.time, model.name, model.status_up_name]
                                      time:time
                                    t1Name:t1name
                                t1ImageUrl:t1url
                                   t1Score:scores.firstObject
                                    t2Name:t2name
                                t2ImageUrl:t2url
                                   t2Score:scores.lastObject
                              basketballT1:@[f1, aScore1, aScore2, aScore3, aScore4, aScore5]
                              basketballT2:@[f2, hScore1, hScore2, hScore3, hScore4, hScore5]
                                footballL1:a1
                                footballL2:a2
                                footballL3:a3
                                    videos:[[videos reverseObjectEnumerator] allObjects]
                                       ban:model.banchang
                                      jiao:model.jiaoqiu
                                  listType:model.listType
                                    status:model.status.integerValue
                               changeModel:[[HomeWSManager instance] getChangeModel:[NSString stringWithFormat:@"%d-%d", model.type.intValue, model.ID.intValue]]
                                     t1New:model.isT1New
                                     t2New:model.isT2New
                                      vsID:model.ID.intValue
                                     clogo:clogo];
}

- (NSArray<NSString *> *)getColors:(NSString *)current initValue:(NSString *)initValue {
    NSArray *arr1 = [current componentsSeparatedByString:@","];
    NSArray *arr2 = [initValue componentsSeparatedByString:@","];
    double v1_0 = ((NSString *)arr1[0]).doubleValue;
    double v1_1 = ((NSString *)arr1[1]).doubleValue;
    double v1_2 = ((NSString *)arr1[2]).doubleValue;
    double v2_0 = ((NSString *)arr2[0]).doubleValue;
    double v2_1 = ((NSString *)arr2[1]).doubleValue;
    double v2_2 = ((NSString *)arr2[2]).doubleValue;
    return @[
        [self colorWithL:v1_0 r:v2_0],
        [self colorWithL:v1_1 r:v2_1],
        [self colorWithL:v1_2 r:v2_2],
    ];
}

- (NSString *)colorWithL:(double)l r:(double)r {
    if (l == r) {
        return @"0";
    } else if (l < r) {
        return @"1";
    } else {
        return @"2";
    }
}

- (NSString *)check0:(NSString *)str {
    if ([str isEqualToString:@"0"]) {
        return @"";
    } else {
        return str;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CellModel.showID = -1;
    [CellModel.moreView setHidden:YES];
    NSArray <UITableViewCell *> *cellArray = [self.tableView visibleCells];
    NSInteger nowSection = -1;
    if (cellArray) {
        UITableViewCell *cell = [cellArray firstObject];
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        nowSection = indexPath.section;
    }
    if (nowSection >= 2) {
        NSArray *dataList = self.datasArray[nowSection-2];
        LiveListModel *model = dataList.firstObject;
        if (model.matchtime.length > 10) {
            NSString *time = [model.matchtime substringToIndex:10];
            if (![self.calendarChoice isEqualToString:time]) {
                _calendarChoice = time;
                [self.topView changeChoice:_calendarChoice];
            }
        }
    }else {
        NSArray *dataList = self.datasArray.firstObject;
        LiveListModel *model = dataList.firstObject;
        if (self.topListArray.count > 0) {
            model = self.topListArray.firstObject;
        }
        if (self.noTopListArray.count > 0) {
            model = self.noTopListArray.firstObject;
        }
        if (model.matchtime.length > 10) {
            NSString *time = [model.matchtime substringToIndex:10];
            if (![self.calendarChoice isEqualToString:time]) {
                _calendarChoice = time;
                [self.topView changeChoice:_calendarChoice];
            }
        }
    }
    if (self.timeStatus == 0) {
        if (nowSection > 2) {
            self.todayBtn.selected = NO;
            self.todayBtn.hidden = NO;
            self.qiehuanBackView.hidden = YES;
        }else {
            NSArray *dataList = self.datasArray.firstObject;
            LiveListModel *model = dataList.firstObject;
            if (self.topListArray.count > 0) {
                model = self.topListArray.firstObject;
            }
            if (self.noTopListArray.count > 0) {
                model = self.noTopListArray.firstObject;
            }
            if (model.matchtime.length > 10) {
                NSInteger choice = [[[model.matchtime substringToIndex:10] stringByReplacingOccurrencesOfString:@"-" withString:@""] integerValue];
                NSInteger today = [[[LiveListCalendarVC getCurrentString] stringByReplacingOccurrencesOfString:@"-" withString:@""] integerValue];
                if (choice > today) {
                    self.todayBtn.selected = NO;
                    self.todayBtn.hidden = NO;
                    self.qiehuanBackView.hidden = YES;
                }else {
                    self.todayBtn.hidden = YES;
                    self.qiehuanBackView.hidden = NO;
                }
            }else {
                self.todayBtn.hidden = YES;
                self.qiehuanBackView.hidden = NO;
            }
        }
    }

//    CGFloat sectionHeaderHeight = 40;
//    if (scrollView.contentOffset.y <= sectionHeaderHeight && scrollView.contentOffset.y >= 0) {
//        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y,0,0,0);
//    } else if (scrollView.contentOffset.y >= sectionHeaderHeight) {
//        scrollView.contentInset=UIEdgeInsetsMake(-sectionHeaderHeight,0,0,0);
//    }

}

- (void)showCalendar {
    if (self.calendarData == nil) {
        NSString *type = [self.categoryModel isKindOfClass:[LiveListCategoryModel class]] ? [NSString stringWithFormat:@"%@",self.categoryModel.type]:[NSString stringWithFormat:@"%ld",(long)self.type];
        NSNumber *cid = [self.categoryModel isKindOfClass:[LiveListCategoryModel class]] ? self.categoryModel.ID : @(0);
        [KYApiHttpTool GET:URL_CALENDAR_DATA withParams:@{@"cid":cid, @"type":type} success:^(NSDictionary * _Nonnull response) {
            NSArray *data = response[@"data"];
            self.calendarData = [NSMutableDictionary new];
            for (NSDictionary *dic in data) {
                self.calendarData[(NSString *)dic[@"matchdate"]] = ((NSNumber *)dic[@"totalmatch"]).stringValue;
            }
            [self.topView reloadDayNuber:self.calendarData];
            [self showCalendarView];
        }failure:^(NSError * _Nullable error) {

        }];
        return;
    }
    [self showCalendarView];
}

- (void)showCalendarView {
    NSDate *date = [NSDate new];
    NSDate *choice = date;
    if (self.calendarChoice != nil && self.calendarChoice.length > 0) {
        NSDateFormatter *formatter = [NSDateFormatter new];
        formatter.dateFormat = @"yyyy-MM-dd";
        choice = [formatter dateFromString:self.calendarChoice];
    }
    WeakSelf;
    [LiveListCalendarVC showWithDate:date
                          choiceDate:choice
                       dayNumberDate:self.calendarData
                              choice:^(NSString * _Nonnull choice) {
        NSLog(@"选择了:%@", choice);
        [LiveListCalendarVC dismissVC];
        weakSelf.pn = 1;
        weakSelf.calendarChoice = choice;
        weakSelf.startTimeChoice = choice;
        [KYRemindView show];
        [weakSelf getDatas:YES];
    }];
}

- (void)setCalendarChoice:(NSString *)calendarChoice {
    _calendarChoice = calendarChoice;
    if ([CommonTools isBlankString:calendarChoice]) {
        self.timeStatus = 0;
        NSDate *date = [NSDate new];
        NSDateFormatter *formatter = [NSDateFormatter new];
        [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Taipei"]];
        formatter.dateFormat = @"yyyy-MM-dd";
        NSString *todayStr = [formatter stringFromDate:date];
        [self.topView changeChoice:todayStr];
        return;
    }
    [self.topView changeChoice:calendarChoice];
    NSDate *date = [NSDate new];
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Taipei"]];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSString *todayStr = [formatter stringFromDate:date];
    NSInteger choice = [[calendarChoice stringByReplacingOccurrencesOfString:@"-" withString:@""] integerValue];
    NSInteger today = [[todayStr stringByReplacingOccurrencesOfString:@"-" withString:@""] integerValue];
    if (choice < today) {//过去了
        self.timeStatus = 1;
    }else if (choice > today) {//未来
        self.timeStatus = 2;
    }else {//今天
        self.timeStatus = 0;
    }
}

//0今天 1过去了  2未来
- (void)setTimeStatus:(NSInteger)timeStatus {
    _timeStatus = timeStatus;
    if (timeStatus == 1) {//过去了
        self.qiehuanBackView.hidden = YES;
        self.todayBtn.hidden = NO;
        self.todayBtn.selected = YES;
    }else if (timeStatus ==2) {//未来
        self.qiehuanBackView.hidden = YES;
        self.todayBtn.hidden = NO;
        self.todayBtn.selected = NO;
    }else {//今天
        self.qiehuanBackView.hidden = NO;
        self.todayBtn.hidden = YES;
        self.todayBtn.selected = NO;
    }
}

- (UIView *)setupSectionHeaderView:(NSString *)week {
    UIView *sectionHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    sectionHeaderView.backgroundColor = SRGB(250);
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(12.5, 5, SCREEN_WIDTH-25, 30)];
    backView.backgroundColor = SRGB(244);
    backView.layer.cornerRadius = 6;
    [sectionHeaderView addSubview:backView];

    QMUILabel *dateLabel = [[QMUILabel alloc] init];
    dateLabel.font = [UIFont systemFontOfSize:13 weight:UIFontWeightSemibold];
    dateLabel.text = week;
    dateLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    [sectionHeaderView addSubview:dateLabel];
    [dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(sectionHeaderView);
    }];

//    QMUIButton *calendar = [[QMUIButton alloc] qmui_initWithImage:[UIImage imageNamed:@"日历"] title:nil];
//    [sectionHeaderView addSubview:calendar];
//    [calendar mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(sectionHeaderView);
//        make.bottom.equalTo(sectionHeaderView);
//        make.right.equalTo(sectionHeaderView).offset(-10);
//        make.width.equalTo(sectionHeaderView.mas_height);
//    }];
//    [calendar addTarget:self action:@selector(showCalendar) forControlEvents:UIControlEventTouchUpInside];

    return sectionHeaderView;
}
//获取当前时间日期星期
- (NSString *)getCurrentTimeAndWeekDay:(NSString *)time {

    NSArray * arrWeek=[NSArray arrayWithObjects:@"星期日",@"星期一",@"星期二",@"星期三",@"星期四",@"星期五",@"星期六", nil];
    NSDate *date = [NSDate date];
    if (time.length > 0) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        date = [dateFormatter dateFromString:time];
    }
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSCalendarUnitYear |NSCalendarUnitMonth | NSCalendarUnitDay |NSCalendarUnitWeekday | NSCalendarUnitHour |NSCalendarUnitMinute |NSCalendarUnitSecond;
    comps = [calendar components:unitFlags fromDate:date];
    NSInteger week = [comps weekday];
    NSInteger year=[comps year];
    NSInteger month = [comps month];
    NSInteger day = [comps day];
    NSString *monthS = [NSString stringWithFormat:@"0%ld",(long)month];
    if (month > 9) {
        monthS = [NSString stringWithFormat:@"%ld",(long)month];
    }
    NSString *dayS = [NSString stringWithFormat:@"0%ld",(long)day];
    if (day > 9) {
        dayS = [NSString stringWithFormat:@"%ld",(long)day];
    }
    return   [NSString stringWithFormat:@"%ld-%@-%@  %@",(long)year,monthS,dayS,[arrWeek objectAtIndex:week-1]];
}


@end

