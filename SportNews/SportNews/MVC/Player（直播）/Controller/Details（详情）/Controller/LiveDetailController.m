//
//  LiveDetailController.m
//  SportNews
//
//  Created by K哥 on 2020/12/29.
//

#import "LiveDetailController.h"
#import <Superplayer/SuperPlayer.h> 

#import "ZFAVPlayerManager.h"
#import "ZFPlayerControlView.h"

#import "SportNews-Swift.h"
#import <WebKit/WebKit.h>
#import <JXPagingView/JXPagerView.h>
#import "JXPagerView.h"
#import "LiveCartoonModel.h"
#import "LiveContentView.h" 
#import "LiveTextListViewController.h"
#import "LiveStatisticalViewController.h"
#import "LiveChatRoomViewController.h"
#import "LiveDatasViewController.h"
#import "SNExponentViewController.h"
#import "SNSquadViewController.h"
#import "SNExampleListViewController.h"
#import "LiveMembersViewController.h"
#import "SocketRocketUtility.h"
#import "SNFootBallResult.h"
#import "SNStatisticalModel.h"
#import "SNDatasModel.h"
#import "SNSquadModel.h"
#import "SNExponentModel.h"
#import "SNLiveDetailNaviView.h"
#import "LiveContentBottomView.h"
#import "SNQuestionFloatBall.h"
#import "CustomActivity.h"
#import <AVKit/AVKit.h>
#import "SNPictureInPictureShare.h"
#import "ZFAVPlayerManager.h"
#import "ZFPlayerControlView.h"
#import "ZFIJKPlayerManager.h"
#import "UIView+ZFFrame.h"
#import "ZFPlayerConst.h"
#import "SNShowFloatWindowView.h"
#import "SNSeasonPickerViewController.h"

#import "SNMatchSeasonButton.h"
#import "SNVSFloatView.h"
#import "JCHATChatModel.h"
#import "BarrageManager.h" 
#import "SNZFPlayerWindow.h" 
#import <CallKit/CallKit.h>


@interface LiveDetailController ()<UITableViewDelegate, UITableViewDataSource,WKNavigationDelegate,SocketRocketUtilityDelegate,JXPagerViewDelegate,JXCategoryViewDelegate,SuperPlayerDelegate,AVPictureInPictureControllerDelegate,CXCallObserverDelegate>

@property (nonatomic , strong) UIView *topHeaderView;


@property(nonatomic, strong) WKWebView *animationWebView;  //动画视频View

@property (nonatomic , copy) NSString *webUrl;

//篮球是否有统计  0 没有  1有
@property(nonatomic, assign) NSInteger hascount;
//足球是否有阵容  0 没有  1有
@property(nonatomic, assign) NSInteger hasZhenRong;

@property(nonatomic, strong) UIView *animateLoadIngView;

/** 分类View的父视图*/
@property (nonatomic) UIView *categoryFatherView;
@property (nonatomic, strong) JXCategoryTitleView *categoryView;
@property (nonatomic, strong) JXPagerView *pagingView;


//分类数据
@property(nonatomic, strong) NSMutableArray *categoryTitles;

@property(nonatomic, strong) LiveTextListViewController *listVc;
@property(nonatomic, strong) LiveStatisticalViewController *statisVc;
@property(nonatomic, strong) LiveChatRoomViewController *chatVc;
@property(nonatomic, strong) LiveDatasViewController *datasVc;
@property(nonatomic, strong) SNExponentViewController *exponentVc;
@property(nonatomic, strong) SNSquadViewController *squadVc;
@property(nonatomic, strong) SNExampleListViewController *exampleVc;
@property (nonatomic , strong) LiveMembersViewController *memberVc;


//统计模型
@property(nonatomic, strong) SNStatisticalModel *statisticalModel;
//数据模型
@property(nonatomic, strong) SNDatasModel *datasModel;
//指数模型
@property(nonatomic, strong) SNExponentModel *exponentModel;

//聊天的id
@property (nonatomic , copy) NSString *roomid;

@property (nonatomic,strong) NSTimer *timer;

//比赛是否完结
@property(nonatomic, assign) BOOL isGameOver;

//足球直播数据
@property(nonatomic, strong) SNFootBallResult *resultFootObj;

//篮球直播数据
@property(nonatomic, strong) SNBasketBallResult *resultBasketObj;


//是否正在播放动画
@property (nonatomic , assign) PlayingStatus PlayStatus;

//是否正在显示的是聊天页面
@property (nonatomic , assign) BOOL isSelectChatVc;

@property(nonatomic, strong) LiveContentView *contentView;

/** 播放器View的父视图*/
@property (nonatomic) UIView *playerFatherView;

//播放视频的时候下面的
@property (nonatomic, strong) UIImageView                   *videoLogo;

@property(nonatomic, copy) NSString *currentTitle;

@property (nonatomic, strong) UIButton              *questionFloatBtn; //问题浮球按钮
@property (nonatomic, strong) SNQuestionFloatBall   *questionFloatView; //问题浮球按钮
@property (nonatomic, strong) UIButton              *vsBtn; //vs浮球按钮
@property (nonatomic, strong) SNVSFloatView         *vsfloatView; //vs浮球按钮
@property (nonatomic, strong) NSArray               *likeMathArray;  //推荐相似的比赛


@property (strong , nonatomic) SNMatchSeasonButton *seasonButton;
@property (strong , nonatomic) UIView *seasonView;

@property(nonatomic, copy) NSString *token;
@property(nonatomic, strong) NSArray *matchArray;

@property (nonatomic , assign) NSInteger time;

//视频播放失败 就自动播放下一个
@property (nonatomic , assign) NSInteger xunHuanCount;

//全屏状态进去了后台
@property(nonatomic, assign) BOOL isFullEnterBackground;

@property(nonatomic, strong) CXCallObserver *callCenter;

@property(nonatomic, strong) LiveCartoonModel *cartoonModel;

@property(nonatomic, strong) NSString  *liveUserName;
@property(nonatomic, strong) NSString  *matchType;      // type: 1 足球  2 篮球
@property(nonatomic, strong) NSString  *matchID;

@end

@implementation LiveDetailController

- (void)dealloc{
    [SocketRocketUtility instance].delegate = nil;
    [self.systemPlayerView stop];
    [self.chatVc deallocChatVc];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    if (![self.navigationController.viewControllers containsObject:self]) {
        [[SocketRocketUtility instance] qiangzhiSRWebSocketClose];
        [KYRemindView dismiss];
        if (self.timer) {
            [self.timer invalidate];
            self.timer = nil;
        }
        [self.contentView dellocTime];
    }
    [[BarrageManager shareManager] removeBarrage];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    //滑动消失 的时候触发 打开小视频
    NSInteger selectIndex = [[NSUserDefaults standardUserDefaults] integerForKey:CloseSmallWindow];
    if (selectIndex == 0) {
        // 變成小窗
        if (!self.isClickPop) {
            if (pictureSupport) {
                if (!SNPictureInPictureShared.picController.isPictureInPictureActive && self.PlayStatus == PlayingStatusLive && SNPictureInPictureShared.picController.isPictureInPicturePossible) {
                    SNPictureInPictureShared.systemPlayerView = self.systemPlayerView;
                    SNPictureInPictureShared.playerVc = self;
                    [SNPictureInPictureShared.picController startPictureInPicture];
                }
            }else {
                UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
                // 是竖屏时候响应关
                if (orientation == UIInterfaceOrientationPortrait && (self.PlayStatus == PlayingStatusLive)) {
                    [ZFPlayerWindowShared setZfPlayer:self.systemPlayerView];
                    [ZFPlayerWindowShared show];
                    ZFPlayerWindowShared.backController = self;
                }
            }
        }
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.systemPlayerView.manager.view layoutSubviews];
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    //有小视频的时候点击列表相同的比赛触发
    NSInteger selectIndex = [[NSUserDefaults standardUserDefaults] integerForKey:CloseSmallWindow];
    if (selectIndex == 0) {
        if (pictureSupport) {
            //点击小窗口进来，需要创建定时器
            if (SNPictureInPictureShared.playerVc == self) {
                [self.systemPlayerView play];
                SNPictureInPictureShared.playerVc = nil;
                [SNPictureInPictureShared.picController stopPictureInPicture];
                [self setupSocket];
            }else {
                if (self.systemPlayerView.manager.player.status == AVPlayerStatusReadyToPlay && self.PlayStatus == PlayingStatusLive) {
                    [self playerVideo:self.playModel];
                }
            }
        }else {
            if (ZFPlayerWindowShared.backController && ZFPlayerWindowShared.zfPlayer.model.ID.intValue == self.model.ID.intValue) {
                [ZFPlayerWindowShared hide];
                ZFPlayerWindowShared.backController = nil;
                [self setupSocket];
                self.systemPlayerView.x = 0;
                self.systemPlayerView.y = 0;
            }else {
                if (self.PlayStatus == PlayingStatusLive) {
                    [self playerVideo:self.playModel];
                }
            }
        }
    }
    
    if (self.chatVc) {
        [self.chatVc isLoginOut];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.token) {
        [self setupSocket];
    }
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self setupParams];
    
    [self calculateBottomHeight];
    
    [self configureLiveData];
    
    [self setupTopHeaderView];
    
    //头部视频播放view
    [self setupLiveHeaderView];
    
    [self getDatas];
    
    [self notificationAndBlock];
    
    //添加来电监测
    [self setupCallObserver];

}

