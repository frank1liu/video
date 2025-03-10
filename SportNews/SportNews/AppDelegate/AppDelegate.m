//
//  AppDelegate.m
//  SportNews
//
//  Created by kkk on 2020/12/2.
//

#import "AppDelegate.h"
#import "AvoidCrash.h"
#import "PlayerViewController.h"
#import <UMCommon/UMCommon.h>
#import <UMAPM/UMCrashConfigure.h>
#import "WelcomeViewController.h"
#import "LiveDetailController.h"
#import "SportNews-Swift.h"
#import "LiveListModel.h"
#import "MSNetwork.h"

#import "JPUSHService.h"
#import <UserNotifications/UserNotifications.h>
#import <AdSupport/AdSupport.h>
#import <AppTrackingTransparency/AppTrackingTransparency.h>
#import <NIMSDK/NIMSDK.h>

#import <Bugly/Bugly.h>
#import "DNSResolver.h"
#import "ZFLandscapeRotationManager.h"
#import "Reachability.h"
#import "SportNews-Swift.h"

#import <AlicloudCrash/AlicloudCrashProvider.h>
#import <AlicloudHAUtil/AlicloudHAProvider.h>

#import "OpenInstallSDK.h"

@interface AppDelegate ()<JPUSHRegisterDelegate, BuglyDelegate, OpenInstallDelegate>

@property(nonatomic, assign) BOOL isSuccess;
@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, strong) DNSManager *dnsManager;
@property (nonatomic, strong) NSString *availableDomain;
@property (nonatomic) BOOL isReqSucDynUrl;
@property (nonatomic, assign) BOOL hasFoundValidUrl;
@property (nonatomic, assign) BOOL isChannelSet;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    self.dnsManager = [DNSManager shared];
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    self.session = [NSURLSession sessionWithConfiguration:config];
    self.isReqSucDynUrl = NO;
    self.hasFoundValidUrl = NO;
    self.isChannelSet = NO;
    self.availableDomain = @"";

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getChannelName) name:@"NetworkAvailable" object:nil];

    [self setAvailableDomain:application didFinishLaunchingWithOptions:launchOptions];

    [self setupWindow];

    // [self getChannelName];
    //极光
    // [self setupJPush:application didFinishLaunchingWithOptions:launchOptions];

    // 云信
    // [self setupNIM];

    [self updateVideoTime];

    [self setupBugly];

    // 阿里雲崩潰報告
    [self AliCrashReport];

    // init openinstall
    [OpenInstallSDK initWithDelegate:self];

    return YES;
}

- (void) setAvailableDomain:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSArray<NSString *> *urls = self.dnsManager.domains;

    self.isReqSucDynUrl = YES;

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (NSString *url in urls) {
            if (self.hasFoundValidUrl) break;

            dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);

            [self.dnsManager getIPForDomain:url completion:^(NSString *resolvedIP, NSError *error) {
                if (resolvedIP) {
                    @try {
                        NSString *path = [NSString stringWithFormat:@"https://%@/prod-api/", url];
                        NSURL *urlss = [NSURL URLWithString:path];
                        NSData *data = [[NSData alloc] initWithContentsOfURL:urlss];
                        NSDictionary *d = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
                        if ([d[@"msg"] isEqualToString:@"ok"]) {
                            if (!self.hasFoundValidUrl) {
                                self.hasFoundValidUrl = YES;
                                self.isReqSucDynUrl = NO;
                                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                                [defaults setObject:url forKey:@"app_net_root_url"];
                                [defaults synchronize];
                                NSLog(@"%@", url);
                                self.availableDomain = url;
                                [self setChannelName];
                                [self getChannelName];
                                //极光
                                [self setupJPush:application didFinishLaunchingWithOptions:launchOptions];
                                // 云信
                                [self setupNIM];
                            }
                        }
                        dispatch_semaphore_signal(semaphore);
                    } @catch (NSException *exception) {
                        NSLog(@"%@", exception.reason);
                        dispatch_semaphore_signal(semaphore);
                    }
                } else {
                    dispatch_semaphore_signal(semaphore);
                }
            }];
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        }
        if (!self.hasFoundValidUrl){
            self.availableDomain = urls[0];
            [self setChannelName];
            [self getChannelName];
            //极光
            [self setupJPush:application didFinishLaunchingWithOptions:launchOptions];
            // 云信
            [self setupNIM];
        }
    });
}

