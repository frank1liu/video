//
//  PlayerViewController.m
//  SportNews
//
//  Created by kkk on 2020/12/3.
//

#import "PlayerViewController.h"
#import "LiveSubjectViewController.h"
#import "LiveListCategoryModel.h"
#import "MSNetwork.h"
#import "SNPersionLeftViewController.h"
#import "SuggestionViewController.h"
#import "MineInfoViewController.h"
#import "LoginViewController.h"
#import "CustomAlertView.h"
#import "SNUserViewController.h"
#import "SNUserWebViewController.h"
#import "CustomActivity.h"
#import "levelViewController.h"
#import "PrivateTalkViewController.h"
#import <UserNotifications/UserNotifications.h>
#import "JPUSHService.h"

extern UIImage *gChangedImage;

#define magin 100

static CGFloat const animationTime = 0.4;

// NSString *talkWebUrl = @"";
NSString *talkWebUrl = @"";
// NSString *talkGetUnreadUrl = @"";
NSString *talkGetUnreadUrl = @"";
NSInteger gUnReadMsgCount = 0;

BOOL isTalkRed = YES;
BOOL isLoadFail = NO;
static NSUInteger netWorkTryTime = 0;

@interface PlayerViewController () <JXCategoryViewDelegate>

@property (nonatomic, strong) JXCategoryTitleView *myCategoryView;
@property (nonatomic, assign) NSInteger currentIndex;
@property(nonatomic, strong) NSArray<LiveListCategoryModel *> *categorysArray;
@property(nonatomic, strong) NSArray<LiveListCategoryModel *> *footBallCategorysArray;
@property(nonatomic, strong) NSArray<LiveListCategoryModel *> *basketBallCategorysArray;
@property(nonatomic, strong) NSArray<LiveListCategoryModel *> *otherCategorysArray;

@property(nonatomic, assign) BOOL isFirstLoad;


@property(nonatomic, strong) UIButton *allBtn;
@property(nonatomic, strong) UIButton *footBallBtn;
@property(nonatomic, strong) UIButton *basketBallBtn;
@property(nonatomic, strong) UIButton *hotBtn;
@property(nonatomic, strong) UIButton *otherBtn;

@property(nonatomic, assign) NSInteger buildCount;

@property(nonatomic, strong) UIButton *scoreBtn;

@property(nonatomic, strong) UIButton *zhishuBtn;

@property(nonatomic, strong) UIImageView *refreshImage;

/** leftVc */
@property (nonatomic, weak) SNPersionLeftViewController *leftVc;
/** bgView */
@property (nonatomic, weak) UIView *bgView;

// 是否首次加载
@property(nonatomic, assign) BOOL isFirstLoads;

@property(nonatomic, assign) CGFloat categoryWidth;

@property(nonatomic, strong) UIImageView *userImageView;

@property(nonatomic, assign) BOOL showLeft;
  

@property(nonatomic, strong) UIView *emptyBackView;
@property(nonatomic, strong) UIImageView *emptyImageView;
@property(nonatomic, strong) UILabel *emptyLabel;
@property(nonatomic, strong) NSTimer *checkTimer;
@property (nonatomic, strong) UIButton *redBtn;

@end

@implementation PlayerViewController
@synthesize redBtn;

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    LoginUserModel *loginModel = [UserModelTool loginModel];
    if (loginModel) {
        if (![CommonTools isBlankString:loginModel.token] && ![CommonTools isBlankString:loginModel.uid]) {
            NSDictionary *dic = @{
                @"token":loginModel.token,
                @"uid":loginModel.uid
            };
            [KYApiHttpTool GETNoHud:URL_GetUserInfo withParams:dic success:^(NSDictionary * _Nonnull response) {
                LoginUseInfoModel *userinfo = [LoginUseInfoModel mj_objectWithKeyValues:response[@"userinfo"]];
                loginModel.userinfo = userinfo;
                [UserModelTool save:loginModel];
                if (gChangedImage != nil) {
                    self.userImageView.image = gChangedImage;
                }
                else if (![loginModel.userinfo.head isEqualToString:userinfo.head]) {
                    [self.userImageView sd_setImageWithURL:[NSURL URLWithString:userinfo.head] placeholderImage:UIImageMake(@"个人中心入口")];
                }
            } failure:^(NSError * _Nullable error) {

            }];
        }
    }
    self.checkTimer = [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(checkNewTalkMsg) userInfo:nil repeats:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(intoTalkView)
                                                 name:@"PrivatedTalkClicked"
                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.checkTimer invalidate];
    self.checkTimer = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"PrivatedTalkClicked" object:nil];
}

