//
//  LiveDetailViewController.m
//  SportNews
//
//  Created by K哥 on 2020/12/29.
//

#import "LiveDetailViewController.h"
#import <Superplayer/SuperPlayer.h>
#import "TextLiveDetailVC.h"
#import "VideoDLNAView.h"
#import "LiveHeaderView.h"

// 小窗单例
#define SuperPlayerWindowShared [SuperPlayerWindow sharedInstance]

#define live_typeValue 0

@interface LiveDetailViewController ()<SuperPlayerDelegate, UITableViewDelegate, UITableViewDataSource,WKNavigationDelegate>


/** 播放器View的父视图*/
@property (nonatomic) UIView *playerFatherView;


@property (strong, nonatomic) SuperPlayerView *playerView;
/** 离开页面时候是否在播放 */
@property (nonatomic, assign) BOOL isPlaying;

@property(nonatomic, strong) LiveHeaderView *headerView;

@property(nonatomic, strong) WKWebView *webView;

@property (nonatomic , strong) BaseNavView *navView;

//0动画 1直播
@property (nonatomic , assign) NSInteger qieHuan;

@property (nonatomic , strong) QMUIButton *backBtn;

@end

@implementation LiveDetailViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle =  UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
     
    self.view.backgroundColor = Blue_Color;
    
    self.playerFatherView = [[UIView alloc] init];
    self.playerFatherView.backgroundColor = SRGB(26);
    [self.view addSubview:self.playerFatherView];
    [self.playerFatherView mas_makeConstraints:^(MASConstraintMaker *make) {            make.top.equalTo(@(StatusBarHeight));
        make.leading.trailing.mas_equalTo(0);
        make.height.mas_equalTo(self.playerFatherView.mas_width).multipliedBy(9.0f/16.0f);
    }];
      
    [self.view layoutIfNeeded];
    self.headerView = [[LiveHeaderView alloc] initWithFrame:self.playerFatherView.bounds];
    [self.view layoutIfNeeded];
    [self.headerView setModel:self.model];
    
    self.webView = [[HPKPageManager sharedInstance] dequeueWebViewWithClass:[HPKWebView class] webViewHolder:self];
    self.webView.navigationDelegate = self;
    self.webView.frame = CGRectMake(0, StatusBarHeight, kScreenWidth, kScreenWidth/16*9);
    [self.webView addSubview:self.headerView];
    if (self.model.live_type == live_typeValue) {
        self.playerFatherView.hidden = YES;
        [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.model.live_cartoon_url.firstObject.url]]];
      
  }else {
      if (self.model.live_urls.count > 0) {
          self.qieHuan = 1;
          self.webView.hidden = YES;
          SuperPlayerModel *model = [[SuperPlayerModel alloc] init];
          model.videoURL = self.model.live_urls.firstObject.url;
          [self.playerView playWithModel:model];
      }else {
          if (self.model.live_cartoon_url.count > 0) {
              self.playerFatherView.hidden = YES;
              [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.model.live_cartoon_url.firstObject.url]]];
          }
      }
      
  }
    
    [self.view addSubview:_webView];
    
    QMUIButton *backBtn = [[QMUIButton alloc] initWithFrame:CGRectMake(1, 0, 44, 44)];
    [backBtn addTarget:self action:@selector(pop) forControlEvents:UIControlEventTouchUpInside];
    self.backBtn = backBtn;
    backBtn.hidden = YES;
    [self.webView addSubview:backBtn];
        
    UIImage *img = [UIImage qmui_imageWithShape:QMUIImageShapeNavBack size:CGSizeMake(10, 18) tintColor:UIColor.whiteColor];
    [backBtn setImage:img forState:UIControlStateNormal];
      
    [self getDatas];
    
    [self setupSubView];
    
}

- (void)setupSubView {
    
    CGFloat y = kScreenWidth/16*9+StatusBarHeight;
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, y, kScreenWidth, kScreenHeight-y)];
    backView.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:backView];
    
    if (self.model.live_cartoon_url.count > 0) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(30, 30, (kScreenWidth-120)/2, 35)];
        [button setTitle:@"切换动画信号" forState:UIControlStateNormal];
        [button setTitleColor:Blue_Color forState:UIControlStateNormal];
        [button addTarget:self action:@selector(clickAnimation:) forControlEvents:UIControlEventTouchUpInside];
        button.layer.cornerRadius = 5;
        button.layer.borderColor = Blue_Color.CGColor;
        button.layer.borderWidth = 1;
        [backView addSubview:button];
    }
    
    if (self.model.live_type != live_typeValue) {
        if (self.model.live_urls.count > 0) {
            UIButton *button1 = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth/2+30, 30, (kScreenWidth-120)/2, 35)];
            [button1 setTitle:@"切换直播信号" forState:UIControlStateNormal];
            [button1 setTitleColor:Blue_Color forState:UIControlStateNormal];
            [button1 addTarget:self action:@selector(clickLive:) forControlEvents:UIControlEventTouchUpInside];
            button1.layer.cornerRadius = 5;
            button1.layer.borderColor = Blue_Color.CGColor;
            button1.layer.borderWidth = 1;
            [backView addSubview:button1];
        }
    }
    
    self.tableView.frame = CGRectMake(30, 85, (kScreenWidth-120)/2, 300);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.layer.cornerRadius = 10;
    self.tableView.layer.borderColor = Blue_Color.CGColor;
    self.tableView.layer.borderWidth = 1;
    [backView addSubview:self.tableView];
    self.tableView.hidden = YES;
}
 