/// 執行域名檢測
- (void)checkDomainAvailability:(NSString *)domain completion:(void (^)(BOOL isAvailable))completion {
    NSString *urlWithScheme = [domain hasPrefix:@"http://"] || [domain hasPrefix:@"https://"] ? domain : [NSString stringWithFormat:@"http://%@/prod-api/", domain];
    NSURL *nsUrl = [NSURL URLWithString:urlWithScheme];

    if (!nsUrl) {
        completion(NO);
        return;
    }

    NSURLRequest *request = [NSURLRequest requestWithURL:nsUrl
                                             cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                         timeoutInterval:10.0];

    NSURLSessionDataTask *task = [self.session dataTaskWithRequest:request
                                                 completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            completion(NO);
        } else {
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
            completion(httpResponse.statusCode == 200);
        }
    }];

    [task resume];
}

- (BOOL)setupWindow {

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor =[UIColor whiteColor];
    GKNavigationController *nav = [[GKNavigationController alloc] initWithRootViewController:[[WelcomeViewController alloc] init]];
    nav.navigationBarHidden = YES;
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
    
    SNGlobalShared.contentBottomHeight = 35;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dealwithCrashMessage:) name:AvoidCrashNotification object:nil];

    return YES;
}

- (void)setChannelName {
    NSString *baseUrl = [[NSUserDefaults standardUserDefaults] objectForKey:Local_BaseUrl];
    if (baseUrl) {
        SNGlobalShared.baseUrl = baseUrl;
    }else {
        SNGlobalShared.baseUrl = [NSString stringWithFormat:@"https://%@/prod-api", self.availableDomain];
    }
    NSString *socketUrl = [[NSUserDefaults standardUserDefaults] objectForKey:Local_SocketUrl];
    if (socketUrl) {
        SNGlobalShared.socketUrl = socketUrl;
    }else {
        SNGlobalShared.socketUrl = [NSString stringWithFormat:@"wss://%@/prod-api/ws", self.availableDomain];
    }

    [AvoidCrash becomeEffective];
}

- (BOOL)CheckNetwork {
    Reachability *rech = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    NetworkStatus netStatus = [rech currentReachabilityStatus];
    if (netStatus == NotReachable) {
        UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"提示" message:@"检测到网络断开，内容无法展示，推荐连接网络继续使用。" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *alertCancel = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            exit(0);
        }];
        UIAlertAction *alertConfirm = [UIAlertAction actionWithTitle:@"去打开网络" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self openWifiSettings];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3
                                                                      * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                exit(0);
            });
        }];
        [actionSheet addAction:alertCancel];
        [actionSheet addAction:alertConfirm];
        [self.window.rootViewController presentViewController:actionSheet animated:YES completion:nil];
        return NO;
    }
    return YES;
}

- (void)openWifiSettings
{
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"prefs:root=WIFI"]]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=WIFI"] options:@{} completionHandler:nil];
    } else {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"App-Prefs:root=WIFI"]options:@{} completionHandler:nil];
    }
}


//处理用户点击通知
- (void)dealToUserClickNotification:(NSDictionary *)userInfo { 
    //跳转到直播详情
    
    LiveListModel *model = [[LiveListModel alloc] init];
    model.ID = userInfo[@"mid"];
    model.type = userInfo[@"type"];
    model.comeFromNotice = YES;
    model.selectCartoonModel = nil;
    if (model.ID.intValue == 0) {
        return;
    }
    if ([CommonTools isBlankString:[model.ID stringValue]]) {
        return;
    }
    //如果是点击通知唤醒的App 画中画可能会存在问题 改为 点击通知进入到了列表再进详情
    if (!SNGlobalShared.isAppOpened) {
        self.listModel = model;
        return;
    }
    if (model.type.intValue == 1 || model.type.intValue == 2) {
        //如果是已经挂起状态 就直接跳转
        [self jumpToDetailVc:model];
    }
}

- (void)jumpToDetailVc:(LiveListModel *)model {
    self.listModel = nil;
    UIViewController *currentVc = [CommonTools currentViewController];
    if ([currentVc isKindOfClass:[LiveDetailController class]]) {
        LiveDetailController *detail = (LiveDetailController *)currentVc;
        //id不相等 才跳转
        if (detail.model.ID.integerValue != model.ID.integerValue) {
            LiveDetailController *detailVc = [[LiveDetailController alloc] init];
            detailVc.model = model;
            [[CommonTools currentViewController].navigationController pushViewController:detailVc animated:NO];
            NSArray *vcArrary = detailVc.navigationController.viewControllers;
            UIViewController *vc = vcArrary.firstObject;
            detailVc.navigationController.viewControllers = @[vc,detailVc];
        }
    }else {
        LiveDetailController *detailVc = [[LiveDetailController alloc] init];
        detailVc.model = model;
        [currentVc.navigationController pushViewController:detailVc animated:NO];
    }
}

// 设置云信
- (void)setupNIM {
    NIMSDKOption *option = [NIMSDKOption optionWithAppKey:K_WANGYI_APPKEY];
    [[NIMSDK sharedSDK] registerWithOption:option];
    [self getYXAccount];
}