- (void)checkNewTalkMsg {
    NSUserDefaults *df = [NSUserDefaults standardUserDefaults];
    LoginUserModel *loginModel = [UserModelTool loginModel];
    if (loginModel != nil) {       // 登入
        NSString *friendID = [df objectForKey:@"FriendTalkID"];
        NSLog(@"[Adam] friend talk id = %@", friendID);
        NSString *myID = [df objectForKey:@"UserTalkID"];
        NSLog(@"[Adam] user talk id = %@", myID);
        NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
        dic[@"actionId"] = @88;
        dic[@"jobDispatchId"] = @4;
        dic[@"newData"] = [NSString stringWithFormat:@"{\"user_uid\":\"%@\"}", myID];
        dic[@"processorId"] = @1008;
        [KYApiHttpTool POST_TALK:talkGetUnreadUrl withParams:dic success:^(NSDictionary * _Nonnull response) {
            if ([response[@"success"] boolValue] == YES) {
                NSDictionary *rc = [CommonTools dictionaryWithJsonString:response[@"returnValue"]];
                if ([rc objectForKey:friendID]) {
                    gUnReadMsgCount += [[rc objectForKey:friendID] intValue];
                    NSLog(@"[Adam]管理有%ld條新消息!!", gUnReadMsgCount);
                    dispatch_async(dispatch_get_main_queue(), ^(void){
                        // [self triggerNotification:gUnReadMsgCount];
                        [self sendLocalNotification: gUnReadMsgCount];
                        [self.redBtn setHidden: NO];
                        isTalkRed = NO;
                        [self.redBtn setTitle:[NSString stringWithFormat:@"%ld", gUnReadMsgCount] forState:UIControlStateNormal];
                    });
                }
            }
        } failure:^(NSError * _Nullable error) {
            NSLog(@"%@", error);
        }];
    } else {
        NSString *friendID = [df objectForKey:@"FriendTalkID"];
        if (friendID != nil) {
            NSLog(@"[Adam] friend talk id = %@", friendID);
            NSString *myID = [df objectForKey:@"UserTalkID"];
            NSString *myToken = [df objectForKey:@"UserToken"];
            NSLog(@"[Adam] user talk id = %@", myID);
            NSLog(@"[Adam] user token = %@", myToken);
            NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
            dic[@"actionId"] = @88;
            // dic[@"device"] = @"0";
            // dic[@"doInput"] = @"1";
            dic[@"jobDispatchId"] = @4;
            dic[@"newData"] = [NSString stringWithFormat:@"{\"user_uid\":\"%@\"}", myID];
            dic[@"processorId"] = @1008;
            // dic[@"token"] = myToken;
            // dic[@"v"] = @"4110052";
            [KYApiHttpTool POST_TALK:talkGetUnreadUrl withParams:dic success:^(NSDictionary * _Nonnull response) {
                if ([response[@"success"] boolValue] == YES) {
                    NSDictionary *rc = [CommonTools dictionaryWithJsonString:response[@"returnValue"]];
                    if ([rc objectForKey:friendID]) {
                        gUnReadMsgCount += [[rc objectForKey:friendID] intValue];
                        NSLog(@"[Adam]管理有%ld條新消息!!", gUnReadMsgCount);
                        dispatch_async(dispatch_get_main_queue(), ^(void){
                            // [self triggerNotification: gUnReadMsgCount];
                            [self sendLocalNotification: gUnReadMsgCount];
                            [self.redBtn setHidden: NO];
                            isTalkRed = NO;
                            [self.redBtn setTitle:[NSString stringWithFormat:@"%ld", gUnReadMsgCount] forState:UIControlStateNormal];
                        });
                    }
                }
            } failure:^(NSError * _Nullable error) {
                NSLog(@"%@", error);
            }];
        }
    }
}

- (void)sendLocalNotification:(NSInteger)num {
    // 1️⃣ 建立通知內容
    NSUserDefaults *df = [NSUserDefaults standardUserDefaults];
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    NSString *fromNickname = [df objectForKey:@"fromNickname"];

    if (fromNickname != nil && ![fromNickname isEqualToString:@""]) {
        content.title = fromNickname;
    } else {
        content.title = @"私聊推送";
    }
    content.body = [NSString stringWithFormat:@"您有%ld则未读私聊消息", num];
    content.sound = [UNNotificationSound defaultSound];

    // 2️⃣ 設定觸發條件（5 秒後觸發）
    UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:1 repeats:NO];

    NSString *fromAvatar = [df objectForKey:@"fromAvatar"];
    NSString *imageName = @"girl.png"; // 確保這張圖片在 `Assets.xcassets` 或 `App Bundle` 內
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:imageName ofType:nil];

    if (fromAvatar != nil && ![fromAvatar isEqualToString:@""]) {
        imagePath = fromAvatar;
    }

    if (imagePath) {
        NSURL *imageURL;
        if ([imagePath containsString:@"http"]) {
            imageURL = [NSURL URLWithString:imagePath];

            NSData *imageData = [NSData dataWithContentsOfURL:imageURL];

            if (imageData) {
                // 取得本地儲存路徑
                NSString *filePath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"downloaded_image.jpg"];
                [imageData writeToFile:filePath atomically:YES];

                imageURL = [NSURL fileURLWithPath:filePath];
                NSLog(@"📌 圖片已儲存: %@", filePath);
            } else {
                NSLog(@"❌ 下載失敗");
            }
        } else {
            imageURL = [NSURL fileURLWithPath:imagePath];
        }

        NSError *error;
        UNNotificationAttachment *attachment = [UNNotificationAttachment attachmentWithIdentifier:@"image"
                                                                                              URL:imageURL
                                                                                          options:nil
                                                                                            error:&error];
        if (attachment) {
            content.attachments = @[attachment];
        } else {
            NSLog(@"❌ 圖片載入失敗: %@", error.localizedDescription);
        }
    }
    // 3️⃣ 建立通知請求
    NSString *identifier = @"LocalNotification";
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:identifier content:content trigger:trigger];

    // 4️⃣ 加入通知中心
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        if (error) {
            NSLog(@"推播發送失敗: %@", error.localizedDescription);
        } else {
            NSLog(@"推播已排程");
        }
    }];
}