- (void)setupParams {
    //点击vs进来的
    if (self.isPushByVs) {
        NSMutableArray *viewControllers = [self.navigationController.viewControllers mutableCopy];
        if (viewControllers.count > 2) {
            UIViewController *vc = [viewControllers objectAtIndex:viewControllers.count-2];
            if ([vc isKindOfClass:[LiveDetailController class]]) {
                [viewControllers removeObject:vc];
                [self.navigationController setViewControllers:viewControllers];
            }
        }
    }
    
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
}
- (void)calculateBottomHeight {
    NSMutableArray *cartoonArray = [NSMutableArray array];
    [cartoonArray addObjectsFromArray:self.model.live_urls];
    [cartoonArray addObjectsFromArray:self.model.live_cartoon_url];
    NSInteger currentRight = 0; // 记录当前Btn的right（右边）
    NSInteger currentBottom = 0; // 记录当前btn的bottom（底部）
    CGFloat originX = 20; //初始X
    CGFloat totalWidth = ScreenWidth; //总宽
    CGFloat magin = 10; //按钮之间的间距
    CGFloat imageWidth = 10; //图片宽度
    UIFont *font = [UIFont systemFontOfSize:12 weight:UIFontWeightSemibold];
    for (int i = 0; i < cartoonArray.count; i++) {
        LiveCartoonModel *cartoonModel = cartoonArray[i];
        // 计算字体长度
        CGSize size = [cartoonModel.name boundingRectWithSize:CGSizeMake(totalWidth, 30000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
        // 更新btn的右边
        currentRight = currentRight + size.width + imageWidth + magin;
        // 判断是否换行
        if (i < cartoonArray.count - 1) {
            LiveCartoonModel *cartoonModel1 = cartoonArray[i + 1];
            // 计算字体长度
            CGSize size = [cartoonModel1.name boundingRectWithSize:CGSizeMake(totalWidth, 30000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
            if (currentRight + size.width > totalWidth - originX*2 - magin) {
                currentRight = 0;
                currentBottom = currentBottom + 30;
            }
        }
        //最后一个
        if (i == cartoonArray.count - 1) {
            currentBottom = currentBottom + 30;
        }
  
     }
    SNGlobalShared.contentBottomHeight = currentBottom + 35;
}

- (void)notificationAndBlock {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pagingViewSetOffset) name:@"datasSectionBtnSelected" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(AppWillEnterForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setupTouPing) name:@"toupingNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setupXiaoPing) name:@"xiaochuangkouNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerViewPlayFailed) name:@"ZFPlayerPlayStatePlayFailed" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerViewPlayAutoPause) name:@"ZFPlayerPlayStatePlayAutoPause" object:nil];
    
    WeakSelf
    ZFPlayerWindowShared.backHandler = ^{
        //点击小视频 跳转到相应的详情页
        [ZFPlayerWindowShared hide];
        if (![[CommonTools currentViewController].navigationController.viewControllers containsObject:ZFPlayerWindowShared.backController]) {
            [[CommonTools currentViewController].navigationController pushViewController:ZFPlayerWindowShared.backController animated:YES];
            [(LiveDetailController *)ZFPlayerWindowShared.backController setupTimer];
            ZFPlayerWindowShared.backController = nil;
            return;
        }else {
            NSMutableArray *viewControllers = [weakSelf.navigationController.viewControllers mutableCopy];
            if (viewControllers.count > 2) {
                NSArray *vcArray = @[viewControllers.firstObject,weakSelf];
                [weakSelf.navigationController setViewControllers:vcArray];
            }
        }
    };
    
    if (self.model.type.intValue == 1) {
        [self.view addSubview:self.questionFloatBtn];
        [self.view addSubview:self.questionFloatView];
    }
    [self.view addSubview:self.vsBtn];
    [self.view addSubview:self.vsfloatView];
    [self.view addSubview:self.seasonView];
    
    
    self.vsfloatView.closeBlock = ^{
        [weakSelf closeVsFloatView];
    };
    
    self.vsfloatView.clickedItemBlock = ^(LiveListModel * _Nonnull model) {
        weakSelf.isClickPop = YES;
        if (weakSelf.PlayStatus == PlayingStatusLive) {
            [weakSelf.systemPlayerView stop];
        }
        [[SocketRocketUtility instance] qiangzhiSRWebSocketClose];
        [weakSelf.timer invalidate];
        weakSelf.timer = nil;
        
        LiveDetailController *liveDetailVc = [[LiveDetailController alloc]init];
        liveDetailVc.isPushByVs = YES;
        liveDetailVc.model = model;
        [weakSelf.navigationController pushViewController:liveDetailVc animated:YES];
    };
    
    
}

- (void)setupTopHeaderView {
    
    self.categoryFatherView = [[UIView alloc] init];
    self.categoryFatherView.backgroundColor = [UIColor whiteColor];
    self.categoryFatherView.frame = CGRectMake(0, 0, kScreenWidth, 41);
    
    self.topHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kContentHeight)];
    self.pagingView = [[JXPagerView alloc] initWithDelegate:self];
    if (self.PlayStatus == PlayingStatusLive) {
        self.pagingView.pinSectionHeaderVerticalOffset = kContentHeight+kBottomHeight;
    }else {
        self.pagingView.pinSectionHeaderVerticalOffset = kContentHeight;
    }
    self.pagingView.mainTableView.bounces = NO;
    self.pagingView.isListHorizontalScrollEnabled = NO;
    [self.view addSubview:self.pagingView];
    
    self.naviView = [[SNLiveDetailNaviView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, NavHeight)];
    self.naviView.autoresizingMask = UIViewAutoresizingNone;
    if (!self.model.comeFromNotice) {
        [self.naviView setModel:self.model];
    }else {
        self.naviView.centerLabel.textColor = UIColor.clearColor;
    }
    [self.view addSubview:self.naviView];
    WeakSelf
    self.naviView.navBackBlock = ^(NSInteger tag) {
        if (tag == 1) {
            // 进来直接是直播中，点击返回直接返回，无需点击2次
//            if (weakSelf.PlayStatus != PlayingStatusNone) {
//                if (!weakSelf.animationWebView.hidden) {
//                    [weakSelf cancelAnimated];
//                }else{
//                    [weakSelf cancelPlay];
//                }
//            }else {
            // 設為NO支持小窗
            weakSelf.isClickPop = YES;
            [weakSelf.navigationController popViewControllerAnimated:YES];
//            }
            [[BarrageManager shareManager] removeBarrage];
        }else {
            //分享
            [weakSelf shareMethod];
        }
    };
    
}

- (void)setupLiveHeaderView{
    
    [self.topHeaderView addSubview:self.bottomView];
    [self.topHeaderView addSubview:self.contentView];
    [self.topHeaderView addSubview:self.playerFatherView];
    [self.topHeaderView addSubview:self.animationWebView];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.topHeaderView);
        make.bottom.equalTo(self.topHeaderView);
        make.height.mas_equalTo(kBottomHeight);     // kBottomHeight = 65
    }];

    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.topHeaderView);
        make.height.mas_equalTo(kContentHeight-kBottomHeight);    // kContentHeight = 295
    }];

    [self.playerFatherView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.top.equalTo(@(StatusBarHeight));       // StatusBarHeight = 54
        make.height.mas_equalTo(kContentHeight-StatusBarHeight);
    }];

    [self.animationWebView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(StatusBarHeight));
        make.left.right.equalTo(self.topHeaderView);
        make.height.mas_equalTo(kContentHeight-StatusBarHeight);
    }];
    
    [self.playerFatherView addSubview:self.systemPlayerView];
    self.systemPlayerView.fatherView = self.playerFatherView;
    
    self.tBackgroundView = [self setupEmptyViewWithFrame:CGRectMake(0, kContentHeight + 110 +(self.PlayStatus == PlayingStatusLive ? kBottomHeight:0), kScreenWidth, 180) title:@"数据加载中..."];
    [self.view addSubview:self.tBackgroundView];

    WeakSelf
    self.contentView.selectBlock = ^(NSInteger tag) {
        if (tag == 1) {
            [weakSelf playerVideo:weakSelf.playModel];
        }else {
            [weakSelf animatedWay];
        }
    };
    self.contentView.countDownTime = ^(NSInteger time) {
        [weakSelf.chatVc isGameStart:time>1200?NO:YES gameStatus:[weakSelf.model.status integerValue]];
    };
}

- (void)setupCategoryView {
    if (self.model.type.intValue == 1) {
        //足球
        if (self.hasZhenRong) {
            self.categoryTitles = @[@"聊天",@"数据",@"直播",@"阵容",@"指数"].mutableCopy;
        }else {
            self.categoryTitles = @[@"聊天",@"数据",@"直播",@"指数"].mutableCopy;
        }
    }else if (self.model.type.intValue == 2) {
        //篮球
        if (self.hascount) {
            self.categoryTitles = @[@"聊天",@"统计",@"数据",@"直播",@"指数"].mutableCopy;
        }else {
            self.categoryTitles = @[@"聊天",@"数据",@"直播",@"指数"].mutableCopy;
        }
        if ([self.model.name containsString:@"NBA"]) {
            [self.categoryTitles addObject:@"榜单"];
        }
    }else {
        self.categoryTitles = @[@"聊天"].mutableCopy;
    }
    self.currentTitle = @"聊天";
    self.isSelectChatVc = YES;
    self.categoryView.titles = self.categoryTitles;
    self.categoryView.titleFont = UIFontMake(14);
    self.categoryView.titleSelectedFont = [UIFont systemFontOfSize:14 weight:UIFontWeightSemibold];
    self.categoryView.delegate = self;
    self.categoryView.titleColor = [UIColor colorWithHexString:@"#666666"];
    self.categoryView.titleSelectedColor = [UIColor colorWithHexString:@"#27C5C3"];
    //下划线
    JXCategoryIndicatorLineView *lineView = [[JXCategoryIndicatorLineView alloc] init];
    lineView.indicatorColor = [UIColor colorWithHexString:@"#27C5C3"];
    lineView.verticalMargin = 3;
    lineView.indicatorHeight = 3;
    self.categoryView.indicators = @[lineView];

    CGFloat x = (kScreenWidth - self.categoryTitles.count*30)/(self.categoryTitles.count+1)/2;
    self.categoryView.frame = CGRectMake(-x, -10, kScreenWidth+x*2, 41); // title上移
    [self.categoryFatherView addSubview:self.categoryView];
    // [self setupDownloadView];       // 下載元友

    self.categoryView.listContainer = (id<JXCategoryViewListContainer>)self.pagingView.listContainerView;
    self.navigationController.interactivePopGestureRecognizer.enabled = (self.categoryView.selectedIndex == 0);
    [self.categoryView reloadData];
    [self.pagingView reloadData];

    //当前比赛不是在比赛中的时候需要跳转到数据
    if (self.model.type.intValue == 1) {
        if (self.model.status.integerValue != 0) {
            [self.categoryView selectCellAtIndex:1 selectedType:JXCategoryCellSelectedTypeCode];
        }
    }else {
        if (self.model.status.integerValue == 2) {
            if (self.hascount) {
                [self.categoryView selectCellAtIndex:1 selectedType:JXCategoryCellSelectedTypeCode];
            }else {
                [self.categoryView selectCellAtIndex:1 selectedType:JXCategoryCellSelectedTypeCode];
            }
        }else if (self.model.status.integerValue != 0) {
            if (self.hascount) {
                [self.categoryView selectCellAtIndex:2 selectedType:JXCategoryCellSelectedTypeCode];
            }else {
                [self.categoryView selectCellAtIndex:1 selectedType:JXCategoryCellSelectedTypeCode];
            }
        }
    }

}