//设置极光
- (void)setupJPush:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
     
    //Required
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    if (@available(iOS 12.0, *)) {
        entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound|JPAuthorizationOptionProvidesAppNotificationSettings;
    } else {
        // Fallback on earlier versions
        entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
 
    NSString __block *advertisingId;
    if (@available(iOS 14, *)) {
          [ATTrackingManager requestTrackingAuthorizationWithCompletionHandler:^(ATTrackingManagerAuthorizationStatus status) {
              if (status == ATTrackingManagerAuthorizationStatusAuthorized) {
                  advertisingId = [[ASIdentifierManager sharedManager] advertisingIdentifier].UUIDString;
              }
          }];
      } else {
          // 使用原方式访问 IDFA
          advertisingId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
      }
     //推送各用各的
    [JPUSHService setupWithOption:launchOptions appKey:JPushAppKey channel:JPushChannel apsForProduction:YES advertisingIdentifier:advertisingId];
     
    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
        [[NSUserDefaults standardUserDefaults] setValue:registrationID forKey:JPushRegistrationID];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self getJPushAccount:registrationID];
    }];
 
}
  
//先检查是否登录
- (void)checkYXIsLogined {
    if (![NIMSDK sharedSDK].loginManager.isLogined) {
        [self getYXAccount];
    }
}

//获取 网易云信的账号
- (void)getYXAccount {
    LoginUserModel *loginModel = [UserModelTool loginModel];
    NSMutableDictionary *param = @{
        @"apptype"  : @2,
        @"deivceid" : [KKKeyChain getDeviceIDInKeychain],
        // @"mobile"   : loginModel.userinfo.mobile,
        @"pid"      : @1,
        // @"uid"      : loginModel.uid,
        @"nickname" : loginModel.userinfo.nickname,
        @"type"     : @2
    }.mutableCopy;
    NSString *nickName = [[NSUserDefaults standardUserDefaults] valueForKey:K_TouristsNickName];
    if (loginModel) {
        [param setValue:loginModel.userinfo.mobile forKey:@"mobile"];
        [param setValue:loginModel.uid forKey:@"uid"];
        nickName = loginModel.userinfo.nickname;
    }
    if (nickName) {
        [param setValue:nickName forKey:@"nickname"];
    }
    [KYApiHttpTool GET:URL_YXUserID withParams:param success:^(NSDictionary * _Nonnull response) {
        NSString *accid = response[@"accid"];
        NSString *token = response[@"token"];
        
        NSString *nickName = [[NSUserDefaults standardUserDefaults] valueForKey:K_TouristsNickName];
        if ([CommonTools isBlankString:nickName]) {
            [[NSUserDefaults standardUserDefaults] setValue:response[@"nickname"] forKey:K_TouristsNickName];
        }
        [[NSUserDefaults standardUserDefaults] setValue:accid forKey:K_WANGYI_ACCID];
        [[NSUserDefaults standardUserDefaults] setValue:token forKey:K_WANGYI_TOKEN];
        [[NIMSDK sharedSDK].loginManager login:accid token:token completion:^(NSError * _Nullable error) {
            
        }];
    } failure:^(NSError * _Nonnull error) {
        
    }];
}

- (void)getJPushAccount:(NSString *)registrationID {
    if (registrationID.length > 0) {
        NSMutableDictionary *param = @{
            @"apptype":@(2),
            @"regid":registrationID,
            @"deivceid":[KKKeyChain getDeviceIDInKeychain]
        }.mutableCopy;
        LoginUserModel *loginModel = [UserModelTool loginModel];
        if (loginModel) {
            [param setValue:loginModel.userinfo.mobile forKey:@"mobile"];
        }
        [KYApiHttpTool GET:URL_Deivce_RegID withParams:param success:^(NSDictionary * _Nonnull response) {
            
        } failure:^(NSError * _Nonnull error) {
            
        }];
    }
}
 
//如果再次进来当前的日期和上次的日期不相等 就观看时长清零
- (void)updateVideoTime {
    NSDate *date = [NSDate date];
    //使用formatter格式化后的时间
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];//样式
    NSString *time_now = [formatter stringFromDate:date];
    NSString *time_last = [[NSUserDefaults standardUserDefaults] objectForKey:SaveLastEnterAppTime];
    if (![time_now isEqualToString:time_last]) {
        [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:SaveTodayVideoViewTime];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)getChannelName {
    if (!self.isChannelSet) {
        [KYApiHttpTool GETNoHud:URL_GetChannel withParams:@{@"pid": @"4"} success:^(NSDictionary * _Nonnull response) {
            self.isSuccess = YES;
            NSString *name = response[@"channel_name"];
            //友盟统计
            [UMConfigure initWithAppkey:K_UMENG_APPKEY channel:name];
            [UMCrashConfigure setCrashCBBlock:^NSString*_Nullable{
                return @"isCrash";
            }];
            self.isChannelSet = YES;
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                // [MBProgressHUD showSuccess:@"友盟發送成功" toView:nil];
//                [self showAlertMsg:[NSString stringWithFormat:@"友盟發送成功\n網域：%@",[NSString stringWithFormat:@"%@%@",BaseUrl,URL_GetChannel]]];
//            });
        } failure:^(NSError * _Nonnull error) {
    //        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    //            // [MBProgressHUD showSuccess:@"友盟失敗失敗失敗" toView:nil];
    //            [self showAlertMsg:[NSString stringWithFormat:@"友盟失敗失敗失敗\n網域：%@",[NSString stringWithFormat:@"%@%@",BaseUrl,URL_GetChannel]]];
    //        });
        }];
    }
}