/*
- (void)triggerNotification:(NSInteger)num {
    // 設定推播內容
    NSUserDefaults *df = [NSUserDefaults standardUserDefaults];
    JPushNotificationContent *content = [[JPushNotificationContent alloc] init];
    NSString *fromNickname = [df objectForKey:@"fromNickname"];

    if (fromNickname != nil && ![fromNickname isEqualToString:@""]) {
        content.title = fromNickname;
    } else {
        content.title = @"私聊推送";
    }
    content.body = [NSString stringWithFormat:@"您有%ld则未读私聊消息", num];
    content.sound = @"default";  // 設定音效
    content.badge = @1;

    NSString *fromAvatar = [df objectForKey:@"fromAvatar"];
    NSString *imageName = @"girl.png"; // 確保這張圖片在 `Assets.xcassets` 或 `App Bundle` 內
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:imageName ofType:nil];

    if (fromAvatar != nil && ![fromAvatar isEqualToString:@""]) {
        imagePath = fromAvatar;
    }

    if (imagePath) {
        NSURL *imageURL;
        if ([imagePath containsString:@"http"]) {
            imageURL = [NSURL URLWithString:imagePath];

            NSData *imageData = [NSData dataWithContentsOfURL:imageURL];

            if (imageData) {
                // 取得本地儲存路徑
                NSString *filePath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"downloaded_image.jpg"];
                [imageData writeToFile:filePath atomically:YES];

                imageURL = [NSURL fileURLWithPath:filePath];
                NSLog(@"📌 圖片已儲存: %@", filePath);
            } else {
                NSLog(@"❌ 下載失敗");
            }
        } else {
            imageURL = [NSURL fileURLWithPath:imagePath];
        }

        NSError *error;
        UNNotificationAttachment *attachment = [UNNotificationAttachment attachmentWithIdentifier:@"image"
                                                                                              URL:imageURL
                                                                                          options:nil
                                                                                            error:&error];
        if (attachment) {
            content.attachments = @[attachment];
        } else {
            NSLog(@"❌ 圖片載入失敗: %@", error.localizedDescription);
        }
    }

    // 設定觸發條件（5 秒後觸發）
    JPushNotificationTrigger *trigger = [[JPushNotificationTrigger alloc] init];
    trigger.timeInterval = 1;
    trigger.repeat = NO;

    // 設定請求
    JPushNotificationRequest *request = [[JPushNotificationRequest alloc] init];
    request.content = content;
    request.trigger = trigger;
    request.requestIdentifier = @"JPushLocalNotification";

    // 發送通知
    [JPUSHService addNotification:request];
}
*/

- (void)viewDidLoad {

    [super viewDidLoad];

#if DEBUG
// #if 1
    talkWebUrl = @"https://test.kzb001.net/notification";
    talkGetUnreadUrl = @"https://testim.nongzhiwios.com/rest_post";
#else
    talkWebUrl = @"https://kzb2knmj.com/notification";
    talkGetUnreadUrl = @"https://nongzhiwios.com/rest_post";
#endif

    NSData* imageData = [[NSUserDefaults standardUserDefaults] objectForKey:@"gChangedImage"];
    if (imageData != nil) {
        gChangedImage = [UIImage imageWithData:imageData];
    }

    [self setupCategoryView];
    
    [self setupNavCenterView];
    
    [self setupTableView];
    
    [self checkNotification];
    
    // [self checkVersion];

    [self getDomainName];
     
    [self setupLeftVc];
    
    [self setupEmptyView];
      
    [KYRemindView show];
    [self getDatas];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshBtnComplete) name:ListRefreshComplete object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccessNotification) name:@"loginSuccess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadDataAgain) name:@"NetworkAvailable" object:nil];
    // [self.redBtn setHidden:YES];
}

- (void)loadDataAgain {
    if (isLoadFail) {
        [self getDatas];
    }
}

- (void)setupLeftVc {
    
    self.showLeft = YES;
    // 半透明的view
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = [UIColor blackColor];
    bgView.frame = [UIScreen mainScreen].bounds;
    bgView.alpha = 0;
    [self.view addSubview:bgView];
    self.bgView = bgView;
    
    // 添加两个手势
    UITapGestureRecognizer *tapGestureRec = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeSideBar)];
    [bgView addGestureRecognizer:tapGestureRec];
    
    UIPanGestureRecognizer *panGestureRec = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveViewWithGesture:)];
    [self.view addGestureRecognizer:panGestureRec];
    
    // 添加控制器
    SNPersionLeftViewController *leftVc = [[SNPersionLeftViewController alloc] init];
    WeakSelf
    leftVc.hideBlock = ^{
        [weakSelf closeAnimation];
    };
    
    leftVc.clickOtherBlock = ^(NSInteger index) {
        LoginUserModel *loginModel = [UserModelTool loginModel];
        if (!loginModel) { 
            LoginViewController *loginVc = [LoginViewController new];
            [weakSelf.navigationController pushViewController:loginVc animated:YES];
        }else {
            if (index == 1) {
                //个人中心
                MineInfoViewController *VC = [[MineInfoViewController alloc] init];
                VC.isLeftPush = YES;
                [weakSelf.navigationController pushViewController:VC animated:YES];
            }else if (index == 2) {
                SuggestionViewController *VC = [[SuggestionViewController alloc] init];
                [weakSelf.navigationController pushViewController:VC animated:YES];
            }else if (index == 3) {
//                LevelViewController *VC = [[LevelViewController alloc] init];
//                [weakSelf.navigationController pushViewController:VC animated:YES];
                SNUserWebViewController *VC = [[SNUserWebViewController alloc] init];
                VC.url = @"https://kzbbckjl.com/user/level";
                [weakSelf.navigationController pushViewController:VC animated:YES];
            }
        }
        [weakSelf closeAnimation];
    };
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width - 50;
    if ([UIScreen mainScreen].bounds.size.width > 375) {
        width -= 50;
    } else if ([UIScreen mainScreen].bounds.size.width > 320) {
        width = width - 25;
    }
    leftVc.view.frame = CGRectMake(-width, 0, width, [UIScreen mainScreen].bounds.size.height);
    [self.view addSubview:leftVc.view];
    [self addChildViewController:leftVc];
    self.leftVc = leftVc;
}