- (void)setupAnimateLoadingView {
    self.animateLoadIngView = [[UIView alloc] init];
    [self.animationWebView addSubview:self.animateLoadIngView];
    self.animateLoadIngView.backgroundColor = UIColor.blackColor;
    [self.animateLoadIngView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];

    UIImageView *imageView = [[UIImageView alloc] initWithImage:UIImageMake(@"足球loading")];
    [imageView.layer addAnimation:[CommonTools rotationAnimation_Animation] forKey:@"rotationAnimation"];
    [self.animateLoadIngView addSubview:imageView];

    QMUIButton *loadingBtn = [[QMUIButton alloc] init];
    [loadingBtn setTitle:@"动画加载中..." forState:UIControlStateNormal];
    [loadingBtn setTitleColor:RGB(153, 153, 153) forState:UIControlStateNormal];
    loadingBtn.titleLabel.font = UIFontMake(12);
    loadingBtn.imagePosition = QMUIButtonImagePositionLeft;
    loadingBtn.spacingBetweenImageAndTitle = 5;
    [self.animateLoadIngView addSubview:loadingBtn];
    [loadingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.animateLoadIngView.mas_centerY);
        make.centerX.equalTo(self.animateLoadIngView.mas_centerX).offset(15);
    }];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(loadingBtn.mas_centerY);
        make.right.equalTo(loadingBtn.mas_left).offset(-8);
        make.width.height.equalTo(@22);
    }];
    
}

- (void)configureLiveData {
    [self.contentView setModel:self.model];
    [self.bottomView setModel:self.model];
    [self setupPlayModel];
}

- (void)setupPlayModel {
    if (self.model.video_url.length > 0 && self.model.status.intValue != 0) {
        SuperPlayerModel *model = [[SuperPlayerModel alloc] init];
        model.videoURL = self.model.video_url;
        self.playModel = model;
        if (self.model.status.intValue > 1) {
            [self playerVideo:self.playModel];
        }
        return;
    }
    //创建当前播放模型
    SuperPlayerModel *playModel = [[SuperPlayerModel alloc] init];
    //从列表点击 视频按钮
    NSString *videoURL = nil;
    if (self.model.selectCartoonModel) {
        videoURL = self.model.selectCartoonModel.url;
    }
    //从所有播放源中获取到一个 能播放的地址
    LiveCartoonModel *firstModel = self.model.live_urls.firstObject;
    if (firstModel.status != 1) {
        //不能播放再去找
        for (int i = 0; i < self.model.live_urls.count; i++) {
            LiveCartoonModel *model = self.model.live_urls[i];
            if (model.status == 1) {
                firstModel = model;
                break;
            }
        }
    }
    
    playModel.videoURL = videoURL? videoURL:firstModel.url;
    self.playModel = playModel;
    [self refreshFBL];
    
    if ([self.model.selectCartoonModel.name containsString:@"动画"] && ![self.model.selectCartoonModel.url containsString:@".m3u8"]) {
        [self animatedWay];
        return;
    }
    
    if (videoURL) {
        [self playerVideo:self.playModel];
        self.cartoonModel = self.model.selectCartoonModel;
    }else {
        if (firstModel.status == 1 && self.model.status.intValue == 0) {
            [self playerVideo:self.playModel];
            self.cartoonModel = firstModel;
        }
    }
}


//点击分享
- (void)shareMethod {
    
    NSDictionary *param = @{
        @"pid" : @"4"
    };
    [KYRemindView show];
    [KYApiHttpTool GET:URL_ShareText withParams:param success:^(NSDictionary * _Nonnull response) {
        // 1、设置分享的内容，并将内容添加到数组中
        NSString *shareText = response[@"share_txt"];
        UIImage *shareImage = [UIImage imageNamed:@"1024Logo.png"];
        NSString *shareUrlStr = response[@"share_url"];
        NSURL *shareUrl = [NSURL URLWithString:shareUrlStr];
        NSArray *activityItemsArray = @[shareText,shareImage,shareUrl];
        CustomActivity *customActivity = [[CustomActivity alloc]initWithTitle:shareText ActivityImage:[UIImage imageNamed:@"1024Logo.png"] URL:shareUrl ActivityType:@"Custom"];
        NSArray *activityArray = @[customActivity];
        // 2、初始化控制器，添加分享内容至控制器
        UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:activityItemsArray applicationActivities:activityArray];
        // 3、设置回调
        // ios8.0 之后用此方法回调
        UIActivityViewControllerCompletionWithItemsHandler itemsBlock = ^(UIActivityType __nullable activityType, BOOL completed, NSArray * __nullable returnedItems, NSError * __nullable activityError){
            NSLog(@"activityType == %@",activityType);
            if (completed == YES) {
                NSLog(@"completed");
            }else{
                NSLog(@"cancel");
            }
        };
        activityVC.completionWithItemsHandler = itemsBlock;
        // 4、调用控制器
        [self presentViewController:activityVC animated:YES completion:nil];
        
    } failure:^(NSError * _Nonnull error) {
    }];
}

- (void)setCartoonModel:(LiveCartoonModel *)cartoonModel {
    _cartoonModel = cartoonModel;
    if (cartoonModel.room_num >= 0) {
        [self setupSocket];
    }
    self.bottomView.cartoonModel = cartoonModel;
}

//视频播放
- (void)playerVideo:(SuperPlayerModel *)model {
    if ([CommonTools isBlankString:model.videoURL]) {
        return;
    }
    self.contentView.hidden = self.animationWebView.hidden = YES;
    self.playerFatherView.hidden = NO;
    self.PlayStatus = PlayingStatusLive;
    
    self.topHeaderView.height = kContentHeight+kBottomHeight;
    self.bottomView.hidden = NO;
    if (self.model.status.intValue == 0) {
        [self.bottomView loadAnimate];
    }
    self.pagingView.mainTableView.contentOffset = CGPointMake(0, 0);
    self.pagingView.pinSectionHeaderVerticalOffset = kContentHeight+kBottomHeight;
    if (!self.systemPlayerView.isFull) {
        [self.pagingView reloadData];
    }
    if (self.chatVc) {
        [self.chatVc scrollToBottom:NO];
    }
    self.systemPlayerView.x = 0;
    self.systemPlayerView.y = 0;
    if (pictureSupport) {
        [self.systemPlayerView setup:model.videoURL];
        NSInteger selectIndex = [[NSUserDefaults standardUserDefaults] integerForKey:CloseSmallWindow];
        if (selectIndex == 0) {
            SNPictureInPictureShared.picController = [[AVPictureInPictureController alloc] initWithPlayerLayer:self.systemPlayerView.manager.avPlayerLayer];
            SNPictureInPictureShared.picController.delegate = self;
        }
    }else {
        if (ZFPlayerWindowShared.isShowing) {
            [ZFPlayerWindowShared hide];
            [ZFPlayerWindowShared.zfPlayer stop];
            ZFPlayerWindowShared.backController = nil;
        }
        ZFPlayerWindowShared.videoURL = model.videoURL;
        [self.systemPlayerView setup:model.videoURL];
    }
    [SNGlobalShared initVideoTimer];
    SNGlobalShared.zfPlayer = self.systemPlayerView;
}

//点击取消视频播放
- (void)cancelPlay {
    ZFPlayerWindowShared.backController = nil;
    self.playerFatherView.hidden = self.animationWebView.hidden = YES;
    self.contentView.hidden = NO;
    self.bottomView.hidden = YES;
    self.topHeaderView.height = kContentHeight;
    
    self.PlayStatus = PlayingStatusNone;
    if (!self.isSelectChatVc) {
        self.pagingView.pinSectionHeaderVerticalOffset = NavHeight;
    }else {
        self.pagingView.pinSectionHeaderVerticalOffset = kContentHeight;
    }
    [self.pagingView reloadData];
    [self.topHeaderView bringSubviewToFront:self.contentView];
    [self.systemPlayerView stop];
    if (self.chatVc) {
        [self.chatVc scrollToBottom:NO];
    }
    [SNGlobalShared invalideVideoTimer];
    
}

//动画播放
- (void)animatedWay {
    self.PlayStatus = PlayingStatusAnimate;
    self.animationWebView.hidden = NO;
    self.contentView.hidden = self.playerFatherView.hidden = YES;
    self.pagingView.mainTableView.contentOffset = CGPointMake(0, 0);
    self.pagingView.pinSectionHeaderVerticalOffset = kContentHeight;
    [self.pagingView.mainTableView reloadData];
    self.webUrl = self.model.live_cartoon_url.firstObject.url;
    [self.animationWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.webUrl]]];
    [self setupAnimateLoadingView];
    if (self.chatVc) {
        [self.chatVc scrollToBottom:NO];
    }
}