- (void)getDatas {
    
    [KYApiHttpTool requestWithUrl:[NSString stringWithFormat:@"%@?mid=%@&type=%@", URL_MATCH_DETAIL, self.ID,self.model.type] withMethod:@"GET" success:^(NSDictionary * _Nonnull response) {
        self.model = [LiveListModel mj_objectWithKeyValues:response[@"data"][@"matchinfo"]];
        self.model.live_type = [response[@"data"][@"live_type"] integerValue];
         
    } failure:^(NSError * _Nonnull error) {
           
    }];
}

- (void)clickAnimation:(UIButton *)sender {
    if (self.qieHuan == 1&&!self.tableView.isHidden) {
        return;
    }
    sender.selected = !sender.isSelected;
    if (sender.isSelected) {
        self.qieHuan = 0;
        CGFloat height = self.model.live_cartoon_url.count*50;
        self.tableView.hidden = NO;
        self.tableView.frame = CGRectMake(30, 85, (kScreenWidth-120)/2, height);
        [self.tableView reloadData];
    }else {
        self.tableView.hidden = YES;
    }
    
}

- (void)clickLive:(UIButton *)sender {
    if (self.qieHuan == 0&&!self.tableView.isHidden) {
        return;
    }
    sender.selected = !sender.isSelected;
    if (sender.isSelected) {
        self.qieHuan = 1;
        CGFloat height = self.model.live_cartoon_url.count*50;
        self.tableView.hidden = NO;
        self.tableView.frame = CGRectMake(kScreenWidth/2+30, 85, (kScreenWidth-120)/2, height);
        [self.tableView reloadData];
    }else {
        self.tableView.hidden = YES;
    }
}

- (void)pop {
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.qieHuan == 1) {
        return self.model.live_urls.count;
    }else {
        return self.model.live_cartoon_url.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellid = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    cell.textLabel.textColor = Blue_Color;
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.backgroundColor = UIColor.whiteColor;
    if (self.qieHuan == 0) {
        LiveCartoonModel *model = self.model.live_cartoon_url[indexPath.row];
        cell.textLabel.text = model.name;
    }else {
        LiveCartoonModel *model = self.model.live_urls[indexPath.row];
        cell.textLabel.text = model.name;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    tableView.hidden = YES;
    if (self.qieHuan == 0) {
        SuperPlayerModel *model = [[SuperPlayerModel alloc] init];
        model.videoURL = @"";
        [self.playerView playWithModel:model];
        self.playerFatherView.hidden = YES;
        self.webView.hidden = NO;
        [self.webView addSubview:self.headerView];
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.model.live_cartoon_url[indexPath.row].url]]];
    }else {
        SuperPlayerModel *model = [[SuperPlayerModel alloc] init];
        model.videoURL = self.model.live_urls[indexPath.row].url;
        [self.playerView playWithModel:model];
        self.playerFatherView.hidden = NO;
        
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@""]]];
        self.webView.hidden = YES;
             
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

#pragma mark - superplayer
- (void)willMoveToParentViewController:(nullable UIViewController *)parent {
    
}

// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    [self.headerView removeFromSuperview];
    self.backBtn.hidden = NO;
}

- (void)didMoveToParentViewController:(nullable UIViewController *)parent {
    if (parent == nil) {
        if (!SuperPlayerWindowShared.isShowing) {
            [self.playerView resetPlayer];
        }
    }
}

- (BOOL)prefersStatusBarHidden {
    return self.playerView.isFullScreen;
}

- (SuperPlayerView *)playerView {
    if (!_playerView) {
        _playerView = [[SuperPlayerView alloc] init];
        _playerView.fatherView = _playerFatherView;
        // 设置代理
        _playerView.delegate = self;
        // demo的时移域名，请根据您项目实际情况修改这里
        _playerView.playerConfig.playShiftDomain = @"vcloudtimeshift.qcloud.com";
        SPDefaultControlView *controlView = (SPDefaultControlView *)_playerView.controlView;
        controlView.disableDanmakuBtn = YES;
        
    }
    return _playerView;
}
 
- (void)superPlayerBackAction:(SuperPlayerView *)player {
    
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    // 是竖屏时候响应关
    // 播放状态
    //默认是打开的 bool值系统默认关闭 所以取反
    BOOL isOpen = ![[NSUserDefaults standardUserDefaults] boolForKey:CloseSmallWindow];
    if (orientation == UIInterfaceOrientationPortrait &&
        isOpen&&(self.playerView.state == StatePlaying)) {
        [SuperPlayerWindowShared setSuperPlayer:self.playerView];
        [SuperPlayerWindowShared show];
        SuperPlayerWindowShared.backController = self;
    } else {
        [self.playerView resetPlayer];  //非常重要
        SuperPlayerWindowShared.backController = nil;
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 投屏
- (void)handleShowDLNASettingView {
    QMUIModalPresentationViewController *modalViewController = [[QMUIModalPresentationViewController alloc] init];
    VideoDLNAView *contentView = [[VideoDLNAView alloc] initWithFrame:CGRectMake(0, 0, 300, 470)];
    contentView.backgroundColor = UIColorMake(245, 245, 245);
    contentView.layer.cornerRadius = 5.0;
    modalViewController.contentView = contentView;
    [modalViewController showWithAnimated:YES completion:nil];
    
}

 
- (BaseNavView *)navView {
    if (!_navView) {
        _navView = [[BaseNavView alloc] init];
        _navView.hiddenLineView = YES;
    }
    return _navView;
}


@end