- (void)setupCategoryView {
    
    self.categoryWidth = ((SCREEN_WIDTH - magin -5) > 200? 200+30:(SCREEN_WIDTH - magin -5))+30;
    self.buildCount = [[NSUserDefaults standardUserDefaults] integerForKey:@"buildCountInLocal"];
    self.isFirstLoad = YES;
    self.isFirstLoads = YES;
    NSString *title = @" ";
    self.titles = @[title, title, title, title];
     _footBallCategorysArray = @[];
    _basketBallCategorysArray = @[];
    
    self.myCategoryView.cellSpacing = 0;
    self.myCategoryView.cellWidth = self.categoryWidth/4;
    self.myCategoryView.titles = self.titles;
    self.myCategoryView.frame = CGRectMake(0, 0, self.categoryWidth, 33);
    self.myCategoryView.delegate = self;
    self.myCategoryView.titleLabelMaskEnabled = YES;
    self.myCategoryView.contentScrollView.scrollEnabled = NO;
    self.myCategoryView.collectionView.scrollEnabled = NO;
    [self.myCategoryView removeFromSuperview];
    self.myCategoryView.center = self.navView.center;
    for (UIView *subView in self.navView.subviews) {
        [subView removeFromSuperview];
    }
    [self.navView addSubview:self.myCategoryView];
}

- (void)setupNavCenterView {
    
    CGFloat w = self.categoryWidth/4;
    CGFloat h = 31;
    // 原本是14
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, h)];
    [self.navView insertSubview:backView atIndex:0];
    backView.centerY = NavHeight-20;
    
    UIView *borderView = [[UIView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-gap)-w*4, 0, self.categoryWidth, h)];
    borderView.layer.cornerRadius = backView.height/2;
    borderView.layer.borderColor = SRGB(215).CGColor;
    borderView.layer.borderWidth = 0.5;
    [backView addSubview:borderView];
     
    //个人中心入口
    UIImageView *userImageView = [[UIImageView alloc] initWithFrame:CGRectMake(13.5, 0, 30, h-1)];
    self.userImageView = userImageView;
    [self loginSuccessNotification];
    [backView addSubview:userImageView];
    UIButton *enterBtn = [[UIButton alloc] initWithFrame:CGRectMake(13.5, 0, 30, 30)];
    [enterBtn addTarget:self action:@selector(showAnimation) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:enterBtn];

    //私聊入口
    UIButton *talkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    talkBtn.frame = CGRectMake(SCREEN_WIDTH - 36, 5, 22, 22);
    [talkBtn setBackgroundImage:[UIImage imageNamed:@"msgicon"] forState:UIControlStateNormal];
    [talkBtn addTarget:self action:@selector(intoTalkView) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:talkBtn];

    // 紅點
    redBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    redBtn.frame = CGRectMake(SCREEN_WIDTH - 23, 1, 15, 15);
    [redBtn setBackgroundImage:[UIImage imageNamed:@"reddot"] forState:UIControlStateNormal];
    [redBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    // [redBtn setTitle:@"3" forState:UIControlStateNormal];
    redBtn.titleLabel.font = [UIFont systemFontOfSize:11.0];
    [redBtn addTarget:self action:@selector(intoTalkView) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:redBtn];
    [redBtn setHidden:YES];
    isTalkRed = YES;

    /*
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(40, 8, 60, 16)];
    imageView.image = [UIImage imageNamed:@"说球帝logo_home-2"];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [backView addSubview:imageView];
    enterBtn.centerY = imageView.centerY;
    */

    UIButton *allBtn = [[UIButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-gap)-w*4, 0.5, w, h-1)];
    [allBtn setTitle:@" 热门" forState:UIControlStateNormal];
    allBtn.titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightSemibold];
    [allBtn setTitleColor:SRGB(153) forState:UIControlStateNormal];
    [allBtn setTitleColor:UIColor.whiteColor forState:UIControlStateSelected];
    [allBtn setImage:[UIImage imageNamed:@"热门未选"] forState:UIControlStateNormal];
    [allBtn setImage:[UIImage imageNamed:@"热门选中"] forState:UIControlStateSelected];
    [allBtn setBackgroundImage:[UIImage imageNamed:@"矩形"] forState:UIControlStateSelected];
    allBtn.selected = YES;
    [backView addSubview:allBtn];
    self.allBtn = allBtn;

    UIButton *footBallBtn = [[UIButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-gap)-3*w, 0.5, w, h-1)];
    [footBallBtn setTitle:@" 足球" forState:UIControlStateNormal];
    footBallBtn.titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightSemibold];
    [footBallBtn setTitleColor:SRGB(153) forState:UIControlStateNormal];
    [footBallBtn setTitleColor:UIColor.whiteColor forState:UIControlStateSelected];
    [footBallBtn setImage:[UIImage imageNamed:@"足球未选"] forState:UIControlStateNormal];
    [footBallBtn setImage:[UIImage imageNamed:@"足球选中"] forState:UIControlStateSelected];
    [footBallBtn setBackgroundImage:[UIImage imageNamed:@"矩形"] forState:UIControlStateSelected];
    [backView addSubview:footBallBtn];
    self.footBallBtn = footBallBtn;
    
    UIButton *basketBallBtn = [[UIButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-gap)-2*w, 0.5, w, h-1)];
    [basketBallBtn setTitle:@" 篮球" forState:UIControlStateNormal];
    basketBallBtn.titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightSemibold];
    [basketBallBtn setTitleColor:SRGB(153) forState:UIControlStateNormal];
    [basketBallBtn setTitleColor:UIColor.whiteColor forState:UIControlStateSelected];
    [basketBallBtn setImage:[UIImage imageNamed:@"篮球未选"] forState:UIControlStateNormal];
    [basketBallBtn setImage:[UIImage imageNamed:@"篮球选中"] forState:UIControlStateSelected];
    [basketBallBtn setBackgroundImage:[UIImage imageNamed:@"矩形"] forState:UIControlStateSelected];
    [backView addSubview:basketBallBtn];
    self.basketBallBtn = basketBallBtn;
    
    UIButton *otherBallBtn = [[UIButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-gap)-w, 0.5, w, h-1)];
    [otherBallBtn setTitle:@" 赛果" forState:UIControlStateNormal];
    otherBallBtn.titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightSemibold];
    [otherBallBtn setTitleColor:SRGB(153) forState:UIControlStateNormal];
    [otherBallBtn setTitleColor:UIColor.whiteColor forState:UIControlStateSelected];
    [otherBallBtn setImage:[UIImage imageNamed:@"result2"] forState:UIControlStateNormal];
    [otherBallBtn setImage:[UIImage imageNamed:@"result1"] forState:UIControlStateSelected];
    [otherBallBtn setBackgroundImage:[UIImage imageNamed:@"矩形"] forState:UIControlStateSelected];
    [backView addSubview:otherBallBtn];
    self.otherBtn = otherBallBtn;
}