//点击取消动画
- (void)cancelAnimated {
    
    self.webUrl = @"";
    self.contentView.hidden = NO;
    self.animationWebView.hidden = self.playerFatherView.hidden = YES;
    
    self.PlayStatus = PlayingStatusNone;
    if (!self.isSelectChatVc) {
        self.pagingView.pinSectionHeaderVerticalOffset = NavHeight;
    }else {
        self.pagingView.pinSectionHeaderVerticalOffset = kContentHeight;
    }
    
    [self.pagingView.mainTableView reloadData];
    [self.topHeaderView bringSubviewToFront:self.contentView];
    if (self.animateLoadIngView.superview) {
        [self.animateLoadIngView removeFromSuperview];
    }
    [self.animationWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@""]]];
}

- (void)setPlayStatus:(PlayingStatus)PlayStatus {
    _PlayStatus = PlayStatus;
    if (self.listVc) {
        [self.listVc updateScrollViewHeight:PlayStatus];
    }
    if (self.statisVc) {
        [self.statisVc updateScrollViewHeight:PlayStatus];
    }
    if (self.chatVc) {
        [self.chatVc updateScrollViewHeight:PlayStatus];
    }
    if (self.datasVc) {
        [self.datasVc updateScrollViewHeight:PlayStatus];
    }
    if (self.squadVc) {
        [self.squadVc updateScrollViewHeight:PlayStatus];
    }
}

- (void)getDatas {
    
    NSMutableDictionary *param = @{
        @"isnew": @"1",
        @"mid"  : self.model.ID,
        @"type" : self.model.type,
        @"pid"  : @"4",
        @"langtype" : @"zh",
        @"zoneId" : @"Asia/Taipei"
    }.mutableCopy;
    LoginUserModel *loginModel = [UserModelTool loginModel];
    if (loginModel) {
        [param setValue:loginModel.uid forKey:@"uid"];
        [param setValue:loginModel.token forKey:@"token"];
    }
    [KYRemindView show];
    self.systemPlayerView.controlView.portraitControlView.fullScreenBtn.enabled = false;
    self.remindLabel.text = @"数据加载中...";
    WeakSelf
    [KYApiHttpTool GET:URL_MATCH_DETAIL withParams:param success:^(NSDictionary * _Nonnull response) {
        
        LiveListModel *model = [LiveListModel mj_objectWithKeyValues:response[@"data"][@"matchinfo"]];
        model.online_num = [response[@"data"][@"online_num"] intValue];
        model.live_type = weakSelf.model.live_type;
        model.selectCartoonModel = weakSelf.model.selectCartoonModel;
        weakSelf.model = model;
        weakSelf.systemPlayerView.isLoaded = YES;
        weakSelf.hascount = [response[@"data"][@"hascount"] intValue];
        weakSelf.hasZhenRong = [response[@"data"][@"haslineup"] intValue];
        weakSelf.contentView.model = weakSelf.model;
        weakSelf.bottomView.model = weakSelf.model;
        weakSelf.naviView.centerLabel.textColor = UIColor.whiteColor;
        weakSelf.naviView.model = weakSelf.model;
        weakSelf.tBackgroundView.hidden = YES;
        weakSelf.liveUserName = response[@"data"][@"matchinfo"][@"mirror_live_urls"][0][@"live_user_name"];
        weakSelf.matchType = response[@"data"][@"matchinfo"][@"type"];
        [weakSelf setupCategoryView];
        
        if ([CommonTools isBlankString:weakSelf.playModel.videoURL]) {
            [weakSelf setupPlayModel];
        }
        NSArray *matchArray = [LiveListModel mj_objectArrayWithKeyValuesArray:response[@"data"][@"likeMatchList"]];
        //matchArray = @[model,model,model,model,model,model];
        weakSelf.matchArray = matchArray;
        if (matchArray.count > 0) {
            CGFloat height = matchArray.count > 3? 120:60;
            weakSelf.vsfloatView.height = height;
            weakSelf.vsfloatView.y = kScreenHeight - height -xBottomHeight;
            weakSelf.vsfloatView.dataSource = matchArray;
            if ([weakSelf.currentTitle isEqualToString:@"直播"]) {
                weakSelf.vsBtn.hidden = NO;
            }
        }else{
            weakSelf.vsBtn.hidden = YES;
        }
        //加载文字直播数据
        [weakSelf getLiveDatas];
        //加载数据的数据
        [weakSelf getDatasData];
        if (weakSelf.model.type.intValue == 2 && weakSelf.hascount) {
            //加载篮球统计数据
            [weakSelf getStatisticalDatas];
        }
        // 加载指数
        [weakSelf getExponentData];
        
        NSString *token = response[@"data"][@"token"];
        weakSelf.token = token;
        //正在比赛才有长链接
        if (weakSelf.model.status.integerValue != 0) {
            weakSelf.isGameOver = YES;
        }
        [weakSelf setupSocket];
        weakSelf.systemPlayerView.controlView.portraitControlView.fullScreenBtn.enabled = true;
        
    } failure:^(NSError * _Nonnull error) {
        [MBProgressHUD hideHUDForView:weakSelf.view];
        weakSelf.remindLabel.text = @"加载失败，点击重新加载";
        [weakSelf.view addSubview:weakSelf.tBackgroundView];
        weakSelf.systemPlayerView.controlView.portraitControlView.fullScreenBtn.enabled = true;
    }];
    
}

- (void)reloadGetData {
    if (![self.remindLabel.text containsString:@"加载失败"]) {
        return;
    }
    self.remindLabel.text = @"数据加载中...";
    [self.view addSubview:self.tBackgroundView];
    [self getDatas];
}

//加载文字直播数据
- (void)getLiveDatas {
    NSDictionary *param1 = @{
        @"mid" : self.model.ID,
        @"type" : self.model.type,
        @"tabtype" : @1
    };
    [KYApiHttpTool GET:URL_Detail_Tabs withParams:param1 success:^(NSDictionary * _Nonnull response) {
        if (self.model.type.integerValue == 1) {
            SNFootBallResult *resultFootObj = [SNFootBallResult mj_objectWithKeyValues:response[@"data"]];
            self.resultFootObj = resultFootObj;
            self.contentView.resultFootObj = resultFootObj;
            self.bottomView.resultFootObj = resultFootObj;
            self.naviView.resultFootObj = resultFootObj;
        }else {
            SNBasketBallResult *resultBasketObj = [SNBasketBallResult mj_objectWithKeyValues:response[@"data"]];
            self.resultBasketObj = resultBasketObj;
            self.contentView.resultBasketObj = resultBasketObj;
            self.bottomView.resultBasketObj = resultBasketObj;
            self.naviView.resultBasketObj = resultBasketObj;
        }
        if (self.listVc) {
            if (self.model.type.integerValue == 1) {
                self.listVc.resultFootObj = self.resultFootObj;
            }else {
                self.listVc.resultBasketObj = self.resultBasketObj;
            }
        }
        
    } failure:^(NSError * _Nonnull error) {
        [self.listVc loadDataFailure];
    }];
}
 

//加载篮球统计数据--新接口
- (void)getNewStatisticalDatas {
    
    NSDictionary *param1 = @{
        @"mid" : self.model.ID,
        @"type" : self.model.type
    };
    [KYApiHttpTool GET:URL_Detail_Count withParams:param1 success:^(NSDictionary * _Nonnull response) {
        
        SNStatisticalModel *statisticalModel = [SNStatisticalModel mj_objectWithKeyValues:response[@"data"]];
        self.statisticalModel = statisticalModel;
        if (self.statisVc) {
            [self.statisVc setupStatisticalModel:statisticalModel];
        }
    } failure:^(NSError * _Nonnull error) {
        if (self.statisVc) {
            [self.statisVc loadDataFailure];
        }
    }];
}

//加载篮球统计数据--老接口
- (void)getOldStatisticalDatas {
    
    NSDictionary *param1 = @{
        @"mid" : self.model.ID,
        @"type" : self.model.type,
        @"tabtype" : @2
    };
    [KYApiHttpTool GET:URL_Detail_Tabs withParams:param1 success:^(NSDictionary * _Nonnull response) {
        
        SNStatisticalModel *statisticalModel = [SNStatisticalModel mj_objectWithKeyValues:response[@"data"]];
        self.statisticalModel = statisticalModel;
        if (self.statisVc) {
            [self.statisVc setupStatisticalModel:statisticalModel];
        }
    } failure:^(NSError * _Nonnull error) {
        if (self.statisVc) {
            [self.statisVc loadDataFailure];
        }
    }];
}

//加载篮球统计数据
- (void)getStatisticalDatas {
    [self getNewStatisticalDatas];
}

//加载数据的数据
- (void)getDatasData {
    
    NSDictionary *param1 = @{
        @"mid" : self.model.ID,
        @"type" : self.model.type,
        @"tabtype" : @3
    };
    [KYApiHttpTool GET:URL_Detail_Tabs withParams:param1 success:^(NSDictionary * _Nonnull response) {
        
        SNDatasModel *datasModel = [SNDatasModel mj_objectWithKeyValues:response[@"data"]];
        self.datasModel = datasModel;
        if (self.datasVc) {
            [self.datasVc setupDatasModel:datasModel];
        }
    } failure:^(NSError * _Nonnull error) {
        if (self.datasVc) {
            [self.datasVc loadDataFailure];
        }
    }];
}