- (void)showAlertMsg:(NSString *)msg {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"訊息"
                                                                   message:msg
                                   preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault
       handler:^(UIAlertAction * action) {}];

    [alert addAction:defaultAction];
    [self.window.rootViewController presentViewController:alert animated:YES completion:nil];
}

//设置腾讯的bug
- (void)setupBugly {
    BuglyConfig *config = [[BuglyConfig alloc] init];
    //监听卡顿
    config.blockMonitorEnable = YES;
    config.blockMonitorTimeout = 3;
    config.consolelogEnable = YES;
    config.delegate = self;
    [Bugly startWithAppId:@"c06b5eea0c" config:config];
}

- (NSString *)attachmentForException:(NSException *)exception {
    NSLog(@"异常事件代理");
    return [NSString stringWithFormat:@"TEST: %@",exception.userInfo];
}

//AvoidCrash异常通知监听方法，在这里我们可以调用reportException方法进行上报
- (void)dealwithCrashMessage:(NSNotification *)notification {
    NSString *logErrorMessage = [NSString stringWithFormat:@"\n\n%@\n\n%@\n%@\n%@\n%@",AvoidCrashSeparatorWithFlag, [notification valueForKeyPath:@"userInfo.errorName"], [notification valueForKeyPath:@"userInfo.errorReason"], [notification valueForKeyPath:@"userInfo.errorPlace"], [notification valueForKeyPath:@"userInfo.defaultToDo"]];
    logErrorMessage = [NSString stringWithFormat:@"%@\n\n%@\n\n",logErrorMessage,AvoidCrashSeparator];
    NSException *exception = [NSException exceptionWithName:@"AvoidCrash" reason:logErrorMessage userInfo:notification.userInfo];
    [Bugly reportException:exception];
}

#pragma mark- JPUSHRegisterDelegate
// iOS 12 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center openSettingsForNotification:(UNNotification *)notification{
    if (notification && [notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //从通知界面直接进入应用
    }else{
        //从通知设置界面进入应用
    }
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        //App在前台接受通知会走这里 
        
        
    }
    // App在前台也要弹出消息的话 就要打开
//    completionHandler(UNNotificationPresentationOptionAlert);

}

// iOS 10 Support 用户点击了通知
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler {
    // Required
    NSDictionary *userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        if (userInfo) {
            //处理用户点击通知
            [self dealToUserClickNotification:userInfo];
        }
    }
    // 系统要求执行这个方法
    completionHandler();
}
 
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    // Required, iOS 7 Support
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}
 
- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
  /// Required - 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //Optional
   NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

- (void)jpushNotificationAuthorization:(JPAuthorizationStatus)status withInfo:(NSDictionary *)info {
    
}

/// 在这里写支持的旋转方向，为了防止横屏方向，应用启动时候界面变为横屏模式
- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    ZFInterfaceOrientationMask orientationMask = [ZFLandscapeRotationManager supportedInterfaceOrientationsForWindow:window];
    if (orientationMask != ZFInterfaceOrientationMaskUnknow) {
        return (UIInterfaceOrientationMask)orientationMask;
    }
    /// 这里是非播放器VC支持的方向
    return UIInterfaceOrientationMaskPortrait;
}


// 点击之后badge清零
- (void)applicationWillEnterForeground:(UIApplication *)application {
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    [JPUSHService setBadge:0];
    [[UNUserNotificationCenter alloc] removeAllPendingNotificationRequests];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [SNGlobalShared invalideVideoTimer];
}

- (void)AliCrashReport {
#if DEBUG

#else
    NSString *appversion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];

    [[AlicloudCrashProvider alloc] initWithAppKey:ALI_CRASH_APPKEY
                                           secret:ALI_CRASH_SECRET
                                       appVersion:appversion
                                          channel:ALI_CRASH_CHANNEL
                                             nick:ALI_CRASH_NICK];
    [AlicloudHAProvider start];
#endif
}


@end