- (void)intoTalkView {
    PrivateTalkViewController *VC = [[PrivateTalkViewController alloc] init];
    [self.navigationController pushViewController:VC animated:YES];
    [self.redBtn setHidden:YES];
    isTalkRed = YES;
}

- (void)setupTableView {
    
    self.tableView.frame = CGRectMake(0, NavHeight, kScreenWidth, kScreenHeight);
    WeakSelf
    MJRefreshHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf refreshData];
    }];
    self.tableView.mj_header = header;
    [self.view addSubview:self.tableView];
    [MSNetwork networkStatusWithBlock:^(MSNetworkStatusType status) {
        if (status != MSNetworkStatusNotReachable && !self.isFirstLoad) {
            if (self.categorysArray.count == 0) {
                [self.tableView.mj_header beginRefreshing];
            }
        }
    }];
     
    [self setupRefreshQiehuan];
    
    [self setupShareBtn];
}

- (void)setupEmptyView {
    UIView *backView = [[UIView alloc] initWithFrame:self.tableView.bounds];
    self.emptyBackView = backView;
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 223, 187)];
    self.emptyImageView = imageView;
    [backView addSubview:imageView];
    imageView.image = [UIImage imageNamed:@"暂无比赛"];
    imageView.centerX = backView.centerX;
    imageView.centerY = (kScreenHeight - NavHeight -187)/2;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(imageView.frame)+5, kScreenWidth, 25)];
    self.emptyLabel = label;
    label.font = [UIFont fontWithName:@"PingFangSC-Regular" size: 14];
    label.textColor = SRGB(102);
    label.textAlignment = NSTextAlignmentCenter;
    [backView addSubview:label];
}

//下面的刷新和切换
- (void)setupRefreshQiehuan {
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth-63-3, kScreenHeight-63-xBottomHeight, 63, 63)];
    [self.view addSubview:backView];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:backView.bounds];
    imageView.image = [UIImage imageNamed:@"椭圆形"];
    [backView addSubview:imageView];
    
    UIImageView *imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(21.5, 19.5, 20, 20)];
    imageView1.image = [UIImage imageNamed:@"刷新-bai"];
    self.refreshImage = imageView1;
    [backView addSubview:imageView1];
    
    UIButton *refreshBtn = [[UIButton alloc] initWithFrame:backView.bounds];
    [refreshBtn addTarget:self action:@selector(refreshBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:refreshBtn];
}

//下面的分享
- (void)setupShareBtn {
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth-63-3, kScreenHeight-63-xBottomHeight - 65, 63, 63)];
    [self.view addSubview:backView];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:backView.bounds];
    imageView.image = [UIImage imageNamed:@"椭圆形"];
    [backView addSubview:imageView];
    
    UIImageView *imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(21.5, 19.5, 20, 20)];
    imageView1.image = [UIImage imageNamed:@"列表分享"];
    [backView addSubview:imageView1];
    
    UIButton *refreshBtn = [[UIButton alloc] initWithFrame:backView.bounds];
    [refreshBtn addTarget:self action:@selector(shareBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:refreshBtn];
    
}

- (void)showAnimation {
    if (self.showLeft) {
        // 根据当前x，计算隐藏时间
        CGFloat time = fabs(self.leftVc.view.frame.origin.x / self.leftVc.view.frame.size.width) * animationTime;
        [UIView animateWithDuration:time animations:^{
            self.leftVc.view.frame = CGRectMake(0, 0, self.leftVc.view.frame.size.width, [UIScreen mainScreen].bounds.size.height);
            [self.leftVc reloadView];
            self.bgView.alpha = 0.5;
        } completion:^(BOOL finished) {
        }];
    }else {
        LoginUserModel *loginModel = [UserModelTool loginModel];
        if (!loginModel) {
            LoginViewController *loginVc = [LoginViewController new];
            [self.navigationController pushViewController:loginVc animated:YES];
        }else {
            SNUserWebViewController *VC = [[SNUserWebViewController alloc] init];
            //VC.url = [NSString stringWithFormat:@"%@user/info",BaseUrl];
            VC.url = @"http://8848.shuoqiudi.live/user/info";
            [self.navigationController pushViewController:VC animated:YES];
        }
    }
}

- (void)closeAnimation {
    // 根据当前x，计算隐藏时间
    CGFloat time = (1 - fabs(self.leftVc.view.frame.origin.x / self.leftVc.view.frame.size.width)) * animationTime;
    [UIView animateWithDuration:time animations:^{
        self.leftVc.view.frame = CGRectMake(-self.leftVc.view.frame.size.width, 0, self.leftVc.view.frame.size.width, [UIScreen mainScreen].bounds.size.height);
        self.bgView.alpha = 0.0;
    } completion:^(BOOL finished) {
        // 隐藏个人中心
    }];
}


- (void)scoreBtnAction:(UIButton *)sender {
    self.scoreBtn.selected = YES;
    self.zhishuBtn.selected = NO;
    [[NSNotificationCenter defaultCenter] postNotificationName:ChangeShowType object:@"0" userInfo:nil];
}