//加载指数的数据
- (void)getExponentData {
    NSDictionary *param1 = @{
        @"mid" : self.model.ID,
        @"type" : self.model.type,
        @"tabtype" : @6
    };
    [KYApiHttpTool GET:URL_Detail_Tabs withParams:param1 success:^(NSDictionary * _Nonnull response) {
        
        SNExponentModel *exponentModel = [SNExponentModel mj_objectWithKeyValues:response[@"data"]];
        self.exponentModel = exponentModel;
        if (self.exponentVc) {
            [self.exponentVc setupExponentModel:exponentModel];
        }
    } failure:^(NSError * _Nonnull error) {
        if (self.exponentVc) {
            [self.exponentVc loadDataFailure];
        }
    }];
}

- (void)pagingViewSetOffset {
    [self.pagingView.mainTableView setContentOffset:CGPointMake(0, kContentHeight)];
    if (self.chatVc) {
        [self.chatVc scrollToBottom:NO];
    }
}

- (void)AppWillEnterForeground {
    if (self.systemPlayerView.isFull) {
        self.isFullEnterBackground = YES;
        [self.systemPlayerView.controlView.landScapeControlView.backBtn sendActionsForControlEvents:UIControlEventTouchUpInside];
    }
    NSInteger selectIndex = [[NSUserDefaults standardUserDefaults] integerForKey:CloseSmallWindow];
    if (selectIndex == 0) {
        if (pictureSupport) {
            //在详情页 退出App 开启了画中画 然后点击了关闭了画中画进入详情 需要重新加载
            if (self.PlayStatus == PlayingStatusLive && !SNPictureInPictureShared.playerVc) {
                [self playerVideo:self.playModel];
            }
            //进入前提 并且当前页面是详情 关闭画中画
            if (SNPictureInPictureShared.playerVc && [self.navigationController.viewControllers containsObject:SNPictureInPictureShared.playerVc]) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [SNPictureInPictureShared.picController stopPictureInPicture];
                });
            }
        }else {
            if (self.PlayStatus == PlayingStatusLive) {
                [self playerVideo:self.playModel];
            }
        }
    }else {
        //支持画中画用的是ZFPlayer 进去前台 可能会暂停 重新加载会快很多
        if (self.PlayStatus == PlayingStatusLive) {
            [self playerVideo:self.playModel];
        }
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (!self.systemPlayerView.isFull && self.isFullEnterBackground) {
            self.isFullEnterBackground = NO;
            [self.systemPlayerView.controlView.portraitControlView.fullScreenBtn sendActionsForControlEvents:UIControlEventTouchUpInside];
        }
    });
}

- (void)setupTimer {
    self.isGameOver = NO;
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    [SocketRocketUtility instance].delegate = self;
    self.timer = [NSTimer timerWithTimeInterval:10 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop]addTimer:self.timer forMode:NSDefaultRunLoopMode];
}

- (void)timerAction {
    NSLog(@"------------------timerAction----:%@",self.model.hteam_name);
    //比赛完结了 就不需要获取直播信息了
    if ([self.currentTitle isEqualToString:@"直播"]) {
        if (self.isGameOver) {
            return;
        }
        if (self.model.type.intValue == 1) {
            NSString *data =[NSString stringWithFormat:@"2-%@-%ld-%ld",self.model.ID,self.resultFootObj.tlive.count,self.resultFootObj.incidents.count];
            [[SocketRocketUtility instance] sendData:data];
            //结束了 就不要 发送数据了
            if (self.resultFootObj.score.count >= 1) {
                NSNumber *status = self.resultFootObj.score[1];
                if (status.intValue == 8) {
                    self.isGameOver = YES;
                }
            }
        }else {
            NSArray *tliveSubArray = self.resultBasketObj.tlive.lastObject;
            NSString *data =[NSString stringWithFormat:@"2-%@-%ld-%ld",self.model.ID,tliveSubArray.count,self.resultBasketObj.tlive.count] ;
            [[SocketRocketUtility instance] sendData:data];
            //结束了 就不要 发送数据了
            if (self.resultBasketObj.score.count >= 1) {
                NSNumber *status = self.resultBasketObj.score[1];
                if (status.intValue == 10) {
                    self.isGameOver = YES;
                }
            }
        }
    }else {
        NSString *data =[NSString stringWithFormat:@"1-%@",self.model.ID] ;
        [[SocketRocketUtility instance] sendData:data];
        
    }
    //在统计的时候 需要自动刷新
    if (self.hascount && [self.currentTitle isEqualToString:@"统计"]) {
        [self getStatisticalDatas];
    }
}

- (void)setupSocket {
    if ([CommonTools isBlankString:self.token]) {
        return;
    }
    NSString *socketUrl;
    NSInteger num = 0;
    if (self.cartoonModel && self.cartoonModel.room_num >= 0) {
        num = self.cartoonModel.room_num;
    }
    if (self.model.type.integerValue == 1) {
        socketUrl = [NSString stringWithFormat:@"%@zuqiu?token=%@&mid=%@&apptype=2&num=%ld",SocketUrl,self.token,self.model.ID,num];
    }else {
        socketUrl = [NSString stringWithFormat:@"%@lanqiu?token=%@&mid=%@&apptype=2&num=%ld",SocketUrl,self.token,self.model.ID,num];
    }
    [[SocketRocketUtility instance] SRWebSocketOpenWithURLString:socketUrl];
    [self setupTimer];
}


- (void)setupCallObserver {
    self.callCenter = [[CXCallObserver alloc] init];
    [self.callCenter setDelegate:self queue:dispatch_get_main_queue()];
}

- (void)callObserver:(CXCallObserver *)callObserver callChanged:(CXCall *)call {
    if (!call.hasConnected && !call.hasEnded) {
        if (self.systemPlayerView.isFull) {
            [self.systemPlayerView.controlView.landScapeControlView.backBtn sendActionsForControlEvents:UIControlEventTouchUpInside];
        }
    }
}

#pragma mark -- SocketRocketUtilityDelegate
- (void)webSocketDidOpen:(SRWebSocket *)webSocket {
    NSLog(@"webSocketDidOpen");
}

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message {
    NSDictionary *dic = [CommonTools dictionaryWithJsonString:message];
    if ([dic[@"msgtype"] integerValue] == 1) {
        //比赛id 不一样
        if ([dic[@"mid"] integerValue] != self.model.ID.integerValue) {
            return;
        }
        //是否有统计
        NSInteger hascount = [dic[@"hascount"] integerValue];
        if (hascount == 1 && ![self.categoryTitles containsObject:@"统计"]) {
            [self.categoryTitles insertObject:@"统计" atIndex:1];
            [self.categoryView reloadData];
            if (!self.systemPlayerView.isFull) {
                [self.pagingView reloadData];
                if (self.chatVc) {
                    [self.chatVc scrollToBottom:NO];
                }
            }
            [self getStatisticalDatas];
        }
        
        NSString *score = dic[@"score"];
        NSString *score2 = @"";
        if ([score isKindOfClass:[NSDictionary class]]) {
            NSError * err;
            NSData * jsonData = [NSJSONSerialization  dataWithJSONObject:score options:0 error:&err];
            score2 = [[NSString alloc] initWithData:jsonData   encoding:NSUTF8StringEncoding];
            NSLog(@"%@", score2);
            self.contentView.scoreStr = score2;
            self.bottomView.scoreStr = score2;
            self.naviView.scoreStr = score2;
        }
        else {
            self.contentView.scoreStr = score;
            self.bottomView.scoreStr = score;
            self.naviView.scoreStr = score;
        }
        self.bottomView.timeStr = dic[@"time"];
        if (self.model.type.intValue == 1) {
            self.contentView.footStatus = [dic[@"status"] integerValue];
            self.bottomView.footStatus = [dic[@"status"] integerValue];
            self.naviView.footStatus = [dic[@"status"] integerValue];
        }else {
            self.contentView.basketStatus = [dic[@"status"] integerValue];
            self.bottomView.basketStatus = [dic[@"status"] integerValue];
            self.naviView.basketStatus = [dic[@"status"] integerValue];
        }
        //聊天人数
        if (self.chatVc) {
            [self.chatVc updateOnlineCount:dic[@"online"]];
        }
    }else if ([dic[@"msgtype"] integerValue] == 2) {
        //直播
        NSDictionary *dict = dic[@"data"];
        if (dict.allKeys.count == 0) {
            return;
        }
        //比赛id 不一样
        if ([dict[@"id"] integerValue] != self.model.ID.integerValue) {
            return;
        }
        if (self.model.type.integerValue == 1) {
            SNFootBallResult *result = [SNFootBallResult mj_objectWithKeyValues:dic[@"data"]];
            for (SNFootBallTextLiveModel *model in self.resultFootObj.tlive) {
                model.isNew = NO;
            }
            for (SNFootBallTextLiveModel *model in result.tlive) {
                model.isNew = YES;
            }
            NSMutableArray *tliveArray = [NSMutableArray array];
            [tliveArray addObjectsFromArray:self.resultFootObj.tlive];
            [tliveArray addObjectsFromArray:result.tlive];
            NSMutableArray *incidentsArray = [NSMutableArray array];
            [incidentsArray addObjectsFromArray:self.resultFootObj.incidents];
            [incidentsArray addObjectsFromArray:result.incidents];
            self.resultFootObj.score = result.score;
            self.resultFootObj.stats = result.stats;
            self.resultFootObj.tlive = tliveArray;
            self.resultFootObj.incidents = incidentsArray;
            self.contentView.resultFootObj = self.resultFootObj;
            self.bottomView.resultFootObj = self.resultFootObj;
            self.naviView.resultFootObj = self.resultFootObj;
            if (self.listVc) {
                self.listVc.resultFootObj = self.resultFootObj;
            }
        }else {
            SNBasketBallResult *result = [SNBasketBallResult mj_objectWithKeyValues:dic[@"data"]];
            NSMutableArray *tliveArray = [self filterMessage:[self.resultBasketObj.tlive mutableCopy] newArrray:result.tlive];
            self.resultBasketObj.players = result.players;
            self.resultBasketObj.score = result.score;
            self.resultBasketObj.stats = result.stats;
            self.resultBasketObj.tlive = tliveArray;
            self.contentView.resultBasketObj = self.resultBasketObj;
            self.bottomView.resultBasketObj = self.resultBasketObj;
            self.naviView.resultBasketObj = self.resultBasketObj;
            if (self.listVc) {
                self.listVc.resultBasketObj = self.resultBasketObj;
            }
        }
    }
}

- (NSMutableArray *)filterMessage:(NSMutableArray *)tliveArray newArrray:(NSArray *)newArray {
    for (NSArray *modelArray in tliveArray) {
        for (SNBasketBallTliveModel *model in modelArray) {
            model.isNew = NO;
        }
    }
    for (NSArray *modelArray in newArray) {
        for (SNBasketBallTliveModel *model in modelArray) {
            model.isNew = YES;
        }
    }
    NSMutableArray *resultArray = [NSMutableArray arrayWithArray:tliveArray];
    if (tliveArray.count == newArray.count) {
        NSMutableArray *lastArray = [NSMutableArray arrayWithArray:resultArray.lastObject];
        NSArray *newLast = newArray.lastObject;
        [lastArray insertObjects:newLast atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, newLast.count)]];
        [resultArray removeLastObject];
        [resultArray addObject:lastArray];
        return resultArray;
    }else {
        for (int i = 0; i < newArray.count; i++) {
            if (i == tliveArray.count - 1) {
                NSMutableArray *lastArray = [NSMutableArray arrayWithArray:resultArray.lastObject];
                NSArray *currArray = newArray[i];
                [lastArray insertObjects:currArray atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, currArray.count)]];
                [resultArray removeLastObject];
                [resultArray addObject:lastArray];
            }else if (i > tliveArray.count - 1) {
                [resultArray addObject:newArray[i]];
            }
        }
        return resultArray;
    }
}

- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean {
    NSLog(@"didCloseWithCode");
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.pagingView.frame = self.view.bounds;
}

- (void)categoryView:(JXCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index {
    NSString *categoryStr = self.categoryTitles[index];
    if ([self.currentTitle isEqualToString:categoryStr]) {
        return;
    }
    self.currentTitle = categoryStr;
    self.isSelectChatVc = NO;
    if ([categoryStr isEqualToString:@"聊天"]) {
        self.isSelectChatVc = YES;
        self.pagingView.mainTableView.contentOffset = CGPointMake(0, 0);
        if (self.PlayStatus == PlayingStatusLive) {
            self.pagingView.pinSectionHeaderVerticalOffset = kContentHeight+kBottomHeight;
        }else {
            self.pagingView.pinSectionHeaderVerticalOffset = kContentHeight;
        }
        [self.pagingView.mainTableView reloadData];
        if (self.chatVc) {
            [self.chatVc scrollToBottom:NO];
        }
    }else {
        if (self.PlayStatus == PlayingStatusNone) {
            // Adam 調整整個view上滑高度
            // self.pagingView.pinSectionHeaderVerticalOffset = NavHeight;
            // headerView整個上滑
            // self.pagingView.pinSectionHeaderVerticalOffset = 0;
            self.pagingView.pinSectionHeaderVerticalOffset = kContentHeight;
            [self.pagingView.mainTableView reloadData];
        }
    }
    if (self.datasVc) {
        [self.datasVc hideScreenView:![categoryStr isEqualToString:@"数据"]];
    }
    
    if ([categoryStr isEqualToString:@"直播"]) {
        self.vsfloatView.hidden = NO;
        if (self.vsfloatView.dataSource.count) {
            if (self.questionFloatView.x == kScreenWidth) {
                self.vsBtn.hidden = NO;
            }else {
                self.vsBtn.hidden = YES;
            }
        }else {
            self.vsBtn.hidden = YES;
        }
    }else {
        self.vsBtn.hidden = self.vsfloatView.hidden = YES;
    }
    
    if ([categoryStr isEqualToString:@"直播"] || [categoryStr isEqualToString:@"阵容"]) {
        self.questionFloatView.hidden = self.questionFloatBtn.hidden = NO;
        if ([categoryStr isEqualToString:@"直播"]) {
            [self.questionFloatView setupIsLive:YES];
        }else {
            [self.questionFloatView setupIsLive:NO];
        }
    }else {
        self.questionFloatView.hidden = self.questionFloatBtn.hidden = YES;
    }
    
    //    if ([categoryStr isEqualToString:@"榜单"]) {
    //        self.seasonView.hidden = NO;
    //    }else {
    //        self.seasonView.hidden = YES;
    //    }
    
    if ([categoryStr isEqualToString:@"数据"]) {
        [self getDatasData];
    }else if ([categoryStr isEqualToString:@"统计"]) {
        [self getStatisticalDatas];
    }else if ([categoryStr isEqualToString:@"指数"]) {
        [self getExponentData];
    }
}

- (void)controlFBL:(LiveCartoonModel *)cartoonModel {
    self.playModel.videoURL = cartoonModel.url;
    self.cartoonModel = cartoonModel;
    [self.chatVc selectCartoonModel:cartoonModel];
    [self refreshFBL];
    if (pictureSupport) {
        [self.systemPlayerView setup:self.playModel.videoURL];
        NSInteger selectIndex = [[NSUserDefaults standardUserDefaults] integerForKey:CloseSmallWindow];
        if (selectIndex == 0) {
            SNPictureInPictureShared.picController = [[AVPictureInPictureController alloc] initWithPlayerLayer:self.systemPlayerView.manager.avPlayerLayer];
            SNPictureInPictureShared.picController.delegate = self;
        }
    }else {
        if (ZFPlayerWindowShared.isShowing) {
            [ZFPlayerWindowShared hide];
            [ZFPlayerWindowShared.zfPlayer stop];
            ZFPlayerWindowShared.backController = nil;
        }
        [self.systemPlayerView setup:self.playModel.videoURL];
    }
}

- (void)setupTouPing {
    LivePlayerPingVC *ping = [LivePlayerPingVC new];
    NSString *url = self.playModel.videoURL;
    if (self.model.video_url.length > 0 && self.model.status.intValue != 0) {
        url = self.model.video_url;
    }
    if ([CommonTools isBlankString:url]) {
        [KYRemindView showWithStatus:@"暂无投屏地址"];
        return;
    }
    ping.url = url;
    [self.navigationController pushViewController:ping animated:true];
}

//是否允许画中画 或者小视频
- (void)setupXiaoPing {
//    NSInteger selectIndex = [[NSUserDefaults standardUserDefaults] integerForKey:CloseSmallWindow];
//    SNShowFloatWindowView *floatView = [[SNShowFloatWindowView alloc] initWithFrame:UIScreen.mainScreen.bounds];
//    WeakSelf
//    floatView.clickWithSelect = ^(NSInteger selectIndex) {
//        [weakSelf reloadPicture:selectIndex];
//    };
//    floatView.selectIndex = selectIndex;
//    [[UIApplication sharedApplication].delegate.window addSubview:floatView];
    self.isClickPop = NO;
    [self.navigationController popViewControllerAnimated:NO];
}

//播放失败自动播放
- (void)playerViewPlayFailed {
    //只有直播的才需要
    if (self.model.live_urls.count == 0 && self.model.status.integerValue != 0) {
        return;
    }
    self.xunHuanCount += 1;
    //循环播放 一轮 就停止
    if (self.xunHuanCount == self.model.live_urls.count) {
        // 新的SDK不支援
        //self.systemPlayerView.controlView.stopXunHuan = YES;
    }
    NSString *url = self.playModel.videoURL;
    NSInteger originIndex = -1;
    for (int i = 0; i < self.model.live_urls.count; i++) {
        LiveCartoonModel *model = self.model.live_urls[i];
        if ([url isEqualToString:model.url]) {
            originIndex = i;
        }
    }
    //证明此链接没有在数组里面 不是直播
    if (originIndex < 0) {
        return;
    }
    originIndex += 1;
    if (originIndex >= self.model.live_urls.count) {
        originIndex = 0;
    }
    LiveCartoonModel *model = self.model.live_urls[originIndex];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self controlFBL:model];
    });
}

- (void)playerViewPlayAutoPause {
    //播放录播的时候 不需要
    if (self.model.status.intValue != 0 && self.model.video_url.length > 0) {
        return;
    }
    [self playerVideo:self.playModel];
}

- (void)reloadPicture:(NSInteger)selectIndex {
    if (selectIndex == 0) {
        SNPictureInPictureShared.picController = [[AVPictureInPictureController alloc] initWithPlayerLayer:self.systemPlayerView.manager.avPlayerLayer];
        SNPictureInPictureShared.picController.delegate = self;
    }else {
        SNPictureInPictureShared.picController = [[AVPictureInPictureController alloc] initWithPlayerLayer:[AVPlayerLayer new]];
        SNPictureInPictureShared.picController.delegate = nil;
    }
}

#pragma mark - delegate
//即将开启画中画功能
- (void)pictureInPictureControllerWillStartPictureInPicture:(AVPictureInPictureController *)pictureInPictureController {
    if (self.systemPlayerView.isFull) {
        self.isFullEnterBackground = YES;
        [self.systemPlayerView.controlView.landScapeControlView.backBtn sendActionsForControlEvents:UIControlEventTouchUpInside];
    }
}

//已经开启画中画功能
- (void)pictureInPictureControllerDidStartPictureInPicture:(AVPictureInPictureController *)pictureInPictureController {
    SNPictureInPictureShared.playerVc = self;
}

//失败
- (void)pictureInPictureController:(AVPictureInPictureController *)pictureInPictureController failedToStartPictureInPictureWithError:(NSError *)error {
    SNPictureInPictureShared.playerVc = nil;
    NSLog(@"%@",error);
}