- (void)zhishuBtnAction:(UIButton *)sender {
    self.scoreBtn.selected = NO;
    self.zhishuBtn.selected = YES;
    [[NSNotificationCenter defaultCenter] postNotificationName:ChangeShowType object:@"1" userInfo:nil];
}

- (void)refreshBtnAction {
    [self.refreshImage.layer addAnimation:[CommonTools rotationAnimation_Animation] forKey:@"refreshBtnAnimation"];
    [[NSNotificationCenter defaultCenter] postNotificationName:ListRefreshBtnAction object:nil userInfo:nil];
}

- (void)shareBtnAction {
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

- (void)refreshBtnComplete {
    [self.refreshImage.layer removeAnimationForKey:@"refreshBtnAnimation"];
}

- (void)checkNotification {
    [CommonTools checkNotificationStatus:^(BOOL isOpen) {
        if (isOpen) {
            NSLog(@"dakaile");
        }else {
            NSLog(@"meidakai");
        }
    }];
}

- (void)loginSuccessNotification {
    LoginUserModel *loginModel = [UserModelTool loginModel];
    if (loginModel) {
        if (gChangedImage != nil) {
            self.userImageView.image = gChangedImage;
        } else {
            [self.userImageView sd_setImageWithURL:[NSURL URLWithString:loginModel.userinfo.head] placeholderImage:UIImageMake(@"personDef")];
        }
        self.userImageView.layer.cornerRadius = _userImageView.frame.size.width / 2;
        self.userImageView.clipsToBounds = YES;
        [self.redBtn setHidden:YES];
        gUnReadMsgCount = 0;
    }else {
        self.userImageView.layer.cornerRadius = _userImageView.frame.size.width / 2;
        self.userImageView.clipsToBounds = YES;
        self.userImageView.image = UIImageMake(@"personDef");
    }
}

/**
 * 点击手势
 */
- (void)closeSideBar {
    [self closeAnimation];
}

/**
 * 拖拽手势
 */
- (void)moveViewWithGesture:(UIPanGestureRecognizer *)panGes {
    // 下面是计算
    // 结束位置
    static CGFloat lastX;
    // 改变多少
    static CGFloat durationX;
    CGPoint touchPoint = [panGes locationInView:[[UIApplication sharedApplication] keyWindow]];
    // 手势开始
    if (panGes.state == UIGestureRecognizerStateBegan) {
        lastX = touchPoint.x;
    }
    // 手势改变
    if (panGes.state == UIGestureRecognizerStateChanged) {
        CGFloat currentX = touchPoint.x;
        // 改变的距离
        durationX = currentX - lastX;
        lastX = currentX;
        // 左边控制器的frame
        CGFloat leftVcX = durationX + self.leftVc.view.frame.origin.x;
        // 如果控制器的x小于宽度直接返回
        if (leftVcX <= -self.leftVc.view.frame.size.width) {
            leftVcX = -self.leftVc.view.frame.size.width;
        }
        // 如果控制器的x大于0直接返回
        if (leftVcX >= 0) {
            leftVcX = 0;
        }
        // 计算bgView的透明度
        self.bgView.alpha = (1 + leftVcX / self.leftVc.view.frame.size.width) * 0.5;
        // 设置左边控制器的frame
        [self.leftVc.view setFrame:CGRectMake(leftVcX, 0, self.leftVc.view.frame.size.width, self.leftVc.view.frame.size.height)];
    }
    // 手势结束
    if (panGes.state == UIGestureRecognizerStateEnded) {
        // 结束为止超时屏幕一半
        if (self.leftVc.view.frame.origin.x > - self.leftVc.view.frame.size.width + [UIScreen mainScreen].bounds.size.width / 2) {
            [self showAnimation];
        } else {
            [self closeAnimation];
        }
    }
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    CGFloat w = self.categoryWidth/4;
    self.myCategoryView.frame = CGRectMake((SCREEN_WIDTH-gap)-4*w, 0, self.categoryWidth, 33);
    self.myCategoryView.centerY = NavHeight - 20;
}

- (JXCategoryTitleView *)myCategoryView {
    return (JXCategoryTitleView *)self.categoryView;
}

- (CGFloat)preferredCategoryViewHeight {
    return 0;
}

- (JXCategoryBaseView *)preferredCategoryView {
    return [[JXCategoryTitleView alloc] init];
}

#pragma mark - JXCategoryListContainerViewDelegate
- (id<JXCategoryListContentViewDelegate>)listContainerView:(JXCategoryListContainerView *)listContainerView initListForIndex:(NSInteger)index {
    
    if (self.categorysArray.count == 0) {
        return nil;
    }
    LiveSubjectViewController *list = [[LiveSubjectViewController alloc] init];
    if (index == 0) {
        NSMutableArray *titles = @[].mutableCopy;
        for (LiveListCategoryModel *model in self.categorysArray) {
            [titles addObject:model.name];
        }
        list.categoryListModelArray = [@[@"全部"] arrayByAddingObjectsFromArray:self.categorysArray];
        if (titles.count > 0) {
            [titles insertObject:@"全部" atIndex:0];
        }
        list.titles = titles;
        list.type = -1;
    }else if(index == 1) {
        
        NSMutableArray *titles = @[].mutableCopy;
        for (LiveListCategoryModel *model in self.footBallCategorysArray) {
            [titles addObject:model.name];
        }
        list.categoryListModelArray = [@[@"全部"] arrayByAddingObjectsFromArray: self.footBallCategorysArray];
        if (titles.count > 0) {
            [titles insertObject:@"全部" atIndex:0];
        }
        list.titles = titles;
        list.type = 1;
    }else if (index == 2) {
        NSMutableArray *titles = @[].mutableCopy;
        for (LiveListCategoryModel *model in self.basketBallCategorysArray) {
            [titles addObject:model.name];
        }
        list.categoryListModelArray = [@[@"全部"] arrayByAddingObjectsFromArray: self.basketBallCategorysArray];
        if (titles.count > 0) {
            [titles insertObject:@"全部" atIndex:0];
        }
        list.titles = titles;
        list.type = 2;
    } else if (index == 3) {
        NSMutableArray *titles = @[].mutableCopy;
//        for (LiveListCategoryModel *model in self.basketBallCategorysArray) {
//            [titles addObject:model.name];
//        }
//        list.categoryListModelArray = [@[@"全部"] arrayByAddingObjectsFromArray: self.basketBallCategorysArray];
//        if (titles.count > 0) {
//            [titles insertObject:@"全部" atIndex:0];
//        }
        [titles addObject:@""];

        list.titles = titles;
        
        list.type = 3;
    }else {
        NSMutableArray *titles = @[].mutableCopy;
        for (LiveListCategoryModel *model in self.otherCategorysArray) {
            [titles addObject:model.name];
        }
        list.categoryListModelArray = [@[@"全部"] arrayByAddingObjectsFromArray: self.otherCategorysArray];
        if (titles.count > 0) {
            [titles insertObject:@"全部" atIndex:0];
        } 
        list.titles = titles;
        list.type = 4;
    }
    return list;
}

// 重新刷新頁面
- (void)refreshData {
    [self getDomainName];
    [self getDatas];
}

- (void)handleOtherSuccess:(nonnull NSDictionary *)response {
    id dic = response[@"data"];
    if (dic == nil || [dic isKindOfClass:[NSNull class]]) {
        return;
    }
    self.tableView.backgroundView = nil;
    self.otherCategorysArray = [LiveListCategoryModel mj_objectArrayWithKeyValuesArray:response[@"data"]];
    [self.myCategoryView reloadData];
}

- (void)getDatas {
    
    if (self.categorysArray.count > 0) {
        return;
    }
    NSDictionary *param = @{
        @"ishot" : @(1)
    };
    
    void (^success)(NSDictionary *) = ^(NSDictionary * _Nonnull response) {
        id dic = response[@"data"];
        if (dic == nil || [dic isKindOfClass:[NSNull class]]) {
            return;
        }
        netWorkTryTime = 10;
        isLoadFail = NO;
        self.tableView.backgroundView = nil;
        self.isFirstLoad = NO;
        self.categorysArray = [LiveListCategoryModel mj_objectArrayWithKeyValuesArray:response[@"data"][@"twoCategoryList"]];
        if (self.categorysArray.count > 0) {
            [UserModelTool saveCategory:self.categorysArray];
        }
        [self.tableView.mj_header endRefreshing];
        if (self.tableView.superview&&self.categorysArray) {
            [self.tableView.mj_header endRefreshing];
            [self.tableView removeFromSuperview];
        }
        for (LiveListCategoryModel *model in self.categorysArray) {
            if (model.type.integerValue == 1) {
                self.footBallCategorysArray = [self.footBallCategorysArray arrayByAddingObject:model];
            }else if (model.type.integerValue == 2) {
                self.basketBallCategorysArray = [self.basketBallCategorysArray arrayByAddingObject:model];
            }
        }
        [self.myCategoryView reloadData];
        
    };
    void (^ fail)(NSError *) = ^(NSError * _Nonnull error) {
        self.isFirstLoad = NO;
        isLoadFail = YES;
        [self.tableView.mj_header endRefreshing];
        NSInteger codeint = error.code;
        self.tableView.backgroundView = self.emptyBackView;
        if (codeint == (-999)) {
            netWorkTryTime = 10;
            self.emptyImageView.image = [UIImage imageNamed:@"暂无网络"];
            self.emptyLabel.text = @"网络不好，请刷新重试";
        }else if (codeint == (-1001)) {
            netWorkTryTime = 10;
            self.emptyImageView.image = [UIImage imageNamed:@"暂无网络"];
            self.emptyLabel.text = @"网络不好，请刷新重试";
        }else if (codeint == (-1009)) {
            netWorkTryTime = 10;
            self.emptyImageView.image = [UIImage imageNamed:@"暂无网络"];
            self.emptyLabel.text = @"网络不好，请刷新重试";
       }else {
            //判断系统错误
           self.emptyImageView.image = [UIImage imageNamed:@"服务器维护中"];
           // self.emptyLabel.text = @"服务器维护或网络异常，下拉刷新尝试";
           self.emptyLabel.text = @"网络异常";
           if (netWorkTryTime < 5) {
               netWorkTryTime += 1;
               dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                   [self triggerMJRefresh];
               });
           }
        }
    };

    void (^otherSuccess)(NSDictionary *) = ^(NSDictionary * _Nonnull response) {
        id dic = response[@"data"];
        if (dic == nil || [dic isKindOfClass:[NSNull class]]) {
            return;
        }
        self.tableView.backgroundView = nil;
        self.otherCategorysArray = [LiveListCategoryModel mj_objectArrayWithKeyValuesArray:response[@"data"]];
        [self.myCategoryView reloadData];
    };

    if (self.isFirstLoads) {
        self.isFirstLoads = false;
        [KYApiHttpTool FirstGET:URL_OTHER_CATEGORY_LIST withParams:@{} success:otherSuccess failure:^(NSError * _Nullable error) {

        }];
        [KYApiHttpTool FirstGET:URL_CATEGORY_LIST withParams:param success:success failure:fail];
        return;
    }
    [KYApiHttpTool GET:URL_OTHER_CATEGORY_LIST withParams:@{} success:otherSuccess failure:^(NSError * _Nullable error) {

    }];
    [KYApiHttpTool GET:URL_CATEGORY_LIST withParams:param success:success failure:fail];
}