//即将停止画中画功能
- (void)pictureInPictureControllerWillStopPictureInPicture:(AVPictureInPictureController *)pictureInPictureController {
    if (![[CommonTools currentViewController].navigationController.viewControllers containsObject:self]) {
        [SNPictureInPictureShared.systemPlayerView stop];
    }
    SNPictureInPictureShared.playerVc = nil;
    [SNGlobalShared invalideVideoTimer];
}

//已经停止画中画功能
- (void)pictureInPictureControllerDidStopPictureInPicture:(AVPictureInPictureController *)pictureInPictureController {
    if (![[CommonTools currentViewController].navigationController.viewControllers containsObject:self]) {
        [SNPictureInPictureShared.systemPlayerView stop];
    }
    SNPictureInPictureShared.playerVc = nil;
}

- (void)pictureInPictureController:(AVPictureInPictureController *)pictureInPictureController restoreUserInterfaceForPictureInPictureStopWithCompletionHandler:(void (^)(BOOL restored))completionHandler {
    if (![[CommonTools currentViewController].navigationController.viewControllers containsObject:self]) {
        SNPictureInPictureShared.playerVc = nil;
        [self setupSocket];
        [[CommonTools currentViewController].navigationController pushViewController:self animated:YES];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            completionHandler(true);
        });
        return;
    }else {
        NSMutableArray *viewControllers = [self.navigationController.viewControllers mutableCopy];
        if (viewControllers.count > 2) {
            NSArray *vcArray = @[viewControllers.firstObject,self];
            [self.navigationController setViewControllers:vcArray];
        }
    }
    completionHandler(true);
}

#pragma mark - JXPagingViewDelegate
- (void)pagerView:(JXPagerView *)pagerView mainTableViewDidScroll:(UIScrollView *)scrollView {
    if ([CommonTools isBlankString:self.model.hteam_name] && [CommonTools isBlankString:self.model.ateam_name]) {
        return;
    }
    CGFloat y = scrollView.contentOffset.y;
    CGFloat alphas = y/(kContentHeight-NavHeight);
    self.naviView.backView.alpha = alphas;
    self.naviView.centerLabel.alpha = 1-alphas;
    self.contentView.stackView.alpha = 1-alphas;
    self.contentView.hTeamImageView.alpha = 1-alphas;
    self.contentView.hTeamNameLabel.alpha = 1-alphas;
    self.contentView.hScoreLabel.alpha = 1-alphas;
    self.contentView.aTeamImageView.alpha = 1-alphas;
    self.contentView.aTeamNameLabel.alpha = 1-alphas;
    self.contentView.aScoreLabel.alpha = 1-alphas;
    self.contentView.scoreLabel.alpha = 1-alphas;
    self.contentView.statusLabel.alpha = 1-alphas;
}

- (UIView *)tableHeaderViewInPagerView:(JXPagerView *)pagerView {
    return self.topHeaderView;
}

- (NSUInteger)tableHeaderViewHeightInPagerView:(JXPagerView *)pagerView {
    if (self.PlayStatus == PlayingStatusLive) {
        return kContentHeight+kBottomHeight;
    }
    return kContentHeight;
}

- (NSUInteger)heightForPinSectionHeaderInPagerView:(JXPagerView *)pagerView {
    return 41;
}

- (UIView *)viewForPinSectionHeaderInPagerView:(JXPagerView *)pagerView {
    return self.categoryFatherView;
}

- (NSInteger)numberOfListsInPagerView:(JXPagerView *)pagerView {
    return self.categoryTitles.count;
}

#pragma mark - 容器代理
- (id<JXPagerViewListViewDelegate>)pagerView:(JXPagerView *)pagerView initListAtIndex:(NSInteger)index {
    NSString *categoryStr = self.categoryTitles[index];
    if ([categoryStr isEqualToString:@"直播"]) {
        if (self.listVc) {
            [self.listVc updateScrollViewHeight:self.PlayStatus];
            return self.listVc;
        }
        LiveTextListViewController *listVc = [[LiveTextListViewController alloc] init];
        listVc.playStatus = self.PlayStatus;
        listVc.model = self.model;
        if (self.model.type.integerValue == 1) {
            listVc.resultFootObj = self.resultFootObj;
        }else {
            listVc.resultBasketObj = self.resultBasketObj;
        }
        WeakSelf
        listVc.reloadDataBlock = ^{
            [weakSelf getLiveDatas];
        };
        self.listVc = listVc;
        return listVc;
    }else if ([categoryStr isEqualToString:@"统计"]) {
        if (self.statisVc) {
            [self.statisVc updateScrollViewHeight:self.PlayStatus];
            return self.statisVc;
        }
        LiveStatisticalViewController *statisVc = [[LiveStatisticalViewController alloc] init];
        statisVc.playStatus = self.PlayStatus;
        self.statisVc = statisVc;
        WeakSelf
        statisVc.reloadDataBlock = ^{
            [weakSelf getStatisticalDatas];
        };
        statisVc.model = self.model;
        if (self.statisticalModel) {
            [statisVc setupStatisticalModel:self.statisticalModel];
        }else {
            [statisVc loadDataFailure];
        }
        return statisVc;
    }else if ([categoryStr isEqualToString:@"聊天"]) {
        if (self.chatVc) {
            return self.chatVc;
        }
        LiveChatRoomViewController *chatVc = [[LiveChatRoomViewController alloc] init];
        chatVc.playStatus = self.PlayStatus;
        chatVc.cartoonModel = self.cartoonModel;
        chatVc.liveUserName = self.liveUserName;
        chatVc.matchType = self.matchType;
        WeakSelf
        chatVc.canShowDanMu = ^BOOL{
            if (weakSelf.systemPlayerView.isFull) {
                return YES;
            }
            // 新的SDK不支援
             else if (!weakSelf.systemPlayerView.controlView.portraitControlView.danmuBtn.isSelected) {
                return YES;
            }
            return NO;
        };
        chatVc.checkDanMu = ^{
            if ([[BarrageManager shareManager] getBarrageView].superview == nil) {
                [[BarrageManager shareManager] removeBarrage];
                [weakSelf.systemPlayerView.manager.view layoutSubviews];
            }
        };
        self.chatVc = chatVc;
        chatVc.model = self.model;
        return chatVc;
    }else if ([categoryStr isEqualToString:@"数据"]) {
        if (self.datasVc) {
            [self.datasVc updateScrollViewHeight:self.PlayStatus];
            return self.datasVc;
        }
        LiveDatasViewController *datasVc = [[LiveDatasViewController alloc] init];
        datasVc.playStatus = self.PlayStatus;
        datasVc.detailView = self.view;
        self.datasVc = datasVc;
        WeakSelf
        datasVc.reloadDataBlock = ^{
            [weakSelf getDatasData];
        };
        datasVc.model = self.model;
        if (self.datasModel) {
            [datasVc setupDatasModel:self.datasModel];
        }else {
            [datasVc loadDataFailure];
        }
        return datasVc;
    }else if ([categoryStr isEqualToString:@"阵容"]) {
        if (self.squadVc) {
            [self.squadVc updateScrollViewHeight:self.PlayStatus];
            return self.squadVc;
        }
        SNSquadViewController *squadVc = [[SNSquadViewController alloc] init];
        squadVc.playStatus = self.PlayStatus;
        self.squadVc = squadVc;
        squadVc.model = self.model;
        return squadVc;
    }else if ([categoryStr isEqualToString:@"指数"]) {
        if (self.exponentVc) {
            [self.exponentVc setupExponentModel:self.exponentModel];
            return self.exponentVc;
        }
        SNExponentViewController *exponentVc = [[SNExponentViewController alloc] init];
        self.exponentVc = exponentVc;
        WeakSelf
        exponentVc.jumpDetail = ^(NSInteger num, NSInteger ID){
            SNExponentDetailVC *vc = [SNExponentDetailVC new];
            vc.type = weakSelf.model.type.intValue;
            vc.detailType = num + 1;
            vc.comID = ID;
            vc.vsID = weakSelf.model.ID.intValue;
            if (num == 0) {
                vc.companyList = weakSelf.exponentModel.yazhi;
            } else if (num == 1) {
                vc.companyList = weakSelf.exponentModel.ouzhi;
            } else if (num == 2) {
                vc.companyList = weakSelf.exponentModel.daxiao;
            } else if (num == 3) {
                vc.companyList = weakSelf.exponentModel.jiaoqiu;
            }
            [weakSelf.navigationController pushViewController:vc animated:true];
        };
        exponentVc.reloadDataBlock = ^{
            [weakSelf getExponentData];
        };
        exponentVc.model = self.model;
        if (self.exponentModel) {
            [exponentVc setupExponentModel:self.exponentModel];
        }
        return exponentVc;
    }else if ([categoryStr isEqualToString:@"榜单"]) {
        if (self.exampleVc) {
            [self.exampleVc updateScrollViewHeight:self.PlayStatus];
            return self.exampleVc;
        }
        SNExampleListViewController *exampleVc = [[SNExampleListViewController alloc] init];
        self.exampleVc = exampleVc;
        exampleVc.playStatus = self.PlayStatus;
        exampleVc.model = self.model;
        return exampleVc;
    }else {
        if (self.memberVc) {
            return self.memberVc;
        }
        //会员
        LiveMembersViewController *memberVc = [[LiveMembersViewController alloc] init];
        memberVc.model = self.model;
        return memberVc;
    }
}

- (NSInteger)numberOfListsInlistContainerView:(JXCategoryListContainerView *)listContainerView {
    return self.categoryTitles.count;
}

// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    if (![CommonTools isBlankString:self.webUrl]) {
        [self.animateLoadIngView removeFromSuperview];
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return UIStatusBarAnimationNone;
}