- (void)triggerMJRefresh {
    // 設置偏移量，模擬下拉效果
    [self.tableView setContentOffset:CGPointMake(0, -60) animated:YES];

    // 延遲一點時間再觸發刷新，確保視覺效果
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.emptyLabel.text = @"刷新中...";
        [self.tableView.mj_header beginRefreshing];
    });
}

//检查版本
- (void)checkVersion {
    NSString *appversion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSDictionary *param = @{
        @"clienttype":@"2",
        @"ptype":@"4",
        @"appversion":appversion
    };
    [KYApiHttpTool GETNoHud:URL_Version withParams:param success:^(NSDictionary * _Nonnull response) {
        if ([response[@"isUpdate"] longValue] == 1) {
            // NSString *url = response[@"download_url"];
            NSString *msg = response[@"updatecontent"];
            NSString *downloadUrl = [NSString stringWithFormat:@"itms-services://?action=download-manifest&url=%@", response[@"build_url"]];
            //0非强制更新 1强制更新
            // NSInteger updatetype = [response[@"updatetype"] integerValue];
            UIWindow *window = [[UIApplication sharedApplication].delegate window];
            BOOL isQiang = [response[@"updatetype"] longValue];
            CustomAlertView *alertView = [[CustomAlertView alloc]initWithFrame:window.bounds WithTitle:@"发现新的版本" Detail:msg CancelTitle:@"取消" OtherTitle:@"更新" IsOneBtn:isQiang];
            alertView.isQiangzhi = isQiang;
            alertView.otherBtnBlock = ^(NSInteger tag) {
                [UIApplication.sharedApplication openURL:[NSURL URLWithString:downloadUrl] options:@{} completionHandler:nil];
            };
            [window addSubview:alertView];
        }
        
    } failure:^(NSError * _Nonnull error) {
        
    }];
}

- (void)getDomainName {
      
    [KYApiHttpTool GETNoHud:URL_GetBaseUrlFirst withParams:nil success:^(NSDictionary * _Nonnull response) {
        SNGlobalShared.baseUrl = response[@"api_url"];
        SNGlobalShared.socketUrl = response[@"ws_api_url"];
        [[NSUserDefaults standardUserDefaults] setValue:SNGlobalShared.baseUrl forKey:Local_BaseUrl];
        [[NSUserDefaults standardUserDefaults] setValue:SNGlobalShared.socketUrl forKey:Local_SocketUrl];
   
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        NSString *regid = [[NSUserDefaults standardUserDefaults] objectForKey:JPushRegistrationID];
        if (regid) {
            [appDelegate getJPushAccount:regid];
        }
        [appDelegate getChannelName];
        if (self.categorysArray.count == 0) {
            [self getDatas];
        }

    } failure:^(NSError * _Nonnull error) {
        
        [KYApiHttpTool GETNoHud:URL_GetBaseUrlSecond withParams:nil success:^(NSDictionary * _Nonnull response) {
            SNGlobalShared.baseUrl = response[@"api_url"];
            SNGlobalShared.socketUrl = response[@"ws_api_url"];
            [[NSUserDefaults standardUserDefaults] setValue:SNGlobalShared.baseUrl forKey:Local_BaseUrl];
            [[NSUserDefaults standardUserDefaults] setValue:SNGlobalShared.socketUrl forKey:Local_SocketUrl];
       
            AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            NSString *regid = [[NSUserDefaults standardUserDefaults] objectForKey:JPushRegistrationID];
            if (regid) {
                [appDelegate getJPushAccount:regid];
            }
            [appDelegate getChannelName];
            [appDelegate checkYXIsLogined];
            
            if (self.categorysArray.count == 0) {
                [self getDatas];
            }
            
        } failure:^(NSError * _Nonnull error) {
         
        }];
    }];
}
 
- (void)categoryView:(JXCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index {
    if (index == 0) {
        self.allBtn.selected = YES;
        self.footBallBtn.selected = NO;
        self.basketBallBtn.selected = NO;
        self.otherBtn.selected = NO;
    }else if (index == 1) {
        self.allBtn.selected = NO;
        self.footBallBtn.selected = YES;
        self.basketBallBtn.selected = NO;
        self.otherBtn.selected = NO;
    }else if (index == 2) {
        self.allBtn.selected = NO;
        self.footBallBtn.selected = NO;
        self.basketBallBtn.selected = YES;
        self.otherBtn.selected = NO;
    }else if (index == 3){
        self.allBtn.selected = NO;
        self.footBallBtn.selected = NO;
        self.basketBallBtn.selected = NO;
        self.otherBtn.selected = YES;
    }
    if (self.categorysArray.count == 0) {
        [self.tableView.mj_header beginRefreshing];
    }
    _currentIndex = index - 1;
    
}

#pragma mark - JXCategoryListContainerViewDelegate
- (void)listContainerViewDidScroll:(UIScrollView *)scrollView {
    if ([self isKindOfClass:[PlayerViewController class]]) {
        CGFloat index = scrollView.contentOffset.x/scrollView.bounds.size.width;
        CGFloat absIndex = fabs(index - self.currentIndex);
        if (absIndex >= 1) {
            //”快速滑动的时候，只响应最外层VC持有的scrollView“，说实话，完全可以不用处理这种情况。如果你们的产品经理坚持认为这是个问题，就把这块代码加上吧。
            //嵌套使用的时候，最外层的VC持有的scrollView在翻页之后，就断掉一次手势。解决快速滑动的时候，只响应最外层VC持有的scrollView。子VC持有的scrollView却没有响应
            self.listContainerView.scrollView.panGestureRecognizer.enabled = NO;
            self.listContainerView.scrollView.panGestureRecognizer.enabled = YES;
            _currentIndex = floor(index);
        }
    }
}


@end