/// 这两句千万记得一定要写，否则，会导致全屏无法点击的问题。
- (BOOL)shouldAutorotate {
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (void)questionFloatBtnAction{
    self.vsBtn.hidden = self.questionFloatBtn.hidden = YES;
    if ([self.currentTitle isEqualToString:@"阵容"]) {
        CGRect frame = self.vsfloatView.frame;
        frame.origin.x = kScreenWidth;
        self.vsfloatView.frame = frame;
    }
    [UIView animateWithDuration:0.5 animations:^{
        CGRect frame = self.questionFloatView.frame;
        frame.origin.x = 0;
        self.questionFloatView.frame = frame;
    }];
}

- (void)vsBtnAction{
    self.vsBtn.hidden = self.questionFloatBtn.hidden = YES;
    
    [UIView animateWithDuration:0.5 animations:^{
        CGRect frame = self.vsfloatView.frame;
        frame.origin.x = 0;
        self.vsfloatView.frame = frame;
    }];
}


- (void)closeFloatBall{
    
    [UIView animateWithDuration:0.5 animations:^{
        CGRect frame = self.questionFloatView.frame;
        frame.origin.x = kScreenWidth;
        self.questionFloatView.frame = frame;
        self.questionFloatBtn.hidden = NO;
        self.vsBtn.hidden = self.vsfloatView.dataSource.count>0?NO:YES;
        if ([self.currentTitle isEqualToString:@"阵容"]) {
            self.vsBtn.hidden = YES;
        }
    }];
}

- (void)closeVsFloatView{
    
    [UIView animateWithDuration:0.5 animations:^{
        CGRect frame = self.vsfloatView.frame;
        frame.origin.x = kScreenWidth;
        self.vsfloatView.frame = frame;
        self.questionFloatBtn.hidden = NO;
        self.vsBtn.hidden = self.vsfloatView.dataSource.count>0?NO:YES;
    }];
}

- (void)clickedSeasonButton {
    SNSeasonPickerViewController *pickerVc = [[SNSeasonPickerViewController alloc]init];
    pickerVc.providesPresentationContextTransitionStyle = YES;
    pickerVc.definesPresentationContext = YES;
    [pickerVc setModalPresentationStyle:UIModalPresentationOverCurrentContext];
    pickerVc.selectStr = self.seasonButton.titleLabel.text;
    WeakSelf;
    pickerVc.selectSeasonBlock = ^(NSString * _Nonnull string) {
        [weakSelf.seasonButton setTitle:[NSString stringWithFormat:@" %@",string] forState:UIControlStateNormal];
    };
    [self presentViewController:pickerVc animated:NO completion:nil];
}

- (void)didMoveToParentViewController:(nullable UIViewController *)parent {
    if (parent == nil) {
        if (!pictureSupport) {
            if (!ZFPlayerWindowShared.isShowing) {
                [self.systemPlayerView setup:self.playModel.videoURL];
            }
        }
    }
}

- (JXCategoryTitleView *)categoryView {
    if (_categoryView == nil) {
        _categoryView = [[JXCategoryTitleView alloc] init];
    }
    return _categoryView;
}

- (NewPlayerView *)systemPlayerView {
    if (!_systemPlayerView) {
        _systemPlayerView = [[NewPlayerView alloc] initWithFrame:CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, UIScreen.mainScreen.bounds.size.width*9/16) withModel:self.model];
        // 新的SDK不支援
        _systemPlayerView.controlView.portraitControlView.fblModels = self.model.live_urls;
        // _systemPlayerView.controlView.landScapeControlView.fblModels = self.model.live_urls;
        [self refreshFBL];
        WeakSelf
        _systemPlayerView.controlView.backBtnClickCallback = ^{
            [weakSelf.chatVc scrollToBottom:NO];
        };
        // 新的SDK不支援
        _systemPlayerView.controlView.portraitControlView.btnTapBlock = ^(NSInteger type) {
            [weakSelf shareMethod];
        };
        _systemPlayerView.controlView.portraitControlView.fblTap = ^(LiveCartoonModel *model) {
            [weakSelf controlFBL:model];
        };
//        _systemPlayerView.controlView.landScapeControlView.fblTap = ^(LiveCartoonModel *model) {
//            [weakSelf controlFBL:model];
//        };
    }
    return _systemPlayerView;
}

- (void)refreshFBL {
    NSString *title;
    for (int i = 0; i < self.model.live_urls.count; i++) {
        LiveCartoonModel *cartoonModel = self.model.live_urls[i];
        if ([self.playModel.videoURL isEqualToString:cartoonModel.url]) {
            title = cartoonModel.name;
        }
    }
    // 新的SDK不支援
//    [_systemPlayerView.controlView.landScapeControlView.fbl setTitle:title forState:UIControlStateNormal];
    [_systemPlayerView.controlView.portraitControlView.fbl setTitle:title forState:UIControlStateNormal];
}


- (UIView *)playerFatherView {
    if (!_playerFatherView) {
        _playerFatherView = [[UIView alloc] init];
        _playerFatherView.backgroundColor = SRGB(26);
        _playerFatherView.hidden = YES;
        
    }
    return _playerFatherView;
}

- (WKWebView *)animationWebView {
    if (!_animationWebView) {
        _animationWebView  = [[WKWebView alloc] init];
        _animationWebView.navigationDelegate = self;
        _animationWebView.backgroundColor = UIColor.greenColor;
        _animationWebView.scrollView.contentInsetAdjustmentBehavior= UIScrollViewContentInsetAdjustmentNever;
        _animationWebView.hidden = YES;
    }
    return _animationWebView;
}

- (LiveContentView *)contentView {
    if (!_contentView) {
        _contentView  = [[LiveContentView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kContentHeight)];
        _contentView.autoresizingMask = UIViewAutoresizingNone;
    }
    return _contentView;
}

- (LiveContentBottomView *)bottomView {
    if (!_bottomView) {
        _bottomView  = [[LiveContentBottomView alloc] initWithFrame:CGRectMake(0, kContentHeight, kScreenWidth, kBottomHeight)];
        _bottomView.autoresizingMask = UIViewAutoresizingNone;
        _bottomView.hidden = NO;
        WeakSelf
        _bottomView.fblTap = ^(LiveCartoonModel *model) {
            [weakSelf controlFBL:model];
        };
    }
    return _bottomView;
}

- (UIImageView *)videoLogo{
    if (!_videoLogo) {
        _videoLogo = [[UIImageView alloc]initWithFrame:CGRectMake(15, 15, 54.5, 18)];
        _videoLogo.image = [UIImage imageNamed:@"说球帝logo白"];

    }
    return _videoLogo;
}

- (UIButton *)questionFloatBtn{
    if (!_questionFloatBtn) {
        _questionFloatBtn = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth - 60, kScreenHeight - 60-xBottomHeight, 50, 50)];
        [_questionFloatBtn setImage:[UIImage imageNamed:@"问题"] forState:UIControlStateNormal];
        [_questionFloatBtn addTarget:self action:@selector(questionFloatBtnAction) forControlEvents:UIControlEventTouchUpInside];
        _questionFloatBtn.hidden = YES;
    }
    return _questionFloatBtn;
}

- (SNQuestionFloatBall *)questionFloatView{
    if (!_questionFloatView) {
        _questionFloatView = [[SNQuestionFloatBall alloc]initWithFrame:CGRectMake(kScreenWidth, kScreenHeight - 60-xBottomHeight, kScreenWidth, 58)];
        _questionFloatView.backgroundColor = UIColor.whiteColor;
        [_questionFloatView.closeBtn addTarget:self action:@selector(closeFloatBall) forControlEvents:UIControlEventTouchUpInside];
    }
    return _questionFloatView;
}


- (UIButton *)vsBtn{
    if (!_vsBtn) {
        CGFloat x = kScreenWidth - 60;
        if (self.model.type.intValue == 1) {
            x = kScreenWidth - 120;
        }
        _vsBtn = [[UIButton alloc]initWithFrame:CGRectMake(x, kScreenHeight - 60-xBottomHeight, 50, 50)];
        [_vsBtn setImage:[UIImage imageNamed:@"热门"] forState:UIControlStateNormal];
        [_vsBtn addTarget:self action:@selector(vsBtnAction) forControlEvents:UIControlEventTouchUpInside];
        _vsBtn.hidden = YES;
    }
    return _vsBtn;
}

- (SNVSFloatView *)vsfloatView {
    if (!_vsfloatView) {
        _vsfloatView = [[SNVSFloatView alloc]initWithFrame:CGRectMake(kScreenWidth, kScreenHeight - 60 -xBottomHeight, kScreenWidth, 60)];
    }
    return _vsfloatView;
}

- (UIView *)seasonView {
    if (!_seasonView) {
        _seasonView = [[UIView alloc]initWithFrame:CGRectMake(kScreenWidth- 150 +17.5, self.view.bounds.size.height - 60 - xBottomHeight, 150, 35)];
        _seasonView.layer.shadowColor = [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:0.39].CGColor;
        _seasonView.layer.cornerRadius = 17.5;
        _seasonView.layer.shadowOffset = CGSizeMake(0, 1.5);
        _seasonView.layer.shadowOpacity = 1;
        _seasonView.layer.shadowRadius = 7;
        _seasonView.backgroundColor = UIColor.whiteColor;
        _seasonView.hidden = YES;
        [_seasonView addSubview:self.seasonButton];
    }
    return _seasonView;
}
- (SNMatchSeasonButton *)seasonButton {
    if (!_seasonButton) {
        _seasonButton = [[SNMatchSeasonButton alloc]initWithFrame:CGRectMake(5, 0, self.seasonView.width-30, 35)];
        [_seasonButton setTitle:@" 20-21常规赛" forState:UIControlStateNormal];
        _seasonButton.titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightSemibold];
        [_seasonButton setTitleColor:Blue_Color forState:UIControlStateNormal];
        [_seasonButton setImage:[UIImage imageNamed:@"箭头下"] forState:UIControlStateNormal];
        [_seasonButton setImage:[UIImage imageNamed:@"箭头下"] forState:UIControlStateHighlighted];
        [_seasonButton addTarget:self action:@selector(clickedSeasonButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _seasonButton;
}


@end
